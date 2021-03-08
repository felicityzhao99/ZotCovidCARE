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
    //dict which records config.json whether to determine whether darkmode is on/off
    var config = ["darkmode" : 0, "notification" : 0]
    
    @IBOutlet weak var mapLabel: UILabel!
    @IBOutlet var mapView:MKMapView!
    let loc_manager = CLLocationManager()

    override func viewDidLoad() {
        darkModeInitialization()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //For reading config json whether to determine whether darkmode is on/off
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
        view.backgroundColor = UIColor.darkGray
        //mapLabel.textColor = UIColor.white
    }
    
    func setWhite()
    {
        view.backgroundColor = UIColor(red:0.78834066585618623, green:1, blue:1, alpha: 0.90000000000000002)
        //mapLabel.textColor = UIColor.black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        darkModeInitialization()
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
