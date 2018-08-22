//
//  BayFee.swift
//  Parking
//
//  Created by 卫星 on 2018/8/23.
//  Copyright © 2018年 Unimelb. All rights reserved.
//

import UIKit
import SwiftyJSON

// Bay Fee Model
class BayFee: NSObject {
    
    var bay_id : String?
    var desc1 : String?
    var desc2 : String?
    var desc3 : String?
    
    init(dict: JSON) {
        bay_id = dict["bay_id"].stringValue
        desc1 = dict["desc1"].stringValue
        desc2 = dict["desc2"].stringValue
        desc3 = dict["desc3"].stringValue
        
        super.init()
    }
}
