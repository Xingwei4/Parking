//
//  ParkingStatus.swift
//  Parking
//
//  Created by 卫星 on 2018/8/20.
//  Copyright © 2018年 Unimelb. All rights reserved.
//

import UIKit
import SwiftyJSON

// Parking Status Model
class ParkingStatus: NSObject {
    
    var bay_id : String?
    var status : String?
    
    init(dict: JSON) {
        bay_id = dict["bay_id"].stringValue
        status = dict["status"].stringValue
        
        super.init()
    }
}
