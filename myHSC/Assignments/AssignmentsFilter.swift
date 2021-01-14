//
//  AssignmentsForm.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//


import UIKit
import Eureka
import RealmSwift


/// To manage the view for selecting filters
class AssignmentsFilter: FormViewController {
    
    
    /// On load setup form
    override func viewDidLoad() {
        
        // Elements
        struct FormItems {
            static let filter = "task"
        }
        
        
        super.viewDidLoad()
        
        
        // Form
        form +++ Section("Choose filter")
            <<< MultipleSelectorRow<String>(FormItems.filter) {
                $0.title = "Task Filters"
                $0.selectorTitle = "Choose Task Filers"
                $0.options = ["Snoozed", "Pending","In Progress","Done"]
                $0.value = getExisting()   // initially selected
            }
            
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Save Settings"
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.finalAction()
        }
        
        
        
    }
    
    
    /// Add the settings to database
    ///
    /// - Parameter mySetting: Set of settings selected
    func addSettings(mySetting: Set<String>) {
        let realm = try! Realm()
        
        let status = ["Snoozed", "Pending", "In Progress", "Done"]
        for s in status {
            let setting = Setting(setting: s)
    
            if mySetting.contains(s) {
                setting.setValue(value: "True")
            } else {
                setting.setValue(value: "False")
            }
        }
    
    }
    
    
    
    
    
    /// Delete existing ones from DB
    func deleteExisting() {
        let realm = try! Realm()
        let filters = realm.objects(settings.self).filter("setting = 'filterStatusAssignment'")
        try! realm.write { realm.delete(filters) }
    }
    
    
    /// Get the existing ones for setup
    ///
    /// - Returns: Existing values
    func getExisting() -> Set<String>{
        let realm = try! Realm()
        
        let status = ["Snoozed", "Pending", "In Progress", "Done"]
        var myFilters = Set<String>()
        
        // For each status in array find it it's on
        for s in status {
            let setting = Setting(setting: s)
            if setting.value == "True" {
                myFilters.insert(setting.setting)
            }
        }
        return myFilters
    }

    
    /// Action Sequency 
    func finalAction() {
        deleteExisting()
        addSettings(mySetting: form.values()["task"]! as! Set<String>)
    }
    
}


