//
//  AssessmentsViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 6/7/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//

import UIKit

class AssessmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var aggregateScoreLabel: UILabel!
    @IBOutlet weak var assessmentTableView: UITableView!
    @IBOutlet weak var projectedScoreView: UIView!
    
    weak var databaseController: DatabaseProtocol?
    
    var subject: Subject?
    
    var assessments: [Assessment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectedScoreView.layer.cornerRadius = 12
        
        self.assessmentTableView.delegate = self
        self.assessmentTableView.dataSource = self
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        assessments = subject!.assessments!.allObjects as! [Assessment]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        assessments = subject!.assessments!.allObjects as! [Assessment]
        assessmentTableView.reloadData()
        aggregateScoreLabel.text = String(calcAggregateScore(assessments: assessments))
        debugPrint(assessments.count)
    }
    
    
    // MARK: - Table View Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if subject!.assessments?.count != 0 {
            return subject!.assessments!.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if assessments.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assessmentOverviewCell") as! AssessmentsTableViewCell
        let infoCell = tableView.dequeueReusableCell(withIdentifier: "assessmentInfoCell") as! HomeInfoTableViewCell
        

        
        if assessments.isEmpty {
            
            infoCell.infoLabel?.text = "Press + to add an assessment."
            infoCell.infoLabel?.textColor = .secondaryLabel
            infoCell.titleLabel?.text = "No Assessments!"
            infoCell.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
            
            return infoCell
            
        } else {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM h:mm a"
            cell.nameLabel.text = assessments[indexPath.row].name
            
            cell.weightingLabel.text = String(format: "%.0f", assessments[indexPath.row].weighting) + "%"

            if assessments[indexPath.row].isCompleted {
                cell.dueDateLabel.text = "Completed"
                cell.scoreLabel.text = String(format: "%.0f", assessments[indexPath.row].score)
                cell.scoreLabel.textColor = .secondaryLabel
                
            } else {
                cell.scoreLabel.text = "In Progress"
                cell.scoreLabel.textColor = .secondaryLabel
                cell.dueDateLabel.text = dateFormatter.string(from: assessments[indexPath.row].dueDate!)
            }
            
            return cell
            
        }
    }
    
    // Allows the deletion of subjects my swiping. Also gives the user feedback on whether they want to delete the subject
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let assessment = assessments[indexPath.row]
            // Delete the row from the data source
            let alertController = UIAlertController(title: "Delete?", message: "Are you sure you want to delete this assessment?\n\n This cannot be reversed.", preferredStyle: UIAlertController.Style.alert)
            
            
            alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (_) in
                // Removing the subject from the user
                self.databaseController?.deleteAssessment(subject: self.subject!, assessment: assessment)
                self.assessments.remove(at: indexPath.row)
                self.aggregateScoreLabel.text = String(self.calcAggregateScore(assessments: self.assessments))
                self.assessmentTableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)

        }
        
    
    }
    
    
    func calcAggregateScore(assessments: [Assessment]) -> Double {
        
        var total: Double = 0
        
        for assessment in assessments {
            if !assessment.isCompleted {
                break
            } else {
                total += (assessment.weighting/100) * assessment.score
            }

        }
        
        return total
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editAssessmentSegue" {
            let destination = segue.destination as! EditAssessmentViewController
            destination.subject = subject
            
            if assessments.isEmpty {
                destination.newAssessment = true
            } else {
                destination.assessment = assessments[assessmentTableView.indexPathForSelectedRow!.row]
                
            }
            
            
        } else if segue.identifier == "newAssessmentSegue" {
            let destination = segue.destination as! EditAssessmentViewController
            destination.subject = subject
            destination.newAssessment = true
        } else if segue.identifier == "newCellAssessmentSegue" {
            let destination = segue.destination as! EditAssessmentViewController
            destination.subject = subject
            destination.newAssessment = true
        }

    }
    

}
