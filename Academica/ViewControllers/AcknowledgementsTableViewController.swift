//
//  AcknowledgementsTableViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 7/7/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//

import UIKit

class AcknowledgementsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ackCell") as! AcknowledgementsTableViewCell
        
        if indexPath.section == 0 {
            cell.ackImage.image = UIImage(named: "LaunchIcon")
            cell.name.text = "Matthew Chen"
            cell.ackLink.text = "https://www.matthewcychen.com"
        } else {
            switch indexPath.row {
            case 0:
                cell.ackImage.image = UIImage(named: "graduationcap.fill")
                cell.name.text = "Icons8"
                cell.ackLink.text = "https://icons8.com/icon/79387/graduation-cap"
                
            case 1:
                cell.ackImage.image = UIImage(named: "book.closed.fill")
                cell.name.text = "Icons8"
                cell.ackLink.text = "https://icons8.com/icon/59739/book"
                
            case 2:
                cell.ackImage.image = UIImage(named: "gearshape.fill")
                cell.name.text = "Icons8"
                cell.ackLink.text = "https://icons8.com/icon/59996/settings"
            default:
                cell.ackImage.image = UIImage(named: "LaunchIcon")
                cell.name.text = "Matthew Chen"
                cell.ackLink.text = "https://www.matthewcychen.com"

            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0  {
            return "App Icon/Logo"
        } else {
            return "Icons"
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if let url = URL(string: "https://www.matthewcychen.com") {
                UIApplication.shared.open(url)
            }
            
        } else {
            switch indexPath.row {

            case 1:
                if let url = URL(string: "https://icons8.com/icon/59739/book") {
                    UIApplication.shared.open(url)
                }
            
            case 2:
                if let url = URL(string: "https://icons8.com/icon/59996/settings") {
                    UIApplication.shared.open(url)
                }
                
            default:
                if let url = URL(string: "https://icons8.com/icon/79387/graduation-cap") {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}
