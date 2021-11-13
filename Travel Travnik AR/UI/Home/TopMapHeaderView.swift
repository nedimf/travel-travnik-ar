//
//	HomeHeaderView
//  Travel Travnik AR
//	Created by: @nedimf on 30/10/2021

// HomeHeaderView hosts header part of HomeViewController UI

import Foundation
import UIKit
import MapKit

// HomeHeaderView we can observe as host view for HomeViewController that contains of headerView and bodyView and navigationView
class TopMapHeaderView: UIView{
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let transparentView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setupView(){
        
        self.addSubview(transparentView)
        transparentView.addSubview(topLabel)
        
        NSLayoutConstraint.activate([
            
            transparentView.topAnchor.constraint(equalTo: self.topAnchor),
            transparentView.leftAnchor.constraint(equalTo: self.leftAnchor),
            transparentView.rightAnchor.constraint(equalTo: self.rightAnchor),
            transparentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            topLabel.centerXAnchor.constraint(equalTo: transparentView.centerXAnchor),
            topLabel.centerYAnchor.constraint(equalTo: transparentView.centerYAnchor)
        
        ])
    }
}
