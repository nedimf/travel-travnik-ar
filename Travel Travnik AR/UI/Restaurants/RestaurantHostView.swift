//
//	RestaurantHostView
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import SwiftUI
import MapKit

struct RestaurantHostView: View {
    @State var restaurants = [Restaurant]()
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
                            "lipa",
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
                                    restaurants = restaurants.filter{
                                        $0.title.contains(searchText)
                                    }
                                }
                            })
                    }.padding()
                }
            }.padding()
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(restaurants, id: \.id) { restaurant in
                        NavigationLink(destination: RestaurantDetailedView()) {
                            RestaurantRowView()
                                .foregroundColor(.black)
                        }
                        .onAppear {
                            print(restaurants)
                        }
                    }
                }
            }
            
            
        }
        
        .onAppear {
            
            restaurants.append(Restaurant(title: "Rest1", description: "Some description", mapCoordinates: CLLocationCoordinate2D(latitude: 21.2312, longitude: -123.232) ))
            restaurants.append(Restaurant(title: "Rest2", description: "Some description", mapCoordinates: CLLocationCoordinate2D(latitude: 21.2312, longitude: -123.232) ))
            restaurants.append(Restaurant(title: "Rest3", description: "Some description", mapCoordinates: CLLocationCoordinate2D(latitude: 21.2312, longitude: -123.232) ))
            
        }
        .navigationTitle("Restaurants")
        .toolbar {
            Image(systemName: "cube.fill")
                .onTapGesture {
                    print("random destination")
                }
        }
    }
}

struct RestaurantHostView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantHostView()
    }
}
