//
//	Landmark
//  Travel Travnik AR
//	Created by: @nedimf on 29/10/2021


import Foundation
import UIKit

// MARK: - LandmarkElement
struct LandmarkElement: Codable {
    let id = UUID()
    let title, landmarkDescription, header: String
    let moreInformation: [MoreInformation]
    let coordinates: Coordinates
    let moreInformationPhotos: [MoreInformationPhoto]
    

    enum CodingKeys: String, CodingKey {
         case title
         case landmarkDescription = "description:"
         case header, coordinates, moreInformation, moreInformationPhotos
     }
}

// MARK: - MoreInformation
struct MoreInformation: Codable {
    let title, content: String
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let lat, log: Double
}

// MARK: - MoreInformationPhoto
struct MoreInformationPhoto: Codable {
    let name: String
}

typealias Landmark = [LandmarkElement]
