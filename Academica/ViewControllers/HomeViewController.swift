//
//  HomeViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 2/8/20.
//  Copyright © 2020 Ashwin Gupta. All rights reserved.
//

import UIKit
import UserNotifications

// Extension for all View Controllers to allow users to tap out of a text field by tapping the background
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DatabaseListener, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    // Setting the inests of the collection view controller
    private let sectionInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

    let firstYearUnit: String = "XXX1"
    let defaults = UserDefaults.standard
    

    @IBOutlet weak var unitTableView: UITableView!
    @IBOutlet weak var calcCollectionView: UICollectionView!
    @IBOutlet weak var gradesLabel: UILabel!
    
    weak var databaseController: DatabaseProtocol?
    
    var listenerType: ListenerType = .all
    var creditSum: Double = 0
    var gpaSum: Double = 0
    var wamCreditSum: Double = 0
    var units: [Subject] = []
    var favUnits: [Subject] = []
    var calcStyle: String?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        self.unitTableView.delegate = self
        self.unitTableView.dataSource = self
        
        self.calcCollectionView.delegate = self
        self.calcCollectionView.dataSource = self
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
        }
        
        
        calcStyle = defaults.string(forKey: "calcStyle")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let calcVC = storyboard.instantiateViewController(
//                   withIdentifier: "CalculationPopUpViewController")
        let newVC = storyboard.instantiateViewController(identifier: "WhatsNewViewController")
         
        // Use the popover presentation style for your view controller.
//        calcVC.modalPresentationStyle = .popover
        newVC.modalPresentationStyle = .popover


        // Present the view controller (in a popover).
//        self.present(calcVC, animated: true) {
//           // The popover is visible.
//        }
        self.present(newVC, animated: true) {
            //Pop over is visible
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        unitTableView.reloadData()
        calcCollectionView.reloadData()
        
        if !units.isEmpty {
            gradesLabel.isHidden = false
        } else {
            gradesLabel.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    // MARK: - Table View Data Source Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favUnits.isEmpty {
            return 1
        } else {
            return favUnits.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unitCell") as! UnitTableViewCell
        let infoCell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! HomeInfoTableViewCell
        
        if favUnits.isEmpty {
            infoCell.infoLabel?.text = "Add favourite subjects by swiping right on a subject in the subject tab!"
            infoCell.infoLabel?.textColor = .secondaryLabel
            infoCell.selectionStyle = .none
            tableView.isUserInteractionEnabled = false
            return infoCell
            
        } else {
            let subject = favUnits[indexPath.row]
            tableView.isUserInteractionEnabled = true
            
            if subject.inProgress {
                cell.scoreLabel.text = ""
                cell.gradeLabel.text = "In Progress"
                cell.gradeLabel.textColor = .secondaryLabel
                
            } else {
                cell.gradeLabel.text = subject.grade
                cell.gradeLabel.textColor = .label
                cell.scoreLabel.text = String(format: "%.0f", subject.score)
                
            }
            
            cell.unitLabel.text = subject.code
            cell.nameLabel.text = subject.name
            
            return cell

        }
    }
    
    // MARK: - Table View Functions
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if favUnits.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    // Allows the deletion of subjects my swiping. Also gives the user feedback on whether they want to delete the subject
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let unit = units[indexPath.row]
            // Delete the row from the data source
            let alertController = UIAlertController(title: "Delete?", message: "Are you sure you want to delete this subject?\n\n This cannot be reversed.", preferredStyle: UIAlertController.Style.alert)
            
            
            alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (_) in
                // Removing the subject from the user
                self.databaseController?.deleteSubject(subject: unit)
                self.unitTableView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)

        }
        
    
    }
    
     func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let unit = favUnits[indexPath.row]
        
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
    

    // MARK: - Collection View Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if units.isEmpty {
            return 1
        } else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calcCell", for: indexPath) as! CalculationCollectionViewCell
        
        cell.layer.cornerRadius = 12
        
        if units.isEmpty {
            cell.gpaWamLabel.text = "No Subjects!"
            cell.calcLabel.text = "Click + to add a subject!"
            cell.isUserInteractionEnabled = true
            
        } else {
            cell.isUserInteractionEnabled = false
            // Setting GPA and WAM Labels
            switch indexPath.row {
            case 0:
                cell.gpaWamLabel.text = "GPA"
                cell.calcLabel.text = gpa()
            
            case 1:
                cell.gpaWamLabel.text = "WAM"
                if calcStyle == "Standard" {
                    cell.calcLabel.text = wamCalculate()
                } else {
                    cell.calcLabel.text = monashWam()
                }
                
            
            default:
                cell.gpaWamLabel.text = "GPA"
                cell.calcLabel.text = gpa()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var itemsPerRow: CGFloat = 1
        var paddingSpace: CGFloat
        if units.isEmpty {
            itemsPerRow = 1
            paddingSpace = 0
            
        } else {
            itemsPerRow = 2
            paddingSpace = sectionInsets.left * (itemsPerRow)
        }
        // Setting the sizing of the collectionView
        
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = collectionView.frame.height
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
        

    // MARK: - Database Listeners
    
    func onStudentChange(change: DatabaseChange, studentSubjects: [Subject]) {
        // Do nothing
    }
    
    func onSubjectChange(change: DatabaseChange, subjects: [Subject]) {
        units = subjects
        favUnits = getFavouriteSubjects(allUnits: units)
        unitTableView.reloadData()
    }
    
    func onAssessmentChange(change: DatabaseChange, assessments: [Assessment]) {
        // Do nothing
    }
    
    func onUniversityChange(change: DatabaseChange, university: [University]) {
        // Do nothing
    }
    
    
    // MARK: - Subject Data Processing
    func getFavouriteSubjects(allUnits: [Subject]) -> [Subject] {
        var favourites: [Subject] = []
        
        for unit in allUnits {
            if unit.isFavourite {
                favourites.append(unit)
            }
        }
        return favourites
        
    }
    
    
    // MARK: - Calculations
    
    func wamCalculate() -> String {
        var marksSum: Double = 0
        gpaSum = 0
        creditSum = 0
        
        for subject in units {
            
            if !subject.inProgress {
                marksSum = (subject.score * subject.points) + marksSum
                creditSum = subject.points + creditSum
            }

        }
        
        var wam = String(format: "%.3f", marksSum/creditSum)
        
        if wam == "nan" {
            wam = "0.000"
        }
        return wam
    }
    
    func gpa() -> String {
        
        for subject in units {
            
            if !subject.inProgress {
                
                switch subject.grade {
                case "D":
                    gpaSum = (subject.points * 3) + gpaSum
                    creditSum = subject.points + creditSum
                    
                case "C":
                    gpaSum = (subject.points * 2) + gpaSum
                    creditSum = subject.points + creditSum
                    
                case "P":
                    gpaSum = (subject.points * 1) + gpaSum
                    creditSum = subject.points + creditSum
                    
                case "N":
                    gpaSum = (subject.points * 0.7) + gpaSum
                    creditSum = subject.points + creditSum
                    
                case "NH":
                    gpaSum = (subject.points * 0.3) + gpaSum
                    creditSum = subject.points + creditSum
                    
                case "WN":
                    gpaSum = (subject.points * 0.3) + gpaSum
                    creditSum = subject.points + creditSum
                    
                case "SFR":
                    break
                    // Nothing
                
                case "NSR":
                    break
                
                case "HI":
                    gpaSum = (subject.points * 4) + gpaSum
                    creditSum = subject.points + creditSum
                    
                case "HIIA":
                    gpaSum = (subject.points * 3) + gpaSum
                    creditSum = subject.points + creditSum
                    
                case "HIIB":
                    gpaSum = (subject.points * 2) + gpaSum
                    creditSum = subject.points + creditSum
                    
                case "HIII":
                    gpaSum = (subject.points * 1) + gpaSum
                    creditSum = subject.points + creditSum
                    
                default:
                    gpaSum = (subject.points * 4) + gpaSum
                    creditSum = subject.points + creditSum
                }
            }
 
        }
        
        var gpaString = String(format: "%.3f", gpaSum/creditSum)
        
        if gpaString == "nan" {
            gpaString = "0.000"
        }
        return gpaString
    }
    
    func monashWam() -> String {
        var marksSum: Double = 0
        var wam: String = ""
        gpaSum = 0
        creditSum = 0
        wamCreditSum = 0
        
        for subject in units {
            let grade = subject.grade
            
            if grade == "NSR" || grade == "SFR" || subject.inProgress {
                
                //do nothing
            } else {
                if subject.code?.firstIndex(of: "1") == firstYearUnit.firstIndex(of: "1") {
                    marksSum = (subject.score * subject.points)/2 + marksSum
                    wamCreditSum = subject.points/2 + wamCreditSum
                    
                } else {
                    marksSum = (subject.score * subject.points) + marksSum
                    wamCreditSum = subject.points + wamCreditSum
                }
                
            }

        }
        
        wam = String(format: "%.3f", marksSum/wamCreditSum)
        
        if wam == "nan" {
            wam = "0.000"
        }
        return wam
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newSubjectSegue" {
            let destination = segue.destination as! UnitViewController
            destination.newSubjectFlag = true
            
        } else if segue.identifier == "oldSubjectSegue" {
            let destination = segue.destination as! UnitViewController
            destination.subject = favUnits[unitTableView.indexPathForSelectedRow!.row]
            
        } else if segue.identifier == "newSubjectCellSegue" {
            let destination = segue.destination as! UnitViewController
            destination.newSubjectFlag = true
            
        }
    }
    

}
