//
//  EditAssessmentViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 6/7/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//

import UIKit

class EditAssessmentViewController: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var weightingTextField: UITextField!
    @IBOutlet weak var completionControl: UISegmentedControl!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    weak var databaseController: DatabaseProtocol?
    
    var assessment: Assessment?
    var subject: Subject?
    var newAssessment: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.weightingTextField.delegate = self
        self.scoreTextField.delegate = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        guard let databaseController = databaseController else {
            fatalError("No database controller.")
        }
        
        if assessment != nil {
            fillInformation(oldAssessment: assessment!)
            
        } else {
            completionControl.selectedSegmentIndex = 0
            datePicker.isHidden = true
            dueDateLabel.isHidden = true
        }
        
        assessment = databaseController.createEditableAssessment(existingAssessment: assessment)
        completionControl.addTarget(self, action: #selector(EditAssessmentViewController.indexChanged(_:)), for: .valueChanged)
        
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        if completionControl.selectedSegmentIndex == 0 {
            datePicker.isHidden = true
            dueDateLabel.isHidden = true
        } else if completionControl.selectedSegmentIndex == 1 {
            datePicker.isHidden = false
            dueDateLabel.isHidden = false
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        
        
        if inputValid() {
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let name = nameTextField.text
            let score = Double(scoreTextField.text!)!
            let weighting = Double(weightingTextField.text!)
            let date = dateFormatter.string(from: datePicker.date)
            var completion = true
            if completionControl.selectedSegmentIndex == 1 {
                completion = false
            }
            
            assessment?.name = name
            assessment?.weighting = weighting!
            assessment?.score = score
            assessment?.isCompleted = completion
            
            if assessment?.isCompleted == true {
                
                assessment?.dueDate = nil
                
            } else {
                assessment?.dueDate = dateFormatter.date(from: date)
                print(assessment?.dueDate)
            }
            
            let _ = databaseController?.addAssessment(name: name!, dueDate: date, weighting: weighting!, score: score, completion: completion, subject: subject!)
            
            print(subject)
            navigationController?.popViewController(animated: true)

        }
    }
    
    
    
    func fillInformation (oldAssessment: Assessment) {
        
        nameTextField.text = oldAssessment.name
        scoreTextField.text = String(format: "%.0f", oldAssessment.score)
        weightingTextField.text = String(format: "%.0f", oldAssessment.weighting)
        
        if oldAssessment.isCompleted {
            datePicker.isHidden = true
            dueDateLabel.isHidden = true
            
        } else {
            
            datePicker.setDate(oldAssessment.dueDate!, animated: true)
            
        }
        

    }
    
    func inputValid() -> Bool {
        if nameTextField.text == ""  {
            displayErrorMessage("Please enter a name!")
            return false
        }
        
        guard let score = Double(scoreTextField.text!) else {
            displayErrorMessage("Please enter a score!")
            return false
        }
        
        guard let weighting = Double(weightingTextField.text!) else {
            displayErrorMessage("Please enter weighting!")
            return false
        }
        
        return true
        
    }
  
    // MARK: - Text Field Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case weightingTextField:
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            if string.isEmpty || string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil {
                return newString.length <= maxLength
            } else {
                return false
            }
        
            
        default:
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            if string.isEmpty || string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil {
                return newString.length <= maxLength
            } else {
                return false
            }
        }
    }
    
    func displayErrorMessage(_ errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }

}
