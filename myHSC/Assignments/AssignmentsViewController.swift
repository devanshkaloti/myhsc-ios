//
//  AssignmentsViewController.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import UIKit
import RealmSwift
import Toaster
import DatePickerDialog
import SwipeCellKit
import ChameleonFramework
import SwiftyJSON
import SwiftDate
import SkeletonView



/// Assignments ViewController (Second Tab)
class AssignmentsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SwipeCollectionViewCellDelegate {
    
    // My Variables
    @IBOutlet weak var collectionView: UICollectionView!
    // Default Notifcation Settings
    // Note Notifications seems like a complicated topic so I may have made a poor implementation
    // I tried my best though
    var isGrantedNotificationAccess = false
    var notificationTitle = "Task Title"
    var notificationBody = "Body of Task"

    
    /// All tasks sorted as per date
    /// Double Array
    var homework = [
        Assignment.getUpcoming(type: Assignment.relativeDate.myTasks),
        Assignment.getUpcoming(type: Assignment.relativeDate.todayTomorrow),
        Assignment.getUpcoming(type: Assignment.relativeDate.thisWeek),
        Assignment.getUpcoming(type: Assignment.relativeDate.nextWeek),
        Assignment.getUpcoming(type: Assignment.relativeDate.thisMonth),
        Assignment.getUpcoming(type: Assignment.relativeDate.nextMonth),
    
    ]
    
    
    var allTasks = getSorted(sort: 0) // All tasks -- this is for true ID Count
    var actionTask = mTasks()
    var sections = ["My Tasks", "24 Hours", "This Week", "Next Week", "This Month", "Next Month"]
    private let refreshControl = UIRefreshControl() // Refresh thing when you swipe downwards
    
    
    
    /// Add refresh controller to collectionview
    override func viewDidLoad() {
        super.viewDidLoad()
        view.showAnimatedGradientSkeleton() // New implemtation of a loading screen - this is really new and I haven't worked it out yet
        // Add pull to refresh
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        // Need to reload data because viewdidload runs once throughout app launch
        // And the user may have done other things in the app which would affect this and so tasks need to updated
        // It has to be called in ViewDidLoad because without that the video may not load properly in some instances as things depend on loaded tasks
        // And these things would happen before the viewwillappear, as so risk of crashing
        reloadDataView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.hideSkeleton()
    }
    // Refresh Data
    @objc private func refreshData(_ sender: Any) {
        reloadDataView()
        self.refreshControl.endRefreshing()
    }
    

    
    /// Reload the Data shortcut button
    func reloadDataView() {
        
        homework = [
            Assignment.getUpcoming(type: Assignment.relativeDate.myTasks),
            Assignment.getUpcoming(type: Assignment.relativeDate.todayTomorrow),
            Assignment.getUpcoming(type: Assignment.relativeDate.thisWeek),
            Assignment.getUpcoming(type: Assignment.relativeDate.nextWeek),
            Assignment.getUpcoming(type: Assignment.relativeDate.thisMonth),
            Assignment.getUpcoming(type: Assignment.relativeDate.nextMonth),
        ]
        self.collectionView.reloadData()
        
    }
    
    
    


    /// Sort the tasks as the user requests
    /// NOTE - DEPRECIATED
    /// May be added in later version!
    /// - Parameter sender: button
    @IBAction func sort(_ sender: Any) {
        let alertController = UIAlertController(title: "Sort Tasks By", message: nil, preferredStyle: .actionSheet)

        let dueDate = UIAlertAction(title: "Due Date", style: .default, handler: { (action) -> Void in
            self.homework = [
                Assignment.getUpcoming(type: Assignment.relativeDate.myTasks),
                Assignment.getUpcoming(type: Assignment.relativeDate.todayTomorrow),
                Assignment.getUpcoming(type: Assignment.relativeDate.thisWeek),
                Assignment.getUpcoming(type: Assignment.relativeDate.nextWeek),
                Assignment.getUpcoming(type: Assignment.relativeDate.thisMonth),
                Assignment.getUpcoming(type: Assignment.relativeDate.nextMonth),
                
            ]
            
            self.allTasks = getSorted(sort: 0)
            self.reloadDataView()
        })

        let course = UIAlertAction(title: "Course", style: .default, handler: { (action) -> Void in
            self.allTasks = getSorted(sort: 1)
            self.collectionView.reloadData()
        })

        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })

        alertController.addAction(dueDate)
        alertController.addAction(course)
        alertController.addAction(cancelButton)

        self.present(alertController, animated: true, completion: nil)

    }


}





// MARK: - Collection View Implementation for the assignments to show
extension AssignmentsViewController {
    
    // Group Cell
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GroupAssignment", for: indexPath) as! GroupedAssignmentsCollectionViewCell
        
        
        headerView.title.text = sections[indexPath.section]
        
