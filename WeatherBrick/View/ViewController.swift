//
//  ViewController.swift
//  WeatherBrick
//
//  Created by Olya Sabadina on 2023-03-11.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var imageStoneImageView: UIImageView!
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
    private var latitude: Double = 0
    private var longitude: Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLocationManager()
        setSearchButton()
        setInfoButton()
        refresh()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    private func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.pausesLocationUpdatesAutomatically = true
            locationManager.startUpdatingHeading()
        }
    }
    
    @objc func updateWeatherInfo(){
        print("YUra")
        updateWeatherInfoLatitudeLongtitude(latitude: latitude, longitude: longitude)
    }
    
    @objc func setInfoView(){
        let infoViwe = InfoView()
        view.addSubview(infoViwe)
    }
    
    private func setSearchButton() {
        //            searchButton.addTarget(self, action: #selector(updateWeatherInfo), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(setAlertControler), for: .touchUpInside)
    }
    @objc func setAlertControler(){
        let alertControler = UIAlertController(title: "You can selected city", message: "Enter city name", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default){ action in
            let alertText = alertControler.textFields?.first?.text
            print(alertText ?? "nil")
        }
        
        alertControler.addTextField { textField in
            textField.placeholder = "Enter city name"
        }
        alertControler.addAction(alertAction)
        self.present(alertControler, animated: true)
//        
//        fetchManager.fetchWeatherForCityName(cityName: alertControler.textFields?.first?.text ?? "") { FinalWeather? in
//            DispatchQueue.main.async {
//                self.tempValueLabel.text = "frfr"
//            }
//        }
        
    }
    
    private func setInfoButton() {
        infoButton.addTarget(self, action: #selector(setInfoView), for: .touchUpInside)
    }
    
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
    func updateView(weather: FinalWeather?){
        if let weather = weather {
            tempValueLabel.text = weather.temperature
        }
    }
    
    
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
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            print(" this is \(lastLocation.coordinate)")
            
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
