//
//  PresetsViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 6/6/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//

import UIKit

class PresetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    var universities: [University] = []
   
    var selectedUni: University?


    @IBOutlet weak var uniCollectionView: UICollectionView!
    @IBOutlet weak var weightingTableView: UITableView!
    
    weak var databaseController: DatabaseProtocol?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        
        self.weightingTableView.delegate = self
        self.weightingTableView.dataSource = self
        
        self.uniCollectionView.delegate = self
        self.uniCollectionView.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {

        universities = setUpUniversities()
    }
    
    func setUpUniversities() -> [University]{
        var unis: [University] = []
        var monash = University(name:"Monash University", desc: ["High Distinction", "Distinction", "Credit", "Pass", "Fail", "Hurdle Fail", "Withdrawn", "Satisfied Faculty Requirements"], codes: ["HD", "D", "C", "P", "N", "NH", "WN", "SFR"], weights: [4.0, 3.0, 2.0, 1.0, 0.7, 0.3, 0.3, 0])
        
        var uniMelb = University(name:"The University of Melbourne", desc: ["First Class Honours", "Second Class Honours Division A", "Second Class Honours Division B", "Third Class Honours", "Pass", "Fail", "Hurdle Fail"], codes: ["H1", "H2A", "H2B", "H3", "P", "N", "NH"], weights: [0, 0, 0, 0, 0, 0, 0, 0])

        
        unis.append(monash)
        unis.append(uniMelb)
        selectedUni = unis[0]
        
        return unis
        
    }
    
    //MARK: - Table View Setup
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch selectedUni?.name {
        case "Monash University":
            return (selectedUni?.codes.count)!
            
        case "The University of Melbourne":
            return (selectedUni?.codes.count)!
        default:
            return 1
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weightingTableView.dequeueReusableCell(withIdentifier: "weightingCell") as! WeightingTableViewCell
        cell.gradeLabel.text = selectedUni?.codes[indexPath.row]
        cell.descLabel.text = selectedUni?.desc[indexPath.row]
        cell.weightLabel.text = String(selectedUni!.weights[indexPath.row])
        
        
        return cell
    }
    
    //MARK: - Collection View Setup
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return universities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = uniCollectionView.dequeueReusableCell(withReuseIdentifier: "uniCell", for: indexPath) as! PresetsCollectionViewCell
        
        cell.universityImage.image = UIImage(named: universities[indexPath.row].name)
        
        return cell
    }
    
    func onStudentChange(change: DatabaseChange, studentSubjects: [Subject]) {
        //Do Nothing
    }
    
    func onSubjectChange(change: DatabaseChange, subjects: [Subject]) {
        // Do nothing
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
