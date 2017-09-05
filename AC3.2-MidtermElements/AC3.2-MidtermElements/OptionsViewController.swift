//
//  OptionsViewController.swift
//  AC3.2-MidtermElements
//
//  Created by Victor Zhong on 9/4/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import UIKit

protocol OptionsDelegate {
    func changeSettings(_ controller: OptionsViewController, _ name: String)
}

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    var delegate: OptionsDelegate!
    var name: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        nameTextField.text = name
        applyButton.setTitle("Cancel", for: .normal)
    }
    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        delegate.changeSettings(self, name)
    }
}

extension OptionsViewController: UITextFieldDelegate {
    // MARK: - UITextField Stuff
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = name
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        applyButton.setTitle("Apply", for: .normal)
        
        if let nameText = textField.text {
            if nameText.characters.count < 1 {
                textField.text = name
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
}
