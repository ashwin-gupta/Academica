//
//  EditAssessmentViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 6/7/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//

import UIKit

class EditAssessmentViewController: UIViewController {
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var weightingTextField: UITextField!
    @IBOutlet weak var saveButtonView: UIButton!
    @IBAction func savePressed(_ sender: Any) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        saveButtonView.layer.cornerRadius = 12

        // Do any additional setup after loading the view.
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
