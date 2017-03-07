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
        pa1.subtitle = lm.streetAddress + " " + lm.state + " " + lm.zipCode + " " + lm.desc
        
        
        landMarksMap.addAnnotations([pa1])
        }
        // zoomToPins()
    }
    
    func fillLandMarksArray() -> Void{
        
        let landMark1 = LandMarkItem(landMarkItemName: "WSU", streetAddress: "west warren ave", city: "Detroit", state: "MI", zipCode: "48202", lat: 42.3520112, long: -83.0854075, desc: "Wayne State University")
        
        let landMark2 = LandMarkItem(landMarkItemName: "Fox Theater", streetAddress: "2211 woodward ave", city: "Detroit", state: "MI", zipCode: "48201", lat: 42.3383693, long: -83.0550822, desc: "Fox Theater")
        
         let landMark3 = LandMarkItem(landMarkItemName: "Cobo Center", streetAddress: "1 washington blvd", city: "Detroit", state: "MI", zipCode: "48226", lat: 42.3266199, long: -83.0521407, desc: "Cobo Center")
        let landMark4 = LandMarkItem(landMarkItemName: "Joe Louis", streetAddress: "19 Steve Yzerman Dr", city: "Detroit", state: "MI", zipCode: "48226", lat: 42.3252134, long: -83.0535564, desc: "Joe Louis")
        let landMark5 = LandMarkItem(landMarkItemName: "Detroit Institute of Arts", streetAddress: "5200 woodward ave", city: "Detroit", state: "MI", zipCode: "48202", lat: 42.3594199, long: -83.0667651, desc: "Detroit Institute of Arts")
        
        let landMark6 = LandMarkItem(landMarkItemName: "Detroit Public Library", streetAddress: "5100 woodward ave", city: "Detroit", state: "MI", zipCode: "48202", lat: 42.3585883, long: -83.0689554, desc: "Detroit Institute of Arts")
        
        let landMark7 = LandMarkItem(landMarkItemName: "ISKCON", streetAddress: "383 Lenox", city: "Detroit", state: "MI", zipCode: "48215", lat: 42.3614399, long: -82.9483467, desc: "ISKCON")
        
         let landMark8 = LandMarkItem(landMarkItemName: "Eastern Market", streetAddress: "2900 Riopelle Street", city: "Detroit", state: "MI", zipCode: "48207", lat: 42.3495025, long: -83.0494247, desc: "Eastern Market")
        
        let landMark9 = LandMarkItem(landMarkItemName: "GM Ren Cen", streetAddress: "100 Renaissance Center", city: "Detroit", state: "MI", zipCode: "48243", lat: 42.3293284, long: -83.0397632, desc: "GM Ren Cen")
        
        let landMark10 = LandMarkItem(landMarkItemName: "Comerica Park", streetAddress: "2100 Woodward ave", city: "Detroit", state: "MI", zipCode: "48201", lat: 42.3371069, long: -83.0522998, desc: "Comerica Park")
        landMarksArray.append(contentsOf: [landMark1, landMark2, landMark3, landMark4, landMark5, landMark6, landMark7, landMark8, landMark9, landMark10])
        
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

