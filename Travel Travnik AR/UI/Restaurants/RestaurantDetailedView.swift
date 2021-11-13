//
//	RestaurantDetailedView
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import SwiftUI
import MapKit

struct RestaurantDetailedView: View {
    @State var restaurant: RestaurantElement
    
    var body: some View {
        ScrollView {
            MapView(region: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
                       .ignoresSafeArea(edges: .top)
                       .frame(height: 300)

            CirclePhotoLandmarkView(image: Image(restaurant.image))
                       .offset(y: -130)
                       .padding(.bottom, -130)

                   VStack(alignment: .leading) {
                       Text(restaurant.title)
                           .font(.title)
                           .foregroundColor(.primary)

                       HStack {
                           Text(restaurant.title)
                           Spacer()
                           Text("Travnik")
                       }
                       .font(.subheadline)
                       .foregroundColor(.secondary)

                       Divider()

                       Text("About restaurant")
                           .font(.title2)
                       //Very risky, but this is only option we can do so far on this
                       try! Text(AttributedString(markdown: restaurant.about))
                   }
                   .padding()

                   Spacer()
        }
        .navigationTitle(restaurant.title)
        .toolbar{
            Image(systemName: "car.fill")
                .onTapGesture {
                    print("directions")
                }
        }
        .navigationBarTitleDisplayMode(.automatic)
    }
}

struct RestaurantDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailedView(restaurant: RestaurantElement(title: "", about: "", image: "", latitude: 0.0, longitude: 0.0, stars: 1))
    }
}
