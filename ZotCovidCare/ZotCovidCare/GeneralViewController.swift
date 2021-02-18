//
//  GeneralViewController.swift
//  ZotCovidCare
//
//  Created by Felicity Zhao on 2/18/21.
//

import UIKit

class GeneralViewController: UIViewController {
    
    @IBOutlet weak var NewsOneButton: UIButton!
    @IBOutlet weak var NewsTwoButton: UIButton!
    
    @IBOutlet weak var NewsOneLabel: UILabel!
    @IBOutlet weak var NewsTwoLabel: UILabel!
    
    @IBOutlet weak var ViewMoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // [Latest News Part]
        
        //Round corners
        NewsOneButton.layer.cornerRadius = 20.0
        NewsTwoButton.layer.cornerRadius = 20.0
        
        NewsOneLabel.layer.cornerRadius = 10.0
        NewsTwoLabel.layer.cornerRadius = 10.0
        
        //Set the label text
        NewsOneLabel.text = "COVID-19 Vaccines @UCI"
        NewsTwoLabel.text = "Understanding a Virus"
        
        //View More Button to Search Page
        ViewMoreButton.addTarget(self, action: #selector(tapOnViewMoreButton), for: .touchUpInside)
    }
    
    
    @IBAction func NewsOneButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.ucihealth.org/covid-19")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func NewsTwoButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.ucihealth.org/blog/2020/11/understanding-covid19")! as URL, options: [:], completionHandler: nil)
    }
    //Without Navigation Method
    @objc func tapOnViewMoreButton() {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    //With Navigation Method
//    @objc func tapOnViewMoreButton() {
//        let story = UIStoryboard(name: "Main", bundle: nil)
//        let controller = story.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
//        let navigation = UINavigationController(rootViewController: controller)
//        self.view.addSubview(navigation.view)
//        self.addChild(navigation)
//        navigation.didMove(toParent: self)
//    }
    

}
