//
//  Info.swift
//  myHSC
//
//  Created by Devansh Kaloti on 2019-08-27.
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//


import Foundation
import RealmSwift
import Firebase



/// Info class to operate to save and retrive info
class Info {
    
    
    /** List of properties stored
     1. active_schoolyear = 2020-2021
     2. firstrun = 0
     */
    
    static public var active_schoolyear = "2019-2020"
    
    
    
    var detail: String
    var value: String
    
    
    // Get value
    init(detail: String) {
        let realm = try! Realm()
        let results = realm.objects(info.self).filter("detail = '\(detail)'")
        
        self.detail = detail
        self.value = results.first?.value ?? ""
    }
    
    // Make new
    init(detail: String, value: String) {
        self.detail = detail
        self.value = value
        
        self.update()
    }
    
    // Update
    func update() {
        let realm = try! Realm()
        
        let object = info()
        object.detail = self.detail
        object.value = self.value
        
        try! realm.write {
            realm.add(object, update: .modified)
        }
    }

    static func isFirst() -> Bool{
        let realm = try! Realm()
        
        if realm.objects(info.self).count == 0 {
            return true
        } else {
            return false
        }
    }
}
