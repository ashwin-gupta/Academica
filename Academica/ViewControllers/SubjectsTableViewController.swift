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
    var favUnits: [Subject] = []
    
    weak var databaseController: DatabaseProtocol?
    
    let defaults = UserDefaults.standard
    let FAVOURITE_LIST = "Favourite List"
    

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
        tableView.reloadData()
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
        if studentSubjects.isEmpty {
            return 0
        } else {
            return orderedSubjects.count
        }
    }


    
    func onStudentChange(change: DatabaseChange, studentSubjects: [Subject]) {
        // Do nothing
    }
    
    func onSubjectChange(change: DatabaseChange, subjects: [Subject]) {
        studentSubjects = subjects
        if !studentSubjects.isEmpty {
            orderedSubjects = []
            sortSubjects(subjects: studentSubjects)
            
        }
        
        tableView.reloadData()
    }
    
    func onAssessmentChange(change: DatabaseChange, subjects: [Assessment]) {
        // Do nothing
    }
    
    
    
    //MARK: - Table View Functions

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unitCell") as! UnitTableViewCell
        
        let subject = orderedSubjects[indexPath.section][indexPath.row]
            cell.gradeLabel.text = subject.grade
            cell.scoreLabel.text = String(format: "%.0f", subject.score)
            cell.unitLabel.text = subject.code
            cell.nameLabel.text = subject.name
            return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderedSubjects[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(orderedSubjects[section][0].year)
    }
    

    
    // Allows the deletion of advertisements my swiping. Also gives the user feedback on whether they want to delete the advert
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let unit = orderedSubjects[indexPath.section][indexPath.row]
            // Delete the row from the data source
            let alertController = UIAlertController(title: "Delete?", message: "Are you sure you want to delete this subject?\n\n This cannot be reversed.", preferredStyle: UIAlertController.Style.alert)
            
            
            alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (_) in
                // Removing the advertisement from teh user
                self.databaseController?.deleteSubject(subject: unit)
                self.tableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            

        }
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let unit = orderedSubjects[indexPath.section][indexPath.row]
        
        var favAction = UIContextualAction(style: .normal, title: "Favourite") { (action, view, handler) in
            print("Favourite Action Tapped")
            debugPrint("Added to favourites")
            
        }
        
        switch unit.isFavourite {
        case true:
             favAction = UIContextualAction(style: .destructive, title: "Unfavourite") { (action, view, handler) in
                print("Favourite Action Tapped")
                unit.isFavourite = false
                debugPrint("Added to favourites")
            }
        case false:
            favAction = UIContextualAction(style: .normal, title: "Favourite") { (action, view, handler) in
                print("Favourite Action Tapped")
                unit.isFavourite = true
                debugPrint("Added to favourites")
                
            }
            favAction.backgroundColor = .systemYellow
            
        
        default:
            favAction = UIContextualAction(style: .normal, title: "Favourite") { (action, view, handler) in
                print("Favourite Action Tapped")
                unit.isFavourite = true
                debugPrint("Added to favourites")
                
            }
            favAction.backgroundColor = .systemYellow
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [favAction])
        
        return configuration
        
    }
    
    // MARK: - Sorting Algorithm for Subjects
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "subjectSegue" {
            let destination = segue.destination as! UnitViewController
            destination.subject = orderedSubjects[tableView.indexPathForSelectedRow!.section][tableView.indexPathForSelectedRow!.row]
            
        } else if segue.identifier == "newUnitSegue" {
            let destination = segue.destination as! UnitViewController
            destination.newSubject = true
            
        }
    }
    

}
