//
//	LandmarkDetailedView
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import SwiftUI

struct LandmarkDetailedView: View {
    
    @State var landmark: Landmark
    @State var isARButtonClicked = false

    var body: some View {
        ScrollView {
                   MapView()
                       .ignoresSafeArea(edges: .top)
                       .frame(height: 300)

            CirclePhotoLandmarkView(image: Image("house"))
                       .offset(y: -130)
                       .padding(.bottom, -130)

                   VStack(alignment: .leading) {
                       Text("Ivo Andrić")
                           .font(.title)
                           .foregroundColor(.primary)

                       HStack {
                           Text("Birth house of nobel recepient Ivo Andrić")
                           Spacer()
                           Text("Travnik, BiH")
                       }
                       .font(.subheadline)
                       .foregroundColor(.secondary)

                       Divider()

                       Text("About monument")
                           .font(.title2)
                       Text("Ivo Andrić was born into a craftsman’s family in Dolac in Bosnia-Herzegovina, which was then part of the Austro-Hungarian Empire. After schooling in Višegrad and Sarajevo, Andric studied subjects such as history and philosophy at universities in Zagreb, Vienna, Graz, and Crakow. Andric worked for an association of southern Slavic countries, and after the formation of Yugoslavia, he served as a diplomat for the country. Beginning in the 1940s, he devoted himself mainly to his writing. Andric married late and had no children.\n\nIvo Andric initially wrote poetry, and his ideas were influenced by such philosophers as Kierkegaard. However, it was the historical epic that would become his main literary genre. Andric’s works, including his novel Na Drini cuprija (The Bridge on the Drina), illuminate the destinies of individuals against a historical, cultural, and religious background. His stories not only convey great affection for people but also depict violence and cruelty. His stories are rich in astute psychological observations, and his language is characterized by simplicity and a wealth of details.\n\nVisitors can see the birth room with furnitures, a library with works in various languages, a room dedicated to the novel 'Travnička hronika' and in the corridors are placed copies of drawings of Zuka Dzumhur as an illustration for a short story 'Priča o vezirom slonu' and the photographs taken during the last visit of Andrić to Travnik.")
                   }
                   .padding()

                   Spacer()
        }
        .navigationTitle("Ivo Andrić")
        .toolbar{
            Image(systemName: "cube.transparent")
                .onTapGesture {
                    isARButtonClicked = true
                }
        }
        .sheet(isPresented: $isARButtonClicked, onDismiss: {
        }, content: {
            ARView()
        })
        .navigationBarTitleDisplayMode(.automatic)
    }
}

struct ARView: UIViewControllerRepresentable{
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> ViewController {
        let arController = ViewController()
        //arController.monumentShow = "l"
        return arController
    }
}

struct LandmarkDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetailedView(landmark: Landmark(title: "", description: "", header: nil, moreInformation: .init()))
    }
}
