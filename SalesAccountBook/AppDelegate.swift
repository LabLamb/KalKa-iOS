//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow()
        self.window?.makeKeyAndVisible()
        
        let invVC = UINavigationController(rootViewController: InventoryViewController())
        invVC.tabBarItem = UITabBarItem(title: .inventory, image: #imageLiteral(resourceName: "Inventory"), tag: 1)
        
        let cusVC = UINavigationController(rootViewController: CustomerViewController())
        cusVC.tabBarItem = UITabBarItem(title: .customers, image: #imageLiteral(resourceName: "Customers"), tag: 2)
        
        let tabController = UITabBarController()
        tabController.viewControllers = [
            invVC, cusVC
        ]
        
        self.window?.rootViewController = tabController
        
        return true
    }
}

