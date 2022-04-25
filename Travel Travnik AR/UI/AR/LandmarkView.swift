//
//	LandmarkView
//  Travel Travnik AR
//	Created by: @nedimf on 12/11/2021


import SwiftUI

struct LandmarkView: View {
    @State var landmark: LandmarkElement
    @State var cardColor: Color
    var body: some View {
        VStack{
            Rectangle()
                .fill(cardColor)
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            CirclePhotoLandmarkView(image: Image(landmark.header.name))
                    .offset(y: -130)
                    .padding(.bottom, -130)
            
     
            
            
            VStack(alignment: .leading) {
                HStack{
                    Text(landmark.title)
                        .font(.title)
                    Spacer()
                    Image(systemName: "cube.transparent")
                        
                }.padding(.bottom, 5)
            
                HStack {
                    Text("")
                        .font(.subheadline)
                    Spacer()
                    Text("Travnik, BiH")
                        .font(.subheadline)
                }
            }.padding()
            Spacer()
        }
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                .overlay(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)).stroke(Color.gray, lineWidth: 1))
                .shadow(radius: 7)
        .frame(width: 300, height: 200)
        .padding()
    }
}

struct LandmarkView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkView(landmark: LandmarkElement(header: LandmarkHeader(name: "", copyright: ""), isTranslatedByGoogle: false, title: "123", landmarkDescription: "", moreInformation: [MoreInformation(title: "lol", content: "lol")], coordinates: Coordinates(lat: 34.343, log: 233.34), sources: [LandmarkSource(link: "")], moreInformationPhotos: [MoreInformationPhoto(name: "lol", copy: "")]), cardColor: .green)
    }
}
