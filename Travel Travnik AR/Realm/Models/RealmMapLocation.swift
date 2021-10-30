//
//	RealmMapLocation
//  Travel Travnik AR
//	Created by: @nedimf on 30/10/2021


import Foundation
import RealmSwift
import UIKit
import CoreLocation

class RealmMapLocation: Object{
    @Persisted var title: String = ""
    @Persisted var locationName: String = ""
    @Persisted var discipline: String = ""
    @Persisted var image: String = ""
    @Persisted var latitude = 0.0
    @Persisted var longitude = 0.0
}
