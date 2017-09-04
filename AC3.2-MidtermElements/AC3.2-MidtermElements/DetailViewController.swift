//
//  DetailViewController.swift
//  AC3.2-MidtermElements
//
//  Created by Victor Zhong on 12/8/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    var element: Element?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var meltLabel: UILabel!
    @IBOutlet weak var boilLabel: UILabel!
    @IBOutlet weak var stealthLabel: UILabel!
    @IBOutlet weak var faveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let validElement = element {
            self.title = validElement.name
            loadData()
        }
    }
    
    func loadData() {
        guard let validElement = element else { return }
        
        self.symbolLabel.text = String(validElement.number)
        self.nameLabel.text = " \(validElement.name) (\(validElement.symbol))  "
        self.weightLabel.text = " Atomic Mass: \(validElement.weight)  "
        
        if validElement.boiling == 9000 {
            self.boilLabel.text = "Boiling Point: IT'S OVER 9,000!*"
        }
        else {
            self.boilLabel.text = "Boiling Point: \(validElement.boiling)° C"
        }
        
        if validElement.melting == -9000 {
            self.meltLabel.text = "Melting Point: IT'S UNDER -9,000!*"
        }
        else {
            self.meltLabel.text = "Melting Point: \(validElement.melting)° C"
        }
        
        if validElement.boiling == 9000 || validElement.melting == -9000 {
            self.stealthLabel.isHidden = false
        }

        let url = URL(string: validElement.image)
        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        
//        APIRequestManager.manager.getData(endPoint: validElement.image) { (data: Data?) in
//            if let validData = data,
//                let validImage = UIImage(data: validData) {
//                print(validElement.image)
//                DispatchQueue.main.sync {
//                    self.imageView.image = validImage
//                }
//            }
//        }
    }

    
    @IBAction func faveButtonTapped(_ sender: UIButton) {
        postFaves()
    }
    
    func postFaves() {
        guard let validElement = element else { return }
        
        let favorite: [String : Any] = [
            "my_name" : "Vic Zhong",
            "favorite_element" : validElement.symbol
        ]
        
        APIRequestManager.manager.postRequest(endPoint: "https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/favorites", data: favorite)
        
        self.faveButton.isEnabled = false
    }

}
