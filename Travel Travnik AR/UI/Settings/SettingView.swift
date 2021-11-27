//
//	SettingView
//  Travel Travnik AR
//	Created by: @nedimf on 27/11/2021


import SwiftUI
import Combine

struct SettingView: View {
    @ObservedObject var settings = SettingViewModel()
    var body: some View {
            VStack{
                Form{
                    Section(header: Text("Maps"),
                            footer: Text("In App Instruction is a feature that allows user turn-to-turn navigation inside the app trough specially designed view. **This feature is experimental, so it may not perform correctly in some cases.**")){
                        Toggle(isOn: $settings.isBetaDirectionsEnabled) {
                            Text("In App Route Instructions")
                        }
                    }
                }
            }
            .navigationTitle(Text("Settings"))
        
        
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
