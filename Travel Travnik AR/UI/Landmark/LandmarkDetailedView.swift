//
//	LandmarkDetailedView
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import SwiftUI
import MapKit

struct LandmarkDetailedView: View {
    
    @State var landmark: LandmarkElement
    @State var isARButtonClicked = false
    @State private var contentForLandmark = ""

    var body: some View {
        ScrollView {
            MapView(region: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: landmark.coordinates.lat, longitude: landmark.coordinates.log),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
                       .ignoresSafeArea(edges: .top)
                       .frame(height: 300)

            CirclePhotoLandmarkView(image: Image(landmark.header))
                       .offset(y: -130)
                       .padding(.bottom, -130)

                   VStack(alignment: .leading) {
                       Text(landmark.title)
                           .font(.title)
                           .foregroundColor(.primary)

                       HStack {
                           Text(landmark.landmarkDescription)
                           Spacer()
                           Text("Travnik, BiH")
                       }
                       .font(.subheadline)
                       .foregroundColor(.secondary)

                       Divider()

                       Text("About monument")
                           .font(.title2)
                       Text(contentForLandmark)
                   }
                   .padding()

                   Spacer()
        }
        .navigationTitle(landmark.title)
        .onAppear{
            for content in landmark.moreInformation {
                contentForLandmark = "\(contentForLandmark)\n\(content.content)"
            }
        
        }
        .toolbar{
            Image(systemName: "cube.transparent")
                .onTapGesture {
                    isARButtonClicked = true
                }
        }
        .sheet(isPresented: $isARButtonClicked, onDismiss: {
        }, content: {
            ARView(landmark: landmark)
        })
        .navigationBarTitleDisplayMode(.automatic)
    }
}

struct ARView: UIViewControllerRepresentable{
    var landmark: LandmarkElement? = nil
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> ARViewController {
        let arController = ARViewController()
        if let landmark = landmark {
            arController.landmark = landmark
        }
        //arController.monumentShow = "l"
        return arController
    }
}

struct LandmarkDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetailedView(landmark: LandmarkElement(title: "", landmarkDescription: "", header: "", moreInformation: [MoreInformation(title: "lol", content: "lol")], coordinates: Coordinates(lat: 324.234, log: 34.234), moreInformationPhotos: [MoreInformationPhoto(name: "lol")]))
    }
}
