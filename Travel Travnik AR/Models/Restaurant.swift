//
//	Restaurant
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import Foundation
import CoreLocation

// MARK: - RestaurantElement
struct RestaurantElement: Codable {
    let id = UUID()
    let title, about, image: String
    let latitude, longitude: Double
    let stars: Int

    enum CodingKeys: String, CodingKey {
        case title
        case about = "about:"
        case stars
        case image, latitude, longitude
    }
}

typealias Restaurant = [RestaurantElement]
