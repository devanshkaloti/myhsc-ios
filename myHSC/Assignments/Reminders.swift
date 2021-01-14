//
//  Reminders.swift
//  myHSC
//
//  Created by Devansh Kaloti on 2018-10-23.
//  Copyright © 2018 Devansh Kaloti. All rights reserved.
//

import Foundation
import UIKit
import Toaster
import DatePickerDialog



// SHOW REMINDER BOX
@objc func showReminderBox(sender:UIButton) {
    let task = homework[sender.tag]
    
    
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
                                
                                
                            }
        }
        
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


func setReminder(date: Date, task: tasks) {
    
    
    let formatter = DateFormatter()
    let myString = formatter.string(from: date) // string purpose I add here
    let yourDate = formatter.date(from: myString)
    formatter.dateFormat = "dd MMM yyyy 'at' HH:mm"
    
    let myDate = formatter.string(from: yourDate!)
    
    
    setNotifications(notificationTitle: "Do \(task.task)", notificationBody: "For \(task.course) on \(task.dueDate)", date: date)
}
