//
//  WhatsNewViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 23/7/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//

import UIKit

class WhatsNewViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton.layer.cornerRadius = 12
        textView.text = " - In Progress assessments and units no longer require a score when saving.\n\n - In progress subjects and assessments no longer contribute to GPA, WAM and aggregate score respectively.\n\n - You can now tap on the cell to add a new subject or assessment.\n\n - A selection of two calculation types: Standard and Monash University"

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
