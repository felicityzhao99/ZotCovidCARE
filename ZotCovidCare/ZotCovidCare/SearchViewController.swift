//
//  SearchViewController.swift
//  ZotCovidCare
//
//  Created by Felicity Zhao on 2/18/21.
//

import UIKit
import Foundation

//title_link.json
struct MyNews {
    let title: String
    let link: String
}

//inverted_index_words.json
struct MyNews2 {
    let counts: Int
    let query: String
    let title: String
    let link: String
}

var myIndex = 0
var news_links_no_searching = [String]()
var news_links_searching = [String]()
var searching = false
var firstTime = true


class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var SearchTableView: UITableView!
    
    @Published var news_no_searching = [MyNews]()
    @Published var news_searching = [MyNews2]()
    
    var news_by_query = [MyNews2]()
    var config = ["darkmode" : 0, "notification" : 0]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {return news_by_query.count}
        if searching == false && firstTime {return news_no_searching.count}
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let verticalPadding: CGFloat = 6
        let maskLayer = CALayer()
        
            maskLayer.backgroundColor = UIColor.black.cgColor
            maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
            cell.layer.mask = maskLayer
        
        if searching {
            cell.textLabel?.text = news_by_query[indexPath.row].title
            news_links_searching.append(news_by_query[indexPath.row].link)
        }
        if searching == false && firstTime {
            cell.textLabel?.text = news_no_searching[indexPath.row].title
            news_links_no_searching.append(news_no_searching[indexPath.row].link)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "showLinks", sender: self)
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchTextOne \(searchText)")
        searching = false
        firstTime = false
        news_by_query.removeAll()
        SearchTableView.reloadData()
            
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searching {
            news_by_query.removeAll()
            searching = false
        }
        print("searchTextTwo \(searchBar.text)")
        
        for news in news_searching {
            
            if news.query.lowercased() == searchBar.text?.lowercased() {
                news_by_query.append(news)
                searching = true
            }
        }
        print(news_by_query)
        news_links_searching.removeAll()
        SearchTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        darkModeInitialization()
        FetchingInformationNoSearching()
        print("News No Searching Counts: \(news_no_searching.count)")
        FetchingInformation()
        print("News Searching Counts: \(news_searching.count)")
        SearchBar.delegate = self
        
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
            
            guard let array2 = json as? [Any] else {return}
            for news2 in array2 {
                guard let newsDict2 = news2 as? [String: Any] else {return}
                guard let counts2 = newsDict2["counts"] as? Int else {return}
                guard let link2 = newsDict2["link"] as? String else {return}
                guard let query2 = newsDict2["query"] as? String else {return}
                guard let title2 = newsDict2["title"] as? String else {return}
                let mynews2 = MyNews2(counts: counts2, query: query2, title: title2, link: link2)
                news_searching.append(mynews2)
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

