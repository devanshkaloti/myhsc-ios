//
//  CourseDayPlanner.swift
//  myHSC
//
//  Created by Devansh Kaloti on 2019-09-28.
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import UIKit


/// Controller to manage courses vc
class CourseDayPlanner: UIViewController  {
    @IBOutlet weak var tableView: UITableView!
//    let blocks: [String] = ["A", "B", "C", "D", "E", "F", "G", "H"]
    var courses: [Course] = [Course]()
    var courseMessages = [[Courses.Message]]()
    

    
    override func viewDidLoad() {
        
        // Get all courses without spares
        for c in Course.getEnrolledCourses() {
            let thisCourse = c
            
            if thisCourse.name != "Spare" {
                courses.append(thisCourse)
                courseMessages.append(Courses().getDayPlanner(sectionid: thisCourse.id ?? "0") as! [Courses.Message])
                
            }
        }
        
        
        
    }
    
}


// MARK: - TableView Controller
extension CourseDayPlanner: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayPlannerCell", for: indexPath) as! DayPlannerCell
    
        print("***************************")
        print(indexPath.row)
        
        cell.title.text = courses[indexPath.row].name
        cell.setID(id: indexPath.row)
//        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)

        cell.collectionview.delegate = self
        cell.collectionview.dataSource = self
        cell.collectionview.tag = indexPath.row
        cell.collectionview.reloadData()
        
        
        
        
        return cell
    }
}

extension CourseDayPlanner: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("HDHHDHDHDHDHDHD")
        print(courseMessages[collectionView.tag].count)
        return courseMessages[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseDayPlannerCollectionCell",
                                                      for: indexPath) as! DayPlannerCollectionViewCell
        var messages: [Courses.Message] = courseMessages[collectionView.tag]
        
        cell.title.text = messages[indexPath.row].title.html2String
        cell.content.attributedText = messages[indexPath.row].message.html2AttributedString
        cell.date.text = messages[indexPath.row].date
        
        
        return cell
    }

}

class DayPlannerCell: UITableViewCell {
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var title: UILabel!
   
    func setID(id: Int) {
        collectionview.tag = id
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


class DayPlannerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var date: Label!
    
}
