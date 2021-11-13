//
//	TourHostBottomView
//  Travel Travnik AR
//	Created by: @nedimf on 13/11/2021


import SwiftUI
import CoreLocation


struct TourHostBottomView: View {
    @State var landmarks:Landmark
    @State var mapWrapper: MapWrapper?=nil
    var body: some View {
        VStack{
         
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    if let landmarks = landmarks {
                        ForEach(landmarks, id: \.id) { landmark in
                                TourRowView(landmark: landmark)
                                    .padding()
                                    .onTapGesture {
                                        
                                        let coord = CLLocationCoordinate2D(latitude: landmark.coordinates.lat, longitude: landmark.coordinates.log)
                                        
                                        getRoute(l1: coord)

                                        
                                    }
                            .onAppear {
                                print(landmark)
                            }
                        }
                    }
                }
            }
        }.onAppear{
          
            //Get nearest points based on current place coordinates
            //Check if current place is available, after x seconds again to sort array correctly
            if let mapWrapper = mapWrapper {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    let sortedLandmarks = mapWrapper.getNearestPoints(array: landmarks)
                    if let sortedLandmarks = sortedLandmarks {                    self.landmarks = sortedLandmarks                        
                    }
                    print(sortedLandmarks)
                }
            }
        }
        .frame(height: 100)
    }
    
    
    private func getRoute(l1: CLLocationCoordinate2D){
        
        if let mapWrapper = mapWrapper {
            
            let m1 = MapLocationPoints(title: "1", locationName: "1", discipline: "1", image: UIImage(systemName: "mappin.and.ellipse"), coordinate: l1)
            
            let m2 = MapLocationPoints(title: "2", locationName: "2", discipline: "2", image: UIImage(systemName: "mappin.and.ellipse"), coordinate: mapWrapper.currentPlace!.coordinate)
            
            let route = mapWrapper.setRouteOnMap(l1: m1, l2: m2, transportType: .walking)
        }
    }
}

struct TourHostBottomView_Previews: PreviewProvider {
    static var previews: some View {
        TourHostBottomView(landmarks: .init())
    }
}
