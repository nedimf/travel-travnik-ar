//
//	TourRowView
//  Travel Travnik AR
//	Created by: @nedimf on 13/11/2021


import SwiftUI

struct TourRowView: View {
    @State var landmark: LandmarkElement
    var body: some View {
            VStack{
                ZStack{
                    Rectangle()
                        .foregroundColor(Color.white.opacity(0.8))
                    HStack(alignment: .top){
                        CirclePhotoLandmarkView(image: Image(landmark.header.name), frame: CGSize(width: 60, height: 60), radius: 20)
                        
                    
                    VStack(alignment: .leading){
                        Text(landmark.title)
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(Color(UIColor.Custom.black))
                        Text("Calculated route")
                            .font(.system(size: 14))
                            .foregroundColor(Color(UIColor.Custom.black).opacity(0.7))

                            
                    }
                }
            }
            
        }.frame(width: 250, height: 80)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
            .overlay(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).stroke(Color.white, lineWidth: 1.5))
            .shadow(radius: 7)
        .padding()
    }
}

struct TourRowView_Previews: PreviewProvider {
    static var previews: some View {
        TourRowView(landmark: LandmarkElement(header: LandmarkHeader(name: "", copyright: ""), isTranslatedByGoogle: false, title: "123", landmarkDescription: "", moreInformation: [MoreInformation(title: "lol", content: "lol")], coordinates: Coordinates(lat: 34.343, log: 233.34), sources: [LandmarkSource(link: "")], moreInformationPhotos: [MoreInformationPhoto(name: "lol", copy: "")]))
    }
}
