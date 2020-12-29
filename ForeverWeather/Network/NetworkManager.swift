//
//  NetworkManager.swift
//  ForeverWeather
//
//  Created by Ростислав Ермаченков on 13.11.2020.
//

import Foundation
import CoreLocation
import RxSwift

class NetworkManager {
    
    enum RequestType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    
    func fetchCurrentWeather(forRequestType requestType: RequestType) -> Observable<CurrentWeatherData> {
        var urlString = ""
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        case .coordinate(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        }
        
        return Observable<CurrentWeatherData>.create { observer in
            let url = URL(string: urlString)
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
                        observer.onNext(currentWeatherData)
                        
                    } catch let error {
                        observer.onError(error)
                    }
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
