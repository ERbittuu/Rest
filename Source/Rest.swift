//
//  Rest.swift
//  Rest
//
//  Created by Utsav Patel on 4/6/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//
import Foundation
import UIKit
import SystemConfiguration

/// A type representing an error value that can be thrown.
public enum RestError: Error {
    
    /// Error Network not available
    case networkNotAvailable
    
    /// Error 400 on login
    case badRequest
    
    /// Error decoding JSON
    case decoding(message: String)
    
    /// Invalid API request
    case invalidRequest(message: String)
}

public typealias Handler<T: Decodable> = (_ data: T?, RestError?) -> Void

fileprivate class Network {
     static func isAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}

open class Rest {
    
    public struct `default` {
        /// if set to true, Rest will log all information in a NSURLSession lifecycle
        public static var showLogs = true
        
        /// default timeout for all services
        public static var timeout = 60.0
        
        /// index webservice help in debug
        static var index : Int {
            return Rest.indexRequest
        }
        
        /// Network Activity Indicator display default is true
        public static var activityIndicatorDisplay : Bool = true

    }
    private static var indexRequest = 0
    
    private var restManager: RestManager!
    
    private static func prepareNextIndex() {
        Rest.indexRequest = Rest.indexRequest + 1
    }
    
    fileprivate static func log(str : String) {
        if Rest.default.showLogs {
            print("<\(Rest.default.index)> " + str)
        }
    }
    
    /**
     the only init method to fire a HTTP / HTTPS request
     
     - parameter method:     the HTTP method you want
     - parameter url:        the url you want
     - parameter timeout:    time out setting
     - parameter flow:       behaviour of webservice

     - returns: a Rest object
     */
    open static func prepare(HTTPMethod method: HTTPMethod, url: String, timeout: Double = Rest.default.timeout, flow: Flow = .async) -> Rest {
        let p = Rest()
        prepareNextIndex()
        p.restManager = RestManager(url: url, method: method, timeout: timeout, flow: flow)
        return p
    }
    
    /**
     add params to self (Rest object)
     
     - parameter params: what params you want to add in the request. Rest will do things right whether methed is GET or POST.
     
     - returns: self (Rest object)
     */
    open func setParams(_ params: [String: Any]) -> Rest {
        self.restManager.setParams(params)
        return self
    }
    
    /**
     add params to URL (Rest object)
     
     - parameter params: what params you want to add at end of the url request. Rest will do things right whether methed is GET or POST.
     
     - returns: self (Rest object)
     */
    open func setURLParams(_ params: [Any]) -> Rest {
        self.restManager.setURLParams(params)
        return self
    }
    
    /**
     add files to self (Rest object), POST only
     
     - parameter params: add some files to request
     
     - returns: self (Rest object)
     */
    open func setFiles(_ files: [File]) -> Rest {
        self.restManager.setFiles(files)
        return self
    }
    
    /**
     set a custom HTTP header
     
     - parameter key:   HTTP header key
     - parameter value: HTTP header value
     
     - returns: self (Rest object)
     */
    open func setHTTPHeader(Name key: String, Value value: String) -> Rest {
        self.restManager.setHTTPHeader(Name: key, Value: value)
        return self
    }
    
    /**
     set HTTP body to what you want. This method will discard any other HTTP body you have built.
     
     - parameter string: HTTP body string you want
     - parameter isJSON: is JSON or not: will set "Content-Type" of HTTP request to "application/json" or "text/plain;charset=UTF-8"
     
     - returns: self (Rest object)
     */
    open func setHTTPBodyRaw(_ string: String, isJSON: Bool = false) -> Rest {
        self.restManager.sethttpBodyRaw(string, isJSON: isJSON)
        return self
    }
    
    /**
     response the http body in NSData type with error
     
     - parameter callback: callback Closure with optional responce data, optional responce HTTPURLResponse, optional error as NSError
     - parameter response: void
     */
    
    
    open func call<T: Decodable>(cancelToken token: CancellationToken? = nil, process callback: @escaping Handler<T>) {
        
        if Network.isAvailable() {
            self.restManager.cancelToken = token
            self.restManager?.fire(callback)
            if let t = token {
                t.register {
                    self.restManager.task.cancel()
                    self.restManager.session.finishTasksAndInvalidate()
                }
            }
        }else{
            let e = NSError(domain: RestManager.errorDomain, code: 503, userInfo: ["reason" : "Internet not available"])
            Rest.log(str: "Rest Error: " + e.localizedDescription)
            DispatchQueue.main.async {
                callback(nil, RestError.networkNotAvailable)
            }
        }
    }
}

