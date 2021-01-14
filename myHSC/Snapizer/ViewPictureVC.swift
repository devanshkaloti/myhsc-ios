//
//  ViewPictureVC.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import UIKit
import Firebase
import SkeletonView

/// VC Controller for screen that shows image
class ViewPictureVC: UIViewController {

    @IBOutlet weak var imageviewer: UIImageView!
    var ref: String!
    var titleVar: String!
    @IBOutlet weak var titleLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.showAnimatedGradientSkeleton()
        titleLabel.text = titleVar
        
        let storage = Storage.storage()
        let img = storage.reference(withPath: ref)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        img.getData(maxSize: 15 * 1024 * 1024) { data, error in
            if let error = error {
                print("ERROR \(error)")
            } else {
                self.imageviewer.image = UIImage(data: data!)
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.hideSkeleton()
    }
    



}
