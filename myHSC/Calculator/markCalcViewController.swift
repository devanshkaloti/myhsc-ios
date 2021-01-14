//
//  WeightAvgViewController.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2018 Devansh Kaloti. All rights reserved.
//

import UIKit
import Eureka
import Toaster
import FirebaseAnalytics


/// This VC is responsible for controlling the Marks Calculator Controller Prime
class marckCalcViewController: FormViewController {
    
    
    /// Setup form and main view
    override func viewDidLoad() {
        super.viewDidLoad()

        
        /// Details of each test mark
        struct FormItems {
            static let title: String = "title"
            static let course: String = "course"
            static let k = "k"
            static let a = "a"
            static let t = "t"
            static let c = "c"
        }
        
        
        
        
        
        form +++ Section("Description")
            <<< TextRow(FormItems.title){ row in
                row.title = "Test Title: "
            }
            // Course
            <<< PickerInlineRow<String>(FormItems.course) {
                $0.title = "Course"
                $0.options = [Course(block: "A").name, Course(block: "B").name, Course(block: "C").name, Course(block: "D").name,
                            Course(block: "E").name, Course(block: "F").name, Course(block: "G").name, Course(block: "H").name]
                $0.value = Course(block: "A").name
            }
        
        // Marks Section
        form +++ Section("Marks")
            <<< TextRow(FormItems.k){ row in
                row.title = "Knowledge: "
                row.placeholder = "25/25"
            }
            <<< TextRow(FormItems.a){ row in
                row.title = "Application: "
                row.placeholder = ""
            }
            <<< TextRow(FormItems.t){ row in
                row.title = "Thinking: "
                row.placeholder = ""
            }
            <<< TextRow(FormItems.c){ row in
                row.title = "Communication: "
                row.placeholder = ""
            }
            
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Setup Course Weightings"
                }
                .onCellSelection { [weak self] (cell, row) in
                    let VC = self?.storyboard?.instantiateViewController(withIdentifier: "courseWeightSetup") as! courseWeightSetup
                    
                    self?.navigationController?.pushViewController(VC, animated: true)
                    
            }
                    
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Calculate"
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.calculate()
        }
    }
    
    
    /// Confirm that the mark is valid
    /// NOTE This part will be fixed in future as currently in requires a got/total
    /// Future version will make this optional format, and automatically detect if a percent is given or a total mark and the keyboard will be customized
    /// With numbers and just a "/"
    /// - Parameter mark: Mark as string value taken direct from user
    /// - Returns: True or false if it's valid / not
    func isValid(mark: String) -> Bool {
        if (mark != nil && mark.contains("/")) { // Needs to be ex. 23/24
            return true
        } else {
            return false
        }
    }
    
    
    
    /// Calculate the mark using values from DB
    func calculate() {
        let valuesDictionary = form.values()
    
        // Validation
        guard let k = valuesDictionary["k"] as? String else {
            Toast(text: "That is not a valid mark!").show()
            return
        }
        guard let a = valuesDictionary["a"] as? String else {
            Toast(text: "That is not a valid mark!").show()
            return
        }
        guard let t = valuesDictionary["t"] as? String else {
            Toast(text: "That is not a valid mark!").show()
            return
        }
        guard let c = valuesDictionary["c"] as? String else {
            Toast(text: "That is not a valid mark!").show()
            return
        }
        guard let title = valuesDictionary["title"] as? String else {
            Toast(text: "Please type a title").show()
            return
        }
        guard let course = valuesDictionary["course"] as? String else {
            Toast(text: "Please select a course").show()
            return
        }
        
        
        let marks = [k, a, t, c]
        
        // Just check once more!
        for i in marks {
            if (!i.contains("/")) {
                Toast(text: "Please enter a mark in the format such as 24/25").show()
                return
            } else {
                let calculatedMark = calculateMark(title: title, course: course, k: marks[0], a: marks[1], t: marks[2], c: marks[3])
                Toast(text: "Your mark is: " + String(calculatedMark)).show() // Give mark
                
                Analytics.logEvent("Marks", parameters: [
                    "name": Setting(setting: "username").value as NSObject,
                    "Test Name": title as NSObject,
                    "Test Overall Mark": calculatedMark as NSObject,
                    ])
                
            }
        }
     
        
        
 
    }


}
