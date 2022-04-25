//
//	SettingViewModel
//  Travel Travnik AR
//	Created by: @nedimf on 27/11/2021


import Foundation
import SwiftUI
import Combine

class SettingViewModel: ObservableObject{
    private enum Keys{
        static let betaStepByStepDirection = "beta_step_by_step_direction"
    }
    
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
           self.defaults = defaults

           defaults.register(defaults: [
               Keys.betaStepByStepDirection: false,
            ])
       }
    
    var isBetaDirectionsEnabled: Bool {
            set { defaults.set(newValue, forKey: Keys.betaStepByStepDirection) }
            get { defaults.bool(forKey: Keys.betaStepByStepDirection) }
        }
}
