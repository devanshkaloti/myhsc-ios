//
//  Courses.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftDate


class Course {
    
    // Properties
    
    /// List of block letters, primary key of courses
    ///
    /// - A: Block A of Schedule
    /// - B: Block B of Schedule
    /// - C: Block C of Schedule
    /// - D: Block D of Schedule
    /// - E: Block E of Schedule
    /// - F: Block F of Schedule
    /// - G: Block G of Schedule
    /// - H: Block H of Schedule
    enum blocks {
        case A, B, C, D, E, F, G, H
        
        
        /// Convert Enum Block letter to String Letter
        ///
        /// - Returns: String of block letter
        func getBlock() -> String {
            switch self {
            case .A: return "A"
            case .B: return "B"
            case .C: return "C"
            case .D: return "D"
            case .E: return "E"
            case .F: return "F"
            case .G: return "G"
            case .H: return "H"
            }
        }
    
        
    }
    
    
    /// Percentage of course weightings stored as Int
    /// Knowlege, Application, Communication, Thinking
    struct courseWeightings {
        var k: Int = 0
        var a: Int = 0
        var c: Int = 0
        var t: Int = 0
    }
    

    public var id: String? // ID of course, only if fetched from myHSC
    public var name: String // Name of course
    public var weights: courseWeightings = courseWeightings() // Weightings of K, A, C, T
    public var block: blocks // Block assigned to course, ex. Block A
    
    
    
    /// Initialize class with the name of the course
    ///
    /// - Parameter name: Name of course, ex. Advanced Functions
    init(name: String) {
        
        // Query course from DB
        let realm = try! Realm()
        let results = realm.objects(mCourses.self).filter("course = '\(name)'").first
        
        
        
        // Set Properties of class
        self.name = results?.course ?? "Loading..." // Name of course
        self.block = Course.getBlock(block: results?.block ?? "A") // Block letter
    
        // Set Weightings
        self.weights.k = Int(results?.weightK ?? 0)
        self.weights.a = Int(results?.weightA ?? 0)
        self.weights.c = Int(results?.weightC ?? 0)
        self.weights.t = Int(results?.weightT ?? 0)
    
    }
    
    
    init(name: String, on: Bool) {
        self.name = name
        self.block = Course.blocks.A

        self.weights.k = 0
        self.weights.a = 0
        self.weights.c = 0
        self.weights.t = 0
    }
    
    /// Initalize class with the block letter of the course
    ///
    /// - Parameter block: Assigned Block Letter, Ex. "B"
    init(block: String) {
        
        // Query course from DB
        let realm = try! Realm()
        let results = realm.objects(mCourses.self).filter("block = '\(block)'").first
        
        // Set Properties
        self.name = results?.course ?? "Loading..."
        self.block = Course.getBlock(block: results?.block ?? "A")
        
        // Set Weightings
        self.weights.k = Int(results?.weightK ?? 0)
        self.weights.a = Int(results?.weightA ?? 0)
        self.weights.c = Int(results?.weightC ?? 0)
        self.weights.t = Int(results?.weightT ?? 0)
    }
    
    
    /// Initalize class if the data is fetched from myHSC's API
    ///
    /// - Parameters:
    ///   - id: A unique ID
    ///   - name: Name of course
    ///   - block: Assigned block letter
    init(id: String?, name: String, block: String) {
        // Set Properties
        self.id = id
        self.name = name
        self.block = Course.getBlock(block: block)
        
        // Set Weightings
        self.weights.k = 0
        self.weights.a = 0
        self.weights.c = 0
        self.weights.t = 0
        
        
    }
    
    
    /// Add new course to Database
    ///
    /// - Parameters:
    ///   - name: Name of course
    ///   - block: Assigned block letter
    ///   - new: Bool to confirm addition of new course
    init(name: String, block: String, new: Bool) {
     
        // Set Properties
        self.name = name
        self.block = Course.getBlock(block: block)
        
        // Set Weightings
        self.weights.k = 0
        self.weights.a = 0
        self.weights.c = 0
        self.weights.t = 0
    
        // Confirm if it should be added
       if new == true {
            add()
       }
    }

    
    /// Get the block as an enum from the given string - letter
    ///
    /// - Parameter block: Assigned block as a string, Ex. "B"
    /// - Returns: Block letter as an enum
    static func getBlock(block: String) -> blocks {
        switch (block) {
        case "A":
            return .A
        case "B":
            return .B
        case "C":
            return .C
        case "D":
            return .D
        case "E":
            return .E
        case "F":
            return .F
        case "G":
            return .G
        case "H":
            return .H
        default:
            print("Error, Could not assign block to course - setting default to A")
            return blocks.A
        }
    }
    
    
    
