//
//  CurrentWeatherViewModel.swift
//  ForeverWeather
//
//  Created by Ростислав Ермаченков on 27.12.2020.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

final class CurrentWeatherViewModel: NSObject {
    
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    private let networkManager = NetworkManager()
    private let disposeBag = DisposeBag()
    
    private var longitude: CLLocationDegrees!
    private var latitude: CLLocationDegrees!
    
    private var weather: Observable<CurrentWeatherData> = Observable.empty()
    
    var city: Observable<String> = Observable.empty()
    
    var temperature: Observable<String> = Observable.empty()
    
    var feelsLikeTemperature: Observable<String> = Observable.empty()
    
    var weatherIcon: Observable<UIImage> = Observable.empty()
    
    var searchText = BehaviorRelay<String>(value: "")
    
    override init() {
        super.init()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        
        weather = searchText.asObservable()
            .flatMapLatest { [unowned self] searchString -> Observable<CurrentWeatherData> in
                
                guard !searchString.isEmpty else {
                    //return Observable.empty()
                    return self.networkManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: self.latitude, longitude: self.longitude))
                }
                
                return self.networkManager.fetchCurrentWeather(forRequestType: .cityName(city: searchString))
            }
            .share()
        
        city = weather
            .map { $0.name }
        
        temperature = weather
            .map { String(format: "%.0f", $0.main.temp) + " °C" }
        
        feelsLikeTemperature = weather
            .map { String(format: "%.0f", $0.main.feelsLike) + " °C" }
        
        
        weatherIcon = weather
            .map {
                switch $0.weather.first!.id {
                case 200...232:
                    return UIImage(systemName: "cloud.bolt.rain.fill")!
                case 300...321:
                    return UIImage(systemName: "cloud.drizzle.fill")!
                case 500...531:
                    return UIImage(systemName: "cloud.rain.fill")!
                case 600...622:
                    return UIImage(systemName: "cloud.snow.fill")!
                case 701...781:
                    return UIImage(systemName: "smoke.fill")!
                case 800:
                    return UIImage(systemName: "sun.min.fill")!
                case 801...804:
                    return UIImage(systemName: "cloud.fill")!
                default:
                    return UIImage(systemName: "nosign")!
                }
            }
        
    }
    
}

extension CurrentWeatherViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
