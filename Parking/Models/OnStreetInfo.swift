//
//  OnStreetInfo.swift
//  Parking
//
//  Created by 卫星 on 2018/8/26.
//  Copyright © 2018年 Unimelb. All rights reserved.
//

import UIKit
import SwiftyJSON

// Bay Info Model
class OnStreetInfo: NSObject {
    
    var bay_id : String?
    var lat : Double = 0
    var lon : Double = 0
    var st_marker_id : String?
    var status : String?
    var desc1 : String?
    var desc2 : String?
    var desc3 : String?
    
    init(dict: JSON) {
        bay_id = dict["bay_id"].stringValue
        lat = dict["lat"].doubleValue
        lon = dict["lon"].doubleValue
        st_marker_id = dict["st_marker_id"].stringValue
        status = dict["status"].stringValue
        desc1 = dict["desc1"].stringValue
        desc2 = dict["desc2"].stringValue
        desc3 = dict["desc3"].stringValue
        
        super.init()
    }
}
