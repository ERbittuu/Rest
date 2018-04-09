//
//  ResultViewController.swift
//  Rest
//
//  Created by Utsav Patel on 4/9/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation
import UIKit

class ResultViewController: UIViewController {

    static let `id` = "ResultViewController"
    
    static var instance : ResultViewController {
        return AppDelegate.main.instantiateViewController(withIdentifier: self.id) as! ResultViewController
    }
    
    var stringTitle : String!
    var dataResult : Data?
    
    @IBOutlet var resultView : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = stringTitle
        
        if let data = dataResult, let responceString = String(data: data, encoding: .utf8) {
            resultView.text =  responceString
        } else {
            resultView.text =  "Unable to convert in Data"
        }
        
    }
}
