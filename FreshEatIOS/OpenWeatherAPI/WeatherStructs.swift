//
//  WeatherStructs.swift
//  FreshEatIOS
//
//  Created by csuser on 22/08/2022.
//

import Foundation

//MARK: - Structs to get the information from the openWeather API
struct WeatherData : Decodable {
    let coord : Coordinate
    let cod, visibility, id : Int
    let name : String
    let base : String
    let weather : [Weather]
    let sys : Sys
    let main : Main
    let wind : Wind
    let dt : Date
    
    enum CodingKeys: String, CodingKey {
        case coord
        case cod
        case visibility
        case id
        case name
        case weather
        case base
        case sys
        case main
        case wind
        case dt
    }
}

struct Coordinate : Decodable {
    let lat, lon : Double
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
    }
}

struct Weather : Decodable {
    let id : Int
    let icon : String
    let main : MainEnum
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case icon
        case main
        case description
    }
}

struct Sys : Decodable {
    let type, id : Int
    let sunrise, sunset : Date
    let country : String
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case sunrise
        case sunset
        case country
    }
}

struct Main : Decodable {
    let temp, tempMin, tempMax,feelsLike : Double
    let pressure, humidity : Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case feelsLike = "feels_like"
        case pressure
        case humidity
    }
}

struct Wind : Decodable {
    let speed : Double
    let deg : Double?
    
    enum CodingKeys: String, CodingKey {
        case speed
        case deg
    }
}

enum MainEnum: String, Decodable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    
    enum CodingKeys: String, CodingKey {
        case clear
        case clouds
        case rain
    }
}
