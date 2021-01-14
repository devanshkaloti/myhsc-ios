//
//  Settings.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase
import RNCryptor


/// Settings class, also contains MISC functions related to a setting
class Setting {
    
    
    /// The setting and value pair will be protected from changing
    /// As in future implementions, security logfiles may be implemented.
    private(set) var setting: String
    private(set) var value: String
    
    
    /// Initializer
    /// Get value automatically
    /// - Parameter setting: Setting name
    init(setting: String) {
        let realm = try! Realm()
        let results = realm.objects(settings.self).filter("setting = '\(setting)'")
        
        
        self.setting = setting
        self.value = results.first?.value ?? ""
    
    }
    
    
    /// Make new setting and add to DB automatically
    ///
    /// - Parameters:
    ///   - setting: Setting name
    ///   - value: Value
    init(setting: String, value: String) {
        self.setting = setting
        self.value = value
        
        updateSetting()
    }
    
    
    /// Add or update a setting
    func updateSetting() {
        let realm = try! Realm()
        
        let settingObject = settings()
        settingObject.setting = self.setting
        settingObject.value = self.value
        
        try! realm.write {
            realm.add(settingObject, update: .modified)
        }
    }
    
    
    
    /// Change the value of a setting
    /// Similar to updateSetting()
    /// - Parameter value: New value
    func setValue(value: String) {
        self.value = value
        self.updateSetting()
    }

    
    
    
    /// Store the generated token in databse and other details on first login
    ///
    /// - Parameters:
    ///   - token: Token value from API
    ///   - userID: Student#
//    static func storeToken(token: String, userID: String) {
//        _ = Setting(setting: "loginToken", value: token)
//        _ = Setting(setting: "loginUserID", value: userID)
//    }
        static func storeToken(token: String) {
            _ = Setting(setting: "loginToken", value: token)
        }
    
    
        static func storeUserID(userID: String) {
             _ = Setting(setting: "loginUserID", value: userID)
        }

    
    
    /// Store the username and password in internal databse
    ///
    /// - Parameters:
    ///   - username: Username
    ///   - password: Password
    static func storeUsernamePassword(username: String, password: String) {
        // Generate key:
        let key: String = try! Security.generateEncryptionKey(withPassword: password)
        Security.saveInKeychain(key: key)
    
        // Encrypt
        let encryptedPass = try! Security.encryptMessage(message: password, encryptionKey: key)
        
        _ = Setting(setting: "username", value: username)
        _ = Setting(setting: "password", value: encryptedPass)
        
    }

    
    
    /// Everything to do with courses settings MISC
    static func syncRegisteredCourses() {
        let realm = try! Realm()
        
        // Get courses from API
        if realm.objects(sysCourses.self).count == 0 {
            let APICourses = Courses()
            APICourses.get()
            
            
            if APICourses.courses.count == 0 {
                // This means myHSC is not providing any courses at the moment
//                let dummy = sysCourses()
//                dummy.id = "0"
//                dummy.course = "dummy course"
//                dummy.block = "A"
//                try! realm.write {
//                    realm.add(dummy)
//                }
                
            }
            
            for i in APICourses.courses {
                
                // Add course to new table in DB
                let newCourse = sysCourses()
                if let id = i.id { // If ID Exists - unwrap optional
                    newCourse.id = id
                }
                newCourse.course = i.name
                newCourse.block = i.block.getBlock()
                try! realm.write {
                    realm.add(newCourse)
                }
            }
            
            
            
            for i in APICourses.courses {

                // Add course to new table in DB
                let newCourse = sysCourses()
                if let id = i.id { // If ID Exists - unwrap optional
                    newCourse.id = id
                }
                newCourse.course = i.name
                newCourse.block = i.block.getBlock()
                try! realm.write {
                    realm.add(newCourse, update: .modified)
                }
            }
            
            
            // Default Courses List
            var defaultCourses = ["A", "B", "C", "D", "E", "F", "G", "H"]
            
            // New implementation - add the API courses to Actual Courses Raw Data
            for i in APICourses.courses {
                let course = Course(id: i.id!, name: i.name, block: i.block.getBlock())
                course.add()
                defaultCourses = defaultCourses.filter{$0 != i.block.getBlock()}
            }
            
            // If user has blank blocks, they must be accounted for i.e spares
            for i in defaultCourses {
                let course = Course(id: "0", name: "Spare", block: i)
                course.add()
            }
        }
    }
    
    
//    /// Settings Defaults to be saved during first run
    static func firstRun() {
        let realm = try! Realm()
        
        // Set Defaults to be changed alter by user or code
        if realm.objects(settings.self).filter("setting = 'firstRun'").count == 0 {
            _ = Setting(setting: "firstRun", value: "True")
            _ = Setting(setting: "Snoozed", value: "True")
            _ = Setting(setting: "Pending", value: "True")
            _ = Setting(setting: "In Progress", value: "True")
            _ = Setting(setting: "Done", value: "True")
    
            _ = Setting(setting: "loginToken", value: "")
            _ = Setting(setting: "loginUserID", value: "")
            _ = Setting(setting: "loginUserName", value: "User")
        }
        
        // Save user's name with DB during this process as well
        
          Setting.setupCourses()
        
        
        
    }
    

