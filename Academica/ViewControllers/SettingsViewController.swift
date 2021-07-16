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
    
    var settingArray: [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Settings"
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.row == 0 {
//
//
//        }
//        else {
//            let presetsCell = tableView.dequeueReusableCell(withIdentifier: "presetsCell")
//            presetsCell?.textLabel?.text = "Presets"
//            return presetsCell!
//
//        }
        
        let ackCell = tableView.dequeueReusableCell(withIdentifier: "toAckCell")
        ackCell?.textLabel?.text = "Acknowledgements"
        return ackCell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
