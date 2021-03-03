//
//  UnitViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 2/8/20.
//  Copyright © 2020 Ashwin Gupta. All rights reserved.
//

import UIKit

class UnitViewController: UIViewController {

    @IBOutlet weak var unitCodeInput: UITextField!
    
    @IBOutlet weak var yearInput: UITextField!
    
    @IBOutlet weak var scoreInput: UITextField!
    
    @IBOutlet weak var creditInput: UITextField!
    
    @IBOutlet weak var gradeControl: UISegmentedControl!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    weak var databaseController: DatabaseProtocol?
    
    var newSubject: Bool = false
    var subject: Subject?
    
    let grades = ["HD", "D", "C", "P", "N"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if newSubject == false {
            fillInformation(oldSubject: subject!)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        navigationItem.backBarButtonItem?.tintColor = .label
        
        

    }
    
    // Sets the details of the pre-existing subject
    func fillInformation (oldSubject: Subject) {
        
        navigationItem.title = oldSubject.code
        
        nameTextField.text = oldSubject.name
        unitCodeInput.text = oldSubject.code
        yearInput.text = String(oldSubject.year)
        scoreInput.text = String(oldSubject.score)
        creditInput.text = String(oldSubject.points)
        
        switch oldSubject.grade {
        case "D":
            gradeControl.selectedSegmentIndex = 1
        case "C":
            gradeControl.selectedSegmentIndex = 2
        case "P":
            gradeControl.selectedSegmentIndex = 3
        case "N":
            gradeControl.selectedSegmentIndex = 4
        default:
            gradeControl.selectedSegmentIndex = 0
        }
        gradeControlStyle()
        
    }
    
    // For styling of segmented control
    func gradeControlStyle() {
        
        switch gradeControl.selectedSegmentIndex {
        case 1:
            gradeControl.selectedSegmentTintColor = .systemTeal
            gradeControl.reloadInputViews()
        case 2:
            gradeControl.selectedSegmentTintColor = .systemYellow
            gradeControl.reloadInputViews()
        case 3:
            gradeControl.selectedSegmentTintColor = .systemOrange
            gradeControl.reloadInputViews()
        case 4:
            gradeControl.selectedSegmentTintColor = .systemRed
            gradeControl.reloadInputViews()
        default:
            gradeControl.selectedSegmentTintColor = .systemGreen
            gradeControl.reloadInputViews()
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
            let grade = grades[gradeControl.selectedSegmentIndex]
            print(newSubject)
            
            if newSubject {

                let _ = databaseController?.addSubject(name: name!, code: code!, grade: grade, points: points!, score: score!, year: year!)
                
            } else {
                subject?.name = name
                subject?.code = code
                subject?.score = score!
                subject?.points = points!
                subject?.year = year!
                subject?.grade = grade
            }
            
            navigationController?.popViewController(animated: true)
            
        }
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
