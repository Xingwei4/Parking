//
//  RealTimeParkingController.swift
//  Parking
//
//  Created by 卫星 on 2018/8/21.
//  Copyright © 2018年 Unimelb. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SnapKit
import SwiftyJSON

class RTParkingViewController: UIViewController, UIWebViewDelegate{
    
    // Bay Related Variables
    var nearBayList: [String]?
    var bayInfoList: [BayInfo]?
    var parkingStatusList:[ParkingStatus]?
    
    // Button Related Variables
    var switchSignal: Bool = false
    
    // Google Map View
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    // Location Related Variables
    var currentLocation: CLLocation?
    var locationManager = CLLocationManager()
    // Default Location
    let defaultLocation = CLLocation(latitude: -37.799084, longitude: 144.962975)
    
    // UI element initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show success.
        print("Navigation Successful")
        
        // UI Settings (Background, Back Button)
        view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back Button"), style: .done, target: self, action: #selector(RTParkingViewController.back))
        navigationItem.title = "Real Time Parking Status"
        
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        //locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        // Create a GMSCameraPosition that tells the map to display the default location with zoom level.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        
        // View Settings
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //mapView.isMyLocationEnabled = true
        //mapView.isIndoorEnabled = false
        //mapView.delegate = self
        //mapView.settings.myLocationButton = false
        
        // Add the map to the view, hide it until got a location update.
        view.addSubview(mapView)
        view.addSubview(refreshButton)
        view.addSubview(segControl)
        
        // Position etting of Refresh button
        refreshButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width : 100, height: 40))
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-30)
            
        }
        
        // Position Setting of Switch button
        segControl.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(80)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Refresh button Creating
    private lazy var refreshButton : UIButton = {
        let button:UIButton = UIButton()
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(UIColor(red: 44/255, green: 124/255, blue: 246/255, alpha: 1) , for: .normal)
        //button.setBackgroundImage(UIImage(named:"Button.png"), for: UIControlState.normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 44/255, green: 124/255, blue: 246/255, alpha: 1).cgColor
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        //button.coloor
        button.addTarget(self,action:#selector(RTParkingViewController.refreshButtonClicked),for:.touchUpInside)
        
        return button
    }()
    
    // Segemented Button
    private lazy var segControl : UISegmentedControl = {
        var segArray:[String] = ["On-Street", "Off-Street"]
        let segControl:UISegmentedControl = UISegmentedControl(items: segArray)
        segControl.selectedSegmentIndex = 0
        segControl.backgroundColor = UIColor.white
        segControl.setWidth(160, forSegmentAt: 0)
        segControl.setWidth(160, forSegmentAt: 1)
        segControl.addTarget(self, action:#selector(RTParkingViewController.segmentChange), for: UIControlEvents.valueChanged)
        return segControl
    }()
    
    @objc func segmentChange(sender: AnyObject?){
        let segControl:UISegmentedControl = sender as! UISegmentedControl
        switch segControl.selectedSegmentIndex {
        case 0 :
            refreshButton.isHidden = false;
            print ("000 ")
            break;
        case 1 :
            refreshButton.isHidden = true;
            self.mapView.clear()
            print ("11111 ")
            break;
        default:
            print ("default ")
        
        }
            
    }
    
    
    
    // Back to previous page (Back Button)
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Refresh function (Refresh Button)
    @objc func refreshButtonClicked() {
        showBaysOnMap()
       
    }
    
    // Show Off-Street Parking Space
    @objc func switchDidChange() {
        changeSignal()
        print(switchSignal)
        
        if switchSignal == false{
            self.mapView.clear()
        }
    }
    
    
    // Show Bays On Map
    func showBaysOnMap(){
        // Get Bay Info
        NetworkTool.sharedTools.getBayInfo { (bayInfo, error) in
            if error == nil {
                self.bayInfoList = bayInfo
                print("BayInfo get successfully.")
                // Get Parking Status
                self.getParkingStatus()
            }
            else{
                self.view.showTextHud(content: "Network Error.")
            }
        }
    }
    
    // Get Parking Status
    func getParkingStatus(){
        self.view.showHudInView(view: view)        
        NetworkTool.sharedTools.getParkingStatus { (parkingStatus, error) in
            self.view.hideHud()
            if error == nil {
                self.parkingStatusList = parkingStatus
                print("ParkingStatus get successfully.")
                // Show Markers
                self.showMarkersOnMap()
            }
            else{
                self.view.showTextHud(content: "Network Error.")
            }
        }
    }
    
    // Print Markers
    func showMarkersOnMap() {
        // Clear all Previous Marker
        self.mapView.clear()
        
        let blueMarker = UIImageView(image: UIImage(named: "Blue P.png"))
        let redMarker = UIImageView(image: UIImage(named: "Red P.png"))
        
        for bay in self.bayInfoList! {
            let parkCoordinate = CLLocationCoordinate2D(latitude: bay.lat, longitude: bay.lon)
            let id = bay.bay_id
            var status: String?
            
            for record in self.parkingStatusList! {
                if id == record.bay_id{
                    status = record.status
                    break
                }
            }
            
            
            if self.mapView.projection.contains(parkCoordinate) {
                let marker = GMSMarker()
                if status!.isEqual("Unoccupied") {
                    marker.iconView = blueMarker
                }
                else {
                    marker.iconView = redMarker
                }
                marker.position = parkCoordinate
                marker.title = bay.st_marker_id
                marker.map = self.mapView
            }
        }
    }
    
    
    
    
    func changeSignal(){
        if switchSignal == false {
            switchSignal = true
        }else {
            switchSignal = false
        }
        
    }
    
    
    
    
    
    
}
