//
//  CalculationPopUpViewController.swift
//  Academica
//
//  Created by Ashwin Gupta on 23/7/21.
//  Copyright © 2021 Ashwin Gupta. All rights reserved.
//

import UIKit

class CalculationPopUpViewController: UIViewController {

//    @IBOutlet weak var calculationCollectionView: UICollectionView!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var calcControl: UISegmentedControl!
    @IBOutlet weak var descLabel: UILabel!
    
    let calcStyles = ["Standard", "Monash University"]
    var style: String?
    
    let defaults = UserDefaults.standard
    
    private let sectionInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    private let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        calculationCollectionView.delegate = self
//        calculationCollectionView.dataSource = self
        
        saveButton.layer.cornerRadius = 12
        saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)

        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "labelInverse")]
        calcControl.setTitleTextAttributes(titleTextAttributes as [NSAttributedString.Key : Any], for: .selected)
        
        
        calcControl.addTarget(self, action: #selector(UnitViewController.indexChanged(_:)), for: .valueChanged)
        
        
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        let index = calcControl.selectedSegmentIndex
        defaults.set(calcStyles[index], forKey: "calcStyle")
        navigationController?.popViewController(animated: true)
//        var homeVC: HomeViewController?
//        navigationController?.popToViewController(homeVC!, animated: true)
        
        
    }
    
    // MARK: - CollectionView Delegates
    /*
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calcStyles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Setting the sport value of the searched array to that of inside the array at which the user has tapped on
        style = calcStyles[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        if style != calcStyles[indexPath.row] {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.contentView.backgroundColor = UIColor(named: "Navy")
                
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        if style == calcStyles[indexPath.row] {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.contentView.backgroundColor = nil

            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        // Setting the sizing of the collectionView
        let paddingSpace = sectionInsets.left * (itemsPerRow)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "standardCell", for: indexPath) as! PresetsCollectionViewCell
        cell.layer.cornerRadius = 12
        
        cell.uniNameLabel.text = calcStyles[indexPath.row]
        
        return cell
        
    }
 */
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
