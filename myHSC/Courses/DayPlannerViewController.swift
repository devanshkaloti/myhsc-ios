//
//  DayPlannerViewController.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import UIKit
import MaterialComponents.MDCCard


/// VC for day planner
class DayPlannerViewController: UIViewController {

    let coursesBlocks: [String] = ["A", "B", "C", "D", "E", "F", "G", "H"]
    let courses: [Course] = Course.getEnrolledCourses()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}


// MARK: - CollectionView data
extension DayPlannerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayPlannerCourse",
                                                      for: indexPath) as! DayPlannerCourseCell

        var messages = Courses().getDayPlanner(sectionid: courses[indexPath.row].id ?? "0")
        messages.reverse()
        
        if messages.count >= 3 {
            if let m1 = messages[2] {
                cell.label1.setTitle(m1.title, for: .normal)
            }
            if let m2 = messages[1] {
                cell.label2.setTitle(m2.title, for: .normal)
            }
            if let m3 = messages[0] {
                cell.label3.setTitle(m3.title, for: .normal)
            }
            
        } else if messages.count == 2 {
        } else if messages.count == 1 {
        }
        
        
        
        cell.title.text = courses[indexPath.row].name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var messages = Courses().getDayPlanner(sectionid: courses[indexPath.row].id ?? "0")
        
        if messages.count >= 1 {
            if let m1 = messages[0] {
                let alertController = MDCAlertController(title: m1.title, message: m1.message.html2String)
                let action = MDCAlertAction(title:"Close") { (action) in print("Close") }
                alertController.addAction(action)
                
                present(alertController, animated: true)
            }
        }
        
        

    }
    
    @objc func showPopup(_tap: tap) {
//        // Present a modal alert
//        let alertController = MDCAlertController(title: tap.title, message: tap.message)
//        let action = MDCAlertAction(title:"Close") { (action) in print("Close") }
//        alertController.addAction(action)
//
//        present(alertController, animated: true)
    }
    
    
}


class DayPlannerCourseCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var label1: MDCFlatButton!
    @IBOutlet weak var label2: MDCFlatButton!
    @IBOutlet weak var label3: MDCFlatButton!
}

class tap: MDCFlatButton {
    var title = String()
    var message = String()
}
