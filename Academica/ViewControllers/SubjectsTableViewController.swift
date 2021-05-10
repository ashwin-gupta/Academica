//
//  SubjectsTableViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 22/3/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//

import UIKit

class SubjectsTableViewController: UITableViewController, DatabaseListener {
    var listenerType: ListenerType = .all
    var studentSubjects: [Subject] = []
    var orderedSubjects: [[Subject]] = []
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
        studentSubjects = []
        orderedSubjects = []
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return orderedSubjects.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderedSubjects[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(orderedSubjects[section][0].year)
    }
    
    func onStudentChange(change: DatabaseChange, studentSubjects: [Subject]) {
        // Do nothing
    }
    
    func onSubjectChange(change: DatabaseChange, subjects: [Subject]) {
        studentSubjects = subjects
        if !studentSubjects.isEmpty {
            sortSubjects(subjects: studentSubjects)
        }
        
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unitCell") as! UnitTableViewCell
        
        let subject = orderedSubjects[indexPath.section][indexPath.row]
            cell.gradeLabel.text = subject.grade
            cell.scoreLabel.text = String(format: "%.0f", subject.score)
            cell.unitLabel.text = subject.code
            cell.nameLabel.text = subject.name
            return cell
    }
    
    func sortSubjects(subjects: [Subject]) {
        // Setting the starting year to the first year in the array
        var currentYear: Int16 = subjects[0].year
        var yearArray: [Subject] = []
        for unit in subjects {
            if unit.year != currentYear {
                currentYear = unit.year
                orderedSubjects.append(yearArray)
                yearArray = [unit]
                
            } else {
                yearArray.append(unit)
            }
        }
        orderedSubjects.append(yearArray)
    }
    
    // Allows the deletion of advertisements my swiping. Also gives the user feedback on whether they want to delete the advert
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let unit = orderedSubjects[indexPath.section][indexPath.row]
            // Delete the row from the data source
            let alertController = UIAlertController(title: "Delete?", message: "Are you sure you want to delete this subject? This cannot be reversed.", preferredStyle: UIAlertController.Style.alert)
            
            
            alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (_) in
                // Removing the advertisement from teh user
                self.databaseController?.deleteSubject(subject: unit)
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)

        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
