//
//	Landmark
//  Travel Travnik AR
//	Created by: @nedimf on 29/10/2021


import Foundation

// MARK: - LandmarkElement
struct LandmarkElement: Codable {
    let id = UUID()
    let header: LandmarkHeader
    let isTranslatedByGoogle: Bool
    let title, landmarkDescription: String
    let moreInformation: [MoreInformation]
    let coordinates: Coordinates
    let sources: [LandmarkSource]
    let moreInformationPhotos: [MoreInformationPhoto]
    

    enum CodingKeys: String, CodingKey {
         case title
         case sources
         case isTranslatedByGoogle
         case landmarkDescription = "description:"
         case header, coordinates, moreInformation, moreInformationPhotos
     }
}

// MARK: - MoreInformation
struct MoreInformation: Codable {
    let title, content: String
}

struct LandmarkSource: Codable{
    let link: String
}

struct LandmarkHeader: Codable{
    let name: String
    var copyright: String?=nil
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let lat, log: Double
}

// MARK: - MoreInformationPhoto
struct MoreInformationPhoto: Codable {
    let name: String
    let copy: String
}

typealias Landmark = [LandmarkElement]