private func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

private func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

private class RestManager: NSObject {
    let boundary = "RestBoundary\(NSUUID().uuidString)"
    static let errorDomain = "com.erbittuu.Rest"
    
    var HTTPBodyRaw = ""
    var HTTPBodyRawIsJSON = false
    
    let method: String!
    var params: [String: Any]?
    var urlParams: [Any]?
    var files: [File]?
    
//    var callback: ((_ data: Decodable?, _ error: NSError?) -> Void)?

    var cancelToken: CancellationToken? = nil
    
    var session: URLSession!
    var url: String!
    var request: URLRequest!
    var task: URLSessionTask!
    
    var extraHTTPHeaders = [(String, String)]()
    
    var flow: Flow = .async
    
    // User-Agent Header
    let userAgent: String = {
        if let info = Bundle.main.infoDictionary {
            let executable: Any = info[kCFBundleExecutableKey as String] ?? "Unknown"
            let bundle: Any = info[kCFBundleIdentifierKey as String] ?? "Unknown"
            let minorVersion: Any = info[kCFBundleVersionKey as String] ?? "Unknown"
            let version: Any = info["CFBundleShortVersionString"] ?? "Unknown"
            
            // could not tested
            let os = ProcessInfo.processInfo.operatingSystemVersionString
            
            var mutableUserAgent = NSMutableString(string: "\(executable)/\(bundle) (V\(version)(\(minorVersion)); OS \(os))") as CFMutableString
            let transform = NSString(string: "Any-Latin; Latin-ASCII; [:^ASCII:] Remove") as CFString
            if CFStringTransform(mutableUserAgent, nil, transform, false) {
                return mutableUserAgent as NSString as String
            }
        }
        
        // could not tested
        return "Rest"
    }()
    
