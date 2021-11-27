//
//	RestaurantDetailedView
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import SwiftUI
import MapKit

struct RestaurantDetailedView: View {
    @State var restaurant: RestaurantElement
    @State var mapWrapper: MapWrapper?=nil
    @State var navigationSteps = [String]()
    @State var openDirections = false
    
    var body: some View {
        ScrollView {
            NavigationLink(destination: RouteStepsListView(steps: navigationSteps), isActive: $openDirections){
                EmptyView()
            }
            MapView(region: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
                       .ignoresSafeArea(edges: .top)
                       .frame(height: 300)

            CirclePhotoLandmarkView(image: Image(restaurant.image.name))
                       .offset(y: -130)
                       .padding(.bottom, -130)

                   VStack(alignment: .leading) {
                       Text(restaurant.title)
                           .font(.title)
                           .foregroundColor(.primary)

                       HStack {
                           Text(restaurant.title)
                           Spacer()
                           Text("Travnik")
                       }
                       .font(.subheadline)
                       .foregroundColor(.secondary)

                       Divider()

                       Text("About restaurant")
                           .font(.title2)
                       //Very risky, but this is only option we can do so far on this
                       try! Text(AttributedString(markdown: restaurant.about,options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                   }
                   .padding()

                   Spacer()
        }
        .navigationTitle(restaurant.title)
        .toolbar{
            Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                .onTapGesture {
                    
                    if let mapWrapper = mapWrapper {
                        
                        let m1 = MapLocationPoints(title: restaurant.title, locationName: "1", discipline: "1", image: UIImage(systemName: "mappin.and.ellipse"), coordinate: CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude))
                        
                        if let currentPlace = mapWrapper.currentPlace{
                            
                            let m2 = MapLocationPoints(title: "2", locationName: "2", discipline: "2", image: UIImage(systemName: "mappin.and.ellipse"), coordinate: currentPlace.coordinate)
                            
                            let userDefaults = UserDefaults()
                            let isBetaEnabled = userDefaults.bool(forKey: "beta_step_by_step_direction")
                            if(isBetaEnabled){
                                
                                let route = mapWrapper.setRouteOnMap(l1: m1, l2: m2, transportType: .automobile)
                                
                                if let route = route {
                                    
                                    for step in route.steps{
                                        if (step.instructions != ""){
                                            navigationSteps.append(step.instructions)
                                        }
                                    }
                                    
                                    openDirections = true
                            }
                                
                                
                            }else{
                                mapWrapper.openRouteInMaps(p1: m1, p2: m2, maps: .maps)
                            }
                       
                      
                        }
                    }
                    
                }
        }
        .navigationBarTitleDisplayMode(.automatic)
    }
}

struct RestaurantDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailedView(restaurant: RestaurantElement(googleLink: "", title: "", about: "", image: RestaurantImage(name: "", copy: ""), latitude: 0.0, longitude: 0.0, stars: 1))
    }
}
