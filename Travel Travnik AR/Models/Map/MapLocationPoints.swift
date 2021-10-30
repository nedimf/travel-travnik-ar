//
//	MapLocationPoints
//  Travel Travnik AR
//	Created by: @nedimf on 30/10/2021

// Extends over MKAnnotation to set needed options

import Foundation
import MapKit

class MapLocationPoints: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let discipline: String?
    let image: UIImage?
    let coordinate: CLLocationCoordinate2D

    init(
      title: String?,
      locationName: String?,
      discipline: String?,
      image: UIImage?,
      coordinate: CLLocationCoordinate2D
    ) {
      self.title = title
      self.locationName = locationName
      self.discipline = discipline
      self.coordinate = coordinate
      self.image = image

      super.init()
    }

    var subtitle: String? {
      return locationName
    }
}
