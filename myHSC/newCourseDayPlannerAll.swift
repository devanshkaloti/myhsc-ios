//
//  newCourseDayPlannerAll.swift
//  myHSC
//
//  Created by Devansh Kaloti on 2019-10-02.
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialDialogs

class CoursePlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var courses: [Course] = [Course]()
    var courseMessages = [[Courses.Message]]()
    
    
//    @IBAction func goHome(_ sender: Any) {
//        self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabController") as UIViewController, animated: false, completion: {
//
//
//        })
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Get all courses without spares
        let allCourses = Course.getEnrolledCourses()
        for c in allCourses {
            let thisCourse = c
            
            if thisCourse.name != "Spare" && thisCourse.block.getBlock() == "A" || thisCourse.block.getBlock() == "B" || thisCourse.block.getBlock() == "C" || thisCourse.block.getBlock() == "D" {
                courses.append(thisCourse)
                courseMessages.append(Courses().getDayPlanner(sectionid: thisCourse.id ?? "0") as! [Courses.Message])
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK:- Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayPlannerCell") as! CoursePlannerTableViewCell
        cell.title.text = courses[indexPath.row].name
        cell.collectionviewclCollectoinView.tag = indexPath.row
        
        return cell
    }
    
    //MARK:- CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courseMessages[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "coursePlannerCollectionCell", for: indexPath) as! CoursePlannerCollectionCell
        cell.title.text = courseMessages[collectionView.tag][indexPath.row].title
        cell.content.attributedText = courseMessages[collectionView.tag][indexPath.row].message.html2AttributedString
        cell.date.text = courseMessages[collectionView.tag][indexPath.row].date
        
        return cell
    }
    
    /// Check if user selects an item so that it can be marked as done
    ///
    /// - Parameters:
    ///   - collectionView: collection view being used
    ///   - indexPath: list of index and section in an array in question
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Present a modal alert
        let alertController = MDCAlertController(title: self.courseMessages[collectionView.tag][indexPath.row].title, message: self.courseMessages[collectionView.tag][indexPath.row].message.html2String + "Posted By on \(self.courseMessages[collectionView.tag][indexPath.row].date)")
        let action = MDCAlertAction(title:"Close") { (action) in print("Close") }
        alertController.addAction(action)
        
        present(alertController, animated: true)
        

}


}


class CoursePlannerTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var collectionviewclCollectoinView: UICollectionView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}

extension CoursePlannerTableViewCell {

    func setCollectionViewDataSourceDelegate
    <D: UICollectionViewDelegate & UICollectionViewDataSource> (_ dataSourceDelegate:D, forRow row: Int) {
        collectionviewclCollectoinView.delegate = dataSourceDelegate
        collectionviewclCollectoinView.dataSource = dataSourceDelegate
        
        collectionviewclCollectoinView.reloadData()
    }
}


class CoursePlannerCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var date: Label!
}
