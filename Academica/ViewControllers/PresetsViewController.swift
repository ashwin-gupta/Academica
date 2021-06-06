//
//  PresetsViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 6/6/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//

import UIKit

class PresetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource  {
   


    @IBOutlet weak var uniCollectionView: UICollectionView!
    @IBOutlet weak var weightingTableView: UITableView!
    
    weak var databaseController: DatabaseProtocol?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Table View Setup
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weightingTableView.dequeueReusableCell(withIdentifier: "weightingCell") as! WeightingTableViewCell
        
        return cell
    }
    
    //MARK: - Collection View Setup
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = uniCollectionView.dequeueReusableCell(withReuseIdentifier: "uniCell", for: indexPath) as! PresetsCollectionViewCell
        
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
