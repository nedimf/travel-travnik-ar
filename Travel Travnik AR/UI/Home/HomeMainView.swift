//
//	HomeMainView
//  Travel Travnik AR
//	Created by: @nedimf on 30/10/2021


// HomeMainView hosts main part of HomeViewController UI

import Foundation
import UIKit
import MapKit
import SwiftUI

// HomeMainView we can observe as host view for HomeViewController that contains of headerView and bodyView and navigationView
class HomeMainView: UIView{
    
    let headerView: HomeHeaderView = {
        let headerView = HomeHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()

    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }()
        
    let hudViewHC: UIHostingController<HomeHUDView> = {
        let viewHC = UIHostingController(rootView: HomeHUDView())
        viewHC.view!.backgroundColor = .black.withAlphaComponent(0.1)
        viewHC.view!.translatesAutoresizingMaskIntoConstraints = false
        
        return viewHC
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setupView(){
        
        self.addSubview(mapView)
        self.addSubview(headerView)
        self.addSubview(hudViewHC.view)
        
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.topAnchor),
            mapView.leftAnchor.constraint(equalTo: self.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: self.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            headerView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 15),
            headerView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -15),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            hudViewHC.view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            hudViewHC.view.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            hudViewHC.view.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            hudViewHC.view.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
}

