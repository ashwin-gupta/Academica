//
//  UnitViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 2/8/20.
//  Copyright © 2020 Ashwin Gupta. All rights reserved.
//

import UIKit

class UnitViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var unitCodeInput: UITextField!
    
    @IBOutlet weak var yearInput: UITextField!
    
    @IBOutlet weak var scoreInput: UITextField!
    
    @IBOutlet weak var creditInput: UITextField!
    
    @IBOutlet weak var progressControl: UISegmentedControl!
    
    @IBOutlet weak var gradePicker: UIPickerView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var assessmentTableView: UITableView!
    
    weak var databaseController: DatabaseProtocol?
    
    var newSubjectFlag: Bool = false
    var subject: Subject?
    var unchangedSubject: Subject?
    var assessments: [Assessment] = []
    var grades : [String] = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.assessmentTableView.delegate = self
        self.assessmentTableView.dataSource = self
        
        self.scoreInput.delegate = self
        self.yearInput.delegate = self
        self.creditInput.delegate = self
        
        self.gradePicker.delegate = self
        self.gradePicker.dataSource = self
        
        grades = ["High Distinction (HD)", "Distinction (D)", "Credit (C)", "Pass (P)", "Fail (N)", "Withdrawn Fail (WN)", "Hurdle Fail (NH)", "Satisfied Faculty Requirements (SFR)", "First Class Honours (HI)", "Second Class Honours Division A (HIIA)", "Second Class Honours Division B (HIIB)", "Third Class Honours (HIII)", "Not Satisfied Requirements (NSR)"]
        
        
