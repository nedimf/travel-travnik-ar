//
//	Landmark
//  Travel Travnik AR
//	Created by: @nedimf on 29/10/2021


import Foundation
import UIKit

struct Landmark{
    let id = UUID()
    var title: String
    var description: String
    var header: UIImage? = nil
    var moreInformation: LandmarkMoreInformation
}

struct LandmarkMoreInformation{
    var content: String? = nil
    var photos = [UIImage]()
}
