//
//  SnapizerMain.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import UIKit


/// This controller is responsible for the snapizer
class SnapizerHomeVC: UIViewController {

    // 2 outlets for each course = 8 * 2 = 16 :(
    @IBOutlet weak var AT: UILabel!
    @IBOutlet weak var AU: UILabel!
    
    @IBOutlet weak var BT: UILabel!
    @IBOutlet weak var BU: UILabel!
    @IBOutlet weak var CT: UILabel!
    @IBOutlet weak var CU: UILabel!
    @IBOutlet weak var DT: UILabel!
    @IBOutlet weak var DU: UILabel!
    @IBOutlet weak var ET: UILabel!
    @IBOutlet weak var EU: UILabel!
    @IBOutlet weak var FT: UILabel!
    @IBOutlet weak var FU: UILabel!
    @IBOutlet weak var GT: UILabel!
    @IBOutlet weak var GU: UILabel!
    @IBOutlet weak var HT: UILabel!
    @IBOutlet weak var HU: UILabel!
    
    // Tap gestures to know user has tapped on something
    @IBAction func tapA(_ sender: UITapGestureRecognizer) { showUnitsScreen(block: "A") }
    @IBAction func tapB(_ sender: UITapGestureRecognizer) { showUnitsScreen(block: "B") }
    @IBAction func tapC(_ sender: UITapGestureRecognizer) { showUnitsScreen(block: "C") }
    @IBAction func tapD(_ sender: UITapGestureRecognizer) { showUnitsScreen(block: "D") }

    @IBAction func tapE(_ sender: UITapGestureRecognizer) { showUnitsScreen(block: "E") }
    @IBAction func tapF(_ sender: UITapGestureRecognizer) { showUnitsScreen(block: "F") }
    @IBAction func tapG(_ sender: UITapGestureRecognizer) { showUnitsScreen(block: "G") }
    @IBAction func tapH(_ sender: UITapGestureRecognizer) { showUnitsScreen(block: "H") }
    
    
    /// Present user units screen
    ///
    /// - Parameter block: Course Block
    func showUnitsScreen(block: String) {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "UnitsTopics") as! UnitsTopicsTVC
        newVC.units = Snapizer.getUnits(course: Course.init(block: block).name)
        self.navigationController!.pushViewController(newVC, animated: true)
    }
    
    // Image picker property to upload image
    var imagePicker: UIImagePickerController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    /// Load boxes and add count number to units and set title of course
    ///
    /// - Parameter animated: always true
    override func viewWillAppear(_ animated: Bool) {
        
        let outletsT: [UILabel] = [AT, BT, CT, DT, ET, FT, GT, HT]
        let outletsU: [UILabel] = [AU, BU, CU, DU, EU, FU, GU, HU]
        
        let blocks: [String] = ["A", "B", "C", "D", "E", "F", "G", "H"]
        var i: Int = 0
        
        // Go through each block and set each outlet
        for b in blocks {
            outletsT[i].text = Course(block: b).name
            outletsU[i].text = "\(Snapizer.getUnits(course: Course(block: b).name).count) Units"
            i += 1
        }
    }
    
    
    /// Back button
    ///
    /// - Parameter sender: button is sender
    @IBAction func back(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
//        present(vc, animated: true, completion: nil)
        
        self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabController") as UIViewController, animated: true, completion: nil)
    }
    

}



