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
    
    // Get Wilson Locations
    func getWilsonLocation( finished: @escaping (_ wilsonlocation:[WilsonLocation]?, _ error: Error?) -> ()) {
        let wilsonlocationURL = SERVER_URL + "wilsonlocation"
        NSLog(wilsonlocationURL)
        
        request(wilsonlocationURL, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let swiftyJsonVar = JSON(value)
                    var wilsonlocation = [WilsonLocation]()
                    for (_, dict) : (String, JSON) in swiftyJsonVar {
                        let parking = WilsonLocation(dict: dict)
                        wilsonlocation.append(parking)
                    }
                    finished(wilsonlocation, nil)
                } else {
                    finished(nil, NSError.init(domain: "Sever Error", code: 44, userInfo: nil))
                }
            } else {
                finished(nil, response.result.error)
            }
        }
    }
    
    // Get Wilson Fees
    func getWilsonFee( finished: @escaping (_ wilsonfee:[WilsonFee]?, _ error: Error?) -> ()) {
        let wilsonfeeURL = SERVER_URL + "wilsonfee"
        NSLog(wilsonfeeURL)
        
        request(wilsonfeeURL, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let swiftyJsonVar = JSON(value)
                    var wilsonfee = [WilsonFee]()
                    for (_, dict) : (String, JSON) in swiftyJsonVar {
                        let record = WilsonFee(dict: dict)
                        wilsonfee.append(record)
                    }
                    finished(wilsonfee, nil)
                } else {
                    finished(nil, NSError.init(domain: "Sever Error", code: 44, userInfo: nil))
                }
            } else {
                finished(nil, response.result.error)
            }
        }
    }
    
    // Get On-Street Parking
    func getOnStreet(minLat: String, maxLat: String, minLon: String, maxLon: String, finished: @escaping (_ onstreetinfo:[OnStreetInfo]?, _ error: Error?) -> ()) {
        let onstreetinfoURL = SERVER_URL + "onstreetinfo?minLat=" + minLat + "&maxLat=" + maxLat + "&minLon=" + minLon + "&maxLon=" + maxLon
        NSLog(onstreetinfoURL)
        
        request(onstreetinfoURL, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let swiftyJsonVar = JSON(value)
                    var onstreetinfo = [OnStreetInfo]()
                    for (_, dict) : (String, JSON) in swiftyJsonVar {
                        let record = OnStreetInfo(dict: dict)
                        onstreetinfo.append(record)
                    }
                    finished(onstreetinfo, nil)
                } else {
                    finished(nil, NSError.init(domain: "Sever Error", code: 44, userInfo: nil))
                }
            } else {
                finished(nil, response.result.error)
            }
        }
    }
    
    
    
}
