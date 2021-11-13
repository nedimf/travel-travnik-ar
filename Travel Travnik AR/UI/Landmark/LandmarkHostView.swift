//
//	LandmarkHostView
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import SwiftUI

struct LandmarkHostView: View {
    @State var landmarks: Landmark? = nil
    @State var searchText = ""
    @State var openRandomLandmark = false
    @State var randomNumber = 0
    @State var searchHint = ""

    
    var body: some View {
        VStack{
            VStack(){
                if let landmarks = landmarks {
                    NavigationLink(destination: LandmarkDetailedView(landmark: landmarks[randomNumber]), isActive: $openRandomLandmark){
                        EmptyView()
                    }
                }
               
                // -MARK: Search bar
                ZStack(alignment: .center){
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.05))
                        .shadow(radius: 8)
                        .frame(width: UIScreen.main.bounds.width - 25, height: 50)
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.black)
                        TextField(
                            searchHint,
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
                                    if let unWrapLandmark = landmarks {
                                        landmarks = unWrapLandmark.filter{
                                            $0.title.contains(searchText)
                                        }
                                    }
                                }
                            })
                    }.padding()
                }
            }.padding()
            
            ScrollView(.horizontal) {
                LazyHStack {
                    if let landmarks = landmarks {
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
            
            
        }
        
        .onAppear {
            
            landmarks = Bundle.main.decode(Landmark.self, from: "landmarks.json")

            if let landmarks = landmarks {
                searchHint = landmarks[Int.random(in: 0..<landmarks.count)].title
            }
            
        }
        .navigationTitle("Monuments")
        .toolbar {
            Image(systemName: "cube.fill")
                .onTapGesture {
                    if let landmarks = landmarks {
                        openRandomLandmark = true
                    randomNumber = Int.random(in: 0..<landmarks.count)
                    

                    }
                    
                    print("random destination")
                }
        }
    }
}

struct LandmarkHostView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkHostView(landmarks: .init())
    }
}
