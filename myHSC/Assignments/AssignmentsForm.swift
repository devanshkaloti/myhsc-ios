//
//  AssignmentsForm.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//


import UIKit
import Eureka


/// To add a new form
class AssignmentsForm: FormViewController {

    
    var createNewTask = true
    
    
     /// Load elements on load
     override func viewDidLoad() {
        
        
        /// Details of task
        struct FormItems {
            static let task = "task"
            static let status = "Pending"
            static let dueDate = "dueDate"
        }
        
        
        super.viewDidLoad()
    
        
        // Form Elements
        form +++ Section("My Task")
            <<< TextRow(FormItems.task){ row in
                row.title = "Task"
                row.placeholder = "Enter the task"
                row.value = createNewTask ? "" : FormItems.task
            }
            <<< ActionSheetRow<String>(FormItems.status) {
                $0.title = "Status"
                $0.selectorTitle = "Status"
                $0.options = ["Pending","In Progress"]
                $0.value = createNewTask ? "Pending" : FormItems.status
                
            }
            <<< ActionSheetRow<String>(FormItems.dueDate) {
                $0.title = "Due Date"
                $0.selectorTitle = "Due Date"
                $0.options = ["This Week","Next Week", "Next Month", "Not Set"]
                $0.value = createNewTask ? "Not Set" : FormItems.dueDate
                
            }
            
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Save"
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.createTask()
        }
        
    
        
    }
    
    
    /// Get the details and add the task
    func createTask() {
        let valuesDictionary = form.values()

        let title = valuesDictionary["task"]! as? String ?? "Untitled"
        let status = valuesDictionary["Pending"]! as? String ?? ""
        let dueDate = valuesDictionary["dueDate"]! as? String ?? ""
        
        
        let task = Assignment(id: Int(NSDate().timeIntervalSince1970), name: String(title), status: String(status), course: "My Task", dueDate: String(dueDate))
        task.update()
    
    }
}


