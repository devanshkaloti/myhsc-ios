//
//  AnnoucementsHomeData.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialDialogs
import FirebaseAnalytics

// MARK: - Annoucements
extension ViewController:  UICollectionViewDataSource, UICollectionViewDelegate  {

    
    /// Number of sections in the collectionview
    ///
    /// - Parameter collectionView: collection view being used
    /// - Returns: Number of sections int
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.annData.count
    }
    
    /// Number of items in section
    ///
    /// - Parameters:
    ///   - collectionView: collection view being used
    ///   - section: section number being used
    /// - Returns: int of number of cells in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.annData[section].opened) {
            return self.annData.count
        } else {
            return 1
        }
    }
    
    
    /// Develop the cell for each cell in collectionview
    ///
    /// - Parameters:
    ///   - collectionView: collection view being used
    ///   - indexPath: indexPath is the indexarray for the cell# provided by the UI
    /// - Returns: The UI built cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "annoucementHomeCell", for: indexPath) as! AnnoucementsHomeCell
        cell.title.text = self.annData[indexPath.section].title
        cell.postedBy.text = "Posted By \(self.annData[indexPath.section].sectionData[2]) on \(self.annData[indexPath.section].sectionData[1])"
        return cell
        
    }

    
    /// Check if user selects an item so that it can be marked as done
    ///
    /// - Parameters:
    ///   - collectionView: collection view being used
    ///   - indexPath: list of index and section in an array in question
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Present a modal alert
        let alertController = MDCAlertController(title: self.annData[indexPath.section].title, message: self.annData[indexPath.section].sectionData[0].html2String + "Posted By \(self.annData[indexPath.section].sectionData[2]) on \(self.annData[indexPath.section].sectionData[1])")
        let action = MDCAlertAction(title:"Close") { (action) in print("Close") }
        alertController.addAction(action)
        
        present(alertController, animated: true)
        
        Analytics.logEvent("Annoucement View", parameters: [
            "name": Setting(setting: "username").value as NSObject,
            ])
        
    }
}


/// Class for annoucements cell to connect UI with code
class AnnoucementsHomeCell: UICollectionViewCell {
//    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var postedBy: Label!
    
}
