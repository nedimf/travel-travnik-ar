//
//	MapWrapperWithCoreLocation
//  Travel Travnik AR
//	Created by: @nedimf on 30/10/2021


import Foundation
import CoreLocation

extension MapWrapper: CLLocationManagerDelegate {
    
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        guard status == .authorizedWhenInUse else {
            return
        }
        manager.requestLocation()
    }

    // On every update of location check for route change
    // This checking enables app to have turn-to-turn navigation
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.currentPlace = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        //Turn by turn navigation
        for route in self.routeSteps{
            if (CLLocation(latitude: route.polyline.coordinate.latitude, longitude: route.polyline.coordinate.longitude).distance(from: CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)) < 10){
                //                self.topViewLabel.text = route.instructions
                
            }
        }
        
        guard let location: CLLocation = manager.location else { return }
        fetchCityAndCountry(from: location) { name, city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
            
            let distance = CLLocation(latitude: 44.2257017, longitude: 17.6364189).distance(from: location)
            if distance < 100 {
                if let name = name {
                    //                        self.orangeView.backgroundColor = .orange.withAlphaComponent(0.3)
                    //                        self.topViewLabel.text = "\(name), \(city)"
                }
                
            }else{
                if let name = name {
                    //                        self.orangeView.backgroundColor = .red.withAlphaComponent(0.3)
                    //                        self.topViewLabel.font = UIFont.systemFont(ofSize: 14)
                    //                        self.topViewLabel.text = "You are not in range: \(name), \(city)"
                }
            }
            
        }
        
        self.mapView.userTrackingMode = .followWithHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Err location manager", error)
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ name: String?, _ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(
                placemarks?.first?.name,
                placemarks?.first?.locality,
                placemarks?.first?.country,
                error)
        }
    }
    
}
