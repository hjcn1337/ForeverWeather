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
    
    private var viewModel: CurrentWeatherViewModel!
    private let disposeBag = DisposeBag()
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        self.presentSearchAlertController(withTitle: "Введите название города", message: nil, style: .alert) { [unowned self] city in
            
            let cityObservable = Observable.just(city)
            cityObservable
                .bind(to: viewModel.searchText)
                .disposed(by: disposeBag)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.showLoadingAlert()
        }
        
        viewModel = CurrentWeatherViewModel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.addBindsToViewModel(self.viewModel)
            self.dismiss(animated: false, completion: nil)
        }
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
        
        viewModel.weatherIcon
            .bind(to: weatherIconImageView.rx.image)
            .disposed(by: disposeBag)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue" {
            let dvc = segue.destination as! MapViewController
            dvc.city = self.cityLabel.text
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
