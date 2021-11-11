//
//	HomeViewController
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import Foundation
import UIKit
import SwiftUI

class HomeViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        let donorView = HomeMainView()
        donorView.hudViewHC.rootView.delegate = self
        view = donorView
        
        let landmarks = Bundle.main.decode([MapLocation].self, from: "maplocation.json")
        
        print(landmarks)

    }
}


extension HomeViewController: HUDClickedDelegate{
    func hudClicked(id: Int, showParking: Bool) {
        
        let landmarksHostVC = UIHostingController(rootView: LandmarkHostView())
        let restaurantHostVC = UIHostingController(rootView: RestaurantHostView())
        let startTourVC = GPSViewController()
        //let arController =
        
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
                //selectOnlyParking()

            }else{
                //mapView.removeAnnotations(mapView.annotations)
                //mapView.addAnnotations(setupMapPoints())

            }
        default:
            print("unexpected choice")
        }

    }
}
