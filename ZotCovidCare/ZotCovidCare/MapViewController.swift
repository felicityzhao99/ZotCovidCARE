//
//  MapViewController.swift
//  ZotCovidCare
//
//  Created by Kaining Mao on 2021/2/5.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController,CLLocationManagerDelegate {
    @IBOutlet var mapView:MKMapView!
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
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
