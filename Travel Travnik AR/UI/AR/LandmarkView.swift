//
//	LandmarkView
//  Travel Travnik AR
//	Created by: @nedimf on 12/11/2021


import SwiftUI

struct LandmarkView: View {
    @State var landmark: LandmarkElement
    var body: some View {
        VStack{
            Rectangle()
                .fill(Color.green.opacity(0.75))
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            CirclePhotoLandmarkView(image: Image(landmark.header))
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
        LandmarkView(landmark: LandmarkElement(title: "", landmarkDescription: "", header: "", moreInformation: [MoreInformation(title: "lol", content: "lol")], coordinates: Coordinates(lat: 34.343, log: 233.34), moreInformationPhotos: [MoreInformationPhoto(name: "lol")]))
    }
}
