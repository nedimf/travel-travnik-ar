//
//	CirclePhotoLandmarkView
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import SwiftUI

struct CirclePhotoLandmarkView: View {
    @State var image: Image
    var body: some View{
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
            .overlay(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).stroke(Color.white, lineWidth: 4))
            .shadow(radius: 7)
    }
}
