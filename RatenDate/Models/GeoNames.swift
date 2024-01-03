//
//  GeoNames.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/2/24.
//

import Foundation

class GeoNamesClient {
    let username: String
    
    init(username: String) {
        self.username = username
    }
    
    func searchCity(query: String, completion: @escaping ([String]) -> Void) {
        let urlString = "http://api.geonames.org/searchJSON?q=\(query)&maxRows=10&username=\(self.username)"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode(GeonamesResponse.self, from: data) {
                DispatchQueue.main.async {
                    completion(decodedResponse.geonames.map { $0.name })
                }
            } else {
                print("Invalid response from server")
            }
        }
        task.resume()
    }
}

struct Geoname: Codable {
    var name: String
}

struct GeonamesResponse: Codable {
    var geonames: [Geoname]
}
