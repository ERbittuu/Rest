//
//  BaseController.swift
//  Rest
//
//  Created by Utsav Patel on 5/2/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit

class BaseController: UIViewController {

    static let `id` = "BaseController"
    
    static var instance : BaseController {
        return AppDelegate.main.instantiateViewController(withIdentifier: self.id) as! BaseController
    }
    
    @IBOutlet private weak var login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        login.isHidden = Instagram.shared.isAuthenticated
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        if let nav = self.navigationController {
            Instagram.shared.login(from: nav, success: {
                
            }, failure: { (error) in
                print(error)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
