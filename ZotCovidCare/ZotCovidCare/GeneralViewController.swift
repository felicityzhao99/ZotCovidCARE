//
//  GeneralViewController.swift
//  ZotCovidCare
//
//  Created by Qian Zhao on 2/3/21.
//

import UIKit


class GeneralViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapButton(){
        let vc = UIViewController()
        vc.view.backgroundColor = .yellow
        
        navigationController?.pushViewController(vc, animated: true)
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
