//
//	MapWrapper
//  Travel Travnik AR
//	Created by: @nedimf on 30/10/2021

// This class represents code wrapping around Apple's MapKit
// Location wrapper and creating annotations

import Foundation
import MapKit
import SwiftUI

class MapWrapper: NSObject{
    
    var mapView: MKMapView
    var locationManager: CLLocationManager
    var region: MKCoordinateRegion
    var calculatedRoute: MKRoute?
    var didClickOnAccessoryMapView: (CLLocationCoordinate2D) -> Void?
    var mapWrapperDelegate: MKMapViewDelegate?
    var view:UIHostingController<TopNavigationView>?
    var debugView: UILabel?=nil
    
    var currentPlace: CLLocation?
    var directions = [String]()
    var routeSteps = [MKRoute.Step]()
    var debugCoordinatesArray = [String]()
    var stepRouterCounter = 0
    var isRegionEntered = false
    var mapLandmarks = Landmark()
    var routeRadiuses = [CLCircularRegion]()
    var instructionIndex = 0

    var routeDirectionImageRepresentation: String = ""{
        didSet{
            let dataInfo: [String: String] = ["imageRepresentation": self.routeDirectionImageRepresentation]
            NotificationCenter.default.post(name: .routeDirectionImageRepresentation, object: dataInfo)
        }
    }
    
    var routeDirectionCurrentInstruction: String = ""{
        didSet{
            let dataInfo: [String: String] = ["currentInstruction": self.routeDirectionCurrentInstruction]
            NotificationCenter.default.post(name: .routeDirectionCurrentInstruction, object: dataInfo)
        }
    }
    
    var showTopNavigationView = false{
        didSet{
            let dataInfo = self.showTopNavigationView
            NotificationCenter.default.post(name: .showTopNotificationView, object: dataInfo)
        }
    }
    
    var routeDirectionNextInstruction: String = ""{
        didSet{
            let dataInfo: [String: String] = ["nextInstruction": self.routeDirectionNextInstruction]
            NotificationCenter.default.post(name: .routeDirectionCurrentInstruction, object: dataInfo)
        }
    }
    


    
    // Setting up region and showing it on Map View
    // Enable location to check for current coordinates
    init(mapView: MKMapView, locationManager: CLLocationManager,view: UIHostingController<TopNavigationView>?, debugView: UILabel?=nil,didClickOnAccessoryMapView: @escaping (CLLocationCoordinate2D) -> Void?) {
        self.mapView =  mapView
        self.locationManager = locationManager
        self.view  = view
        self.debugView = debugView
        self.didClickOnAccessoryMapView = didClickOnAccessoryMapView
        
        let travnikCity = CLLocation(latitude: 44.2257017, longitude: 17.6364189)
        self.region = MKCoordinateRegion(
            center: travnikCity.coordinate,
            latitudinalMeters: 10000,
            longitudinalMeters: 20000
        )
        
        super.init()
        self.mapView.delegate = self
        
    
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.distanceFilter = 1
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
        
        
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        mapView.centerToLocation(travnikCity)
        
        mapView.removeAnnotations(mapView.annotations)
    }
    
