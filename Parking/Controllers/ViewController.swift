//
//  ViewController.swift
//  Parking
//
//  Created by 卫星 on 2018/8/13.
//  Copyright © 2018年 Unimelb. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

// ViewController is linked with Main.stroyboard
class ViewController: UIViewController {
    
    // UI element initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Background Image
        self.view.layer.contents = UIImage(named:"Background.png")?.cgImage
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Real Time Parking Status Button
    @IBAction func showParkingStutsButton(_ sender: UIButton) {
        let RTViewController = RTParkingViewController()
        let RealTimePage =  UINavigationController(rootViewController: RTViewController)
        present(RealTimePage, animated: true, completion: nil)
        
    }
    
}

