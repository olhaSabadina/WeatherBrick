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
    @IBOutlet weak var tempValueLabel: UILabel!
    @IBOutlet weak var indicationDegreeLabel: UILabel!
    @IBOutlet weak var weatherConditionsLabel: UILabel!
    @IBOutlet weak var iconLocationImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let locationManager = CLLocationManager()
    private var fetchManager = FetchWeatherManager()
    private let refreshControl = UIRefreshControl()
    private var latitude: Double = 0 {
        didSet {
            print("широта \(latitude)")
        }
    }
    private var longitude: Double = 0 {
        didSet {
            print("долгота \(longitude)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLocationManager()
        setSearchButton()
        setInfoButton()
        setupRefreshControl()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        refresh()
//    }
    

    
    
    
    private func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                self.locationManager.pausesLocationUpdatesAutomatically = true
                self.locationManager.startUpdatingLocation()
                print("запуск GPS")
                print(self.longitude, self.latitude)
            }
        }
    }
    
    @objc private func didPullToRefresh() {
        refresh()
       print("refreshControOk")
        refreshControl.endRefreshing()
    }
    
    @objc func setInfoView(){
        let infoViwe = InfoView()
        view.addSubview(infoViwe)
    }
    
    @objc func setAlertControler(){
        let alertControler = UIAlertController(title: "You can selected city", message: "Enter city name", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default){ action in
            guard let alertText = alertControler.textFields?.first?.text else {
                print("please enter cityName")
                return
            }
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
            print(alertText)
            self.fetchManager.fetchWeatherForCityName(cityName: alertText ) { weather in
                DispatchQueue.main.async {
                    self.updateView(weather: weather)
                    self.activityIndicator.stopAnimating()
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
    
    private func setupRefreshControl(){
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    private func setInfoButton() {
        infoButton.addTarget(self, action: #selector(setInfoView), for: .touchUpInside)
    }
    
    private func setSearchButton() {
        searchButton.addTarget(self, action: #selector(setAlertControler), for: .touchUpInside)
    }
    
    private func refresh(){
        print("refresh")
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        fetchManager.fetchWeatherForCoordinates(latitude: latitude, longitude: longitude) { weather in
            DispatchQueue.main.async {
                self.updateView(weather: weather)
                self.activityIndicator.stopAnimating()
//                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 5){
//                    print("Stop location")
//                    self.locationManager.stopUpdatingLocation()
//                }
            }
        }
    }
    private func updateView(weather: FinalWeather?){
        if let weather = weather {
            tempValueLabel.text = weather.temperature
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
            tempValueLabel.text = ""
            cityNameLabel.text = "Not found"
            weatherConditionsLabel.text = ""
            indicationDegreeLabel.text = ""
            brickOnRopeImageView.image = UIImage(named: "image_without_stone_")
            UIView.animate(withDuration: 2, delay: 1) {
                self.brickOnRopeImageView.transform = CGAffineTransformMakeRotation(CGFloat(0))
            }
        }
        
        func windOfBrick(windSpeed: Double){
            print("windSpeed = \(windSpeed)")
            if windSpeed > 4 {
                UIView.animate(withDuration: 2, delay: 1) {
                    self.brickOnRopeImageView.transform = CGAffineTransformMakeRotation(CGFloat(45))
                }
            } else {
                UIView.animate(withDuration: 2, delay: 1) {
                    self.brickOnRopeImageView.transform = CGAffineTransformMakeRotation(CGFloat(0))
                }
            }
        }
        
    }
}
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            latitude = lastLocation.coordinate.latitude
            longitude = lastLocation.coordinate.longitude
            print("gps определил коордтаты и записсал в переменные")
            refresh()
            
        }
    }
}





