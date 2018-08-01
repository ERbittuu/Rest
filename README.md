# Rest
An HTTP networking library for iOS in Swift 4

## Setup  
Drag Rest.swift file to your XCode project and set default setting as per your requirement. 

## Features 

    - [x] Support all basic service type  (GET, POST, PUT, PATCH, DELETE)
    - [x] Multipart file Upload support 
    - [x] Request Cancel support 
    - [x] Inbuilt network logs support 
    - [x] Ios Network Activity Indicator support
    - [x] Set parameter to request, url params and header to your request 
    - [x] You can set ypu time out for webservice
    - [x] Status Codes acceptance for single or all request.
    - [x] Network Activity Indicator support
    - [ ] File Download support 


## RestError 
`RestError` is a custom error while creating request, or handle the response, you can print it using enabling logs in rest.

## Rest `default` setting option 

1. showLogs(Bool): Rest will print logs for you or not, the default is true  
2. timeout(Double): Webservice timeout in second.
3. index(Int): Webservice index use for debugging.
4. activityIndicatorDisplay(Bool): Network Activity Indicator display default is true.
5. statusCodes([Int]): The expected status call for the call, Default is from any[].
6. cachePolicy: The NSURLRequest CachePolicy for Rest request

## RestRequired *Protocol*
If you want to user Rest then must extend RestRequired `protocol` in your service wrapper file.

Two things you need to set... 
1. Domain url as origin(`String`)
2. End points enums

`Then just use Your class name and call()... your services`

## RestOption for setting different option for web service 

1. route: String -> The route for the request
2. requestType: HTTPMethod -> The requestType for the request
3. expectedStatusCodes: [Int] -> The requestType for the request
4. requestTimeoutSeconds -> The amount of time in `seconds` until the request times out, Default is from Rest default setting.
5. parameter : [String: Any] -> An optional set of params to send, What params you want to add in the request. Rest will do things right whether a method is GET or POST.
6. URLParams : [Any] -> An optional set of URLParams to send: like user/4/post/10, What URLParams you want to add in the request. Rest will do things right whether a method is GET or POST.
7. files: [File] -> Add files to Rest, POST only
8. httpHeaders: [String: String] -> An optional set of HTTP Headers to send with the call.
9. HTTPBodyRaw: (body: String, isJSON: Bool) -> An optional set of HTTP Raw body to send with the call, is JSON or not: will set "Content-Type" of HTTP request to "application/json" or "text/plain;charset=UTF-8"
10. flow: Flow -> The request flow will be sync or aysnc, default to aysnc


## Example

```swift

    class TestAPI: RestRequired { }
    
    // Default settings 
    Rest.default.showLogs = true
    Rest.default.activityIndicatorDisplay = true

    // GET request 
     
    var option = RestOptions(route: End.users.route, method: .GET)
    option.parameter = ["page": id]
    option.expectedStatusCodes = [200, 404]
    
    TestAPI.call(with: option) { (result) in
        
        switch(result) {
            case .success(_):
                print("Success")
            case .failure(_):
                print("error")
        }
    }

    // POST request 
     
    var option = RestOptions(route: End.login.route, method: .POST)
    option.parameter = [ "email": email, "password": password]
    option.expectedStatusCodes = [400, 200]
        
    TestAPI.call(with: option) { (result) in
         switch(result) {
            case .success(_):
                print("Success")
            case .failure(_):
                print("error")
        }
    }

    // PUT request 
     
    var option = RestOptions(route: End.users.route, method: .PUT)        
    // user with id
    option.URLParams = [id]
    
    // update data
    option.parameter = ["name": info.name, "job": info.job]
    
    option.expectedStatusCodes = [200, 404]
    
    TestAPI.call(with: option) { (result) in
        switch(result) {
            case .success(_):
                print("Success")
            case .failure(_):
                print("error")
        }
    }

    // DELETE request 
     
   var option = RestOptions(route: End.users.route, method: .DELETE)        
    // user with id
    option.URLParams = [id]
    option.expectedStatusCodes = [204]
    
    TestAPI.call(with: option) { (result) in
        switch(result) {
            case .success(_):
                print("Success")
            case .failure(_):
                print("error")
        }
    }


    // Cancel request Test 

    // Create `CancellationSource` for handle when request is Cancel 
    var cs: CancellationSource = delayCall { (success, errorMsg) in
            if !success {
                print("error")
            }
        }

    // This call when request cancelld   
    cs?.token.register {
        print("request stoped")        
    }
    
    // For Cancel web request 
    cs?.cancel()
 
     
     // Web function
     func delayCall(callback: @escaping (_ success: Bool, _ error: String?) -> ()) ->  CancellationSource {
        
        let cancellationSource = CancellationSource()
        var option = RestOptions(route: End.users.route, method: .GET)
        
        // user with id
        option.URLParams = [2]
        option.parameter = ["delay": 10]
        
        option.expectedStatusCodes = [200, 404]
        
        TestAPI.call(with: option, andCancelToken: cancellationSource.token) { (result) in
            
            switch(result) {
            case .success(_):
                print("user successfully deleted")
                callback(true, nil)
            case .failure(let error):
                callback(false, error.localizedDescription)
            }
        }
        
        return cancellationSource
    }
```

# Contributing to Rest

Rest welcomes contributions to our [open source projects on Github](https://github.com/ERbittuu/Rest).

Issues
------

Feel free to submit issues and enhancement requests.

Contributing
------------

Please refer to each project's style guidelines and guidelines for submitting patches and additions. In general, we follow the "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that I can review your changes

NOTE: Be sure to merge the latest from "upstream" before making a pull request!

# Thanks 🍺
