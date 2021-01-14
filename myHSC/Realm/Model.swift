//
//  Model.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import Foundation
import RealmSwift

class mUser: Object {
    @objc dynamic var username = ""
    @objc dynamic var password = ""
    
    override static func primaryKey() -> String? {
        return "username"
    }
}

class mTasks: Object {
    @objc dynamic var id = ""
    @objc dynamic var course = ""
    @objc dynamic var task = ""
    @objc dynamic var startDate = ""
    @objc dynamic var dueDate = ""
    @objc dynamic var dueStamp = ""
    @objc dynamic var status = "Pending"
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class mCoursesOLD: Object {
    @objc dynamic var A = ""
    @objc dynamic var B = ""
    @objc dynamic var C = ""
    @objc dynamic var D = ""
    
    @objc dynamic var E = ""
    @objc dynamic var F = ""
    @objc dynamic var G = ""
    @objc dynamic var H = ""
}

class mCourses: Object {
    @objc dynamic var id = ""
    @objc dynamic var course = "" // A ... H
    @objc dynamic var weightK = 0
    @objc dynamic var weightA = 0
    @objc dynamic var weightT = 0
    @objc dynamic var weightC = 0
    @objc dynamic var block = ""
    
    override static func primaryKey() -> String? {
        return "block"
    }
//
}

class sysCourses: Object {
    @objc dynamic var id = ""
    @objc dynamic var course = ""
    @objc dynamic var block = ""
    
    override static func primaryKey() -> String? {
          return "id"
      }
}

class mMarks: Object {
    @objc dynamic var date = ""
    @objc dynamic var course = ""
    @objc dynamic var test = ""
    @objc dynamic var weightK = 0
    @objc dynamic var weightA = 0
    @objc dynamic var weightT = 0
    @objc dynamic var weightC = 0
}

class mSnapizer: Object {
    @objc dynamic var course = ""
    @objc dynamic var unit = ""
    @objc dynamic var title = ""
    @objc dynamic var pictureRef = ""
    @objc dynamic var dateSaved = ""
}

struct storedImages {
    var course: String
    var title: String
    var imageRef: String
    
    init(course: String, title: String, imageRef: String) {
        self.course = course
        self.title = title
        self.imageRef = imageRef
    }
}

class mUnit: Object {
    @objc dynamic var name = ""
    @objc dynamic var course = ""
}

enum weightSection: String {
    case k = "k"
    case a = "a"
    case t = "t"
    case c = "c"
}


// DEPRECIATED
class schoolDays: Object {
    @objc dynamic var realDate = ""
    @objc dynamic var schoolDay = ""
    
    override static func primaryKey() -> String? {
        return "realDate"
    }
}


class settings: Object {
    @objc dynamic var setting = ""
    @objc dynamic var value = ""
    
    override static func primaryKey() -> String? {
        return "setting"
    }
}

class info: Object {
    @objc dynamic var detail = ""
    @objc dynamic var value = ""
    
    override static func primaryKey() -> String? {
        return "detail"
    }
}
