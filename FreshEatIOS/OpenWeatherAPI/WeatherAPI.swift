//
//  WeatherAPI.swift
//  FreshEatIOS
//
//  Created by csuser on 22/08/2022.
//

import Foundation
import Alamofire

func getWeatherDetailsByCity(city:String,onComplete: @escaping (WeatherData?)->Void) {
    AF.request(BASE_URL+city+APP_ID+API_KEY+UNITS_METRIC).responseDecodable(of:WeatherData.self){ response in
        switch response.result{
        case .success(let data):
            print ("success")
            onComplete(data)
        case .failure(let error):
            print("error : \(error)")
            onComplete(nil)
        }
    }
    
}
