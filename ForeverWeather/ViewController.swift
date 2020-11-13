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
        
        networkManager.onCompletion = { [weak self] currentWeather in
            print(currentWeather.temperatureString)
            print(currentWeather.city)
        }
        self.networkManager.fetchCurrentWeather(for: "Kaluga")
        
        
    }


}

