//
//	RestaurantRowView
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import SwiftUI

struct RestaurantRowView: View {
    var body: some View {
        VStack{
            MapView()
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            CirclePhotoLandmarkView(image: Image("gradska-kafana-lipa"))
                .offset(y: -130)
                .padding(.bottom, -130)
            
            HStack(alignment: .center){
                ForEach(0...4, id: \.self){_ in
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.yellow)
                }
            }
            .padding(.top, 5)
            
            VStack(alignment: .leading) {
              
                HStack{
                    Text("Gradska Kafana Lipa")
                        .font(.title)
                }.padding(.bottom, 5)
            
                HStack {
                    Text("Restaurant ")
                        .font(.subheadline)
                    Spacer()
                    Text("Bosanska bb")
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
        RestaurantRowView()
    }
}