    static func setupCourses() {
        
        // Add Name
        let name = retriveUserName(userid: getUserID())
        _ = Setting(setting: "loginUserName", value: name)
        
        
        let realm = try! Realm()
        
        let APICourses = Courses()
        APICourses.get()
        
        
        if APICourses.courses.count == 0 {
            // myHSC not providing any courses
            // Exit and notify client of this
        } else {
            for course in APICourses.courses {
                let newCourse = sysCourses()
                
                if let id = course.id { // If ID Exists - unwrap optional
                    newCourse.id = id
                }
                newCourse.course = course.name
                newCourse.block = course.block.getBlock()
                try! realm.write {
                    realm.add(newCourse, update: .modified)
                }
            } // End of for loop
            
            var defaultCourses = ["A", "B", "C", "D", "E", "F", "G", "H"]
            for course in APICourses.courses {
                let course = Course(id: course.id, name: course.name, block: course.block.getBlock())
                course.add()
                
                defaultCourses = defaultCourses.filter{$0 != course.block.getBlock()}
            }
            
            // Add Spares
            for i in defaultCourses {
                let course = Course(id: "0", name: "Spare", block: i)
                course.add()
            }
            
            Course.getDayInAdvance(number: 0)
            Course.getDayInAdvance(number: 1)
            Course.getDayInAdvance(number: 2)
            
            
        } // End of Sync
        
        
    
        
    }
    
    
    static func startup() {
        let realm = try! Realm()
        
        if (Info.isFirst() && Setting.isFirst()) {
            setupCourses()
        } else {
            let active_schoolyear = Info(detail: "active_schoolyear")
            
            if (active_schoolyear.value != Info.active_schoolyear) {
                // Clear out tasks and schedule, reset for new school year
                try! realm.write {
                    realm.delete(realm.objects(mCourses.self))
                    realm.delete(realm.objects(mMarks.self))
                    realm.delete(realm.objects(mSnapizer.self))
                    realm.delete(realm.objects(mTasks.self))
                    realm.delete(realm.objects(mUnit.self))
                    realm.delete(realm.objects(mUser.self))
                    realm.delete(realm.objects(sysCourses.self))
                }
    
                active_schoolyear.value = Info.active_schoolyear
                active_schoolyear.update()
                
                setupCourses()
            }
            
            // Save user's name with DB during this process as well
            let name = retriveUserName(userid: getUserID())
            var setting = Setting(setting: "loginUserName")
            setting.setValue(value: name)
        
            Course.getDayInAdvance(number: 0)
            Course.getDayInAdvance(number: 1)
            Course.getDayInAdvance(number: 2)
            
            //http://myschoolappapi.dksources.com/api.php?course=SCH4U
        }
       
    }
    
    
//    static func firstrun() {
//        let realm = try! Realm()
//
//        // Phase 1 - Filling inital values
//        _ = Setting(setting: "firstRun", value: "True")
//        _ = Setting(setting: "Snoozed", value: "True")
//        _ = Setting(setting: "Pending", value: "True")
//        _ = Setting(setting: "In Progress", value: "True")
//        _ = Setting(setting: "Done", value: "True")
//
//
//    }
    
    static func isFirst() -> Bool{
        let realm = try! Realm()
        
        if (realm.objects(settings.self).count <= 3)  { // 3 if AppDelegate made first 3
            return true
        } else {
            return false
        }
    }
    
    
}
//    static func setupCourses() {
//      let realm = try! Realm()
//
//        if realm.objects(mCourses.self).count == 0 {
//            let defaultCourses = ["A", "B", "C", "D", "E", "F", "G", "H"]
//
//            for i in defaultCourses {
//                _ = Course(name: i, block: i, new: true)
//            }
//        }
//    }
//}

