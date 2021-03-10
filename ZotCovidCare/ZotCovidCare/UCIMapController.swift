//
//  UCIMapController.swift
//  ZotCovidCare
//
//  Created by Kylin on 2021/3/4.
//

import UIKit
import MapKit
import CoreLocation

struct DashboardLocation {
    let building: String
    let dates: String
}

class UCIMapController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var UCIMap: MKMapView!
    var config = ["darkmode" : 0, "notification" : 0]
    let loc_manager = CLLocationManager()
    
    var allBuildings = [DashboardLocation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        darkModeInitialization()

        UCIMap.showsUserLocation = true
        let anotation = MKPointAnnotation()
        anotation.coordinate = CLLocationCoordinate2D(latitude: 33.646016154709855, longitude: -117.84271241543259)
//        UCIMap.addAnnotation(anotation)
        
        
        let region = MKCoordinateRegion(center: anotation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        UCIMap.setRegion(region, animated: true)
        
        readDashboard()
        addDashboardLocation()
    
        // Do any additional setup after loading the view.
    }
    
    
    
    func readDashboard(){
        guard let path = Bundle.main.path(forResource: "dash_json", ofType: "json") else {return}
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            print(json)
            guard let array = json as? [Any] else {return}
            for b in array {
                guard let buildingDict = b as? [String: Any] else {return}
                guard let building = buildingDict["building"] as? String else {return}
                guard let dates = buildingDict["dates"] as? String else {return}
                let myBuilding = DashboardLocation(building:building, dates:dates)
                allBuildings.append(myBuilding)
            }
        } catch {
            print(error)
        }
    }
    
    
    func addDashboardLocation(){
        for b in allBuildings{
            print(b.building)
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = b.building
            request.region = UCIMap.region
            let search = MKLocalSearch(request: request)
            search.start { response, _ in
                guard let response = response else {
                    return
                }
                var mapItems = response.mapItems
                for mapItem in mapItems{
                    var myLatitude = mapItem.placemark.location!.coordinate.latitude
                    var myLongitude = mapItem.placemark.location!.coordinate.longitude
                    print(myLatitude,myLongitude)
                    let annotation = MKPointAnnotation()
                    annotation.title = b.building
                    annotation.coordinate = CLLocationCoordinate2D(latitude: myLatitude, longitude: myLongitude)
                    self.UCIMap.addAnnotation(annotation)
                }
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

}
