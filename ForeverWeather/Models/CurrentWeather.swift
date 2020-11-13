//
//  CurrentWeather.swift
//  ForeverWeather
//
//  Created by Ростислав Ермаченков on 13.11.2020.
//

import Foundation

struct CurrentWeather {
    let city: String
    
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    let feelsLikeTemperature: Double
    var feelsLikeTemperatureString: String {
        return String(format: "%.0f", feelsLikeTemperature)
    }
    
    let conditionCode: Int
    
    init?(currentWeatherData: CurrentWeatherData) {
        city = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feelsLike
        conditionCode = currentWeatherData.weather.first!.id
    }
}
