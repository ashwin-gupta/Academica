//
//  HomeViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 2/8/20.
//  Copyright © 2020 Ashwin Gupta. All rights reserved.
//

import UIKit

// Extension for all View Controllers to allow users to tap out of a text field by tapping the background
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
    
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DatabaseListener {
    

    var units: [Subject] = []
    let firstYearUnit: String = "XXX1"
    
    @IBOutlet weak var gpaLabel: UILabel!
    
    @IBOutlet weak var wamLabel: UILabel!

    @IBOutlet weak var unitTableView: UITableView!

    
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .all
    var creditSum: Double = 0
    var gpaSum: Double = 0
    var wamCreditSum: Double = 0
    
    @IBAction func newSubject(_ sender: Any) {
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        self.unitTableView.delegate = self
        self.unitTableView.dataSource = self

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        unitTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    // MARK: - Table View Data Source Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if units.count < 4 {
            return units.count
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unitCell") as! UnitTableViewCell
        
        
            let subject = units[indexPath.row]
            cell.gradeLabel.text = subject.grade
            cell.scoreLabel.text = String(format: "%.0f", subject.score)
            cell.unitLabel.text = subject.code
            cell.creditPoints.text = subject.name
            
            monashWamCalculate()
            gpaCalculate()
            return cell

    }
    
    // MARK: - Table View Functions
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Allows the deletion of advertisements my swiping. Also gives the user feedback on whether they want to delete the advert
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let unit = units[indexPath.row]
            // Delete the row from the data source
            let alertController = UIAlertController(title: "Delete?", message: "Are you sure you want to delete this subject? This cannot be reversed.", preferredStyle: UIAlertController.Style.alert)
            
            
            alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (_) in
                // Removing the advertisement from teh user
                self.databaseController?.deleteSubject(subject: unit)
                self.unitTableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)

        }
    }
    

    // MARK: - Database Listeners
    
    func onStudentChange(change: DatabaseChange, studentSubjects: [Subject]) {
        // Do nothing
    }
    
    func onSubjectChange(change: DatabaseChange, subjects: [Subject]) {
        units = subjects
        unitTableView.reloadData()
    }
    
    func wamCalculate() {
        var marksSum: Double = 0
        gpaSum = 0
        creditSum = 0
        for subject in units {
            marksSum = (subject.score * subject.points) + marksSum
            creditSum = subject.points + creditSum

        }
        
        let wam = String(format: "%.4f", marksSum/creditSum)
        
        wamLabel.text = wam
    }
    
    func gpaCalculate() {
        for subject in units {
            
            creditSum = subject.points + creditSum
            
            switch subject.grade {
            case "D":
                gpaSum = (subject.points * 3) + gpaSum
            case "C":
                gpaSum = (subject.points * 2) + gpaSum
            case "P":
                gpaSum = (subject.points * 1) + gpaSum
            case "N":
                gpaSum = (subject.points * 0) + gpaSum
                
            default:
                gpaSum = (subject.points * 4) + gpaSum
            }
            
            let gpa = String(format: "%.4f", gpaSum/creditSum)
            gpaLabel.text = gpa
            
        }
    }
    
    func monashWamCalculate() {
        var marksSum: Double = 0
        gpaSum = 0
        creditSum = 0
        wamCreditSum = 0
        for subject in units {
            if subject.code?.firstIndex(of: "1") == firstYearUnit.firstIndex(of:"1") {
                marksSum = (subject.score * subject.points)/2 + marksSum
                wamCreditSum = subject.points/2 + wamCreditSum
                
            } else {
                marksSum = (subject.score * subject.points) + marksSum
                wamCreditSum = subject.points + wamCreditSum
            }
        
        let wam = String(format: "%.4f", marksSum/wamCreditSum)
        
        wamLabel.text = wam
    }
    
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newSubjectSegue" {
            let destination = segue.destination as! UnitViewController
            
            destination.newSubject = true
        } else if segue.identifier == "oldSubjectSegue" {
            let destination = segue.destination as! UnitViewController
            destination.subject = units[unitTableView.indexPathForSelectedRow!.row]
            
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
