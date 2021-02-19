//
//  HomeViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 2/8/20.
//  Copyright © 2020 Ashwin Gupta. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DatabaseListener {
    

    var units: [Subject] = []
    
    @IBOutlet weak var gpaLabel: UILabel!
    
    @IBOutlet weak var wamLabel: UILabel!

    @IBOutlet weak var unitTableView: UITableView!
    
    
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .all
    var marksSum: Double = 0
    var creditSum: Double = 0
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    // MARK: - Table View Data Source Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return units.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unitCell") as! UnitTableViewCell
        
        let subject = units[indexPath.row]
        cell.gradeLabel.text = subject.grade
        cell.scoreLabel.text = String(subject.score)
        cell.unitLabel.text = subject.code
        cell.creditPoints.text = subject.name
        
        wamCalculate()
        
        return cell
    }

    // MARK: - Database Listeners
    
    func onStudentChange(change: DatabaseChange, studentSubjects: [Subject]) {

        
    }
    
    func onSubjectChange(change: DatabaseChange, subjects: [Subject]) {
        units = subjects
        unitTableView.reloadData()
    }
    
    func wamCalculate() {
        for subject in units {
            marksSum = (subject.score * subject.points) + marksSum
            creditSum = subject.points + creditSum

        }
        
        let wam = String(format: "%.4f", marksSum/creditSum)
        wamLabel.text = wam
        
        
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
