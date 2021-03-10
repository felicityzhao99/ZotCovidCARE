//
//  UCIMapController.swift
//  ZotCovidCare
//
//  Created by 茅铠宁 on 2021/3/4.
//

import UIKit
import MapKit
import CoreLocation

class UCIMapController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var UCIMap: MKMapView!
    var config = ["darkmode" : 0, "notification" : 0]
    let loc_manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        darkModeInitialization()

        UCIMap.showsUserLocation = true
        let anotation = MKPointAnnotation()
        anotation.coordinate = CLLocationCoordinate2D(latitude: 33.640455, longitude: -117.844285)
        UCIMap.addAnnotation(anotation)
        
        let region = MKCoordinateRegion(center: anotation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        UCIMap.setRegion(region, animated: true)
    
        // Do any additional setup after loading the view.
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
