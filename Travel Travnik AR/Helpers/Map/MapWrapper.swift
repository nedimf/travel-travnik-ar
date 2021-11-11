//
//	MapWrapper
//  Travel Travnik AR
//	Created by: @nedimf on 30/10/2021

// This class represents code wrapping around Apple's MapKit
// Location wrapper and creating annotations

import Foundation
import MapKit

class MapWrapper: NSObject{
    
    var mapView: MKMapView
    var locationManager: CLLocationManager
    var region: MKCoordinateRegion
    var calculatedRoute: MKRoute?
    var didClickOnAccessoryMapView: (CLLocationCoordinate2D) -> Void?
    var mapWrapperDelegate: MKMapViewDelegate?
    var view: UIView?
    var debugView: UILabel?
    
    var currentPlace: CLLocation?
    var directions = [String]()
    var routeSteps = [MKRoute.Step]()
    var debugCoordinatesArray = [String]()
    
    // Setting up region and showing it on Map View
    // Enable location to check for current coordinates
    init(mapView: MKMapView, region: MKCoordinateRegion, locationManager: CLLocationManager,view: UIView?, debugView: UILabel,didClickOnAccessoryMapView: @escaping (CLLocationCoordinate2D) -> Void?) {
        self.mapView =  mapView
        self.region = region
        self.locationManager = locationManager
        self.view  = view
        self.debugView = debugView
        self.didClickOnAccessoryMapView = didClickOnAccessoryMapView
        super.init()
        self.mapView.delegate = self
        
        let travnikCity = CLLocation(latitude: 44.2257017, longitude: 17.6364189)
        let region = MKCoordinateRegion(
            center: travnikCity.coordinate,
            latitudinalMeters: 50000,
            longitudinalMeters: 60000
        )
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
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
                    mapView.addAnnotations([startPointAnnotation, destinationPointAnnotation])
                    mapView.addOverlay(route.polyline)
                    mapView.setVisibleMapRect(
                        route.polyline.boundingMapRect,
                        edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                        animated: true)
                    if let response = response{
                        if let primaryRoute = response.routes.first {
                            
                            for i in 0..<primaryRoute.steps.count{
                                let step = primaryRoute.steps[i]
                                
                                debugThis {
                                    print(step.instructions)
                                    print(step.distance)
                                    print(step.polyline.coordinate)
                                }
                                
                                let region = CLCircularRegion(center: step.polyline.coordinate,
                                                              radius: 50,
                                                              identifier: "\(i)")
                                self.locationManager.startMonitoring(for: region)
                                locationManager.requestState(for: region)
                                
                            }
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
    
    func annotationFactory(title: String, subtitle: String, placemark: MKPlacemark) -> MKPointAnnotation{
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subtitle
        if let location = placemark.location{
            annotation.coordinate = location.coordinate
        }
        return annotation
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
            renderer.strokeColor = .red
            renderer.lineWidth = 1
            
            return renderer
        }else{
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
            
            let a = MapLocationPoints(title: "sss", locationName: nil, discipline: nil, image: nil, coordinate: annotation.coordinate)
            let b = MapLocationPoints(title: "222", locationName: nil, discipline: nil, image: nil, coordinate: currentPlace!.coordinate)
            
            let route = setRouteOnMap(l1: b, l2: a, transportType: MKDirectionsTransportType.automobile)
            
            print(route)
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

