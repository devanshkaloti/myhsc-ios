//
//  AnnoucementsHomeData.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialCards
import BEMCheckBox


/// DataSource for Collection view on ViewController
class TasksHomeData: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, BEMCheckBoxDelegate  {

    
    /// Get homework
    var homework = [
        Assignment.getUpcoming(type: Assignment.relativeDate.myTasks),
        Assignment.getUpcoming(type: Assignment.relativeDate.todayTomorrow),
        Assignment.getUpcoming(type: Assignment.relativeDate.thisWeek),
        Assignment.getUpcoming(type: Assignment.relativeDate.nextWeek),
    ]
    
    
    //var actionTask = mTasks()
    
    
    
    /// Number of sections in the collectionview
    ///
    /// - Parameter collectionView: collection view being used
    /// - Returns: Number of sections int
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    
    /// Number of items in section
    ///
    /// - Parameters:
    ///   - collectionView: collection view being used
    ///   - section: section number being used
    /// - Returns: int of number of cells in section, max 5
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Return max of 5
        if (homework[section].count < 5) {
            return homework[section].count
        } else {
            return 5
        }
    }
    
    
    /// Develop the cell for each cell in collectionview
    ///
    /// - Parameters:
    ///   - collectionView: collection view being used
    ///   - indexPath: indexPath is the indexarray for the cell# provided by the UI
    /// - Returns: The UI built cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // Reuse cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tasksHomeCell", for: indexPath) as! TasksHomeCell
        
        // Set fields
        cell.title.text = homework[indexPath.section][indexPath.row].name
//        cell.course.text = homework[indexPath.section][indexPath.row].course.name
        cell.date.text = homework[indexPath.section][indexPath.row].dueDate.string.toDate()?.toFormat("EEEE, dd MMM.")

        
        

        // Checkbox Settings
        cell.checkmark.delegate = self
        if homework[indexPath.section][indexPath.row].status == "Done" {
            cell.checkmark.setOn(true, animated: true)
        }
        
        return cell
    }
    
    
    /// Check if user selects an item so that it can be marked as done
    ///
    /// - Parameters:
    ///   - collectionView: collection view being used
    ///   - indexPath: list of index and section in an array in question
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Get cell
        let cell = collectionView.cellForItem(at: indexPath) as! TasksHomeCell
        
        // Check if it's done to unmark or mark
        if (cell.checkmark.on) {
            cell.checkmark.setOn(false, animated: true)
            changeStatus(task: homework[indexPath.section][indexPath.row], status: "Pending")
        } else {
             cell.checkmark.setOn(true, animated: true)
            changeStatus(task: homework[indexPath.section][indexPath.row], status: "Done")
        }
    }
}



/// Task Cell Class to connect UI with Code
class TasksHomeCell: UICollectionViewCell {

//    @IBOutlet weak var title: UILabel!
//    @IBOutlet weak var course: UILabel!
//    @IBOutlet weak var date: UILabel!
//
    @IBOutlet weak var date: Label!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var checkmark: BEMCheckBox!
}