        return headerView
    }
    
    // Main Cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "assignmentsCell",
                                                      for: indexPath) as! AssignmentsCollectionViewCell
        cell.delegate = self
        
        cell.course.text = homework[indexPath.section][indexPath.row].course.name
        cell.dueDate.text = homework[indexPath.section][indexPath.row].dueDate.string
        cell.homeworkTitle.text = homework[indexPath.section][indexPath.row].name
        
        //     Status
        cell.status.tag = indexPath.row
        cell.status.accessibilityIdentifier = "\(indexPath.section)"
        cell.status.addTarget(self, action: #selector(showStatusBox), for: UIControl.Event.touchUpInside)
        
        
        switch homework[indexPath.section][indexPath.row].status {
        case "Pending":
            cell.status.setTitleColor(UIColor.black, for: .normal)
            cell.status.setTitle("Pending", for: .normal)
        case "In Progress":
            cell.status.setTitleColor(UIColor.flatOrangeDark(), for: .normal)
            cell.status.setTitle("In Progress", for: .normal)
        case "Done":
            cell.status.setTitleColor(UIColor.flatGreen(), for: .normal)
            cell.status.setTitle("Done", for: .normal)
        case "Snoozed":
            cell.status.setTitleColor(UIColor.orange, for: .normal)
            cell.status.setTitle("Snoozed", for: .normal)
        default:
            cell.status.setTitleColor(UIColor.black, for: .normal)
        }
        
        return cell
    }
    
    
    // Collection View Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homework[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    
    
    // Functions For Swipe function
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        return options
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .right {
            let doneAction = SwipeAction(style: .default, title: "Done") { action, indexPath in
                let task = self.homework[indexPath.section][indexPath.row]
                changeStatus(task: task, status: "Done")
                self.reloadDataView()
                
            }
            let progressAction = SwipeAction(style: .default, title: "In Progress") { action, indexPath in
                let task = self.homework[indexPath.section][indexPath.row]
                changeStatus(task: task, status: "In Progress")
                self.reloadDataView()
            }
            doneAction.backgroundColor = UIColor.flatGreen()
            progressAction.backgroundColor = .flatRed()
            
            return [doneAction, progressAction]
        }
        
        if orientation == .left { //
            let snoozeAction = SwipeAction(style: .default, title: "Snooze") { action, indexPath in
                let task = self.homework[indexPath.section][indexPath.row]
                self.showReminderBox(task: task)
                changeStatus(task: task, status: "Snoozed")
                self.reloadDataView()
            }
            snoozeAction.backgroundColor = UIColor.flatYellowDark()
            return [snoozeAction]
        }
        return nil // Invalid, this should not run
        
        //        guard orientation == .right else { return nil }
    }
    
}



// MARK: - Secondary Options for each cell
extension AssignmentsViewController {
    
    
    // Mark as done
    @objc func markAsDone(sender:UIButton) {
        let task = homework[Int(sender.accessibilityIdentifier!)!][sender.tag]
        
        if markDone(task: task) {
            Toast(text: "\(allTasks[sender.tag].task) Marked As Done!").show()
            reloadDataView()
            
        } else {
            Toast(text: "Error... Please try again or contact support").show()
        }
    }
    
    

    
    //    // SHOW STATUS BOX
    @objc func showStatusBox(sender:UIButton) {
        let task = homework[Int(sender.accessibilityIdentifier!)!][sender.tag]
        let alertController = UIAlertController(title: "Status of \(task.name)", message: nil, preferredStyle: .actionSheet)
        
        
        let snooze = UIAlertAction(title: "Snooze", style: .default, handler: { (action) -> Void in
            self.showReminderBox(task: task)
            self.reloadDataView()
        })
        
        alertController.addAction(snooze)
        
        
        let status = ["Pending", "In Progress", "Done", "Delete"]
        for s in status {
            let option = UIAlertAction(title: s, style: .default, handler: { (action) -> Void in
                changeStatus(task: task, status: s)
                self.reloadDataView()
            })
            alertController.addAction(option)
        }
        
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
        
    }

    
    func showReminderBox(task: Assignment) {
        let alertController = UIAlertController(title: "Set Reminder time", message: nil, preferredStyle: .actionSheet)
        
        let option1 = UIAlertAction(title: "1 Hour From Now", style: .default, handler: { (action) -> Void in
            let minutes:TimeInterval = 60.0 * 60.0
            let date = Date(timeIntervalSinceNow: minutes)
            self.setReminder(date: date, task: task)
        })
        
        let  option2 = UIAlertAction(title: "Tomorrow (+24)", style: .default, handler: { (action) -> Void in
            let minutes:TimeInterval = 1440.0 * 60.0 // RIGHT NOW THIS WILL SCHEDULE FOR +24hours
            let date = Date(timeIntervalSinceNow: minutes)
            self.setReminder(date: date, task: task)
        })
        
        let  option3 = UIAlertAction(title: "Choose a Date", style: .default, handler: { (action) -> Void in
            let currentDate = Date()
            var dateComponents = DateComponents()
            dateComponents.month = 2
            let twoMonthNext = Calendar.current.date(byAdding: dateComponents, to: currentDate)
            let datePicker = DatePickerDialog(showCancelButton: true)
            
            datePicker.show("Remind me...",
                            doneButtonTitle: "Done",
                            cancelButtonTitle: "Cancel",
                            minimumDate: currentDate,
                            maximumDate: twoMonthNext,
                            datePickerMode: .dateAndTime) { (date) in
                                if let dt = date {
                                    self.setReminder(date: dt, task: task)
                                    Toast(text: "Reminder Scheduled!").show()
                                }}
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        alertController.addAction(option1)
        alertController.addAction(option2)
        alertController.addAction(option3)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func setReminder(date: Date, task: Assignment) {
        let formatter = DateFormatter()
        let myString = formatter.string(from: date) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd MMM yyyy 'at' HH:mm"
        
        let myDate = formatter.string(from: yourDate!)
        changeStatus(task: task, status: "Snoozed")
        
        setNotifications(notificationTitle: "Do \(task.name)", notificationBody: "For \(task.course.name) on \(task.dueDate.string)", date: date)
    }
}



// MARK: - Implemting skeleton load - currently in progress! 
extension AssignmentsViewController: SkeletonCollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homework[section].count
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "assignmentsCell"
    }
}
