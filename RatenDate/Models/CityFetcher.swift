import Foundation
import CoreLocation

class CityFetcher: ObservableObject {
    @Published var cityName: String = ""
    
    func fetchCityName(from location: CLLocation?) {
        guard let location = location else {
            self.cityName = "Unknown"
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Reverse geocoding failed: \(error.localizedDescription)")
                    self?.cityName = "Error finding city"
                    return
                }
                
                self?.cityName = placemarks?.first?.locality ?? "Unknown"
            }
        }
    }
}
