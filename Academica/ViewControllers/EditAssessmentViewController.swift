//
//  EditAssessmentViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 6/7/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//

import UIKit
import UserNotifications

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
            navigationItem.title = assessment?.name
            fillInformation(oldAssessment: assessment!)
        } else {
            navigationItem.title = "New Assessment"
        }
        
        if !newAssessment {
            fillInformation(oldAssessment: assessment!)
            
        } else {
            completionControl.selectedSegmentIndex = 0
            datePicker.isHidden = true
            dueDateLabel.isHidden = true
        }
        
        assessment = databaseController.createEditableAssessment(existingAssessment: assessment)
        completionControl.addTarget(self, action: #selector(EditAssessmentViewController.indexChanged(_:)), for: .valueChanged)
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "labelInverse")]
        completionControl.setTitleTextAttributes(titleTextAttributes as [NSAttributedString.Key : Any], for: .selected)
        
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
            var score = 0.0
            let weighting = Double(weightingTextField.text!)!
            let date = dateFormatter.string(from: datePicker.date)
            var completion = false
            if completionControl.selectedSegmentIndex == 1 {
                completion = false
                
                if scoreTextField.text == "" {
                    score = -1
                    
                } else {
                    score = Double(scoreTextField.text!)!
                    
                }
                
            } else {
                score = Double(scoreTextField.text!)!
                completion = true

                assessment?.dueDate = nil
            }
            
            assessment?.name = name
            assessment?.isCompleted = completion
            assessment?.score = score
            assessment?.weighting = weighting
            
            if assessment?.isCompleted == true {
                
                assessment?.dueDate = nil
                
            } else {
                assessment?.dueDate = dateFormatter.date(from: date)
                let center = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                if let subUnit = subject?.code {
                    content.title = "\(subUnit) - Assessment Due"
                }
                
                dateFormatter.dateFormat = "EEEE, d MMM h:mm a"
                let time = dateFormatter.string(from: datePicker.date)
                
                if let body = assessment?.name {
                    content.body = "\(body) is due on \(time)"
                }
                let notifDefaults = UserDefaults.standard
                let userWeek = Double(notifDefaults.integer(forKey: "weeks"))
                let userDay = Double(notifDefaults.integer(forKey: "days"))
                let userHour = Double(notifDefaults.integer(forKey: "hours"))
                
                var notifTime: Double = 0
                var notifWeek: Double = 0
                var notifDay: Double = 0
                var notifHour: Double = 0
                
                notifWeek = userWeek*7*24*60*60
                notifDay = userDay*24*60*60
                notifHour = userHour*60*60
            
                notifTime = notifWeek + notifDay + notifHour
                
                let notifyDate = datePicker.date.addingTimeInterval(-notifTime)
                

                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notifyDate)

                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let uuidString = UUID().uuidString

                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

                center.add(request) { error in
                    
                }
                
            }
            
            if newAssessment {
                let _ = databaseController?.addAssessment(name: name!, dueDate: date, weighting: weighting, score: score, completion: completion, subject: subject!)
                
            }
            navigationController?.popViewController(animated: true)

        }
    }
    
    
    
    func fillInformation (oldAssessment: Assessment) {
        
        nameTextField.text = oldAssessment.name
        weightingTextField.text = String(format: "%.0f", oldAssessment.weighting)
        if oldAssessment.isCompleted {
            datePicker.isHidden = true
            dueDateLabel.isHidden = true
        } else {
            completionControl.selectedSegmentIndex = 1
            datePicker.setDate(oldAssessment.dueDate!, animated: true)
            
        }
        
        if oldAssessment.score == -1 {
            scoreTextField.text = ""
            
        } else {
            scoreTextField.text = String(format: "%.0f", oldAssessment.score)
        }
        

    }
    
    func inputValid() -> Bool {
        if nameTextField.text == ""  {
            displayErrorMessage("Please enter a name!")
            return false
        }
        
        guard Double(weightingTextField.text!) != nil else {
            displayErrorMessage("Please enter weighting!")
            return false
        }
        
        if completionControl.selectedSegmentIndex == 0 {
            guard Double(scoreTextField.text!) != nil else {
                displayErrorMessage("Please enter a score!")
                return false
            }
            
            
        } else {
            if datePicker.date < Date() {
                displayErrorMessage("Please enter a correct date!")
                return false
            }
            
            return true
            
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
