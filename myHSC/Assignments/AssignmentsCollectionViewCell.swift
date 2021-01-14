//
//  AssignmentsCollectionViewCell.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import UIKit
import SwipeCellKit


/// Card cell for swipe as well as connecting UI to Code
class AssignmentsCollectionViewCell: SwipeCollectionViewCell {
    
    
    @IBOutlet weak var course: UILabel!
    @IBOutlet weak var homeworkTitle: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    
    @IBOutlet weak var status: UIButton!
}

