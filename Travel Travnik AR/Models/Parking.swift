//
//	Parking
//  Travel Travnik AR
//	Created by: @nedimf on 13/11/2021


import Foundation

// MARK: - ParkingElement
struct ParkingElement: Codable {
    let title, locationName, discipline, image: String
    let latitude, longitude: Double

    enum CodingKeys: String, CodingKey {
        case title
        case locationName = "locationName:"
        case discipline, image, latitude, longitude
    }
}

typealias Parking = [ParkingElement]
