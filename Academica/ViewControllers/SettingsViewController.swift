//
//  SettingsViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 6/6/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    
    @IBOutlet weak var tableView: UITableView!
    
    let settingsArray = ["Acknowledgements", "Notifications", "Calculation Settings"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Settings"
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "acknowledgementsCell")
        
            cell?.textLabel?.text = settingsArray[indexPath.row]
            
            return cell!
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsCell")
        
            cell?.textLabel?.text = settingsArray[indexPath.row]
            
            return cell!
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "calculationCell")
        
            cell?.textLabel?.text = settingsArray[indexPath.row]
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tableView.deselectRow(at: IndexPath.init(row: 0, section: 0), animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
