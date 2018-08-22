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

class RTParkingViewController: UIViewController, GMSMapViewDelegate{
    
    // Bay Related Variables
    var nearBayList: [String]?
    var bayInfoList: [BayInfo]?
    var parkingStatusList: [ParkingStatus]?
    var wilsonLocationList: [WilsonLocation]?
    var wilsonFeeList: [WilsonFee]?
    var bayFeeList: [BayFee]?
    
    // Button Related Variables
    var onStreetMode: Bool = true
    
    // Google Map View
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 17.0
    
    // Location Related Variables
    var currentLocation: CLLocation?
    var locationManager = CLLocationManager()
    
    // Default Location
    let defaultLocation = CLLocation(latitude: -37.799084, longitude: 144.962975)
    
    // UI Element Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show Success.
        print("Navigation Successful")
        
        // UI Settings (Background, Back Button)
        view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back Button"), style: .done, target: self, action: #selector(RTParkingViewController.back))
        navigationItem.title = "Real Time Parking Status"
        
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        placesClient = GMSPlacesClient.shared()
        
        // Create a GMSCameraPosition that tells the map to display the default location with zoom level.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        
        // Map View Settings
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.settings.zoomGestures = true
        mapView.settings.scrollGestures = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.isIndoorEnabled = false
        mapView.delegate = self
        mapView.isHidden = true
        
        // Add the map to the view, hide it until got a location update.
        view.addSubview(mapView)
        view.addSubview(searchButton)
        view.addSubview(refreshButton)
        view.addSubview(segControl)
        
