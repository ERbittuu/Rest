//
//  ExampleCell.swift
//  Rest
//
//  Created by Utsav Patel on 4/6/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit

class ExampleCell: UICollectionViewCell {
    
    static let `id` = "ExampleCell"

    @IBOutlet private weak var httpMethod: UILabel!
    @IBOutlet private weak var desc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 14
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.masksToBounds = false
    }
    
    func configureWith(_ example: Example) {
        httpMethod.text = example.httpMethod
        desc.text = example.description
    }
}
