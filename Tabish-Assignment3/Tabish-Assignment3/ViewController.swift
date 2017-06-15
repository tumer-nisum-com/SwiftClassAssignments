//
//  ViewController.swift
//  Tabish-Assignment3
//
//  Created by Tabish Umer Farooqui on 14/06/2017.
//  Copyright © 2017 Tabish Umer Farooqui. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var binTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var selectionPickerView: UIPickerView!
    @IBOutlet weak var addBinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationBar.topItem?.title = "Add Details"
        saveButton.addTarget(self, action: #selector(saveHandler), for: .touchUpInside)
        addBinButton.addTarget(self, action: #selector(addBinHandler), for: .touchUpInside)
        selectionPickerView.isHidden = true
        
        binTextField.delegate = self
        binTextField.allowsEditingTextAttributes = false
        locationTextField.delegate = self
        selectionPickerView.delegate = self
        selectionPickerView.dataSource = self
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
        print(self.binTextField.text!)
        print(self.locationTextField.text!)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "unwindToAddDetails" {
            //let viewController:LocationViewController = segue.destination as! LocationViewController
            
        }
    }
    
    
    @IBAction func unwindToAddItem(sender: UIStoryboardSegue) {
        
        
        let AddBinViewController = sender.source as! AddBinViewController
        let item = AddBinViewController.binName!
        
        print("Value of add bin Text field - ", item)
        
    }

    func addBinHandler(sender: UIButton) {
        print("Add Bin Button")
        
        //self.name = binTextfield.text
        
        //self.performSegue(withIdentifier: "itemSearchSegue", sender:self )
        //self.performSegue(withIdentifier: "unwindToAddItem", sender: self)
        
        //self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerRowSelectedHandler!(row)
        self.selectionPickerView.isHidden = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var allowEditing = true
        switch textField {
        case self.binTextField:
            self.pickerData = ["First Bin", "Second Bin", "Third Bin"]
            selectionPickerView.reloadAllComponents()
            self.selectionPickerView.isHidden = false
            allowEditing = false
            
        case self.locationTextField:
            self.pickerData = ["First Location", "Second Location", "Third Location"]
            selectionPickerView.reloadAllComponents()
            self.selectionPickerView.isHidden = false
            allowEditing = false
        default: self.selectionPickerView.isHidden = true
            
        }
        
        self.pickerRowSelectedHandler = {(selectedIndex:Int) -> Void in
            var entityType: EntityType?
            switch textField {
            case self.locationTextField:
                entityType = EntityType.Location
                self.locationTextField.text = self.pickerData[selectedIndex]
            case self.binTextField:
                entityType = EntityType.Bin
                self.binTextField.text = self.pickerData[selectedIndex]
            default: break
            }
            print("\(entityType!) selected: \(selectedIndex)")
        }
        return allowEditing;
        
    }

}

