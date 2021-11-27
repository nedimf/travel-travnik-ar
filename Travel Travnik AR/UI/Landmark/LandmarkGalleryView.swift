//
//	LandmarkGalleryView
//  Travel Travnik AR
//	Created by: @nedimf on 25/11/2021


import SwiftUI

struct LandmarkGalleryView: View {
    @State var landmark: LandmarkElement
    var body: some View {
        VStack{
            List{
                VStack(alignment: .leading){
                    Text("Gallery\n")
                        .font(.system(size: 24))
                        .bold()
                    Text("Images in the app are loaded directly from an app bundle and can be viewed without internet connection. Please note these images are not our property, all rights are reserved by their original owners!")
                        .font(.system(size: 15))
                }
                
                ForEach(landmark.moreInformationPhotos, id: \.self){ photo in
                    VStack{
                        Image(photo.name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            
                        Link(photo.copy, destination: URL(string: photo.copy)!)
                    }
                }
                    
            }
        }
    }
}

struct LandmarkGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkGalleryView(landmark: LandmarkElement(header: LandmarkHeader(name: "", copyright: ""), isTranslatedByGoogle: false, title: "123", landmarkDescription: "", moreInformation: [MoreInformation(title: "lol", content: "lol")], coordinates: Coordinates(lat: 34.343, log: 233.34), sources: [LandmarkSource(link: "")], moreInformationPhotos: [MoreInformationPhoto(name: "lol", copy: "")]))
    }
}
