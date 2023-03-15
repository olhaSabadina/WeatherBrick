//
//  ViewController.swift
//  WeatherBrick
//
//  Created by Olya Sabadina on 2023-03-11.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var brickOnRopeImageView: UIImageView!
    @IBOutlet weak var tempValueLabel: UILabel!
    @IBOutlet weak var indicationDegreeLabel: UILabel!
    @IBOutlet weak var weatherConditionsLabel: UILabel!
    @IBOutlet weak var iconLocationImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let locationManager = CLLocationManager()
    private var fetchManager = FetchWeatherManager()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    private func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                self.locationManager.pausesLocationUpdatesAutomatically = true
                self.locationManager.startUpdatingHeading()
            }
        }
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
                    self.activityIndicator.isHidden = true
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
    
    private func setInfoButton() {
        infoButton.addTarget(self, action: #selector(setInfoView), for: .touchUpInside)
    }
    
    private func setSearchButton() {
        searchButton.addTarget(self, action: #selector(setAlertControler), for: .touchUpInside)
    }
    
    private func refresh(){
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.locationManager.startUpdatingLocation()
        }
        fetchManager.fetchWeatherForCoordinates(latitude: latitude, longitude: longitude) { weather in
            DispatchQueue.main.async {
                self.updateView(weather: weather)
                self.activityIndicator.stopAnimating()
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 5){
                    print("Stop location")
                    self.locationManager.stopUpdatingLocation()
                }
                self.activityIndicator.isHidden = true
            }
        }
    }
    private func updateView(weather: FinalWeather?){
        if let weather = weather {
            tempValueLabel.text = weather.temperature
            cityNameLabel.text = "\(weather.nameCity), \(weather.country)"
            weatherConditionsLabel.text = weather.description
            brickOnRopeImageView.image = UIImage(named: weather.image)
            
        }
    }
    
    func windOfBrick(windSpeed: Double){
        print("windSpeed = \(windSpeed)")
        if windSpeed > 4 {
            UIView.animate(withDuration: 2, delay: 1) {
                self.brickOnRopeImageView.transform = CGAffineTransformMakeRotation(CGFloat(30))
            }
        } else {
            UIView.animate(withDuration: 2, delay: 1) {
                self.brickOnRopeImageView.transform = CGAffineTransformMakeRotation(CGFloat(0))
            }
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            latitude = lastLocation.coordinate.latitude
            longitude = lastLocation.coordinate.longitude
            refresh()
        }
    }
}




/*
 func refresh(){
 DispatchQueue.main.async {
 self.activityIndicator.startAnimating()
 }
 fetchManager.fetchWeatherForCoordinates(latitude: latitude, longitude: longitude) { weather in
 DispatchQueue.main.async {
 self.updateView(weather: weather)
 self.activityIndicator.stopAnimating()
 DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 5){
 print("Stop location")
 self.locationManager.stopUpdatingLocation()
 }
 }
 }
 }
 */

/*
 @objc func updateWeatherInfo(){
     print("YUra")
     updateWeatherInfoLatitudeLongtitude(latitude: latitude, longitude: longitude)
 }
           searchButton.addTarget(self, action: #selector(updateWeatherInfo), for: .touchUpInside)

 func updateWeatherInfoLatitudeLongtitude(latitude: Double, longitude: Double) {
     let session = URLSession.shared
     guard let url = URL(string:
                             "https://api.openweathermap.org/data/2.5/weather?q=London&units=metric&appid=f2085fa546a323d778ef788c6b934414&lang=uk") else {return}
     let task = session.dataTask(with: url) { data, response, error in
         guard error == nil, let data = data else { print("Data task = \(String(describing: error?.localizedDescription))")
             return}
         print("ответ сервера \(data)")
         do {
             let weather = try JSONDecoder().decode(WeatherData.self, from: data)
             print(weather)
             DispatchQueue.main.async {
                 self.tempValueLabel.text = "\(weather.main.temp)"
                 self.cityNameLabel.text = "\(weather.name), \(weather.sys.country)"
                 self.weatherConditionsLabel.text = weather.weather.first?.description
             }
             
         } catch {
             print("\(String(describing: error.localizedDescription))")
         }
     }
     task.resume()
     
 }
 
 */