        // Position Setting of Search button
        searchButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width : 100, height: 40))
            make.right.equalTo(refreshButton.snp.left).offset(-20)
            make.bottom.equalTo(view).offset(-20)
        }
        
        // Position Setting of Refresh button
        refreshButton.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width : 100, height: 40))
            make.centerX.equalTo(view).offset(60)
            make.bottom.equalTo(view).offset(-20)
        }
        
        // Position Setting of Segment Control
        segControl.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(80)
        }
        
        showBaysOnMap()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Create Search Button
    private lazy var searchButton : UIButton = {
        let button:UIButton = UIButton()
        button.setTitle("Search", for: .normal)
        button.setTitleColor(UIColor(red: 44/255, green: 124/255, blue: 246/255, alpha: 1), for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 44/255, green: 124/255, blue: 246/255, alpha: 1).cgColor
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self,action:#selector(RTParkingViewController.searchButtonClicked),for:.touchUpInside)
        
        return button
    }()
    
    // Create Refresh Button
    private lazy var refreshButton : UIButton = {
        let button:UIButton = UIButton()
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(UIColor(red: 44/255, green: 124/255, blue: 246/255, alpha: 1), for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 44/255, green: 124/255, blue: 246/255, alpha: 1).cgColor
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self,action:#selector(RTParkingViewController.refreshButtonClicked),for:.touchUpInside)
        
        return button
    }()
    
    // Create Segemented Button
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
    
    // Back to previous page (Back Button)
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @objc func searchButtonClicked() {
        let SearchController = GMSAutocompleteViewController()
        SearchController.delegate = self
        present(SearchController, animated: true, completion: nil)
    }
    
    // Mode change function (Segment Control)
    @objc func segmentChange(sender: AnyObject?){
        let segControl:UISegmentedControl = sender as! UISegmentedControl
        switch segControl.selectedSegmentIndex {
        case 0 :
            self.mapView.clear()
            onStreetMode = true
            showBaysOnMap()
            print ("On-Street Mode")
            break;
        case 1 :
            self.mapView.clear()
            onStreetMode = false
            showWilsonOnMap()
            print ("Off-Street Mode")
            break;
        default:
            print ("Whatever.")
            
        }
        
    }
    
    // Refresh function (Refresh Button)
    @objc func refreshButtonClicked() {
        if onStreetMode == true {
            showBaysOnMap()
        }else if onStreetMode == false {
            showWilsonOnMap()
        }
        
    }
    
    // Show Wilson On Map
    func showWilsonOnMap(){
        self.view.showHudInView(view: view)
        NetworkTool.sharedTools.getWilsonLocation { (wilsonLocation, error) in
            self.view.hideHud()
            if error == nil {
                self.wilsonLocationList = wilsonLocation
                print("WilsonLocation get successfully.")
                // Show Wilson Markers
                self.getWilsonFee()
            }
            else{
                self.view.showTextHud(content: "Network Error.")
            }
        }
    }
    
    // Get Wilson Fee
    func getWilsonFee(){
        NetworkTool.sharedTools.getWilsonFee { (wilsonFee, error) in
            if error == nil {
                self.wilsonFeeList = wilsonFee
                print("WilsonFee get successfully.")
                // Show Wilson Markers
                self.showWilsonMarkers()
            }
            else{
                self.view.showTextHud(content: "Network Error.")
            }
        }
    }
    
    // Print Wilson Markers
    func showWilsonMarkers() {
        // Clear all Previous Marker
        self.mapView.clear()
    
        let wilsonMarker = UIImageView(image: UIImage(named: "Parking.png"))
        
        for wilson in self.wilsonLocationList! {
            let parkCoordinate = CLLocationCoordinate2D(latitude: wilson.lat, longitude: wilson.lon)
            var feeString: String = ""
            
            for record in self.wilsonFeeList! {
                if wilson.id == record.place_id {
                    feeString = feeString + record.scope! + "  " + record.rate! + "\n"
                }
    
            }
            
            if self.mapView.projection.contains(parkCoordinate) {
                let marker = GMSMarker()
                
                marker.iconView = wilsonMarker
                marker.position = parkCoordinate
                marker.title = wilson.place
                marker.map = self.mapView
                marker.snippet = feeString
                
            }
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
            //self.view.hideHud()
            if error == nil {
                self.parkingStatusList = parkingStatus
                print("ParkingStatus get successfully.")
                // Show Markers
                self.getBayFee()
            }
            else{
                self.view.showTextHud(content: "Network Error.")
            }
        }
    }
    
    // Get Bay fee
    func getBayFee(){
        NetworkTool.sharedTools.getBayFee { ( bayFee, error) in
            if error == nil {
                self.bayFeeList = bayFee
                print("BayFee get successfully.")
                self.view.hideHud()
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
        
        // Get Marker Images
        let blueMarker = UIImageView(image: UIImage(named: "Blue P.png"))
        let redMarker = UIImageView(image: UIImage(named: "Red P.png"))
        
        for bay in self.bayInfoList! {
            let parkCoordinate = CLLocationCoordinate2D(latitude: bay.lat, longitude: bay.lon)
            let id = bay.bay_id
            var status: String?
            
            for record in self.parkingStatusList! {
                if id == record.bay_id {
                    status = record.status
                    break
                }
            }
            
            var feeString: String = ""
            
            for record in self.bayFeeList! {
                if id == record.bay_id {
                    feeString = feeString + record.desc1! + "\n"
                    if !record.desc2!.isEqual(""){
                        feeString = feeString + record.desc2! + "\n"
                    }
                    if !record.desc3!.isEqual(""){
                        feeString = feeString + record.desc3! + "\n"
                    }
                }
            }
            
            
            if self.mapView.projection.contains(parkCoordinate) {
                let marker = GMSMarker()
                if status != nil{
                    if status!.isEqual("Unoccupied") {
                        marker.iconView = blueMarker
                    }
                    else {
                        marker.iconView = redMarker
                    }
                }else{
                    marker.iconView = redMarker
                }
                
                marker.position = parkCoordinate
                marker.title = bay.st_marker_id
                marker.map = self.mapView
                marker.snippet = feeString
            }
        }
    }
    
}

// Delegates to handle events for the location manager.
extension RTParkingViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        self.currentLocation = location
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
            mapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension RTParkingViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle User's Selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.dismiss(animated: false, completion: nil)
        DispatchQueue.main.async(execute: {
            self.mapView.animate(toLocation:place.coordinate)
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            if self.onStreetMode == true {
                self.showBaysOnMap()
            }else if self.onStreetMode == false {
                self.showWilsonOnMap()
            }
        }
    }
    
    // Handel Errors
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // Handle Cancelation
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
}


