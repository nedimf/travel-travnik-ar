//
//	RestaurantRowView
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import SwiftUI
import MapKit

struct RestaurantRowView: View {
    var restaurant: RestaurantElement
    var body: some View {
        VStack{
            MapView(region: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            CirclePhotoLandmarkView(image: Image(restaurant.image.name))
                .offset(y: -130)
                .padding(.bottom, -130)
            
            HStack(alignment: .center){
                ForEach(0..<restaurant.stars, id: \.self){_ in
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.yellow)
                }
            }
            .padding(.top, 5)
            
            VStack(alignment: .leading) {
              
                HStack{
                    Text(restaurant.title)
                        .font(.system(size: 20))
                        .bold()
                }.padding(.bottom, 5)
            
                HStack {
                    Text("Restaurant ")
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

struct RestaurantRowView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantRowView(restaurant: RestaurantElement(googleLink: "", title: "", about: "", image: RestaurantImage(name: "", copy: ""), latitude: 0.0, longitude: 0.0, stars: 1))
    }
}
