//
//  ViewController.swift
//  ZotCovidCare
//
//  Created by Susie Liu on 1/28/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapButton(){
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        vc.view.textInputMode
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

