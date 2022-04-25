//
//	TopNavigationView
//  Travel Travnik AR
//	Created by: @nedimf on 25/11/2021


import SwiftUI

struct TopNavigationView: View {
    @State var routeDirectionImageRepresentation = ""
    @State var routeDirectionCurrentInstruction = ""
    @State var routeDirectionNextInstruction = ""
    @State var showTopNavigationView = false
    
    var notificationForRouteDirectionImageRepresentation = NotificationCenter.default.publisher(for: .routeDirectionImageRepresentation)
    
    var notificationForRouteDirectionCurrentInstruction = NotificationCenter.default.publisher(for: .routeDirectionCurrentInstruction)
   
    var notificationForRouteDirectionNextInstruction = NotificationCenter.default.publisher(for: .routeDirectionNextInstruction)
    
    var notificationShowTopNavigationView = NotificationCenter.default.publisher(for: .showTopNotificationView)
    
    @State var arrow = ""    
    var body: some View {
            VStack{
         if(showTopNavigationView){
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.green.opacity(0.85))
                    VStack{
                        HStack(spacing: 20){
                            VStack(alignment: .center, spacing: 15){
                                Image(systemName: arrow)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .padding(.leading, 20)
                            }
                            VStack(alignment: .leading, spacing: 10){
                                
                                Text(routeDirectionCurrentInstruction)
                                    .font(.system(size: 20))
                                    .bold()
                                    .padding(.trailing, 5)

                               
                            }
                        }
                        
                    }.foregroundColor(.white)
                    
                }
            }
        }
        
        .onReceive(notificationShowTopNavigationView, perform: { dataObject in
            
            let value = dataObject.object! as! Bool
            self.showTopNavigationView = value
            
        })
        .onReceive(notificationForRouteDirectionCurrentInstruction, perform: { dataObject in
            
            let dict = dataObject.object as! [String: String]
           
            if let currentInstruction = dict["currentInstruction"] {
                self.routeDirectionCurrentInstruction = currentInstruction
            }
        })
        .onReceive(notificationForRouteDirectionNextInstruction, perform: { dataObject in
            
            let dict = dataObject.object as! [String: String]
           
            if let nextInstruction = dict["nextInstruction"] {
                self.routeDirectionCurrentInstruction = nextInstruction
            }
            
        })
        .onReceive(notificationForRouteDirectionImageRepresentation, perform: { dataObject in
            
            let dict = dataObject.object as! [String: String]
           
            if let imageRepresentation  = dict["imageRepresentation"] {
                
                if(imageRepresentation.lowercased().contains("left")){
                    self.arrow = "arrow.turn.up.left"
                }
                else if(imageRepresentation.lowercased().contains("right")){
                    self.arrow = "arrow.turn.up.right"
                }
                else if(imageRepresentation.lowercased().contains("continue")){
                    self.arrow = "arrow.turn.left.up"
                }
                else if(imageRepresentation.lowercased().contains("back")){
                    self.arrow = "arrow.turn.left.down"

                }
                else if(imageRepresentation.lowercased().contains("u-turn")){
                    self.arrow = "arrow.uturn.left"
                }
                else{
                    self.arrow = "mappin.and.ellipse"
                }
            
            }
            
        })
        .frame(height: 150)
    }
}

struct TopNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TopNavigationView()
    }
}
