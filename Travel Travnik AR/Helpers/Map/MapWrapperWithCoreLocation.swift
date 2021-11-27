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
        guard status == .authorizedAlways else {
            return
        }
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("--- Monitoring did fail for region with identifier \(region?.identifier) with error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("--- Started monitoring for this region:: \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("--- Heading: \(newHeading)")
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        print("DidDetermainState: \(region.identifier)")
        print("DidDetermainState: \(state.rawValue)")
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
    
    private func checkIfUserIsInRouteStepRadius(currentLocation: CLLocation, steps: [CLCircularRegion]) -> (Bool, CLCircularRegion?){
        for step in steps{
            let distance = currentLocation.distance(from: CLLocation(latitude: step.center.latitude, longitude: step.center.longitude))
            if(distance < 20){
                print("--- Distance: \(distance)")

                return (true, step)
            }
        }
        return (false,nil)
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
            let doCheck = self.checkIfUserIsInRouteStepRadius(currentLocation: self.currentPlace!, steps: self.routeRadiuses)
            if(doCheck.0){
                
                
                print("--- Radius closest \(doCheck.1)")
                let index = Int((doCheck.1?.identifier.replacingOccurrences(of: "steps-", with: ""))!)
                print("--- Step \(self.routeSteps[index!].instructions)")
                
                print(self.evaluateClosestRouteSteps(steps: self.routeSteps))
                let closestStep = self.evaluateClosestRouteSteps(steps: self.routeSteps)[1].0

                var message = ""
                if self.instructionIndex == 0 {

                    message = "In \(closestStep.distance.rounded()) meters in, \(closestStep.instructions)"
                    if (!self.routeSteps[index!].instructions.lowercased().contains("arriv")){
                        self.instructionIndex += 1
                    }
                }else{
   
                    if (self.routeSteps[index!].distance.rounded() > 1){
                        message = "In \(self.routeSteps[index!].distance.rounded()) meters in, \(self.routeSteps[index!].instructions)"
                    }else{
                        message = "Arrived"
                        self.instructionIndex = 0
                    }
                }
                //let nextMessage = "In \(nextClosestStep.distance.rounded()) meters in, \(nextClosestStep.instructions)"

                self.routeDirectionCurrentInstruction = message
                self.routeDirectionImageRepresentation = message
               //zr self.routeDirectionNextInstruction = nextMessage
//
                
                print("\n ---- Message from checkIfUser \(message)")
                print(self.evaluateClosestRouteSteps(steps: self.routeSteps))
            }
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
               //not in range
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



