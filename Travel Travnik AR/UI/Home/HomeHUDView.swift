//
//	HomeHUDView
//  Travel Travnik AR
//	Created by: @nedimf on 30/10/2021


import SwiftUI

protocol HUDClickedDelegate{
    func hudClicked(id: Int, showParking: Bool)
}

struct HomeHUDView: View {
    @State var showParking = false
    
    var delegate: HUDClickedDelegate?
    var body: some View {
        VStack{
            ZStack(alignment: .bottomLeading){
                ScrollView(.horizontal) {
                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white)
                                .frame(width: 200, height: 40)
                            HStack{
                                Image(systemName: "figure.walk")
                                Text("START A TOUR")
                            }
                        }.onTapGesture {
                            delegate?.hudClicked(id: 0, showParking: showParking)
                        }
                        ZStack{
                        
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white)
                                .frame(width: 200, height: 40)
                            HStack{
                                Image(systemName: "mappin.and.ellipse")
                                Text("MONUMENTS")
                            }
                        }.onTapGesture {
                            delegate?.hudClicked(id: 1, showParking: showParking)
                        }
                        
                        ZStack{
                        
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white)
                                .frame(width: 200, height: 40)
                            HStack{
                                Image(systemName: "hands.sparkles.fill")
                                Text("RESTAURANTS")
                                
                            }
                        }.onTapGesture {
                            delegate?.hudClicked(id: 2, showParking: showParking)
                        }
                        
                        ZStack{
                            if(!showParking){

                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.white)
                                    .frame(width: 200, height: 40)
                                
                                HStack{
                                    Image(systemName: "car")
                                    Text("PARKING")
                                    
                                }.foregroundColor(.black)
                                
                            }else{
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.init(red: 63/225, green: 81/225, blue: 181/225))
                                    .frame(width: 200, height: 40)
                                
                                HStack{
                                    Image(systemName: "car")
                                    Text("PARKING")
                                }.foregroundColor(.white)
                            }
                                
                            
                            
                        }.onTapGesture {
                            showParking.toggle()
                            delegate?.hudClicked(id: 3, showParking: showParking)
                        }
                    }
                    .padding()
                    .foregroundColor(.black)
                    .font(.custom("Helvetica", size: 18))
                }.frame(height: 70)
            }

        }.frame(height: 50)
    }
}

struct HomeHUDView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHUDView()
    }
}
