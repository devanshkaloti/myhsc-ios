//
//  JSONAssignments.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftDate



/// This class is to control the assignments and provide layer between database
class Assignment {

    
    /// This converts an actual string date to an enum for easy reference
    ///
    /// - myTasks: Tasks that were added custom
    /// - todayTomorrow: Due in 24 hours
    /// - thisWeek: Due this week
    /// - nextWeek: This Next Week
    /// - thisMonth: Due This Month (does not include this week / next week)
    /// - nextMonth: Due next month
    enum relativeDate {
        case myTasks
        case todayTomorrow
        case thisWeek
        case nextWeek
        case thisMonth
        case nextMonth
        
        
        /// Convert a string to enum
        ///
        /// - Parameter stringDueDate: Due date as a string
        /// - Returns: Returns the proper enum
        static func stringToDate(stringDueDate: String) -> relativeDate {
           
            if let taskDueDate = stringDueDate.toDate() {
                
                if (taskDueDate.isToday || taskDueDate.isTomorrow) {
                    return relativeDate.todayTomorrow
                } else if (taskDueDate.compare(.isThisWeek) && !(taskDueDate.isToday || taskDueDate.isTomorrow)) {
                    return relativeDate.thisWeek
                } else if (taskDueDate.compare(.isNextWeek)) {
                    return relativeDate.nextWeek
                } else if (taskDueDate.compare(.isThisMonth) && !(taskDueDate.compare(.isThisWeek) || taskDueDate.compare(.isNextWeek))) {
                    return relativeDate.thisMonth
                } else if (taskDueDate.compare(.isNextMonth) && !(taskDueDate.compare(.isThisWeek) || taskDueDate.compare(.isNextWeek))) {
                    return relativeDate.nextMonth
                }
            }
            return relativeDate.myTasks
        }
    }
    
    
    /// Date struct contains details as string and relative enum
    struct date {
        var string: String
        var relative: relativeDate
        
        
        /// Initlaizes a string to relative
        ///
        /// - Parameter string: If a string is given - convert to enum
        init(string: String) {
            self.string = string
            self.relative = relativeDate.stringToDate(stringDueDate: string)
        }
    }
    
    
    // Properties of a task
    var id: Int
    var name: String
    var course: Course
    var dueDate: date
    var status: String = "Pending"
    var startDate: String = "None" // Depreciated
    // var dueStamp: String = dueDate // Depreciated

    
    /// Initalize task with ID
    /// Get details from DB
    /// - Parameter id: ID of task
    init(id: Int) {
        let realm = try! Realm()
        let assignment = realm.objects(mTasks.self).filter("id = '\(id)'").first!
        
        self.id = Int(assignment.id) ?? 0
        self.name = assignment.task
        self.status = assignment.status
        self.course = Course(name: assignment.course, on: true)
        self.dueDate = date(string: assignment.dueDate)
    }

    
    /// Initalize task with name
    /// Get details from DB
    /// - Parameter name: task name
    init(name: String) {
        let realm = try! Realm()
        let assignment = realm.objects(mTasks.self).filter("name = '\(name)'").first!
        
        self.id = Int(assignment.id) ?? 0
        self.name = assignment.task
        self.status = assignment.status
        self.course = Course(name: assignment.course, on: true)
        self.dueDate = date(string: assignment.dueDate)
    }
    
    
    /// Initialize assignments class without getting from DB
    /// Can be used to intilaize "fake tasks" such as those from myHSC directly which are only used temporarily
    ///
    /// - Parameters:
    ///   - id: ID of task
    ///   - name: Name of task
    ///   - status: Pending, In Progress, Done, Snoozed etc. - need to add overdue status
    ///   - course: The course name which will be initialzied later from Course class
    ///   - dueDate: Due date as a string which will be converted to an enum
    init(id: Int, name: String, status: String, course: String, dueDate: String) {
        self.id = id
        self.name = name
        
        if status == "-1" {
            self.status = "Pending"
        } else {
            self.status = status
        }
        self.course = Course(name: course, on: true)
        self.dueDate = date(string: dueDate)
    }
    
    
    
    /// Add a new task
    /// Update a task if it exists
    func update() {
        let realm = try! Realm()
        let newAssignment = mTasks()
        
        newAssignment.id = String(self.id)
        newAssignment.task = self.name
        newAssignment.course = self.course.name
        newAssignment.dueDate = self.dueDate.string
        newAssignment.status = self.status
        newAssignment.dueStamp = ""
        
        try! realm.write {
            realm.add(newAssignment, update: .modified)
        }
    }
    
    
    // Follow Filters and return upcoming tasks
    ///
    
    /// Follow filters and get tasks
    ///
    /// - Parameter type: the relative due date as enum
    /// - Returns: Return a list of assignments matching crieria
    static func getUpcoming(type: Assignment.relativeDate) -> [Assignment]{
        let taskFilter = Assignment.getFilters() // Get filters from DB
        let realm = try! Realm()
        
        let upcoming = realm.objects(mTasks.self) // Get all upcoming tasks
        var returnTasks = [Assignment]() // Make array of assignments
        
        // For all upcomings tasks, append if it matches due date
        for task in upcoming {
            let myAssignment = Assignment(id: Int(task.id) ?? 0)
            if !taskFilter.contains(myAssignment.status) { continue }
            
            if myAssignment.dueDate.relative == type {
                returnTasks.append(myAssignment)
            }
        }
        
        return returnTasks
    }
    
    // Shadow Function for future security
    static func sync() {
        Assignments().syncAssignments()
    }
    
    
    /// Get filters from Database
    ///
    /// - Returns: Valid filters
    static func getFilters() -> [String] {
        var returnValue = [String]()
        
        
        let status = ["Snoozed", "Pending", "In Progress", "Done"]
        for s in status {
            let setting = Setting(setting: s)
            if setting.value == "True" {
                returnValue.append(setting.setting)
            }
        }
        
        return returnValue
    }
    
    

 } // End of Class




