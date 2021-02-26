//
//  ViewController.swift
//  ZotCovidCare
//
//  Created by Susie Liu on 1/28/21.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func didTapButton(){
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        
        navigationController?.pushViewController(vc, animated: true)
    }
    

}

