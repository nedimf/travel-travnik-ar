//
//	MapLocationAnnotationView
//  Travel Travnik AR
//	Created by: @nedimf on 30/10/2021


import Foundation
import UIKit
import MapKit

class LocationPointView: MKAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      guard let locationPoint = newValue as? MapLocationPoints else {
        return
      }
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
        let mapsButton = UIButton(frame: CGRect(
          origin: CGPoint.zero,
          size: CGSize(width: 30, height: 30)))
        mapsButton.setBackgroundImage(locationPoint.image, for: .normal)
        rightCalloutAccessoryView = mapsButton
        
      image = locationPoint.image
    }
  }
}
