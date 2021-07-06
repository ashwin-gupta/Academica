//
//  AssessmentsViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 6/7/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//

import UIKit

class AssessmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var aggregateScoreLabel: UILabel!
    @IBOutlet weak var assessmentTableView: UITableView!
    @IBOutlet weak var projectedScoreView: UIView!
    
    var subject = Subject()
    var assessments: [Assessment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectedScoreView.layer.cornerRadius = 12
        
        self.assessmentTableView.delegate = self
        self.assessmentTableView.dataSource = self

        assessments = subject.assessments!.allObjects as! [Assessment]
        debugPrint(assessments)
    }
    
    
    // MARK: - Table View Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if subject.assessments?.count != 0 {
            return subject.assessments!.count
        } else {
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assessmentOverviewCell") as! AssessmentsTableViewCell
        
        
        cell.nameLabel.text = assessments[indexPath.row].name
        cell.weightingLabel.text = String(assessments[indexPath.row].weighting)
        
        return cell
        
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
