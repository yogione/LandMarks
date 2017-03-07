//
//  ViewController.swift
//  LandMarks
//
//  Created by Srini Motheram on 3/5/17.
//  Copyright © 2017 Srini Motheram. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet var landMarksMap :MKMapView!
    
    var landMarksArray = [LandMarkItem]()
    
    var locationMgr = CLLocationManager()
    
    func zoomToPins(){
        landMarksMap.showAnnotations(landMarksMap.annotations, animated: true)
    }
    
    func zoomToLocation(lat: Double, lon: Double, radius: Double){
        if lat == 0 && lon == 0 {
            print("invalid data")
            
        } else {
            let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let viewRegion = MKCoordinateRegionMakeWithDistance(coord, radius, radius)
            let adjustedRegion = landMarksMap.regionThatFits(viewRegion)
            landMarksMap.setRegion(adjustedRegion, animated: true)
            
        }
        landMarksMap.showAnnotations(landMarksMap.annotations, animated: true)
    }
    
    func annotateMapLocations(){
        
        var pinsToRemove = [MKPointAnnotation]()
        for annotation in landMarksMap.annotations{
            if annotation is MKPointAnnotation {
                pinsToRemove.append(annotation as! MKPointAnnotation)
            }
            
        }
        landMarksMap.removeAnnotations(pinsToRemove)
        
        for  lm in landMarksArray {
        let pa1 = MKPointAnnotation()
        pa1.coordinate = CLLocationCoordinate2D(latitude: lm.lat, longitude: lm.long)
        pa1.title = lm.landMarkItemName + " " + lm.city
        pa1.subtitle = lm.state + " " + lm.zipCode + " " + lm.desc
        
        
        landMarksMap.addAnnotations([pa1])
        }
        // zoomToPins()
    }
    
    func fillLandMarksArray() -> Void{
        
        let landMark1 = LandMarkItem(landMarkItemName: "test", streetAddress: "test", city: "Detroit", state: "MI", zipCode: "48187", lat: 42, long: -83, desc: "landmark1")
        
        let landMark2 = LandMarkItem(landMarkItemName: "test2", streetAddress: "test2", city: "Detroit", state: "MI", zipCode: "48187", lat: 42.123, long: -83.123, desc: "landmark2")
        
         let landMark3 = LandMarkItem(landMarkItemName: "test3", streetAddress: "test3", city: "Detroit", state: "MI", zipCode: "48187", lat: 42.234, long: -83.234, desc: "landmark3")
        landMarksArray.append(contentsOf: [landMark1, landMark2, landMark3])
        
        //return [landMark1,landMark2, landMark3]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillLandMarksArray()
        annotateMapLocations()
        setupLocationMonitoring()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLoc = locations.last!
        print("Last loc: \(lastLoc.coordinate.latitude), \(lastLoc.coordinate.longitude)")
        zoomToLocation(lat: lastLoc.coordinate.latitude, lon: lastLoc.coordinate.longitude, radius: 500)
        manager.stopUpdatingLocation()
    }
    
    //MARK - LOCATION AUTHORISING METHODS
    
    func turnOnLocationMonitoring(){
        locationMgr.startUpdatingLocation()
        landMarksMap.showsUserLocation = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        setupLocationMonitoring()
    }
    
    func setupLocationMonitoring(){
        locationMgr.delegate = self
        locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                turnOnLocationMonitoring()
            case .denied, .restricted:
                print("hey turn us back on in settings")
            case .notDetermined:
                if locationMgr.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)){
                    locationMgr.requestAlwaysAuthorization()
                }
                
            }
        } else {
            print("hey turn on location on settings please")
        }
    }
}

