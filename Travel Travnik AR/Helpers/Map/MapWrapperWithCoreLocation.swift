//
//	MapWrapperWithCoreLocation
//  Travel Travnik AR
//	Created by: @nedimf on 30/10/2021


import Foundation
import CoreLocation
import UIKit
import MapKit

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

    //This checking enables app to have turn-to-turn navigation
    //Checks on all locationRegions and matching coordinated with region geofencing
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.isRegionEntered = true
 
            if stepRouterCounter < routeSteps.count{
                let currentStep = routeSteps[stepRouterCounter]
                let message = "In \(currentStep.distance.rounded()) meters in, \(currentStep.instructions)"

                if let view = self.view {
                    view.transparentView.isHidden = false
                    view.topLabel.text = message
                }

                debugThis {
                    print("MESSAGE")
                    print(message)
                }
                stepRouterCounter += 1

            }else{
                let message = "Arrived!"
                stepRouterCounter = 0
                if let view = self.view {
                    view.transparentView.isHidden = true
                    view.topLabel.text = message
                }
            }
       
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exit region")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        if let view = self.view {
            view.transparentView.isHidden = false
            view.transparentView.backgroundColor = .red.withAlphaComponent(0.3)
            view.topLabel.text = "Failed to provide instructions!"
        }
    }
    
    private func checkIfUserIsInLandmarkRadius(currentLocation: CLLocation, landmarks: Landmark) -> Bool{
        
        for landmark in landmarks{
            let distance = currentLocation.distance(from: CLLocation(latitude: landmark.coordinates.lat, longitude: landmark.coordinates.log))
            if(distance < 20){
                return true
            }
            print("Distance: \(distance)")

        }
        return false
    }
    
    private func checkIfUserIsInRouteStepRadius(currentLocation: CLLocation, steps: [MKRoute.Step]) -> Bool{
        
        for step in steps{
            if(currentLocation.distance(from: CLLocation(latitude: step.polyline.coordinate.latitude, longitude: step.polyline.coordinate.longitude)) < 20){
                return true
            }
        }
        return false
    }
    
    // Continues check to see if user is in correct city
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.currentPlace = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
       
        self.debugView?.text = "\(locValue.latitude) \(locValue.longitude)"
        self.debugCoordinatesArray.append("\(locValue.latitude) \(locValue.longitude)")
        print(self.evaluateClosestRouteSteps(steps: self.routeSteps))

        //Check if landmark is near
        DispatchQueue.main.async {
            if(self.checkIfUserIsInLandmarkRadius(currentLocation: self.currentPlace!, landmarks: self.mapLandmarks)){
                
                let scene = UIApplication.shared.connectedScenes.first

                let element = self.getNearestPoints(array: self.mapLandmarks)
                 
                if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                    
                    let alert = UIAlertController(title: "🥳", message: "You've just found AR landmark!", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Open Now", style: .cancel, handler: { (_) in
                         
                        let arViewController = ARViewController()
                        arViewController.landmark = element?.first
                        sd.nc.pushViewController(arViewController, animated: true)
                    }))
                    sd.nc.present(alert, animated: true, completion: nil)
                    
                }
            }
// TODO:// Worth checking
//            if(self.checkIfUserIsInRouteStepRadius(currentLocation: self.currentPlace!, steps: self.routeSteps)){
//                print(self.evaluateClosestRouteSteps(steps: self.routeSteps))
//                let closestStep = self.evaluateClosestRouteSteps(steps: self.routeSteps).last!.0
//
//                let message = "In \(closestStep.distance.rounded()) meters in, \(closestStep.instructions)"
//
//                if let view = self.view {
//                    view.transparentView.isHidden = false
//                    view.topLabel.text = message
//                }
//            }
        }
        
        
        guard let location: CLLocation = manager.location else { return }
        fetchCityAndCountry(from: location) { name, city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
            
            let distance = CLLocation(latitude: 44.2257017, longitude: 17.6364189).distance(from: location)
            if distance < 50 {
                self.debugThis {
                    print("Distance in city!")
                }
            }else{
                if let name = name {
                    if let view = self.view{
                        view.transparentView.isHidden = false
                        view.transparentView.backgroundColor = .red.withAlphaComponent(0.3)
                        view.topLabel.font = UIFont.systemFont(ofSize: 14)
                        view.topLabel.text = "You are not in range: \(name), \(city)"
                    }
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
