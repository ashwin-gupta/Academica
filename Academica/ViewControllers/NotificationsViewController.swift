//
//  NotificationsViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 17/7/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var timePicker: UIPickerView!
    
    let weeks = [0, 1, 2, 3, 4]
    let days = [0, 1, 2, 3, 4, 5, 6]
    let hours = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
    let notifDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timePicker.delegate = self
        self.timePicker.dataSource = self

        // Setting user defaults
        let userWeek = notifDefaults.integer(forKey: "weeks")
        let userDay = notifDefaults.integer(forKey: "days")
        let userHour = notifDefaults.integer(forKey: "hours")
        
        timePicker.selectRow(userWeek+1, inComponent: 0, animated: true)
        timePicker.selectRow(userDay+1, inComponent: 1, animated: true)
        timePicker.selectRow(userHour+1, inComponent: 2, animated: true)
        
        
    }
    
    
    // MARK: - Picker View Delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // For weeks, days, hours
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return weeks.count+1
        case 1:
            return days.count+1
        default:
            return hours.count+1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            if row == 0 {
                return "Weeks"
            } else {
                return String(weeks[row-1])
            }
            
        case 1:
            if row == 0 {
                return "Days"
            } else {
                return String(days[row-1])
            }
            
        default:
            if row == 0 {
                return "Hours"
            } else {
                return String(hours[row-1])
            }
        }
    }
    
    // Save Button
    @IBAction func saveButton(_ sender: Any) {
        if inputValid() {
            let week = weeks[timePicker.selectedRow(inComponent: 0)-1]
            let day = days[timePicker.selectedRow(inComponent: 1)-1]
            let hour = hours[timePicker.selectedRow(inComponent: 2)-1]
            
            notifDefaults.setValue(week, forKey: "weeks")
            notifDefaults.setValue(day, forKey: "days")
            notifDefaults.setValue(hour, forKey: "hours")
        }
        
        navigationController?.popViewController(animated: true)
        
        
        
    }
    
    
    // MARK: - Input Validation
    
    func inputValid() -> Bool {
        if timePicker.selectedRow(inComponent: 0) == 0 {
            displayErrorMessage("Please choose a week!")
            return false
            
        } else if timePicker.selectedRow(inComponent: 1) == 0{
            displayErrorMessage("Please choose a day!")
            return false
            
        } else if timePicker.selectedRow(inComponent: 2) == 0 {
            displayErrorMessage("Please choose an hour!")
            return false
        }
        
        return true
        
    }
    
    func displayErrorMessage(_ errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
