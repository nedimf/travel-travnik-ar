//
//	RouteStepsListView
//  Travel Travnik AR
//	Created by: @nedimf on 13/11/2021


import SwiftUI

struct RouteStepsListView: View {
    @State  var steps: [String]?=nil
    @Environment(\.presentationMode) var presentationMode
    @State var mapWrapper: MapWrapper?=nil
    @State var showWarning = false
    @State var topNavigationView: UIHostingController<TopNavigationView>?=nil
    var body: some View {
        
        VStack{
            List{
                if let steps = steps {
                    ForEach(steps, id: \.self){ step in
                        Text(step)
                    }
                }
            }
            .toolbar(content: {
               Image(systemName: "xmark.circle")
                    .foregroundColor(.red)
                .onTapGesture {
                    self.showWarning = true
                }
            })
            .alert(isPresented: $showWarning) {
                Alert(title: Text("End Route?"), message: Text("This action will end current route"), primaryButton: Alert.Button.default(Text("End Route"), action: {
                    let dataInfo = false
                    NotificationCenter.default.post(name: .showTopNotificationView, object: dataInfo)
                    presentationMode.wrappedValue.dismiss()
                    if let mapWrapper = mapWrapper {
                        mapWrapper.clearMapViewFromDrawnRoute()
                        
                        if let topNavigationView = topNavigationView {
                            topNavigationView.view!.isUserInteractionEnabled = false
                        }
                    }
                    
                }), secondaryButton: Alert.Button.cancel(Text("Cancel").foregroundColor(.red)))
             }
            .navigationTitle("Instructions")
        }
    }
}

struct RouteStepsListView_Previews: PreviewProvider {
    static var previews: some View {
        RouteStepsListView()
    }
}
