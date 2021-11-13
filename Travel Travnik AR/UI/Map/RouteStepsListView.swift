//
//	RouteStepsListView
//  Travel Travnik AR
//	Created by: @nedimf on 13/11/2021


import SwiftUI

struct RouteStepsListView: View {
    @State  var steps: [String]?=nil
    var body: some View {
        
        VStack{
            List{
                if let steps = steps {
                    ForEach(steps, id: \.self){ step in
                        Text(step)
                    }
                }
            }.navigationTitle("Instructions")
        }
    }
}

struct RouteStepsListView_Previews: PreviewProvider {
    static var previews: some View {
        RouteStepsListView()
    }
}
