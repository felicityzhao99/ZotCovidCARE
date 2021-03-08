//
//  SearchViewController.swift
//  ZotCovidCare
//
//  Created by Felicity Zhao on 2/18/21.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var SearchBar: UISearchBar!
    
    var config = ["darkmode" : 0, "notification" : 0]
    override func viewDidLoad() {
        super.viewDidLoad()
        darkModeInitialization()

        SearchBar.layer.cornerRadius = 20.0
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
        
    }
    func setWhite()
    {
        view.backgroundColor = UIColor(red:0.5, green:0.71397772293849049, blue:0.75263522360999191, alpha:1.0)
        
    }
    
    //Keep checking Dark mode status even if this page doesn't receive any user actions.
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        darkModeInitialization()
    }
    


}
