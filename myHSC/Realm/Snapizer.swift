//
//  Snapizer.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase


/// Provides code for snapizer function
class Snapizer {
    
    
    /// Struct for the course and unit tied together
    struct Tags {
        var course: Course
        var unit: String
        
        init(course: String, unit: String) {
            self.course = Course.init(name: course, on: false)
            self.unit = unit
        }
    }
    
    // Properties Basic
    var title: String
    var tags: Tags
    var imageRef: String?
    
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - title: Title of lesson
    ///   - course: Course
    ///   - unit: Unit of course
    init(title: String, course: String, unit: String) {
        self.title = title
        self.tags = Tags(course: course, unit: unit)
        
        
    }
    
    
    /// Save the data
    private func saveName() {
        let realm = try! Realm()
        let picture = mSnapizer()
        
        picture.title = self.title
        picture.course = self.tags.course.name
        picture.pictureRef = self.imageRef!
        picture.unit = self.tags.unit
        picture.dateSaved = Date().toString()
        
        try! realm.write {
            realm.add(picture)
        }
    }
    
    
    /// Upload to Firebase
    ///
    /// - Parameter image: Image being uploaded
    /// - Returns: Status completion
    func uploadImage(image: UIImage) -> Bool {
        guard let data = image.pngData() else { return false } // Make sure image exists
        
        // Get DB Instance
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let username: String = Setting(setting: "username").value // Get user's username
        
        self.imageRef = String(NSDate().timeIntervalSince1970) // Unique Name stored in DB (Timestamp)
        let reference = storageRef.child("photos/\(username)/\(self.imageRef ?? "NONAME").jpg") // Upload image
        
        _ = reference.putData(data, metadata: nil) { (metadata, error) in } // Metadata closure currently not used
        saveName()
        return true
    }
    
    
    
    /// Get the images from datebase
    ///
    /// - Parameter unit: Unit
    /// - Returns: array of images
    static func getImages(unit: String) -> [storedImages]{ // ANY WILL WORK??
        let realm = try! Realm()
        let results = realm.objects(mSnapizer.self).filter("unit = '\(unit)'")
        var returnValues = [storedImages]()
        let username: String = Setting(setting: "username").value
        
    
        for r in results {
            let returnInfo = storedImages(course: r.course, title: r.title, imageRef: "photos/\(username)/\(r.pictureRef)")
            returnValues.append(returnInfo)
        }
        
        return returnValues
    }

}


// MARK: - Units
extension Snapizer {
    
    /// Add Unit
    ///
    /// - Parameters:
    ///   - name: Name
    ///   - course: Course for unit
    static func saveUnit(name: String, course: String) {
        let realm = try! Realm()
        let unit = mUnit()
        unit.name = name
        unit.course = course
        
        try! realm.write {
            realm.add(unit)
        }
    }
    
    
    /// Get units
    ///
    /// - Parameter course: Course name
    /// - Returns: String array of units
    static func getUnits(course: String) -> [String]{
        let realm = try! Realm()
        let results = realm.objects(mUnit.self).filter("course = '\(course)'")
        var returnValues = [String]()
        
        for r in results {
            returnValues.append(r.name)
        }
        
        return returnValues
    }
}
