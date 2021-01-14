//
//  CoursesViewController.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import UIKit


/// Controller to manage courses vc
class CoursesViewController: UIViewController {

    @IBOutlet weak var todayDay: UILabel!
    @IBOutlet var blockA: [UILabel]!
    @IBOutlet var blockB: [UILabel]!
    @IBOutlet var blockC: [UILabel]!
    @IBOutlet var blockD: [UILabel]!
    
    @IBOutlet var blockE: [UILabel]!
    @IBOutlet var blockF: [UILabel]!
    @IBOutlet var blockG: [UILabel]!
    @IBOutlet var blockH: [UILabel]!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad() // idk if i can call this here or not... 

        // Do any additional setup after loading the view.
        setSchedule(blockLabel: blockA, course: Course(block: "A").name)
        setSchedule(blockLabel: blockB, course: Course(block: "B").name)
        setSchedule(blockLabel: blockC, course: Course(block: "C").name)
        setSchedule(blockLabel: blockD, course: Course(block: "D").name)
        
        setSchedule(blockLabel: blockE, course: Course(block: "E").name)
        setSchedule(blockLabel: blockF, course: Course(block: "F").name)
        setSchedule(blockLabel: blockG, course: Course(block: "G").name)
        setSchedule(blockLabel: blockH, course: Course(block: "H").name)
        
        // Get school day and set task.. 
        let today = SchoolDays().getTodayDay()
        if today != 0 {
            todayDay.text = "Today is Day: \(today)"
        } else {
            todayDay.text = "Today is a Holiday!"
        }
    }
    
    func setSchedule(blockLabel: [UILabel], course: String) {
        for label in blockLabel {
            label.text = course
        }
    }
    
    

}
