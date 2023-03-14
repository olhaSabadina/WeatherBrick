//
//  InfoView.swift
//  WeatherBrick
//
//  Created by Olya Sabadina on 2023-03-13.
//

import Foundation

struct FinalWeather {
    
    var nameCity: String
    var temperature: String
    var description: String
    var wind: Double
    var id: Int
    var temp: Double
    var country : String
    
    var image: String {
        switch id {
        case 200...599 : return "image_stone_wet"
        case 600...699 : return "image_stone_snow"
        default: return temp > 27 ? "image_stone_cracks" : "image_stone_normal"
        }
    }
    
    init?(weatherData: WeatherData) {
        self.nameCity = weatherData.name
        self.temperature = String(format: "%.1f", weatherData.main.temp)
        self.description = weatherData.weather.first?.description ?? "Not found"
        self.wind = weatherData.wind.speed
        self.id = weatherData.weather.first?.id ?? 0
        self.temp = weatherData.main.temp
        self.country = weatherData.sys.country
    }
}
