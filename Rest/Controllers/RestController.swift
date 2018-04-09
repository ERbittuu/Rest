//
//  ViewController.swift
//  Rest
//
//  Created by Utsav Patel on 4/6/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import UIKit
import VegaScrollFlowLayout

// MARK: - Configurable constants
private let itemHeight: CGFloat = 128
private let lineSpacing: CGFloat = 32
private let xInset: CGFloat = 16
private let topInset: CGFloat = 8

class RestController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    fileprivate var eamples: [Example] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eamples = Example.list()
        let nib = UINib(nibName: ExampleCell.id, bundle: nil)
        collectionView.register( nib, forCellWithReuseIdentifier: ExampleCell.id)
        collectionView.contentInset.bottom = itemHeight
        configureCollectionViewLayout()
        setUpNavBar()
    }
    
    private func setUpNavBar() {
        navigationItem.title = "Services"
        navigationController?.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    private func configureCollectionViewLayout() {
        guard let layout = collectionView.collectionViewLayout as? VegaScrollFlowLayout else { return }
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        let itemWidth = UIScreen.main.bounds.width - 2 * xInset
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension RestController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExampleCell.id, for: indexPath) as! ExampleCell
        let example = eamples[indexPath.row]
        cell.configureWith(example)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eamples.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        DELETE, GET, HEAD, OPTIONS, PATCH, POST, PUT
        
        if HTTPMethod.GET.rawValue == eamples[indexPath.row].httpMethod {
            WebService.shared.simpleGET{ data in
                let result = ResultViewController.instance
                result.stringTitle = self.eamples[indexPath.row].httpMethod
                result.dataResult = data
                
                self.navigationController?.pushViewController(result, animated: true)
            }
        }
        
        if HTTPMethod.POST.rawValue == eamples[indexPath.row].httpMethod {
            WebService.shared.SimplePOST { data in
                let result = ResultViewController.instance
                result.stringTitle = self.eamples[indexPath.row].httpMethod
                result.dataResult = data
                
                self.navigationController?.pushViewController(result, animated: true)
            }
        }

        if HTTPMethod.PATCH.rawValue == eamples[indexPath.row].httpMethod {
            WebService.shared.SimplePATCH { data in
                let result = ResultViewController.instance
                result.stringTitle = self.eamples[indexPath.row].httpMethod
                result.dataResult = data
                
                self.navigationController?.pushViewController(result, animated: true)
            }
        }
        
        if HTTPMethod.DELETE.rawValue == eamples[indexPath.row].httpMethod {
            WebService.shared.SimpleDELETE { data in
                let result = ResultViewController.instance
                result.stringTitle = self.eamples[indexPath.row].httpMethod
                result.dataResult = data
                
                self.navigationController?.pushViewController(result, animated: true)
            }
        }
        
        if HTTPMethod.PUT.rawValue == eamples[indexPath.row].httpMethod {
            WebService.shared.SimplePUT { data in
                let result = ResultViewController.instance
                result.stringTitle = self.eamples[indexPath.row].httpMethod
                result.dataResult = data
                
                self.navigationController?.pushViewController(result, animated: true)
            }
        }
        
        if HTTPMethod.OPTIONS.rawValue == eamples[indexPath.row].httpMethod ||
             HTTPMethod.HEAD.rawValue == eamples[indexPath.row].httpMethod {
            WebService.shared.SimpleTRY{
                let result = ResultViewController.instance
                result.stringTitle = self.eamples[indexPath.row].httpMethod
                result.dataResult = "Try Yourself".data(using: String.Encoding.utf8)
                
                self.navigationController?.pushViewController(result, animated: true)
            }
        }
    }
}
