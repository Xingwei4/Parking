//
//  WilsonLocation.swift
//  Parking
//
//  Created by 卫星 on 2018/8/22.
//  Copyright © 2018年 Unimelb. All rights reserved.
//

import UIKit
import SwiftyJSON

// Wilson Location Model
class WilsonLocation: NSObject {
    
    // bay_id, lat, lon, st_marker_id
    var id: String?
    var place: String?
    var lat : Double = 0
    var lon : Double = 0    
    
    init(dict: JSON) {
        id = dict["id"].stringValue
        place = dict["place"].stringValue
        lat = dict["lat"].doubleValue
        lon = dict["lon"].doubleValue
        
        super.init()
    }
}
