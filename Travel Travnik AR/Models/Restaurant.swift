//
//	Restaurant
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import Foundation
import CoreLocation

struct Restaurant{
    let id = UUID()
    let title: String
    let description: String
    let mapCoordinates: CLLocationCoordinate2D
}
