//
//	Debug
//  Travel Travnik AR
//	Created by: @nedimf on 29/10/2021


import Foundation
import SwiftUI

// Extension on DEBUG to handle print statements as closures
extension NSObject{
    func debugThis(closure: () -> Void){
        #if DEBUG
            closure()
        #endif
    }
}
