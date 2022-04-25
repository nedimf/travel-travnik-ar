//
//	TourViewController
//  Travel Travnik AR
//	Created by: @nedimf on 13/11/2021


import Foundation
import UIKit
import SwiftUI
import CoreLocation
import MapKit


class TourViewController: UIViewController {
    
    //-MARK: View
    lazy var locationManger = CLLocationManager()
    lazy var landmarks: Landmark?=nil
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }()
    lazy var headerView: TopMapHeaderView = {
        let headerView = TopMapHeaderView()
        headerView.transparentView.isHidden = false
        headerView.transparentView.isUserInteractionEnabled = true
        headerView.transparentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openListOfRouteInstructions)))
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    
    var mapWrapper: MapWrapper?
    var mapLocationPoints = [MapLocationPoints]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        mapWrapper  = MapWrapper(mapView: mapView, locationManager: locationManger, view: self.headerView, didClickOnAccessoryMapView: { coordinates in
//            print(coordinates)
//        })
//        
//        let landmarks = Bundle.main.decode(Landmark.self, from: "landmarks.json")
//
//        DispatchQueue.main.async {
//            
//            for landmark in landmarks{
//                self.mapLocationPoints.append(MapLocationPoints(title: landmark.title, locationName: landmark.landmarkDescription, discipline: "sculpture", image: UIImage(named: landmark.header.name)?.circleImage(20, size: CGSize(width: 60, height: 60)), coordinate: CLLocationCoordinate2D(latitude: landmark.coordinates.lat, longitude: landmark.coordinates.log)))
//            }
//            
//            if let mapWrapper = self.mapWrapper {
//                mapWrapper.setMapPoints(for: self.mapLocationPoints, with: .includingAll, settingView: LocationPointView.self)
//                mapWrapper.mapLandmarks = landmarks
//            }
//                       
//        }
        
       
    
        setupLayout()

    }
    
    func setupLayout(){
        
        view.addSubview(mapView)
        view.addSubview(headerView)
        
        landmarks = Bundle.main.decode(Landmark.self, from: "landmarks.json")
        if  let landmarks = landmarks {
            
            let bottomViewHC: UIHostingController<TourHostBottomView> = {
                let viewHC = UIHostingController(rootView: TourHostBottomView(landmarks: landmarks, mapWrapper: self.mapWrapper))
                viewHC.view!.backgroundColor = .black.withAlphaComponent(0.1)
                viewHC.view!.translatesAutoresizingMaskIntoConstraints = false
                
                return viewHC
            }()
            
            view.addSubview(bottomViewHC.view)
            
            NSLayoutConstraint.activate([
                bottomViewHC.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
                bottomViewHC.view.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                bottomViewHC.view.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
                bottomViewHC.view.heightAnchor.constraint(equalToConstant: 90)
            ])
        }
        NSLayoutConstraint.activate([
        
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            headerView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            headerView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
        ])
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
    

}

