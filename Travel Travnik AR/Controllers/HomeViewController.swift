//
//	HomeViewController
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import Foundation
import UIKit
import SwiftUI
import CoreLocation

class HomeViewController: UIViewController{
    
    lazy var locationManger = CLLocationManager()
    var mapWrapper: MapWrapper?
    var mapLocationPoints = [MapLocationPoints]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        let donorView = HomeMainView()
        donorView.headerView.transparentView.isHidden = true
        donorView.headerView.transparentView.isUserInteractionEnabled = true
        donorView.headerView.transparentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openListOfRouteInstructions)))
        donorView.hudViewHC.rootView.delegate = self
        view = donorView
        
        mapWrapper  = MapWrapper(mapView: donorView.mapView, locationManager: locationManger, view: donorView.headerView, didClickOnAccessoryMapView: { coordinates in
            print(coordinates)
        })
        
        let locations = Bundle.main.decode([MapLocation].self, from: "maplocation.json")
        let landmarks = Bundle.main.decode(Landmark.self, from: "landmarks.json")

        DispatchQueue.main.async {
            
            for location in locations{
                self.mapLocationPoints.append(MapLocationPoints(title: location.title, locationName: location.title, discipline: location.discipline, image: UIImage(named: location.image), coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)))
            }
            
            for landmark in landmarks{
                self.mapLocationPoints.append(MapLocationPoints(title: landmark.title, locationName: landmark.landmarkDescription, discipline: "sculpture", image: UIImage(named: landmark.header)?.circleImage(20, size: CGSize(width: 60, height: 60)), coordinate: CLLocationCoordinate2D(latitude: landmark.coordinates.lat, longitude: landmark.coordinates.log)))
            }
            
            
            if let mapWrapper = self.mapWrapper {
                mapWrapper.setMapPoints(for: self.mapLocationPoints, with: .includingAll, settingView: LocationPointView.self)
                mapWrapper.mapLandmarks = landmarks
            }

            
        }
      
    }
    
    @objc func openListOfRouteInstructions(){
        if let mapWrapper = mapWrapper {
            var steps = [String]()
            if let calculatedRoute = mapWrapper.calculatedRoute{
                for step in calculatedRoute.steps{
                    if (step.instructions != ""){
                        steps.append("In \(step.distance.rounded()) meters, \(step.instructions)")
                    }
                }
                let listRouteHostVC = UIHostingController(rootView: RouteStepsListView(steps: steps))
                let scene = UIApplication.shared.connectedScenes.first
                if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                    sd.nc.pushViewController(listRouteHostVC, animated: true)
                }
            }
           
        }
    }
    
    func selectOnlyParking(){
        
        let locations = Bundle.main.decode(Parking.self, from: "parking.json")
        print(locations)
        
        var mapLocationPoints = [MapLocationPoints]()
       
        for location in locations{
            mapLocationPoints.append(MapLocationPoints(title: location.title, locationName: location.title, discipline: location.discipline, image: UIImage(named: location.image), coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)))
        }
        
        if let mapWrapper = mapWrapper {
            mapWrapper.setMapPoints(for: mapLocationPoints, with: .includingAll, settingView: LocationPointView.self)
        }
    }
}


extension HomeViewController: HUDClickedDelegate{
    func hudClicked(id: Int, showParking: Bool) {
        
        let landmarksHostVC = UIHostingController(rootView: LandmarkHostView())
        let restaurantHostVC = UIHostingController(rootView: RestaurantHostView(mapWrapper: mapWrapper))
        let startTourVC = TourViewController()
        
        let scene = UIApplication.shared.connectedScenes.first
        switch(id){
        case 0:
            if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                //locationManager.stopUpdatingLocation()
                sd.nc.pushViewController(startTourVC, animated: true)
            }
        case 1:
            if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                sd.nc.pushViewController(landmarksHostVC, animated: true)
            }
        case 2:
            if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                sd.nc.pushViewController(restaurantHostVC, animated: true)
            }
        case 3:
            print("PARKING \(showParking)")
            if (showParking){
                selectOnlyParking()

            }else{
                
                if let mapWrapper = mapWrapper {
                    mapWrapper.setMapPoints(for: mapLocationPoints, with: .includingAll, settingView: LocationPointView.self)
                }
            }
        default:
            print("unexpected choice")
        }

    }
}
