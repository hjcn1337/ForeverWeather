//
//  ViewController.swift
//  ForeverWeather
//
//  Created by Ростислав Ермаченков on 13.11.2020.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    
    let networkManager = NetworkManager()
    
    var weather: CurrentWeather!
    
    private var viewModel: CurrentWeatherViewModel!
    private let disposeBag = DisposeBag()
    
    /*lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()*/

    @IBAction func searchButtonPressed(_ sender: Any) {
        
        self.presentSearchAlertController(withTitle: "Введите название города", message: nil, style: .alert) { [unowned self] city in
            
            let cityObservable = Observable.just(city)
            cityObservable
                .bind(to: viewModel.searchText)
                .disposed(by: disposeBag)
            
            /*DispatchQueue.main.async {
                self.showLoadingAlert()
            }*/
            //self.networkManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
        }
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel = CurrentWeatherViewModel()
        addBindsToViewModel(viewModel)
        
        
        /*DispatchQueue.main.async {
            self.showLoadingAlert()
        }*/
        
        /*networkManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else  { return }
            self.updateInterface(weather: currentWeather)
            self.weather = currentWeather
        }*/
        
        /*if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }*/
        
    }
    
    private func addBindsToViewModel(_ viewModel: CurrentWeatherViewModel) {
        
        viewModel.city
            .bind(to: cityLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.temperature
            .bind(to: temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.feelsLikeTemperature
            .bind(to: feelsLikeTemperatureLabel.rx.text)
            .disposed(by: disposeBag)
    }

    /*func updateInterface(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.city
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
            
            self.dismiss(animated: false, completion: nil)
        }
        
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue" {
            let dvc = segue.destination as! MapViewController
            dvc.city = self.weather.city
        }
    }
    
    func showLoadingAlert() {
        
        let alert = UIAlertController(title: nil, message: "Загрузка...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
    }
}



/*extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}*/
