//
//	GPSTestViewController
//  Travel Travnik AR
//	Created by: @nedimf on 11/11/2021


import Foundation
import UIKit
import CoreLocation
import MapKit


class GPSViewController: UIViewController{
    
    lazy var locationManger = CLLocationManager()
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }()
    
    let coordinatesView: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = .red.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let endButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue.withAlphaComponent(0.7)
        button.setTitle("END record", for: .normal)
        button.addTarget(self, action: #selector(endRecordForLocation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func endRecordForLocation(){
        
        let alert = UIAlertController(title: "Save location name", message: "Enter a text", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "location name"
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField.text)")
            
            let filename = self.getDocumentsDirectory().appendingPathComponent("output-\(textField.text!)-\(UUID().uuidString).txt")

            do {
                let str = self.mapWrapper!.debugCoordinatesArray
                var writeString = ""
                for str in str {
                    writeString = "\(writeString)\(str),\n"
                }
                try writeString.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
                self.endButton.setTitle("SAVED", for: .normal)
            } catch {
                // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            }
            
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }

    var mapWrapper: MapWrapper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.225, longitude: 17.67),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        mapWrapper = MapWrapper(mapView: mapView, region: region, locationManager: locationManger, view: self.view,  debugView: coordinatesView) { coordinates in
            print(coordinates)
            
        }
        
//        mapView.delegate = self
//        locationManger.delegate = self
//        
        let locations = MapLocationPoints(title: "lol", locationName: "lol", discipline: "lol", image: UIImage(systemName: "cube"), coordinate: CLLocationCoordinate2D(latitude: 44.22970, longitude: 17.67418))
        var points = [ MapLocationPoints]()
        points.append(locations)
        
        mapWrapper!.setMapPoints(for: points, with: .none, settingView: LocationPointView.self)
        
        setupView()
        view.backgroundColor = .red
    }
    
    func setupView(){
        
        view.addSubview(mapView)
        view.addSubview(coordinatesView)
        view.addSubview(endButton)
        
        
        NSLayoutConstraint.activate([
            
           mapView.topAnchor.constraint(equalTo: view.topAnchor),
           mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
           mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
           mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           
           coordinatesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
           coordinatesView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 40),
           coordinatesView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -40),
           coordinatesView.heightAnchor.constraint(equalToConstant: 40),

           endButton.topAnchor.constraint(equalTo: coordinatesView.bottomAnchor, constant: 20),
           endButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 40),
           endButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -40),
           endButton.heightAnchor.constraint(equalToConstant: 40)
           
        ])
    }
    
}
