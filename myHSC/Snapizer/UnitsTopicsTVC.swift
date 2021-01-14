//
//  UnitsTopicsTVC.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import UIKit
import ChameleonFramework


/// Units Page (Course Page) VC
class UnitsTopicsTVC: UITableViewController {

    // Get units for the course
    var units: [String] = Snapizer.getUnits(course: "A")
    var lessons: [[storedImages]] = [[storedImages]]() // Get lessons for each unit
        
    
    /// Store data in variables
    /// Extensive on memory but will do for now
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var returnValues = [[storedImages]]()
        for u in units {
            returnValues.append(Snapizer.getImages(unit: u))
        }
        lessons = returnValues
        
    }

    // MARK: - Table view data source

    // # of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return lessons.count
    }

    // # of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lessons[section].count
    }

    // title for each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return units[section]
    }
    
    // Selected cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "viewPicture") as! ViewPictureVC
//        newVC.image = Snapizer.getImage(ref: lessons[indexPath.section][indexPath.row].imageRef)
        newVC.ref = lessons[indexPath.section][indexPath.row].imageRef + ".jpg"
        newVC.titleVar = lessons[indexPath.section][indexPath.row].title
        self.navigationController!.pushViewController(newVC, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let button: UIButton = UIButton(type: .system)
//        button.backgroundColor = .flatSkyBlue
//        button.setTitleColor(.black, for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//        button.addTarget(self, action: #selector(handleOpenClose), for: .touchUpInside)
//
//        button.setTitle("Close", for: .normal)
//        return button
//
//
////        let title: UILabel = UILabel()
////        title.text = units[section]
//    }
    
//    @objc func handleOpenClose() {
//        print("Opening And Closing hey...")
//        let section = 0
//
//        var indexPaths = [IndexPath]()
//        for row in lessons[section].indices {
//            let indexPath = IndexPath(row: row, section: section)
//            indexPaths.append(indexPath)
//        }
//
//        lessons[section].removeAll()
//        tableView.deleteRows(at: indexPaths, with: .fade)
//    }
//
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 36
//    }
    
    // Code cell for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "snapizerUnitCell", for: indexPath) as! snapizerUnitCell
        
        cell.title.text = lessons[indexPath.section][indexPath.row].title
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


/// To connect UI to code
class snapizerUnitCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    
}



