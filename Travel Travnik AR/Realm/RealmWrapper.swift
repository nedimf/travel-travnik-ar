//
//	RealmWrapper
//  Travel Travnik AR
//	Created by: @nedimf on 30/10/2021


import Foundation
import RealmSwift

// RealmWrapper class handles all Realm operation needed for this app to operate properly (read, create)
class RealmWrapper: NSObject{
    
    var localRealm: Realm?
    
    override init() {
        super.init()
        do {
            try localRealm = Realm()
        }catch{
            self.debugThis {
                print("Realm failed to initialise")
            }
        }
    }
    
    func addObject<T> (_ object: T) -> Bool{
        let realmObject = object as! Object
        if let localRealm = localRealm {
            do{
                
                try localRealm.write{
                    localRealm.add(realmObject)
                }
                return true
                
            }catch{
                return false
            }
        }
        
        return false
    }
    
    
}
