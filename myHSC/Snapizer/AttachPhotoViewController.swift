//
//  AttachPhotoViewController.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import UIKit
import Eureka
import Toaster


/// Form to upload image and save details of lesson
class AttachPhotoViewController: FormViewController  {
    
    // Properties
    var imagePicker: UIImagePickerController!
    var unit: String!
    var image: UIImage!
    
    
    /// Build form on viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Items of form
        struct FormItems {
            static let title = "title"
            static let course = "course"
            static let unit = "unit"
        }
        
        
        form +++ Section("Attach Photo")
            <<< TextRow(FormItems.title){ row in
                row.title = "Title"
                row.placeholder = "Title of Picture (Lesson #?)"
            }
            <<< PickerInlineRow<String>(FormItems.course) {
                $0.title = "Course"
                $0.options = [Course(block: "A").name, Course(block: "B").name, Course(block: "C").name, Course(block: "D").name,
                              Course(block: "E").name, Course(block: "F").name, Course(block: "G").name, Course(block: "H").name]
                $0.value = Course(block: "A").name
                }.onChange() {[weak self ] row in
                    self?.showUnitSelector(course: self?.form.values()["course"] as? String ?? Course.init(block: "A").name)
            }
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Attach Picture" }
                .onCellSelection { [weak self] (cell, row) in
                    self?.takePicture()
                    row.title = "Change Picture"
            }
            
            +++ Section()
            
            // Save Button
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Save" }
                .onCellSelection { [weak self] (cell, row) in // On-click
                    
                    // Make sure unit is added
                    guard let unit = self?.unit else {
                        Toast.init(text: "Error occured, add/choose unit!").show()
                        return
                    }
                    
                    // Make sure picture is attached
                    guard let picture = self?.image else {
                        Toast.init(text: "Error occured, attach a picture").show()
                        return
                    }
                    
                    // Initialize Snapizer, and add
                    let snap = Snapizer.init(title: self?.form.values()["title"] as? String ?? "Untitled", course: self?.form.values()["course"] as? String ?? Course.init(block: "A").name, unit: unit)
                    Toast.init(text: "Loading - Please wait until uploading finished...").show()
                        
//                        snap.uploadImage(image: self?.image ?? UIImage(imageLiteralResourceName: "hqdefault.png"))
                        _ = snap.uploadImage(image: picture)
                        Toast.init(text: "Uploaded! Snap saved").show()
                    
        }
    }
    

}


// MARK: - Image Picker for the form
extension AttachPhotoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    /// Present the image taker view
    func takePicture() {
        self.imagePicker =  UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
        // Get the picture, resize and save into variable
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        self.image = info[.originalImage] as? UIImage
        self.image = self.image.resized(withPercentage: 0.3)
    }

}


// MARK: - Unit selecter popup
extension AttachPhotoViewController {
    
    
    /// Show the unit selecter and get the course it is for
    ///
    /// - Parameter course: Course as string
    func showUnitSelector(course: String) {
        
        // Popup
        let alertController = UIAlertController(title: "Select Unit From \(course)", message: nil, preferredStyle: .actionSheet)
        
        // Get units and attach as options to popup
        for s in Snapizer.getUnits(course: course) {
            let option = UIAlertAction(title: s, style: .default, handler: { (action) -> Void in
                self.unit = s
            })
            alertController.addAction(option)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped, no action...")
        })
        
        let addNew = UIAlertAction(title: "Add Unit", style: .default, handler: { (action) -> Void in
            self.showUnitAddPopup(course: course)
        })
        
  
        alertController.addAction(addNew)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    /// If user needs to add a unit
    ///
    /// - Parameter course: Course that it is for
    func showUnitAddPopup(course: String) {
        let alertController = UIAlertController(title: "Add New Unit for \(course)", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Unit Name"
        }
        
        let saveAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
            let textfield = alertController.textFields![0] as UITextField
            Snapizer.saveUnit(name: textfield.text ?? "Untitled Unit", course: course)
            self.unit = textfield.text ?? "Untitled Unit"
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}


// MARK: - Image helper functions
extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
