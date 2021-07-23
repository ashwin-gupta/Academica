//
//  PresetsViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 6/6/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//

import UIKit

class PresetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DatabaseListener, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    var listenerType: ListenerType = .all
    private let sectionInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    private let itemsPerRow: CGFloat = 3
    private let itemsPerCol: CGFloat = 2
    
    let monashWeights = [4.0, 3.0, 2.0, 1.0, 0.7, 0.3, 0.3, 0]
    let monashCodes = ["HD", "D", "C", "P", "N", "NH", "WN", "SFR"]
    let monashDesc = ["High Distinction", "Distinction", "Credit", "Pass", "Fail", "Hurdle Fail", "Withdrawn", "Satisfied Faculty Requirements"]
    
    
    let standaardDesc = ["High Distinction", "Distinction", "Credit", "Pass", "Fail"]
    let standardCodes = ["HD", "D", "C", "P", "N"]
    let standardWeights = [4.0, 3.0, 2.0, 1.0, 0]
    
    var selectedUni: University?
    var weights: [Double] = []
    var desc: [String] = []
    var codes: [String] = []

    @IBOutlet weak var calcStyleControl: UISegmentedControl!
    @IBOutlet weak var uniCollectionView: UICollectionView!
    @IBOutlet weak var weightingTableView: UITableView!
    
    weak var databaseController: DatabaseProtocol?
    let defaults = UserDefaults.standard
    let universities = ["Standard", "Monash University", "Melbourne University", "RMIT University", "Victoria UNiversity"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController

//        let preset = defaults.string(forKey: "calcStyle")
        /*
        if preset == "Standard" {
            calcStyleControl.selectedSegmentIndex = 0
            codes = standardCodes
            weights = standardWeights
            desc = standaardDesc
            weightingTableView.reloadData()
            
        } else {
            calcStyleControl.selectedSegmentIndex = 1
            codes = monashCodes
            weights = monashWeights
            desc = monashDesc
            weightingTableView.reloadData()
        }*/
        
        self.weightingTableView.delegate = self
        self.weightingTableView.dataSource = self
        
        uniCollectionView.delegate = self
        uniCollectionView.dataSource = self
        uniCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
//        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "labelInverse")]
        
//        calcStyleControl.addTarget(self, action: #selector(EditAssessmentViewController.indexChanged(_:)), for: .valueChanged)
//
//        calcStyleControl.setTitleTextAttributes(titleTextAttributes as [NSAttributedString.Key : Any], for: .selected)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {

//        universities = setUpUniversities()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
//        let index = calcStyleControl.selectedSegmentIndex
//        defaults.set(universities[index], forKey: "calcStyle")
    }
    /*
    @objc func indexChanged(_ sender: UISegmentedControl) {
        if calcStyleControl.selectedSegmentIndex == 0 {
            codes = standardCodes
            weights = standardWeights
            desc = standaardDesc
            weightingTableView.reloadData()
            
        } else if calcStyleControl.selectedSegmentIndex == 1 {
            codes = monashCodes
            weights = monashWeights
            desc = monashDesc
            weightingTableView.reloadData()
            
        }
    }
 

    func setUpUniversities() -> [University]{
        var unis: [University] = []
        let monash = University(name:"Monash University", desc: ["High Distinction", "Distinction", "Credit", "Pass", "Fail", "Hurdle Fail", "Withdrawn", "Satisfied Faculty Requirements"], codes: ["HD", "D", "C", "P", "N", "NH", "WN", "SFR"], weights: [4.0, 3.0, 2.0, 1.0, 0.7, 0.3, 0.3, 0])

        let uniMelb = University(name:"The University of Melbourne", desc: ["First Class Honours", "Second Class Honours Division A", "Second Class Honours Division B", "Third Class Honours", "Pass", "Fail", "Hurdle Fail"], codes: ["H1", "H2A", "H2B", "H3", "P", "N", "NH"], weights: [0, 0, 0, 0, 0, 0, 0, 0])

        
        unis.append(monash)
        unis.append(uniMelb)
        selectedUni = unis[0]
        
        return unis
        
    }
 
  */
    //MARK: - Table View Setup
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        switch selectedUni?.name {
        case "Monash University":
            return (selectedUni?.codes.count)!
            
        case "The University of Melbourne":
            return (selectedUni?.codes.count)!
        default:
            return 1
        }*/
        return codes.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weightingTableView.dequeueReusableCell(withIdentifier: "weightingCell") as! WeightingTableViewCell
        cell.layer.cornerRadius = 12
        cell.gradeLabel.text = codes[indexPath.row]
        cell.descLabel.text = desc[indexPath.row]
        cell.weightLabel.text = String(weights[indexPath.row])
        
        return cell
    }
    
    //MARK: - Collection View Setup
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return universities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = uniCollectionView.dequeueReusableCell(withReuseIdentifier: "presetCell", for: indexPath) as! PresetsCollectionViewCell
        
        cell.uniNameLabel?.text = universities[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerCol)
        let availableWidth = uniCollectionView.frame.width - paddingSpace
        let availableHeight = uniCollectionView.frame.height - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = availableHeight / itemsPerCol

        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    
 
    // MARK: - Database Listeners
    
    func onStudentChange(change: DatabaseChange, studentSubjects: [Subject]) {
        //Do Nothing
    }
    
    func onSubjectChange(change: DatabaseChange, subjects: [Subject]) {
        // Do nothing
    }
    
    func onAssessmentChange(change: DatabaseChange, assessments: [Assessment]) {
        // Do nothing
    }
    
    func onUniversityChange(change: DatabaseChange, university: [University]) {
        // DO nothing
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
