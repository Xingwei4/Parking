//
//  WilsonFee.swift
//  Parking
//
//  Created by 卫星 on 2018/8/22.
//  Copyright © 2018年 Unimelb. All rights reserved.
//

import UIKit
import SwiftyJSON

// Wilson Fee Model
class WilsonFee: NSObject {
    
    var place_id: String?
    var scope: String?
    var rate: String?
    
    init(dict: JSON) {
        place_id = dict["place_id"].stringValue
        scope = dict["scope"].stringValue
        rate = dict["rate"].stringValue
        
        super.init()
    }
}