    init(url: String, method: HTTPMethod!, timeout: Double, flow: Flow) {
        self.url = url
        self.request = URLRequest(url: URL(string: url)!)
        self.method = method.rawValue
        self.flow = flow
        
        super.init()
        // setup a session with delegate to self
        let sessionConfiguration = Foundation.URLSession.shared.configuration
        sessionConfiguration.timeoutIntervalForRequest = timeout
        self.session = Foundation.URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: Foundation.URLSession.shared.delegateQueue)
    }
    
    func setParams(_ params: [String: Any]?) {
        self.params = params
    }
    
    func setURLParams(_ urlParams: [Any]?) {
        self.urlParams = urlParams
    }
    
    func setFiles(_ files: [File]?) {
        self.files = files
    }
    
    func setHTTPHeader(Name key: String, Value value: String) {
        self.extraHTTPHeaders.append((key, value))
    }
    func sethttpBodyRaw(_ rawString: String, isJSON: Bool = false) {
        self.HTTPBodyRaw = rawString
        self.HTTPBodyRawIsJSON = isJSON
    }
    func fire<T: Decodable>(_ callback: @escaping Handler<T>) {
        
        self.prepareRequest()
        self.prepareHeader()
        self.prepareBody()
        
        // Web service
        
        DispatchQueue.main.async {
            if Rest.default.activityIndicatorDisplay {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
        
        if let a = self.request.allHTTPHeaderFields {
            Rest.log(str: "Rest Request HEADERS: " + a.description)
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        
        self.task = self.session.dataTask(with: self.request) { (data, response, error) -> Void in
            
            self.cancelToken?.resetAllHandlers()
            
            DispatchQueue.main.async {
                if Rest.default.activityIndicatorDisplay {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            
            semaphore.signal()
            
            if let error = error as NSError? {
                if error.code == -999 { // NSURLErrorCancelled
                    Rest.log(str: "Rest Cancel Manually: " + self.url)
                } else {
                    let e = NSError(domain: RestManager.errorDomain, code: error.code, userInfo: error.userInfo)
                    Rest.log(str: "Rest Error: " + e.localizedDescription)
                    DispatchQueue.main.async {
                        callback(nil, RestError.decoding(message: error.localizedDescription))
                    }
                }
            }
            else {
                if let a = response {
                    Rest.log(str: "Rest Response: " + a.description)
                }
                
                DispatchQueue.global(qos: .utility).async {
                    do {
                        if let data = data {
                            let jsonDecoder = JSONDecoder()
                            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                            let object = try jsonDecoder.decode(T.self, from: data)
                            
                            DispatchQueue.main.async {
                                callback(object, nil)
                            }
                            
                            if let responceString = String(data: data, encoding: .utf8) {
                                Rest.log(str: "Rest Response: " + responceString.description)
                            } else {
                                Rest.log(str: "Rest response : Unable to log responce string")
                            }
                        }else{
                            DispatchQueue.main.async {
                                callback(nil, nil)
                            }
                            Rest.log(str: "Rest response : ERROR data is nil from server")
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            callback(nil, RestError.decoding(message: error.localizedDescription))
                        }
                        Rest.log(str: "Rest response : \(error.localizedDescription)")
                    }
                }
            }
            self.session.finishTasksAndInvalidate()
        }
        self.task.resume()
        if flow == .sync{
            semaphore.wait()
        }
    }
    private func prepareRequest() {
        
        if self.urlParams?.count > 0 {
            url = url + RestHelper.prepareURLParams(urlParams!)
        }
        
        if self.method == "GET" && self.params?.count > 0 {
            url = url + "?" + RestHelper.prepareParams(self.params!)
        }
        
        // rebuild request
        if self.params?.count > 0 || self.urlParams?.count > 0  {
            self.request = URLRequest(url: URL(string: url)!)
        }
        
        self.request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        self.request.httpMethod = self.method
    }
    private func prepareHeader() {
        // multipart Content-Type
        if self.params?.count > 0 {
            self.request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        if self.files?.count > 0 && self.method != "GET" {
            self.request.setValue("multipart/form-data; boundary=" + self.boundary, forHTTPHeaderField: "Content-Type")
        }
        if self.HTTPBodyRaw != "" {
            self.request.setValue(self.HTTPBodyRawIsJSON ? "application/json" : "text/plain;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        }
        self.request.addValue(self.userAgent, forHTTPHeaderField: "User-Agent")
        for i in self.extraHTTPHeaders {
            self.request.setValue(i.1, forHTTPHeaderField: i.0)
        }
    }
    private func prepareBody() {
        let data = NSMutableData()
        if self.HTTPBodyRaw != "" {
            data.append(self.HTTPBodyRaw.nsdata as Data)
        } else if self.files?.count > 0 {
            if self.method == "GET" {
                print("\n\n------------------------\nThe remote server may not accept GET method with HTTP body. But Rest will send it anyway.\nBut it looks like iOS 9 SDK has prevented sending http body in GET method.\n------------------------\n\n")
            } else {
                if let ps = self.params {
                    for (key, value) in ps {
                        data.append("--\(self.boundary)\r\n".nsdata as Data)
                        data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".nsdata as Data)
                        data.append("\(value)\r\n".nsdata as Data)
                    }
                }
                if let fs = self.files {
                    for file in fs {
                        data.append("--\(self.boundary)\r\n".nsdata as Data)
                        data.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.nameWithType)\"\r\n\r\n".nsdata as Data)
                        if let fileurl = file.url {
                            if let a = try? Data(contentsOf: fileurl as URL) {
                                data.append(a)
                                data.append("\r\n".nsdata as Data)
                            }
                        } else if let filedata = file.data {
                            data.append(filedata)
                            data.append("\r\n".nsdata as Data)
                        }
                    }
                }
                data.append("--\(self.boundary)--\r\n".nsdata as Data)
            }
        } else if self.params?.count > 0 && self.method != "GET" {
            data.append(RestHelper.prepareParams(self.params!).nsdata)
        }
        self.request.httpBody = data as Data
    }
    
}

/**
 *  HTTP method enum for Rest
 */
public enum HTTPMethod: String {
    case DELETE, GET, HEAD, OPTIONS, PATCH, POST, PUT
}

/**
 *  Flow of web service
 */
public enum Flow {
    case async, sync
}

/**
 *  the File struct for Rest to upload
 */
public struct File {
    fileprivate let name: String
    fileprivate let nameWithType: String
    fileprivate let url: URL?
    fileprivate let data: Data?
    
    /**
     the only init method of File
     
     - parameter name:       Name of file which is uploaded
     - parameter url:        URL of file
     
     - returns: a File object
     */
    public init(name: String, url: URL) {
        self.name = name
        self.url = url
        self.data = nil
        self.nameWithType = NSString(string: url.description).lastPathComponent
    }
    
    /**
     the only init method of File
     
     - parameter name:       Name of file which is uploaded
     - parameter url:        data of file
     - parameter url:        Type of file
     
     - returns: a File object
     */
    public init(name:String, data: Data, type: String) {
        self.name = name
        self.data = data
        self.url  = nil
        self.nameWithType = name + "." + type
    }
}

private extension String {
    /// return NSData of self String
    var nsdata: Data {
        return self.data(using: String.Encoding.utf8)!
    }
}

private extension String {
    /// return base64 string of self String
    var base64: String! {
        let utf8EncodeData: Data! = self.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let base64EncodingData = utf8EncodeData.base64EncodedString(options: [])
        return base64EncodingData
    }
}

private class RestHelper {
    // add prepareParams
    static func prepareParams(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sorted(by: <) {
            let value = parameters[key]
            components += RestHelper.queryComponents(key, value ?? "value_is_nil")
        }
        
        return components.map{"\($0)=\($1)"}.joined(separator: "&")
    }
    
    // add prepare URL Params
    static func prepareURLParams(_ parameters: [Any]) -> String {
        
        let list = parameters.map {
            String(describing: $0)
        }
        return list.joined(separator: "/")
    }
    
    // add queryComponents
    static func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        var valueString = ""
        
        switch value {
        case _ as String:
            valueString = value as! String
        case _ as Bool:
            valueString = (value as! Bool).description
        case _ as Double:
            valueString = (value as! Double).description
        case _ as Int:
            valueString = (value as! Int).description
        default:
            break
        }
        
        components.append(contentsOf: [(RestHelper.escape(key), RestHelper.escape(valueString))])
        return components
    }

    // add escape
    static func escape(_ string: String) -> String {
        
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }
}

// Cancel request

enum State {
    case cancelled
    case pending(CancellationSource)
}

/**
 A `CancellationToken` indicates if cancellation of "something" was requested.
 Can be passed around and checked by whatever wants to be cancellable.
 
 To create a cancellation token, use `CancellationTokenSource`.
 */
public struct CancellationToken {
    
    private weak var source: CancellationSource?
    
    fileprivate init(source: CancellationSource) {
        self.source = source
    }
    
    public var isCancellationRequested: Bool {
        return source?.isCancellationRequested ?? true
    }
   
    public func resetAllHandlers() {
        guard let source = source else {
            return
        }
        source.resetAllHandlers()
    }
    
    public func register(_ handler: @escaping () -> Void) {
        guard let source = source else {
            return handler()
        }
        
        source.register(handler)
    }
}

/**
 A `CancellationTokenSource` is used to create a `CancellationToken`.
 The created token can be set to "cancellation requested" using the `cancel()` method.
 */
public class CancellationSource {
    
    private let internalState: InternalState
    fileprivate var isCancellationRequested: Bool {
        return internalState.readCancelled()
    }
    
    public init() {
        internalState = InternalState()
    }
    
    deinit {
        tryCancel()
    }
    
    public var token: CancellationToken {
        return CancellationToken(source: self)
    }
    
    fileprivate func resetAllHandlers() {
        internalState.removeHandlers()
    }
    
    fileprivate func register(_ handler: @escaping () -> Void) {
        if let handler = internalState.addHandler(handler) {
            handler()
        }
    }
    
    public func cancel() {
        tryCancel()
    }
    
    public func cancelAfter(deadline dispatchTime: DispatchTime) {
        // On a background queue
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        queue.asyncAfter(deadline: dispatchTime) { [weak self] in
            self?.tryCancel()
        }
    }
    
    public func cancelAfter(timeInterval: TimeInterval) {
        cancelAfter(deadline: .now() + timeInterval)
    }
    
    fileprivate func tryCancel() {
        let handlers = internalState.tryCancel()
        
        // Call all previously scheduled handlers
        for handler in handlers {
            handler()
        }
    }
}

extension CancellationSource {
    typealias Handler = () -> Void
    
    fileprivate class InternalState {
        private let lock = NSLock()
        private var cancelled = false
        private var handlers: [() -> Void] = []
        
        func readCancelled() -> Bool {
            lock.lock(); defer { lock.unlock() }
            
            return cancelled
        }
        
        func tryCancel() -> [Handler] {
            lock.lock(); defer { lock.unlock() }
            
            if cancelled {
                return []
            }
            
            let handlersToExecute = handlers
            
            cancelled = true
            handlers = []
            
            return handlersToExecute
        }
        
        func removeHandlers() {
            lock.lock(); defer { lock.unlock() }
            handlers.removeAll()
        }
        
        func addHandler(_ handler: @escaping Handler) -> Handler? {
            lock.lock(); defer { lock.unlock() }
            
            if !cancelled {
                handlers.append(handler)
                return nil
            }
            
            return handler
        }
    }
}
