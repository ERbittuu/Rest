//
//  Controller.swift
//  Rest
//
//  Created by Utsav Patel on 4/6/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit

class Controller: UIViewController {

//    @IBOutlet weak var cancel: UIButton!
    
    @IBOutlet weak var selection: UISegmentedControl!
    var allService = [Rest]()
    
//    var cs : CancellationSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Rest.default.origin = "https://reqres.in/api"
        Rest.default.showLogs = true
    }
    
    private func cancelVisibilityChange() {
//        cancel.isHidden = allService.isEmpty
    }
    
//    @IBAction func getCall(_ sender: UIButton) {
//        cancel.isHidden = false
//        self.cs = WebService.shared.simpleGET{ data in
//            self.cancel.isHidden = true
//        }
//
//        self.cs?.token.register {
//            print("I have cancelled request stop unwanted task here")
//        }
//    }
//
    
    func login(success: Bool) {
        Request.login(email: "peter@klaven", password: success ? "cityslicka" : "") { (token, error) in
            guard let loginToken = token else {
                print(error ?? "Some error")
                return
            }
            print(loginToken)
        }
    }
    
    func register(success: Bool) {
        Request.register(email: "peter@klaven", password: success ? "cityslicka" : "") { (token, error) in
            guard let loginToken = token else {
                print(error ?? "Some error")
                return
            }
            print(loginToken)
        }
    }
    
    func userList(success: Bool, islist: Bool, forInfo: Bool = false) {
        Request.users(id: success ? 2 : 2000, isPageId: islist) { (users, error) in
            if let _error = error {
                print(_error)
                return
            }
            print(users)
        }
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {

        let alert = UIAlertController(title: "Login example", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Success response", style: .default , handler:{ (UIAlertAction)in
            self.login(success: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Error response", style: .default , handler:{ (UIAlertAction)in
            self.login(success: false)
        }))
       
        alert.addAction(UIAlertAction(title: "Close", style: .cancel , handler:{ (UIAlertAction)in }))
        self.present(alert, animated: true, completion: { })
    }
    
    @IBAction func registerClicked(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Register example", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Success response", style: .default , handler:{ (UIAlertAction)in
            self.register(success: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Error response", style: .default , handler:{ (UIAlertAction)in
           self.register(success: false)
        }))
        
        alert.addAction(UIAlertAction(title: "Close", style: .cancel , handler:{ (UIAlertAction)in }))
        self.present(alert, animated: true, completion: { })
    }
    
    @IBAction func getList(_ sender: UIButton) {
        
        let forInfo = selection.selectedSegmentIndex == 1
        let alert = UIAlertController(title: "User List example", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Single user response", style: .default , handler:{ (UIAlertAction)in
            self.userList(success: true, islist: false, forInfo: forInfo)
        }))
        
        alert.addAction(UIAlertAction(title: "Single user error response", style: .default , handler:{ (UIAlertAction)in
            self.userList(success: false, islist: false, forInfo: forInfo)
        }))
        
        alert.addAction(UIAlertAction(title: "User list response", style: .default , handler:{ (UIAlertAction)in
            self.userList(success: true, islist: true, forInfo: forInfo)
        }))
        
        alert.addAction(UIAlertAction(title: "User list not found response", style: .default , handler:{ (UIAlertAction)in
            self.userList(success: false, islist: true, forInfo: forInfo)
        }))
        
        alert.addAction(UIAlertAction(title: "Close", style: .cancel , handler:{ (UIAlertAction)in }))
        self.present(alert, animated: true, completion: { })
    }
//
//    @IBAction func cancelLastCall(_ sender: UIButton) {
//
//        cs?.cancel()
//    }
}
