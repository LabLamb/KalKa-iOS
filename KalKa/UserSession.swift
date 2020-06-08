//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

class UserSession {
    
    static let shared = UserSession()
    
    private init() {}
    
    var isPremium: Bool {
        return true
    }
    
    var currentStoreName: String {
        return ""
    }

}
