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
        case 2:
            gradeControl.selectedSegmentTintColor = .systemYellow
        case 3:
            gradeControl.selectedSegmentTintColor = .systemOrange
        case 4:
            gradeControl.selectedSegmentTintColor = .systemRed
        default:
            gradeControl.selectedSegmentTintColor = .systemGreen
        }
    }
    

    // Controls what the save button does
    @IBAction func saveButton(_ sender: Any) {
        if newSubject == false {
            subject!.code = unitCodeInput.text
            subject!.name = nameTextField.text
            let score = Double(scoreInput.text!)
            let points = Double(creditInput.text!)
            let year = Int16(yearInput.text!)
    
            subject!.grade = grades[gradeControl.selectedSegmentIndex]
            subject!.score = score!
            subject!.year = year!
            subject!.points = points!
            
            
        }
        
        
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
