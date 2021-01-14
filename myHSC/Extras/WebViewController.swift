//
//  LunchMenuViewController.swift
//  myHSC
//
//  Created by Devansh Kaloti
//  Copyright © 2019 Devansh Kaloti. All rights reserved.
//

import UIKit
import WebKit
import FirebaseAnalytics


/// VC for web views including lunch menu
class WebViewController: UIViewController {
    var webView: WKWebView!
    var url: String = "https://menu2.danahospitality.ca/hsc/HSCmenubar.asp?banner=1&grid=1"
    
    // Load view
    override func loadView() {
        
        Analytics.logEvent("Lunch Menu", parameters: [
            "name": Setting(setting: "username").value as NSObject,
            ])
        
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        self.view = webView
    }
    
    // Back button
    @IBAction func back(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
//        present(vc, animated: true, completion: nil)
        
            self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabController") as UIViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url: URL(string: url)!))
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
