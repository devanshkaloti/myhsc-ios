//
//  CoursesForm.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import UIKit
import Eureka

class CoursesForm: FormViewController {

    override func viewDidLoad() {
        
        struct FormItems {
            static let A = "A"
            static let B = "B"
            static let C = "C"
            static let D = "D"
            static let E = "E"
            static let F = "F"
            static let G = "G"
            static let H = "H"
        }
        
        
        super.viewDidLoad()
        
        
        
        form +++ Section("My Task")
            <<< TextRow(FormItems.A){ row in
                row.title = "Course A"
                row.placeholder = "..."
                row.value = Course(block: "A").name
            }
            <<< TextRow(FormItems.B){ row in
                row.title = "Course B"
                row.placeholder = "..."
                row.value = Course(block: "B").name
            }
            <<< TextRow(FormItems.C){ row in
                row.title = "Course C"
                row.placeholder = "..."
                row.value = Course(block: "C").name
            }
            <<< TextRow(FormItems.D){ row in
                row.title = "Course D"
                row.placeholder = "..."
                row.value = Course(block: "D").name
            }
            <<< TextRow(FormItems.E){ row in
                row.title = "Course E"
                row.placeholder = "..."
                row.value = Course(block: "E").name
            }
            <<< TextRow(FormItems.F){ row in
                row.title = "Course F"
                row.placeholder = "..."
                row.value = Course(block: "F").name
            }
            <<< TextRow(FormItems.G){ row in
                row.title = "Course G"
                row.placeholder = "..."
                row.value = Course(block: "G").name
            }
            <<< TextRow(FormItems.H){ row in
                row.title = "Course H"
                row.placeholder = "..."
                row.value = Course(block: "H").name
            }

            form +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Save"
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.createTask()
        }
       
        
    }
    
    func createTask() {
        let valuesDictionary = form.values()
        

        let coursesBlock = [
            "A": valuesDictionary["A"]! as! String,
            "B": valuesDictionary["B"]! as! String,
            "C": valuesDictionary["C"]! as! String,
            "D": valuesDictionary["D"]! as! String,
            "E": valuesDictionary["E"]! as! String,
            "F": valuesDictionary["F"]! as! String,
            "G": valuesDictionary["G"]! as! String,
        ]
        
        for (block, course) in coursesBlock {
            let myCourse = Course(block: block)
            myCourse.name = course
            myCourse.update()
        }
    }
}


