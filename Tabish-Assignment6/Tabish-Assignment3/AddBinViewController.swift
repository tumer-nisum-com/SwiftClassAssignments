//
//  AddBinViewController.swift
//  Tabish-Assignment3
//
//  Created by Tabish Umer Farooqui on 14/06/2017.
//  Copyright © 2017 Tabish Umer Farooqui. All rights reserved.
//

import UIKit

class AddBinViewController: UIViewController, UITextFieldDelegate {

    var binName: String?
    
    @IBOutlet weak var binTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationBar.topItem?.title = "Add Details"
        saveButton.addTarget(self, action: #selector(saveHandler), for: .touchUpInside)
        
        binTextField.delegate = self
        binTextField.allowsEditingTextAttributes = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var pickerData = [String]()
    enum EntityType {
        case Bin
        case Location
    }
    
    var pickerRowSelectedHandler: ((Int) -> Void)?

    func saveHandler() {
        print("Add save Button")
        
        self.binName = binTextField.text
        
        self.performSegue(withIdentifier: "unwindToAddDetails", sender: self)
    }


}

