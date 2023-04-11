//
//  ViewController.swift
//  WeatherBrick
//
//  Created by Olya Sabadina on 2023-03-11.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var brickOnRopeImageView: UIImageView!
    @IBOutlet weak var temperatureValueLabel: UILabel!
    @IBOutlet weak var indicationDegreeLabel: UILabel!
    @IBOutlet weak var weatherConditionsLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let locationManager = CLLocationManager()
    public var fetchManager: FetchWeatherProtocol?
    private var latitude: Double = 0
    private var longitude: Double = 0
    
    init?(coder: NSCoder, fechManager: FetchWeatherProtocol) {
        self.fetchManager = fechManager
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLocationManager()
        setSearchButton()
        setInfoButton()
        setLocationButton()
        scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshData()
        scrollView.contentInset = .init(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    @objc private func pressLocationButton() {
        refreshData()
    }
    
    @objc func setInfoView(){
        let infoViwe = InfoView()
        view.addSubview(infoViwe)
    }
    
    @objc func setAlertControler(){
        let alertControler = UIAlertController(title: "You can selected city", message: "Enter city name", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default){ action in
            guard let cityAlertText = alertControler.textFields?.first?.text else {return}
            self.isActivityAnimatingStart(true)
            self.fetchManager?.fetchWeatherForCityName(cityName: cityAlertText ) { weather in
                DispatchQueue.main.async {
                    self.updateView(weather: weather)
                    self.isActivityAnimatingStart(false)
                }
            }
        }
        let alertCancel = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertControler.addTextField { textField in
            textField.placeholder = "Enter city name"
        }
        alertControler.addAction(alertAction)
        alertControler.addAction(alertCancel)
        self.present(alertControler, animated: true)
    }
    
    private func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                self.locationManager.pausesLocationUpdatesAutomatically = true
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    private func setLocationButton() {
        locationButton.addTarget(self, action: #selector(pressLocationButton), for: .touchUpInside)
    }
    
    private func setInfoButton() {
        infoButton.addTarget(self, action: #selector(setInfoView), for: .touchUpInside)
    }
    
    private func setSearchButton() {
        searchButton.addTarget(self, action: #selector(setAlertControler), for: .touchUpInside)
    }
    
    private func refreshData(){
//        guard latitude != 0 else {return}
        isActivityAnimatingStart(true)
        fetchManager?.fetchWeatherForCoordinates(latitude: latitude, longitude: longitude) { weather in
            DispatchQueue.main.async {
                self.updateView(weather: weather)
                self.isActivityAnimatingStart(false)
            }
        }
    }
    
    private func isActivityAnimatingStart(_ animating: Bool){
        if animating {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func alertCityNotFound() {
        let alertNotFound = UIAlertController(title: "City not found", message: "Try input another City\nPlease!\nOr check internet connection!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alertNotFound.addAction(action)
        present(alertNotFound, animated: true)
    }
    
    private func windOfBrick(windSpeed: Double){
        if windSpeed > 4 {
            UIView.animate(withDuration: 3, delay: 1.5, options: [.repeat, .autoreverse, .curveEaseInOut]) {
                self.brickOnRopeImageView.transform = CGAffineTransformMakeRotation(CGFloat(0.3))
            }
        } else {
            UIView.animate(withDuration: 2, delay: 1) {
                self.brickOnRopeImageView.transform = CGAffineTransformMakeRotation(CGFloat(0))
            }
        }
    }
    
    private func updateView(weather: WeatherModel?){
        if let weather = weather {
            temperatureValueLabel.text = weather.temperature
            cityNameLabel.text = "\(weather.nameCity), \(weather.country)"
            weatherConditionsLabel.text = weather.description
            indicationDegreeLabel.text = "℃"
            brickOnRopeImageView.image = UIImage(named: weather.image)
            windOfBrick(windSpeed: weather.wind)
            
            if (701...799).contains(weather.id){
                brickOnRopeImageView.alpha = 0.15
            } else {
                brickOnRopeImageView.alpha = 1.0
            }
        } else {
            temperatureValueLabel.text = ""
            cityNameLabel.text = "Not found"
            weatherConditionsLabel.text = ""
            indicationDegreeLabel.text = ""
            brickOnRopeImageView.image = UIImage(named: "image_without_stone_")
            UIView.animate(withDuration: 2, delay: 1) {
                self.brickOnRopeImageView.transform = CGAffineTransformMakeRotation(CGFloat(0))
            }
            alertCityNotFound()
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            latitude = lastLocation.coordinate.latitude
            longitude = lastLocation.coordinate.longitude
        }
    }
}

extension WeatherViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        refreshData()
    }
}