    /// Add a new course to the database
    /// Only used in first setup
    func add() {
        let realm = try! Realm()
        
        
        let newCourse = mCourses()
        if let id = self.id {
            newCourse.id = id
        }
        newCourse.course = self.name
        newCourse.block = self.block.getBlock()
        
        newCourse.weightK = self.weights.k
        newCourse.weightA = self.weights.a
        newCourse.weightC = self.weights.c
        newCourse.weightT = self.weights.t
        
        
        // Write Transaction
        try! realm.write {
            realm.add(newCourse, update: .modified)
        }
        
    }
    
    
    /// Update the course in the database using initialized object directly
    func update() {
        let realm = try! Realm()
        
        let course = mCourses()
        course.course = self.name
        course.block = self.block.getBlock()
        
        course.weightK = self.weights.k
        course.weightA = self.weights.a
        course.weightC = self.weights.c
        course.weightT = self.weights.t
        
        try! realm.write {
            realm.add(course, update: .modified)
        }
        
    }
    
}


/// Calculate the weighted average of a test using course weightings
///
/// - Parameters:
///   - title: Title of the test
///   - course: Course corresponding to the test
///   - k: Knowlege Weighting
///   - a: Application Weighting
///   - t: Thinking Weighting
///   - c: Communication Weighting
/// - Returns: Weighted Average as percent, Unrounded
func calculateMark(title: String, course: String, k: String, a: String, t: String, c: String) -> Double {
    let realm = try! Realm()
    
    var mark: Double = 0.00 // Initialize Mark
    let marks: [String] = [k, a, t, c] // Weightings
    var prMarks: [Double] = [Double]() // Plain marks
    
    // For Database, initialize model
    let testMark = mMarks()
    testMark.date = Date().toString()
    testMark.course = course
    testMark.test = title
    
    // Save to DB
    try! realm.write {
        realm.add(testMark)
    }
    
    // Add mark and prepare to weight it
    for mark in marks {
        let splitMark = mark.split(separator: "/")
        prMarks.append(Double(splitMark[0])!/Double(splitMark[1])!*100)
    }
    
    // Add marks to the mark variable, to sum up. 
    mark += (prMarks[0]*(Double(Course(name: course).weights.k)/100))
    mark += (prMarks[1]*(Double(Course(name: course).weights.a)/100))
    mark += (prMarks[2]*(Double(Course(name: course).weights.t)/100))
    mark += (prMarks[3]*(Double(Course(name: course).weights.c)/100))
    
    
    return mark
}


// MARK: - Adding support for interaction with myHSC API. 
extension Course {
    static func getEnrolledCourses() -> [Course]{
        let realm = try! Realm()
        let results = realm.objects(sysCourses.self)
        var courses = [Course]()
        
        for c in results {
            let course = Course(id: c.id, name: c.course, block: c.block)
            courses.append(course)
        }
        
        return courses
    }

}


// MARK: - Getting the next 2 days and saving it to Info
extension Course {
    static func saveDate(date: String, day: String) {
        _ = Info(detail: date, value: day)
    }
    
    static func getDayInAdvance(number: Int) {
        let date = Date() + number.days
        
        if (Info(detail: date.toFormat("M/d/yyyy")).value == "" || Info(detail: date.toFormat("M/d/yyyy")).value == "0") {
            // Good to override:
            let dayNum = SchoolDays().getDay(date: date)
            saveDate(date: date.toFormat("M/d/yyyy"), day: String(dayNum))
        }

    }
    
    static func forDaysOnRun() {
     
    }
    
    static func getSavedDayNum() -> Int{
        
        // Find out of today date is in saved list
        var dayNum = Info(detail: Date().toFormat("M/d/yyyy")).value
        
//        SchoolDays().getTodayDay()
        // If found:
        if (dayNum != "") {
            return Int(dayNum)!
        }
        
        // Not Found
        if (dayNum == "") {
            var date = Date() + 1.days
            dayNum = Info(detail: date.toFormat("M/d/yyyy")).value
        }
        
        // Check if Next Day is Found
        if (dayNum != "") {
            return Int(dayNum)!
        }
        
        // If not found
        if (dayNum == "") {
            var date = Date() + 2.days
            dayNum = Info(detail: date.toFormat("M/d/yyyy")).value
        }
        // Check if Next Day is Found
        if (dayNum != "") {
            return Int(dayNum)!
        }
        
        return SchoolDays().getTodayDay()
        
    }
}

// MARK: - Marks API from http://myschoolappapi.dksources.com/api.php?course=SCH4U
extension Course {
    static func syncMarksWithdkAPI() {
        let realm = try! Realm()
        
        for i in getEnrolledCourses() {
            let courseCode = i.name.slice(from: "(", to: ")")
            
            let newWeights = DKsourcesAPI().get(course: courseCode?.replacingOccurrences(of: " ", with: "%20") ?? "0")
            
//            if (Int(newWeights.k) != 0) {
                i.weights.k = newWeights.k
                i.weights.a = newWeights.a
                i.weights.t = newWeights.t
                i.weights.c = newWeights.c
            
                i.id = ""
                i.update()
                
//            }
            
    
        }
    }
}
