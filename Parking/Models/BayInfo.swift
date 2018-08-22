//
//  BayInfo.swift
//  Parking
//
//  Created by 卫星 on 2018/8/15.
//  Copyright © 2018年 Unimelb. All rights reserved.
//

import UIKit
import SwiftyJSON

// Bay Info Model
class BayInfo: NSObject {
    
    var bay_id : String?
    var lat : Double = 0
    var lon : Double = 0
    var st_marker_id : String?
    
    init(dict: JSON) {
        bay_id = dict["bay_id"].stringValue
        lat = dict["lat"].doubleValue
        lon = dict["lon"].doubleValue
        st_marker_id = dict["st_marker_id"].stringValue
        
        super.init()
    }
}