    // Set map points as array of provided coordinates
    // Exclude filters
    func setMapPoints(for locations: [MapLocationPoints], with excludeFilters: MKPointOfInterestFilter?=nil, settingView view: AnyClass){
        
        mapView.removeAnnotations(mapView.annotations)
        if let excludeFilters = excludeFilters {
            mapView.pointOfInterestFilter = excludeFilters
        }
        
        mapView.register(view.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.addAnnotations(locations)
    }
    
   
    
    // Set Route on Map View and returns MKRoute
    // Clears all overlays, makes network request to Apple Maps API for l1 and l2
    // Calculates best route to destination, based on provided coordinates and transport type
    func setRouteOnMap(l1: MapLocationPoints, l2: MapLocationPoints, transportType: MKDirectionsTransportType) -> MKRoute? {
        // Clear present overlays on Map View
        if (!mapView.overlays.isEmpty){
            mapView.removeOverlays(mapView.overlays)
        }
        // TODO: make map point to show again
        mapView.setRegion(region, animated: true)
        
        // MKPlacemark
        let p1 = MKPlacemark(coordinate: l1.coordinate)
        let p2 = MKPlacemark(coordinate: l2.coordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: p1)
        request.destination = MKMapItem(placemark: p2)
        request.transportType = transportType
        
        if let startTitle = l1.title {
            let startPointAnnotation = annotationFactory(title: startTitle, subtitle: l1.description, placemark: p1)
            if let destinationTitle = l2.title {
                let destinationPointAnnotation = annotationFactory(title: destinationTitle, subtitle: l2.description, placemark: p2)
                
                let directions = MKDirections(request: request)
                directions.calculate { [self] response, error in
                    guard let route = response?.routes.first else { return }
                    self.calculatedRoute = route
                    self.routeSteps = route.steps
                    mapView.addAnnotations([p1, p2])
                    mapView.addOverlay(route.polyline)
                    mapView.setVisibleMapRect(
                        route.polyline.boundingMapRect,
                        edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                        animated: true)
                    if let response = response{
                        if let primaryRoute = response.routes.first {
                            
                            for region in self.locationManager.monitoredRegions{
                                self.locationManager.stopMonitoring(for: region)
                            }
                            
                            for i in 0..<primaryRoute.steps.count{
                                let step = primaryRoute.steps[i]
                                
                                debugThis {
                                    print(step.instructions)
                                    print(step.distance)
                                    print(step.polyline.coordinate)
                                }
                                
                                let region = CLCircularRegion(center: step.polyline.coordinate,
                                                              radius: 20,
                                                              identifier: "steps-\(i)")
                                let circle = MKCircle(center: region.center, radius: region.radius)
                                self.mapView.addOverlay(circle)
                                locationManager.requestState(for: region)
                                locationManager.startMonitoring(for: region)
                                
                                region.notifyOnEntry = true
                                routeRadiuses.append(region)
                                
                                self.showTopNavigationView = true
                                
                            }
                            self.stepRouterCounter += 1
                            let message = "In \(self.routeSteps[stepRouterCounter].distance) meters in, \(self.routeSteps[stepRouterCounter].instructions)"
                            
                            self.routeDirectionCurrentInstruction = message
                            self.routeDirectionImageRepresentation = message
                            
                        
                            
                        }
                    }
                }
            }
        }
        
        guard let calculatedRoute = calculatedRoute else {
            return  nil
        }

        return calculatedRoute
    }
    
    //Get nearest points to location
    //Mainly used to sort landmarks in start tour mode
    func getNearestPoints(array: Landmark) -> Landmark?{
        guard let currentPlace = currentPlace else {
            return nil
        }

        let current = CLLocation(latitude: currentPlace.coordinate.latitude, longitude: currentPlace.coordinate.longitude)
        var dictArray = [[String: Any]]()
        for i in 0..<array.count{
            let loc = CLLocation(latitude: array[i].coordinates.lat, longitude: array[i].coordinates.log)
            let distanceInMeters = current.distance(from: loc)
            let a:[String: Any] = ["distance": distanceInMeters, "coordinate": array[i]]
            dictArray.append(a)
        }
        
        dictArray = dictArray.sorted(by: {($0["distance"] as! CLLocationDistance) < ($1["distance"] as! CLLocationDistance)})
        var sortedArray = Landmark()
        for i in dictArray{
            sortedArray.append(i["coordinate"] as! LandmarkElement)
        }
        return sortedArray
    }
    
    func evaluateClosestRouteSteps(steps: [MKRoute.Step]) -> ArraySlice<(MKRoute.Step, Double)> {

        var allDistance : [Double] = []

        //Calculate distance of each region's center to currentLocation
        for step in steps{
            let distance = currentPlace!.distance(from: CLLocation(latitude: step.polyline.coordinate.latitude, longitude: step.polyline.coordinate.longitude))
            allDistance.append(distance)
        }
        // a Array of Tuples
        let distanceOfEachRegionToCurrentLocation = zip(steps, allDistance)

        //sort and get closest
        let sortedRouteSteps = distanceOfEachRegionToCurrentLocation
            .sorted{ tuple1, tuple2 in return tuple1.1 < tuple2.1 }
            .prefix(steps.count)
        
        return sortedRouteSteps
    }
    
    func annotationFactory(title: String, subtitle: String, placemark: MKPlacemark) -> MKPointAnnotation{
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subtitle
        if let location = placemark.location{
            annotation.coordinate = location.coordinate
        }
        return annotation
    }
    
    //Clear mapView
    func clearMapViewFromDrawnRoute(){
        self.mapView.removeOverlays(self.mapView.overlays)
    }
    
    //Open Route in Apple/Google Maps
    enum TypeOfSupportedMaps {
        case google
        case maps
    }

    func openRouteInMaps(p1: MapLocationPoints, p2: MapLocationPoints, maps: TypeOfSupportedMaps){
        switch maps {
        case .google:
            let url = URL(string: "comgooglemaps://?daddr=\(p1.coordinate.latitude),\(p1.coordinate.longitude)+\(p2.coordinate.latitude),\(p2.coordinate.longitude)&directionsmode=driving&zoom=14&views=traffic")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case .maps:
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: p1.coordinate, addressDictionary: nil))
            mapItem.name = p1.title
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
}

extension MapWrapper: MKMapViewDelegate{
    
    // Delegate method to render overlay over MapView
    // Each overlay must returned individually
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        // Draw circle as overlay
       if (overlay is MKCircle){
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = .white.withAlphaComponent(0.0)
           renderer.strokeColor = .red.withAlphaComponent(0.0)
            renderer.lineWidth = 2
            
            return renderer
        }
        
        else{
            // Draw polyline renderer for route creation
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation {
            self.didClickOnAccessoryMapView(annotation.coordinate)
            
            let a = MapLocationPoints(title: annotation.title!, locationName: nil, discipline: nil, image: UIImage(systemName: "mappin"), coordinate: annotation.coordinate)
            let b = MapLocationPoints(title: "Current location", locationName: nil, discipline: nil, image: UIImage(systemName: "mappin"), coordinate: currentPlace!.coordinate)
            
            let userDefaults = UserDefaults()
            let isBetaEnabled = userDefaults.bool(forKey: "beta_step_by_step_direction")
            if(isBetaEnabled){
                let route = setRouteOnMap(l1: a, l2: b, transportType: MKDirectionsTransportType.automobile)
                print(route)
                NotificationCenter.default.post(name: .showTopNotificationView, object: true)
                self.view?.view.isUserInteractionEnabled = true
            }else{
                openRouteInMaps(p1: a, p2: b, maps: .maps)
            }

        }
    }
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 500
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

