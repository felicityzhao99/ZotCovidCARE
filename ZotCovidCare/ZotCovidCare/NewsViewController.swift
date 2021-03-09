//
//  NewsViewController.swift
//  ZotCovidCare
//
//  Created by Felicity Zhao on 3/8/21.
//

import UIKit
import WebKit

class NewsViewController: UIViewController {

    @IBOutlet weak var NewsWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var str_url = news_links[myIndex]
        guard let url = URL(string: str_url) else { return }
        let request = URLRequest(url: url)
        NewsWebView.load(request)
        
        // Do any additional setup after loading the view.
    }
    

}
