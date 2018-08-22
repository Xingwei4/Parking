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
    
    // Get Bay Info data from server
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
    
    // Get Parking Status from server
    func getParkingStatus( finished: @escaping (_ parkingstatus:[ParkingStatus]?, _ error: Error?) -> ()) {
        let parkingstatusURL = SERVER_URL + "parkingstatus"
        NSLog(parkingstatusURL)
        
        request(parkingstatusURL, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let swiftyJsonVar = JSON(value)
                    var parkingstatus = [ParkingStatus]()
                    for (_, dict) : (String, JSON) in swiftyJsonVar {
                        let record = ParkingStatus(dict: dict)
                        parkingstatus.append(record)
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
    
    // Get Bay Fees
    func getBayFee( finished: @escaping (_ bayfee:[BayFee]?, _ error: Error?) -> ()) {
        let bayfeeURL = SERVER_URL + "bayfee"
        NSLog(bayfeeURL)
        
        request(bayfeeURL, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let swiftyJsonVar = JSON(value)
                    var bayfee = [BayFee]()
                    for (_, dict) : (String, JSON) in swiftyJsonVar {
                        let record = BayFee(dict: dict)
                        bayfee.append(record)
                    }
                    finished(bayfee, nil)
                } else {
                    finished(nil, NSError.init(domain: "Sever Error", code: 44, userInfo: nil))
                }
            } else {
                finished(nil, response.result.error)
            }
        }
    }
    
    
    
}
