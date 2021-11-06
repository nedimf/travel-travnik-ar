//
//	MapLocation
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import Foundation

struct MapLocation: Codable {
    let title, locationName, discipline, image: String?
    let latitude, longitude: String?

    enum CodingKeys: String, CodingKey {
        case title
        case locationName = "locationName:"
        case discipline, image, latitude, longitude
    }
}

