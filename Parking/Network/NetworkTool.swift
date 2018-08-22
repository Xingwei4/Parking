//
//  NetworkTool.swift
//  Parking
//
//  Created by 卫星 on 2018/8/15.
//  Copyright © 2018年 Unimelb. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GoogleMaps

let SERVER_URL = "http://115.146.85.189:8000/parkdata/"

class NetworkTool: Alamofire.SessionManager {
    // Singleton
    internal static let sharedTools: NetworkTool = {
        let configuration = URLSessionConfiguration.default
        var header : Dictionary =  SessionManager.defaultHTTPHeaders
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return NetworkTool(configuration: configuration)
    }()
    
    // Get analysis data
    func getBayInfo( finished: @escaping (_ bayInfo:[BayInfo]?, _ error: Error?) -> ()) {
        let bayinfoURL = SERVER_URL + "bayinfo"
        NSLog(bayinfoURL)
        
        request(bayinfoURL, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let swiftyJsonVar = JSON(value)
                    var bayInfo = [BayInfo]()
                    for (_, dict) : (String, JSON) in swiftyJsonVar {
                        let bay = BayInfo(dict: dict)
                        bayInfo.append(bay)
                    }
                    finished(bayInfo, nil)
                } else {
                    finished(nil, NSError.init(domain: "Sever Error", code: 44, userInfo: nil))
                }
            } else {
                finished(nil, response.result.error)
            }
        }
    }
    
    func getParkingStatus( finished: @escaping (_ parkingstatus:[ParkingStatus]?, _ error: Error?) -> ()) {
        let bayinfoURL = SERVER_URL + "parkingstatus"
        NSLog(bayinfoURL)
        
        request(bayinfoURL, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let swiftyJsonVar = JSON(value)
                    var parkingstatus = [ParkingStatus]()
                    for (_, dict) : (String, JSON) in swiftyJsonVar {
                        let status = ParkingStatus(dict: dict)
                        parkingstatus.append(status)
                    }
                    finished(parkingstatus, nil)
                } else {
                    finished(nil, NSError.init(domain: "Sever Error", code: 44, userInfo: nil))
                }
            } else {
                finished(nil, response.result.error)
            }
        }
    }
    
    
    
}
