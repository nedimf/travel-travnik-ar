//
//	RestaurantDetailedView
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import SwiftUI

struct RestaurantDetailedView: View {
    var body: some View {
        ScrollView {
                   MapView()
                       .ignoresSafeArea(edges: .top)
                       .frame(height: 300)

            CirclePhotoLandmarkView(image: Image("gradska-kafana-lipa"))
                       .offset(y: -130)
                       .padding(.bottom, -130)

                   VStack(alignment: .leading) {
                       Text("Gradska kafana LIPA")
                           .font(.title)
                           .foregroundColor(.primary)

                       HStack {
                           Text("Gradska kafana Lipa")
                           Spacer()
                           Text("Travnik")
                       }
                       .font(.subheadline)
                       .foregroundColor(.secondary)

                       Divider()

                       Text("About restaurant")
                           .font(.title2)
                       Text("Gradska kafana LIPA is located in center of Travnik, it has vast amount of drinks available for everyones taste.\n\nTo learn more about this restaurant please visit their [web site](http://location.com). Click on right corner icon to get directions to the **Gradska kafa LIPA**")
                   }
                   .padding()

                   Spacer()
        }
        .navigationTitle("LIPA")
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
        RestaurantDetailedView()
    }
}
