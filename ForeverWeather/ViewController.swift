//
//  ViewController.swift
//  ForeverWeather
//
//  Created by Ростислав Ермаченков on 13.11.2020.
//

import UIKit

class ViewController: UIViewController {
    
    let networkManager = NetworkManager()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        networkManager.fetchCurrentWeather(for: "Kaluga")
        
        
    }


}

