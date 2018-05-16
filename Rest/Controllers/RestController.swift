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
    
    var allService = [Rest]()
    
    var cs : CancellationSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancel.isHidden = true
    }
    
    private func cancelVisibilityChange() {
//        cancel.isHidden = allService.isEmpty
    }
    
    @IBAction func getCall(_ sender: UIButton) {
        cancel.isHidden = false
        self.cs = WebService.shared.simpleGET{ data in
            self.cancel.isHidden = true
        }
        
        self.cs?.token.register {
            print("I have cancelled request stop unwanted task here")
        }
    }
    
    @IBAction func postCall(_ sender: UIButton) {
        cancel.isHidden = true
        WebService.shared.simplePOST { (data) in

        }
    }
    
    @IBAction func cancelLastCall(_ sender: UIButton) {
        
        cs?.cancel()
    }
}
