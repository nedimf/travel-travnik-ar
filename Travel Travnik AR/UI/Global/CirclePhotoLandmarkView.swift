//
//	CirclePhotoLandmarkView
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import SwiftUI

struct CirclePhotoLandmarkView: View {
    @State var image: Image
    @State var frame: CGSize?=nil
    @State var radius: CGFloat?=nil
    var body: some View{
        if  let frame = frame {
            if let radius = radius {
                image
                    .resizable()
                    .clipped()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: frame.width, height: frame.height)
                    .clipShape(RoundedRectangle(cornerRadius: radius))
                    .overlay(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 7)
            }
        }else{
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                .overlay(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).stroke(Color.white, lineWidth: 4))
                .shadow(radius: 7)
        }
    }
}
