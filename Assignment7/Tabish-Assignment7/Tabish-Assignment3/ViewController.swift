//
//  ViewController.swift
//  Tabish-Assignment3
//
//  Created by Tabish Umer Farooqui on 14/06/2017.
//  Copyright © 2017 Tabish Umer Farooqui. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, EntityViewControllerInterface {

    //MARK: - Declarations
    
    @IBOutlet weak var binTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var selectionPickerView: UIPickerView!
    @IBOutlet weak var addBinButton: UIButton!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemQuantityTextField: UITextField!
        
    enum ActionType {
        case Create
        case Update
        case Delete
    }
    
//    enum EntityType {
//        case Bin
//        case Item
//        case Location
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationBar.topItem?.title = "Create Item"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchHandler(sender:)))
        
        saveButton.addTarget(self, action: #selector(saveHandler), for: .touchUpInside)
        addBinButton.addTarget(self, action: #selector(addBinHandler), for: .touchUpInside)
        addLocationButton.addTarget(self, action: #selector(addLocationHandler), for: .touchUpInside)
        
        selectionPickerView.isHidden = true
        
        binTextField.delegate = self
        binTextField.allowsEditingTextAttributes = false
        locationTextField.delegate = self
        selectionPickerView.delegate = self
        selectionPickerView.dataSource = self
        itemNameTextField.delegate = self;
        itemQuantityTextField.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Object Declarations
    
    var pickerData = [String]()
    var pickerRowSelectedHandler: ((Int) -> Void)?

    var entity:EntityBase?
    var locationArray:[String] =  ["Central Library","City Library","University Library"]
    var binArray:[String] = ["Information Technology","Economics","Literature"]
    
    var fetchUtility = FetchUtility()

    //MARK: - Methods
    
    func saveHandler() {
        print(self.binTextField.text!)
        print(self.locationTextField.text!)
    }

    func searchHandler(sender: UIBarButtonItem) {
        print("Search clicked!")
        self.performSegue(withIdentifier: "itemSearchSegue", sender:self )
    }
    
    func addLocationHandler(sender: UIBarButtonItem) {
        print("Add Location Button")
        self.showAddEntityAlertView(entityType: .Location, actionType: .Create)
    }

    func addBinHandler(sender: UIButton) {
        print("Add Bin Button")
        
        if (self.locationTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Title", message: "Enter Location Please", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        else {
            self.showAddEntityAlertView(entityType: .Bin, actionType: .Create)
        }

        //self.name = binTextfield.text
        
        //self.performSegue(withIdentifier: "itemSearchSegue", sender:self )
        //self.performSegue(withIdentifier: "unwindToAddItem", sender: self)
        
        //self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Picker View Delegates
    
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
    
    //MARK: - AlertView Delegates
    
    func showAddEntityAlertView(entityType:EntityType, actionType:ActionType)    {
        let alert = UIAlertController(title: "\(actionType) \(entityType)", message: "Enter \(entityType) name", preferredStyle: .alert)
        alert.addTextField { (textField) in textField.placeholder = "\(entityType) name"}
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            [weak alert, weak self] (_) in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.reset()
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(String(describing: textField.text))")
            var isError = false
            var errorMessage = ""
            if entityType == EntityType.Bin {
                
                let bin = Bin(context: context)
                bin.name = textField.text!
                bin.entityType = EntityType.Bin
                let  text:String = self!.locationTextField.text!
                let location = self!.fetchUtility.fetchLocation(byName:text)
                bin.binToLocationFK = location
                
                do {
                    try bin.validateForInsert()
                } catch {
                    isError = true
                    errorMessage = error.localizedDescription
                }
            } else if entityType == EntityType.Location {
                let location = Location(context: context)
                location.name = textField.text!
                location.entityType = EntityType.Location
            }
            
            if !isError {
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            } else {
                UIAlertController(title: "\(actionType) \(entityType)", message: errorMessage, preferredStyle: .alert)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    //MARK: - TextField Delegates
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var allowEditing = true
        switch textField {
        case self.locationTextField:
            self.pickerData = (fetchUtility.fetchSortedLocation()?.map(
                {
                    (value: Location) -> String in
                    return value.name!
            }))!
            selectionPickerView.reloadAllComponents()
            self.selectionPickerView.isHidden = false
            if self.locationTextField.text != nil && !self.locationTextField.text!.isEmpty  {
                self.selectionPickerView.selectRow(pickerData.index(of: self.locationTextField.text!)!, inComponent:0, animated: false)
            }
            else {
                self.selectionPickerView.selectRow(0, inComponent:0, animated: false)
            }
            allowEditing = false
            
        case self.binTextField:
            //                self.pickerData = binArray
            selectionPickerView.reloadAllComponents()
            self.selectionPickerView.isHidden = false
            if self.binTextField.text != nil && !self.binTextField.text!.isEmpty  {
                self.selectionPickerView.selectRow(pickerData.index(of: self.binTextField.text!)!, inComponent:0, animated: false)
            }
            else {
                self.selectionPickerView.selectRow(0, inComponent:0, animated: false)
            }
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
            print("\(String(describing: entityType)) selected: \(selectedIndex)")
        }
        
        return allowEditing;
    }
    //MARK: - Navigation Methods
    
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
    
    @IBAction func unwindFromSearch(sender: UIStoryboardSegue) {
        let itemSearchTableViewController = sender.source as! EntityViewControllerInterface
        let entity:EntityBase? = itemSearchTableViewController.entity
        if let item = entity as? Item? {
            self.entity = item
            self.updateFields(fromItem: item!)
        } else if let bin = entity as? Bin? {
            self.updateFields(fromBin: bin!)
        }
        else if let location = entity as? Location? {
            self.updateFields(fromLocation: location!)
        }
    }

    //MARK: - Update Entry Methods
    
    func updateFields(fromItem:Item)    {
        self.itemNameTextField.text = fromItem.name
        self.itemQuantityTextField.text = String(fromItem.qty)
        self.locationTextField.text = fromItem.itemToBinFK?.binToLocationFK?.name
        self.binTextField.text = fromItem.itemToBinFK?.name
        //self.updateTitle(actionType: ActionType.Update)
    }
    
    func updateFields(fromBin:Bin)    {
        //        self.locationText.text = fromBin.location?.name
        //        self.binText.text = fromBin.name
    }
    
    func updateFields(fromLocation:Location)    {
        self.locationTextField.text = fromLocation.name
    }

}

