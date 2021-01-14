//
//  Label.swift
//  myHSC
//
//  Created by Devansh Kaloti on 2019-09-28.
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import Foundation
import UIKit


class Label: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeFontName()
    }
    
    func changeFontName()
    {
        self.font = UIFont(name: "SF-Pro-Display-Black", size: self.font.pointSize)
    }
}
