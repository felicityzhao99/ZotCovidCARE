//
//  SearchViewController.swift
//  ZotCovidCare
//
//  Created by Felicity Zhao on 2/18/21.
//

import UIKit
import Foundation

struct MyNews {
    let title: String
    let link: String
}

var myIndex = 0
var news_links = [String]()

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var SearchTableView: UITableView!
    
    @Published var news_no_searching = [MyNews]()

    var config = ["darkmode" : 0, "notification" : 0]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news_no_searching.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let verticalPadding: CGFloat = 6
        let maskLayer = CALayer()
        
            maskLayer.backgroundColor = UIColor.black.cgColor
            maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
            cell.layer.mask = maskLayer
        
        cell.textLabel?.text = news_no_searching[indexPath.row].title
        news_links.append(news_no_searching[indexPath.row].link)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "showLinks", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        darkModeInitialization()
        FetchingInformationNoSearching()
        print(news_no_searching.count)
        
        SearchBar.layer.cornerRadius = 20.0
        SearchTableView.layer.cornerRadius = 15.0
        
    }
    
    //Search Part
    // News Title data without searching
    func FetchingInformationNoSearching() {
        guard let path = Bundle.main.path(forResource: "title_links", ofType: "json") else {return}
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            //print(json)
            guard let array = json as? [Any] else {return}
            for news in array {
                guard let newsDict = news as? [String: Any] else {return}
                guard let title = newsDict["title"] as? String else {return}
                guard let link = newsDict["link"] as? String else {return}
                let mynews = MyNews(title: title, link: link)
                news_no_searching.append(mynews)
            }
            
        } catch {
            print(error)
        }
    }
    
    // News Title Json data to front-end
    func FetchingInformation() {
        
        guard let path = Bundle.main.path(forResource: "inverted_index_words", ofType: "json") else {return}

        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            //print(json)
            
            guard let array = json as? [Any] else {return}
            for news in array {
                guard let newsDict = news as? [String: Any] else {return}
                guard let counts = newsDict["counts"] as? String else {return}
                guard let link = newsDict["link"] as? String else {return}
                guard let query = newsDict["query"] as? String else {return}
                guard let title = newsDict["title"] as? String else {return}
            }
            

        } catch {
            print(error)
        }
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

