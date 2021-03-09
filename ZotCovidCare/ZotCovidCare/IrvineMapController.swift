//
//  IrvineMapController.swift
//  ZotCovidCare
//
//  Created by 茅铠宁 on 2021/3/4.
//

import UIKit
import MapKit
import CoreLocation

class IrvineMapController: UIViewController,CLLocationManagerDelegate {
    @IBOutlet weak var IrvineMap: MKMapView!
    let loc_manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loc_manager.desiredAccuracy = kCLLocationAccuracyBest
        loc_manager.delegate = self
        loc_manager.requestWhenInUseAuthorization()
        loc_manager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            loc_manager.stopUpdatingLocation()
            
            render(location)
        }
    }
    func render(_ location:CLLocation){
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1,
                                    longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        IrvineMap.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        IrvineMap.addAnnotation(pin)
    }

    /*
    // MARK: - Navigati
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
