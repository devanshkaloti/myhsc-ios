//
//  courseWeightSetup.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//


import UIKit
import Eureka
import Toaster




/// Setup course weightings
class courseWeightSetup: FormViewController {
    
    // Courses List
    let blocks = ["A", "B", "C", "D", "E", "F", "G", "H"]
    var courses: [Course] = []
    
    
    
    /// Setup view
    override func viewDidLoad() {
        super.viewDidLoad()
    
        for c in blocks {
            if Course(block: c).name != "Spare" {
                courses.append(Course(block: c))
            }
        }


        for course in courses {
            form +++ Section(course.name)
                <<< TextRow("\(course.name)k"){ row in
                    row.title = "Knowledge"
                    row.placeholder = "35"
                    row.value = String(course.weights.k)
                    }
                    <<< TextRow("\(course.name)a"){ row in
                        row.title = "Application"
                        row.placeholder = "35"
                        row.value = String(course.weights.a)
                    }
                    <<< TextRow("\(course.name)t"){ row in
                        row.title = "Thinking"
                        row.placeholder = "20"
                        row.value = String(course.weights.t)
                    }
                    <<< TextRow("\(course.name)c"){ row in
                        row.title = "Communication"
                        row.placeholder = "10"
                        row.value = String(course.weights.c)
                }
                <<< ButtonRow() { (row: ButtonRow) -> Void in
                    row.title = "Save"
                    }
                    .onCellSelection { [weak self] (cell, row) in
                        self?.save(course: course)
                   
            }
            
            
        }
        
    }
    
    
    /// Save the new values
    ///
    /// - Parameter course: Course
    func save(course: Course) {
        let valuesDictionary = form.values()
        
        course.weights.k = Int(valuesDictionary["\(course.name)k"] as! String)!
        course.weights.a = Int(valuesDictionary["\(course.name)a"] as! String)!
        course.weights.t = Int(valuesDictionary["\(course.name)t"] as! String)!
        course.weights.c = Int(valuesDictionary["\(course.name)c"] as! String)!
  
        course.update()
        Toast(text: "Weightings Saved!").show()
    }
}

