//
//  ViewController.swift
//  Rest
//
//  Created by Utsav Patel on 4/6/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit

class RestController: UIViewController {

    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var login: UIButton!
    
    var cancelHandle : CancellationSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancel.isHidden = true
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        cancel.isHidden = false
        
        cancelHandle = Endpoint.login(email: "peter@klaven",
                       password: "cityslicka") { (user, error) in
                        
                        self.cancel.isHidden = true
                        guard let token = user?.token else {
                            if error == nil,
                                let error1 = user?.error {
                                print(error1)
                            }else{
                                print("Unknown error")
                            }
                            return
                        }
                        
                        // login success
                        print(token)
        }
        
        // Handler called when service cancelled manually
        cancelHandle?.token.register {
            print("login api stoped")
        }
    }
    
    @IBAction func cancelLastCall(_ sender: UIButton) {
        cancelHandle?.cancel()
    }
}
