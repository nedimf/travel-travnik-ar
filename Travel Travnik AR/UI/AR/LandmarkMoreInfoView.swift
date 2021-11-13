//
//	LandmarkMoreInfoView
//  Travel Travnik AR
//	Created by: @nedimf on 12/11/2021


import SwiftUI

enum MoreInformationType {
    case basic
    case photoDouble
    case photoGrid
    
}

struct LandmarkMoreInfoView: View {
    @State var landmark: LandmarkElement
    var landmarkPosition = 0
    @State var moreInformationType:MoreInformationType = .basic
    
    var body: some View {
        VStack{
        
            //TODO:: change color to be more randomised
            Rectangle()
                .fill(Color.green.opacity(0.75))
                .ignoresSafeArea(edges: .top)
                .frame(height: 150)
            
            VStack(alignment: .leading) {
                HStack{
                    Text(landmark.title)
                        .font(Font.system(size: 16))
                    Spacer()
                    Image(systemName: "cube.transparent")
                        
                }.padding(.bottom, 5)
            
                HStack {
                    if (landmark.moreInformation[landmarkPosition].title != ""){
                        Text(landmark.moreInformation[landmarkPosition].title)
                            .font(Font.system(size: 12))

                    }else{
                        Text(landmark.landmarkDescription)
                            .font(Font.system(size: 12))

                    }
                    Spacer()
                    Text("Travnik,BiH")
                        .font(.subheadline)
                }

                
                
                
            }.offset(y: -100)
                .foregroundColor(.white)
            .padding()
            
            if(moreInformationType == .basic){
                ZStack(alignment: .topLeading){
                    VStack{
                        Text(landmark.moreInformation[landmarkPosition].content)
                            .foregroundColor(.black)
                            .font(Font.system(size: 12))
                 
                    }
                    
                }
                .padding()
                .padding(.top , -90)
                
                Spacer()
            }
            
            else if (moreInformationType == .photoDouble){
                VStack{
                     
                    Image(landmark.moreInformationPhotos[0].name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Image(landmark.moreInformationPhotos[1].name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    
                    
                }
                .padding(.top , -100)
                .padding()
            }
            
            else if(moreInformationType == .photoGrid){
                VStack{
                    
                    HStack{
                        Image(landmark.moreInformationPhotos[2].name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        Image(landmark.moreInformationPhotos[3].name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    HStack{
                        Image(landmark.moreInformationPhotos[4].name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Image(landmark.moreInformationPhotos[5].name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    
                }
                .padding(.top , -90)
                .padding()
                
            }
        }
        .background(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous).fill(Color.white))
        .overlay(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous).stroke(Color.gray, lineWidth: 1))
        .shadow(radius: 7)
        .frame(width: 300, height: 500)
        .padding()
    }
}

struct LandmarkMoreInfoView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkMoreInfoView(landmark: LandmarkElement(title: "title", landmarkDescription: "lol", header: "plava-voda/1", moreInformation: [MoreInformation(title: "l1", content: "")], coordinates: Coordinates(lat: 0.0, log: 0.0), moreInformationPhotos: [MoreInformationPhoto(name: "plava-voda/2")]), landmarkPosition: 0, moreInformationType: .basic)
.previewInterfaceOrientation(.portrait)
    }
}
