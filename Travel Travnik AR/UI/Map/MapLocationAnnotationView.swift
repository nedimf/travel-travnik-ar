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

extension UIImage {
func circleImage(_ cornerRadius: CGFloat, size: CGSize) -> UIImage? {
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    if let context = UIGraphicsGetCurrentContext() {
        var path: UIBezierPath
        if size.height == size.width {
            if cornerRadius == size.width/2 {
                path = UIBezierPath(arcCenter: CGPoint(x: size.width/2, y: size.height/2), radius: cornerRadius, startAngle: 0, endAngle: 2.0*CGFloat(Double.pi), clockwise: true)
            }else {
                path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            }
        }else {
            path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        }
        context.addPath(path.cgPath)
        context.clip()
        self.draw(in: rect)
        guard let uncompressedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()
        return uncompressedImage
    }else {
        return nil
    }
}}
