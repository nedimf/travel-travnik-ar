//
//	LandmarkRowView
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import SwiftUI
import CoreLocation
import MapKit

struct LandmarkRowView: View {
    
    @State var landmark: LandmarkElement
    
    var body: some View {
        VStack{
            MapView(region: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: landmark.coordinates.lat, longitude: landmark.coordinates.log),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )).ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            CirclePhotoLandmarkView(image: Image(landmark.header.name))
                .offset(y: -130)
                .padding(.bottom, -130)
            
            
            VStack(alignment: .leading) {
                HStack{
                    Text(landmark.title)
                        .font(.system(size: 20))
                        .bold()
                    Spacer()
                    Image(systemName: "cube.transparent")
                        
                }.padding(.bottom, 5)
            
                HStack {
                    Text(landmark.landmarkDescription)
                        .font(.subheadline)
                    Spacer()
                    Text("Travnik")
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

struct LandmarkRowView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkRowView(landmark: LandmarkElement(header: LandmarkHeader(name: "", copyright: ""), isTranslatedByGoogle: false, title: "123", landmarkDescription: "", moreInformation: [MoreInformation(title: "lol", content: "lol")], coordinates: Coordinates(lat: 34.343, log: 233.34), sources: [LandmarkSource(link: "")], moreInformationPhotos: [MoreInformationPhoto(name: "lol", copy: "")]))
    }
}
