//
//  NetworkManager.swift
//  ForeverWeather
//
//  Created by Ростислав Ермаченков on 13.11.2020.
//

import Foundation

class NetworkManager {
    
    func fetchCurrentWeather(for city: String) {
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
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
