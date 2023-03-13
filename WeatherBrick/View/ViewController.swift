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
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLocationManager()
        setSearchButton()
        setInfoButton()

        
    }

    func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.pausesLocationUpdatesAutomatically = true
            locationManager.startUpdatingHeading()
        }
    }
    
    func setSearchButton() {
            searchButton.addTarget(self, action: #selector(updateWeatherInfo), for: .touchUpInside)
        }
    @objc func updateWeatherInfo(){
        print("YUra")
        updateWeatherInfoLatitudeLongtitude(latitude: 0, longtitude: 0)
    }
    
    func setInfoButton() {
        infoButton.addTarget(self, action: #selector(setInfoView), for: .touchUpInside)
    }
    
    @objc func setInfoView(){
        let infoViwe = InfoView()
        view.addSubview(infoViwe)
    }
    
    func updateWeatherInfoLatitudeLongtitude(latitude: Double, longtitude: Double) {
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
            print(lastLocation.coordinate)
        }
    }
}
