//
//	Restaurant
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import Foundation
import CoreLocation

// MARK: - RestaurantElement
struct RestaurantElement: Codable {
    let id = UUID()
    var googleLink: String?=nil
    let title, about: String
    let image: RestaurantImage
    let latitude, longitude: Double
    let stars: Int

    enum CodingKeys: String, CodingKey {
        case title
        case about = "about:"
        case stars
        case googleLink
        case image, latitude, longitude
    }
}

struct RestaurantImage: Codable{
    let name:String
    let copy:String
}

typealias Restaurant = [RestaurantElement]
