//
//  ViewController.swift
//  ForeverWeather
//
//  Created by Ростислав Ермаченков on 13.11.2020.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    
    let networkManager = NetworkManager()

    @IBAction func searchButtonPressed(_ sender: Any) {
        
        self.presentSearchAlertController(withTitle: "Введите название города", message: nil, style: .alert) { city in
            self.networkManager.fetchCurrentWeather(for: city)
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        networkManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else  { return }
            self.updateInterface(weather: currentWeather)
        }
        self.networkManager.fetchCurrentWeather(for: "Kaluga")
        
    }

    func updateInterface(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.city
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
        }
        
    }
}

