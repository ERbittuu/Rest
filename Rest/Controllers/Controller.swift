//
//  Controller.swift
//  Rest
//
//  Created by Utsav Patel on 4/6/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit

class Controller: UIViewController {

    
    @IBOutlet weak var selection: UISegmentedControl!
    var allService = [Rest]()
    
    override func viewDidLoad() {
        cancel.isHidden = true
        super.viewDidLoad()
    }
    
    func login(success: Bool) {
        TestAPI.login(email: "peter@klaven", password: success ? "cityslicka" : "") { (token, error) in
            guard let loginToken = token else {
                print(error ?? "Some error")
                return
            }
            print(loginToken)
        }
    }
    
    func register(success: Bool) {
        TestAPI.register(email: "peter@klaven", password: success ? "cityslicka" : "") { (token, error) in
            guard let loginToken = token else {
                print(error ?? "Some error")
                return
            }
            print(loginToken)
        }
    }
    
    func userList(success: Bool, islist: Bool, forInfo: Bool = false) {
        
        if forInfo {
            TestAPI.info(id: success ? 2 : 2000, isPageId: islist) { (users, error) in
                if let _error = error {
                    print(_error)
                    return
                }
                print(users)
            }
        } else {
            TestAPI.users(id: success ? 2 : 2000, isPageId: islist) { (users, error) in
                if let _error = error {
                    print(_error)
                    return
                }
                print(users)
            }
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
        let alert = UIAlertController(title: "\(forInfo ? "Info" : "User") List example", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Single \(forInfo ? "Info" : "User") response", style: .default , handler:{ (UIAlertAction)in
            self.userList(success: true, islist: false, forInfo: forInfo)
        }))
        
        alert.addAction(UIAlertAction(title: "Single \(forInfo ? "Info" : "User") error response", style: .default , handler:{ (UIAlertAction)in
            self.userList(success: false, islist: false, forInfo: forInfo)
        }))
        
        alert.addAction(UIAlertAction(title: "\(forInfo ? "Info" : "User") list response", style: .default , handler:{ (UIAlertAction)in
            self.userList(success: true, islist: true, forInfo: forInfo)
        }))
        
        alert.addAction(UIAlertAction(title: "\(forInfo ? "Info" : "User") list not found response", style: .default , handler:{ (UIAlertAction)in
            self.userList(success: false, islist: true, forInfo: forInfo)
        }))
        
        alert.addAction(UIAlertAction(title: "Close", style: .cancel , handler:{ (UIAlertAction)in }))
        self.present(alert, animated: true, completion: { })
    }
    
    @IBAction func updateUserClicked(_ sender: UIButton) {
        TestAPI.updateUser(info: (name: "morpheus", job: "zion resident" ), id: 2) { (success, error) in
            if !success {
                print("error")
            }
        }
    }
    
    @IBAction func deleteUserClicked(_ sender: UIButton) {
        
        TestAPI.deleteUser(id: 2) { (success, error) in
            if !success {
                print("error")
            }
        }
    }
    
    @IBOutlet weak var cancel: UIButton!
    var cs : CancellationSource?
    
    @IBAction func delayClicked(_ sender: UIButton) {
        cancel.isHidden = false
        
        cs = TestAPI.delayCall { (success, errorMsg) in
            self.cancel.isHidden = true
            if !success {
                print("error")
            }
        }
        
        cs?.token.register {
            print("request stoped")
        }
        
        cs?.token.register {
            print("request stoped second handler")
        }
    }
    
    @IBAction func cancelLastCall(_ sender: UIButton) {
        cs?.cancel()
    }
}
