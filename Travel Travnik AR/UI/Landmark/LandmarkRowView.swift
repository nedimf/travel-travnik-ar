//
//	LandmarkRowView
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import SwiftUI

struct LandmarkRowView: View {
    
    @State var landmark: Landmark
    var body: some View {
        VStack{
            MapView()
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            CirclePhotoLandmarkView(image: Image(uiImage: landmark.header!))
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
                    Text(landmark.description)
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
        LandmarkDetailedView(landmark: Landmark(title: "", description: "", header: nil, moreInformation: .init()))
    }
}