//        self.navigationItem.hidesBackButton = true
//        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(UnitViewController.back(sender:)))
//        self.navigationItem.leftBarButtonItem = newBackButton
        
        
        if subject != nil {
            navigationItem.title = subject?.name
            fillInformation(oldSubject: subject!)
        } else {
            progressControl.selectedSegmentIndex = 1
            
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        guard let databaseController = databaseController else {
            fatalError("No database controller.")
        }
        subject = databaseController.createEditableSubject(existingSubject: subject)
        unchangedSubject = subject
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "labelInverse")]
        progressControl.setTitleTextAttributes(titleTextAttributes as [NSAttributedString.Key : Any], for: .selected)
        

    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        assessmentTableView.reloadData()
        assessments = subject!.assessments!.allObjects as! [Assessment]
        
    }
    
    
    
    // Sets the details of the pre-existing subject
    func fillInformation (oldSubject: Subject) {
        
        nameTextField.text = oldSubject.name
        unitCodeInput.text = oldSubject.code
        yearInput.text = String(oldSubject.year)
        scoreInput.text = String(format: "%.0f", oldSubject.score)
        creditInput.text = String(format: "%.0f", oldSubject.points)
        
        if subject?.inProgress == true {
            progressControl.selectedSegmentIndex = 0
        }
        
        switch oldSubject.grade {
        case "D":
            gradePicker.selectRow(1, inComponent: 0, animated: true)
        case "C":
            gradePicker.selectRow(2, inComponent: 0, animated: true)
        case "P":
            gradePicker.selectRow(3, inComponent: 0, animated: true)
        case "N":
            gradePicker.selectRow(4, inComponent: 0, animated: true)
        case "WN":
            gradePicker.selectRow(5, inComponent: 0, animated: true)
        case "NH":
            gradePicker.selectRow(6, inComponent: 0, animated: true)
        case "SFR":
            gradePicker.selectRow(7, inComponent: 0, animated: true)
        case "HI":
            gradePicker.selectRow(8, inComponent: 0, animated: true)
        case "HIIA":
            gradePicker.selectRow(9, inComponent: 0, animated: true)
        case "HIIB":
            gradePicker.selectRow(10, inComponent: 0, animated: true)
        case "HIII":
            gradePicker.selectRow(11, inComponent: 0, animated: true)
        case "NSR":
            gradePicker.selectRow(12, inComponent: 0, animated: true)
        default:
            gradePicker.selectRow(0, inComponent: 0, animated: true)
        }
        
        
    }
    

    // Controls what the save button does
    @IBAction func saveButton(_ sender: Any) {
        
        if checkInputValidity() == true {
            let name = nameTextField.text
            let code = unitCodeInput.text
            let score = Double(scoreInput.text!)
            let points = Double(creditInput.text!)
            let year = Int16(yearInput.text!)
            
            var grade: String
        
            switch gradePicker.selectedRow(inComponent: 0) {
            case 1:
                grade = "D"
            case 2:
                grade = "C"
            case 3:
                grade = "P"
            case 4:
                grade = "N"
            case 5:
                grade = "WN"
            case 6:
                grade = "NH"
            case 7:
                grade = "SFR"
            case 8:
                grade = "HI"
            case 9:
                grade = "HIIA"
            case 10:
                grade = "HIIB"
            case 11:
                grade = "HIII"
            case 12:
                grade = "NSR"
            default:
                grade = "HD"
            }
            
            var inProgress = false
            if progressControl.selectedSegmentIndex == 0 {
                inProgress = true
            }
            
            print(newSubjectFlag)
            let favourite = false
            
            subject?.name = name
            subject?.code = code
            subject?.grade = grade
            subject?.points = points!
            subject?.score = score!
            subject?.year = year!
            subject?.isFavourite = favourite
            subject?.inProgress = inProgress
            
            newSubjectFlag = false
            databaseController?.saveEdits()
            databaseController?.cleanup()
            
            navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return grades.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return grades[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view {
            label = v as! UILabel
        }
        
        label.font = UIFont(name: "San Francisco", size: 12)
        label.text = grades[row]
        label.textAlignment = .center
        return label
    }
    
    
    func checkInputValidity() -> Bool {
        if nameTextField.text == ""  {
            displayErrorMessage("Please enter a name!")
            return false
        }
        
        if unitCodeInput.text == "" {
            displayErrorMessage("Please enter a unit code!")
            return false
        }
        
        guard let score = Double(scoreInput.text!) else {
            displayErrorMessage("Please enter a score!")
            return false
        }
        
        guard let points = Double(creditInput.text!) else {
            displayErrorMessage("Please enter credit points!")
            return false
        }
        
        guard let year = Int16(yearInput.text!) else {
            displayErrorMessage("Please enter a year!")
            return false
        }

        return true
        
    }
    
    func displayErrorMessage(_ errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case scoreInput:
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            if string.isEmpty || string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil {
                return newString.length <= maxLength
            } else {
                return false
            }
            
            
        case creditInput:
            let maxLength = 2
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            if string.isEmpty || string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil {
                return newString.length <= maxLength
            } else {
                return false
            }
        default:
            let maxLength = 4
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            if string.isEmpty || string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil {
                return newString.length <= maxLength
            } else {
                return false
            }
            
        }
    }
        
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == scoreInput && scoreInput.text != "" {
            
            
            let score = Double(scoreInput.text!)!
            
            if score >= 80 {
                gradePicker.selectRow(0, inComponent: 0, animated: true)
                
            } else if score >= 70 && score < 80 {
                gradePicker.selectRow(1, inComponent: 0, animated: true)
            } else if score >= 60 && score < 70 {
                gradePicker.selectRow(2, inComponent: 0, animated: true)
            } else if score >= 50 && score < 60 {
                gradePicker.selectRow(3, inComponent: 0, animated: true)
            } else if score < 50 {
                gradePicker.selectRow(4, inComponent: 0, animated: true)
            }
            // do what is needed
        }
    }
    
    // MARK: - TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assessmentCountCell") as! AssessmentTableViewCell
        
        var count: Int?
        
        count = subject?.assessments?.count
        
        if count == nil {
            count = 0
        }
        cell.assessmentCount.text = "\(count!)"
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if checkInputValidity() == false && newSubjectFlag == true {
//            displayErrorMessage("Please fill all fields and press save before continuing.")
//
//
//        } else {
//
//            performSegue(withIdentifier: "viewAllAssessmentsSegue", sender: self)
//        }
//    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewAllAssessmentsSegue" {
            let destination = segue.destination as! AssessmentsViewController
            destination.subject = subject!
        
        }
    }
    

}

