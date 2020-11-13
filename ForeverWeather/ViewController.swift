//
//  ViewController.swift
//  ForeverWeather
//
//  Created by Ростислав Ермаченков on 13.11.2020.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=Moscow&appid=78f0d5436db9172dc2780f7e006b2bf0"
        let url = URL(string: urlString)!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                let dataString = String(data: data, encoding: .utf8)
                print(dataString!)
                
            }
        }
        
        task.resume()
    }


}

