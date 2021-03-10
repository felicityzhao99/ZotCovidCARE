//
//  IrvineMapController.swift
//  ZotCovidCare
//
//  Created by Kylin on 2021/3/4.
//

import UIKit
import MapKit
import CoreLocation

class IrvineMapController: UIViewController,CLLocationManagerDelegate {
    @IBOutlet weak var IrvineMap: MKMapView!
    var config = ["darkmode" : 0, "notification" : 0]
    
    let locationManger = CLLocationManager()
    let regionMeters:Double = 10000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        darkModeInitialization()
        checkLocationServices()
        IrvineMap.showsUserLocation  = true
//        centerViewOnUserLocation()
        locationManger.startUpdatingLocation()
        addTestingLocation()
        

        // Do any additional setup after loading the view.
    }
    
    
    func addTestingLocation(){

        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "covid testing"
        request.region = IrvineMap.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            let mapItems = response.mapItems
            for mapItem in mapItems{
                let myLatitude = mapItem.placemark.location!.coordinate.latitude
                let myLongitude = mapItem.placemark.location!.coordinate.longitude
                let building_name = mapItem.name
                let building_phone = mapItem.phoneNumber
                
                
                let annotation = MKPointAnnotation()
                annotation.title = building_name
                annotation.subtitle = building_phone
                
                
                annotation.coordinate = CLLocationCoordinate2D(latitude: myLatitude, longitude: myLongitude)
                self.IrvineMap.addAnnotation(annotation)
            }
        }
        
    }
    
    
    
    
    func darkModeInitialization()
        {
            guard let path = Bundle.main.path(forResource: "config", ofType: "json") else {return}

            let url = URL(fileURLWithPath: path)
            
            do {
                
                let data = try Data(contentsOf: url)
                let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                if let dictFromJSON = jsonData as? [String : Int]{
                    config["darkmode"] = dictFromJSON["darkmode"]
                    config["notification"] = dictFromJSON["notification"]
                } else {
                    print("json convert fail\n")
                }
                if config["darkmode"] == 1{
                    setBlack()
                }else{
                    setWhite()
                }
                return
            } catch {}
        }
        
        func setBlack()
        {
            if #available(iOS 13.0, *) {
                self.overrideUserInterfaceStyle = .dark
            }
        }
        
        func setWhite()
        {
            if #available(iOS 13.0, *) {
                self.overrideUserInterfaceStyle = .light
            }
        }
    
    func setupLocationManager(){
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManger.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
            IrvineMap.setRegion(region, animated: true)
            
        }
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
        }else{
            //Show alert
        }
    }

}

    
extension IrvineMapController{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{return}
        let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
        IrvineMap.setRegion(region, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //back here
    }
    
}
