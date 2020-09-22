//
//  HomeViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 2/8/20.
//  Copyright © 2020 Ashwin Gupta. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var units: [String] = []
    
    @IBOutlet weak var gpaLabel: UILabel!
    
    @IBOutlet weak var wamLabel: UILabel!
    
    @IBOutlet weak var unitTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.unitTableView.delegate = self
        self.unitTableView.dataSource = self
        unitTableView.layer.cornerRadius = 12

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Table View Data Source Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unitCell") as! UnitTableViewCell
        
        return cell
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
