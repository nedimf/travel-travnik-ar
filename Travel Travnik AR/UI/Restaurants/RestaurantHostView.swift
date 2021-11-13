//
//	RestaurantHostView
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import SwiftUI
import MapKit

struct RestaurantHostView: View {
    @State var restaurants: Restaurant? = nil
    @State var searchText = ""
    @State var openRandomRestaurant = false
    @State var randomNumber = 0
    @State var searchHint = ""
    
    var body: some View {
        VStack{
            VStack(){
                if let restaurants = restaurants {
                    NavigationLink(destination: RestaurantDetailedView(restaurant: restaurants[randomNumber]), isActive: $openRandomRestaurant){
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
                                    if let unwrapRestaurant = restaurants{
                                        restaurants = unwrapRestaurant.filter{
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
                    if let restaurants = restaurants {
                        ForEach(restaurants, id: \.id) { restaurant in
                            NavigationLink(destination: RestaurantDetailedView(restaurant: restaurant)) {
                                RestaurantRowView(restaurant: restaurant)
                                    .foregroundColor(.black)
                            }
                            .onAppear {
                                print(restaurants)
                            }
                        }
                    }

                }
            }
            
            
        }
        
        .onAppear {
            
           restaurants = Bundle.main.decode(Restaurant.self, from: "restaurants.json")
            
            if let restaurants = restaurants {
                searchHint = restaurants[Int.random(in: 0..<restaurants.count)].title
            }
            
        }
        .navigationTitle("Restaurants")
        .toolbar {
            Image(systemName: "cube.fill")
                .onTapGesture {
                    if let restaurants = restaurants {
                        openRandomRestaurant = true
                        randomNumber = Int.random(in: 0..<restaurants.count)
                        
                    }
                }
        }
    }
}

struct RestaurantHostView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantHostView()
    }
}
