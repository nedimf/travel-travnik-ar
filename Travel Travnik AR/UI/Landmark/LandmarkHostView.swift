//
//	LandmarkHostView
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import SwiftUI

struct LandmarkHostView: View {
    @State var landmarks = [Landmark]()
    @State var searchText = ""
    
    var body: some View {
        VStack{
            VStack(){
                ZStack(alignment: .center){
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.05))
                        .shadow(radius: 8)
                        .frame(width: UIScreen.main.bounds.width - 25, height: 50)
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.black)
                        TextField(
                            "Ivo Andric",
                            text: $searchText,
                            onEditingChanged: { (isBegin) in
                                if isBegin {
                                    print("Begins editing")
                                    
                                } else {
                                    print("Finishes editing")
                                }
                            },
                            onCommit: {
                                //get text and filter list
                                if (searchText != ""){
                                    landmarks = landmarks.filter{
                                        $0.title.contains(searchText)
                                    }
                                }
                            })
                    }.padding()
                }
            }.padding()
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(landmarks, id: \.id) { landmark in
                        NavigationLink(destination: LandmarkDetailedView(landmark: landmark)) {
                            LandmarkRowView(landmark: landmark)
                                .foregroundColor(.black)
                        }
                        .onAppear {
                            print(landmark)
                        }
                    }
                }
            }
            
            
        }
        
        .onAppear {
            
            landmarks.append(Landmark(title: "Birth house of Ivo Andric", description: "Birth house of nobel prize winner Ivo Andric", header: UIImage(named: "ivoandric"), moreInformation: .init()))
            landmarks.append(Landmark(title: "Sulejmanija mosque", description: "Sulejmanija mosque", header: UIImage(named: "sarena-dzamija/1"), moreInformation: .init()))
            landmarks.append(Landmark(title: "Plava Voda", description: "Beautiful river side", header: UIImage(named: "plava-voda/p4"), moreInformation: .init()))
            
        }
        .navigationTitle("Monuments")
        .toolbar {
            Image(systemName: "cube.fill")
                .onTapGesture {
                    print("random destination")
                }
        }
    }
}

struct LandmarkHostView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkHostView()
    }
}
