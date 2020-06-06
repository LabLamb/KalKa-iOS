//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import PNPForm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = .buttonIcon
        PNPFormConstants.UI.BaseRowDefaultHeight = Constants.UI.Sizing.Height.TextFieldDefault
        PNPFormConstants.UI.RowConfigDefaultLabelWidth = Constants.UI.Sizing.Width.Medium * 1.25
        
        self.window = UIWindow()
        
        let ordVC = CustomNavigationController(rootViewController: OrderViewController())
        ordVC.tabBarItem = UITabBarItem(title: .orders, image: #imageLiteral(resourceName: "Orders"), tag: 0)
        
        let invVC = CustomNavigationController(rootViewController: InventoryViewController())
        invVC.tabBarItem = UITabBarItem(title: .inventory, image: #imageLiteral(resourceName: "Inventory"), tag: 1)
        
        let cusVC = CustomNavigationController(rootViewController: CustomerViewController())
        cusVC.tabBarItem = UITabBarItem(title: .customers, image: #imageLiteral(resourceName: "Customers"), tag: 2)
        
        let memVC = CustomNavigationController(rootViewController: MembershipViewController())
        memVC.tabBarItem = UITabBarItem(title: .extraFeatures, image: UIImage(named: "Membership"), tag: 3)
        
        let setVC = CustomNavigationController(rootViewController: SettingsViewController())
        setVC.tabBarItem = UITabBarItem(title: .settings, image: #imageLiteral(resourceName: "Settings"), tag: 4)
        
        let tabController: UITabBarController = {
            let result = UITabBarController()
            result.tabBar.barTintColor = .background
            result.tabBar.backgroundImage = UIImage()
            result.tabBar.shadowImage = UIImage()
            result.tabBar.isTranslucent = false
            result.tabBar.tintColor = .buttonIcon
            return result
        }()
        
        tabController.viewControllers = [cusVC, invVC, ordVC, memVC, setVC]
        tabController.selectedIndex = 2
        
        self.window?.rootViewController = tabController
        self.window?.makeKeyAndVisible()
        self.window?.tintColor = .buttonIcon
        
        #if DEBUG
        self.createTestData()
        #endif
        
        return true
    }
    
    private func createTestData() {
        let customersDetails_testData = [
            CustomerDetails(image: nil,
                            address: "8 Longbranch St. Bethlehem, PA 18015",
                            lastContacted: Date(), name: "Rocco Pennington", phone: "91239123", orders: nil, remark: ""),
            CustomerDetails(image: nil,
                            address: "683 Summer Street\nCampbell, CA 95008",
                            lastContacted: Date(), name: "Keaton Davis", phone: "91239123", orders: nil, remark: ""),
            CustomerDetails(image: nil,
                            address: "1 E. Belmont Court Valrico, FL 33594",
                            lastContacted: Date(), name: "Jayson Williams", phone: "91230123", orders: nil, remark: ""),
            CustomerDetails(image: nil,
                            address: "502 Pineknoll Drive King Of Prussia, PA 19406",
                            lastContacted: Date(), name: "Sanaa Chandler", phone: "91231123", orders: nil, remark: ""),
            CustomerDetails(image: nil,
                            address: "7086 NW. Hillcrest Lane Mundelein, IL 60060",
                            lastContacted: Date(), name: "Tatum Villanueva", phone: "91232123", orders: nil, remark: ""),
            CustomerDetails(image: nil,
                            address: "151 North College Lane Worcester, MA 01604",
                            lastContacted: Date(), name: "Keaton Rich", phone: "91233123", orders: nil, remark: ""),
            CustomerDetails(image: nil,
                            address: "8051 Southampton Street Nazareth, PA 18064",
                            lastContacted: Date(), name: "Cael Lynch", phone: "91234123", orders: nil, remark: ""),
            CustomerDetails(image: nil,
                            address: "41 Heather Lane\nReynoldsburg, OH 43068",
                            lastContacted: Date(), name: "Quinn Waters", phone: "91235123", orders: nil, remark: ""),
            CustomerDetails(image: nil,
                            address: "8380 Tarkiln Hill Lane\nPainesville, OH 44077",
                            lastContacted: Date(), name: "Darren Whitehead", phone: "91236123", orders: nil, remark: ""),
            CustomerDetails(image: nil,
                            address: "540 Jefferson Drive\nClemmons, NC 27012",
                            lastContacted: Date(), name: "Alisha Garcia", phone: "91237123", orders: nil, remark: ""),
            CustomerDetails(image: nil,
                            address: "7618 Elizabeth Street\nEncino, CA 91316",
                            lastContacted: Date(), name: "Jazlene Stokes", phone: "91238123", orders: nil, remark: "")
        ]
        
        let custList = CustomerList()
        for custDet in customersDetails_testData {
            custList.add(details: custDet, completion: { _ in })
        }
        
//        let merchDetails_testData = [
//            MerchDetails(name: "Shampoo", price: 36.6, qty: 255, remark: "", image: nil, restocks: []),
//            MerchDetails(name: "Soap", price: 12.2, qty: 125, remark: "", image: nil, restocks: []),
//            MerchDetails(name: "Rubber duck", price: 4.2, qty: 1325, remark: "", image: nil, restocks: []),
//            MerchDetails(name: "Towel", price: 76.8, qty: 234, remark: "", image: nil, restocks: []),
//            MerchDetails(name: "Hair tie", price: 1, qty: 4324, remark: "", image: nil, restocks: []),
//            MerchDetails(name: "Mirror", price: 20, qty: 542, remark: "", image: nil, restocks: [])
//        ]
//
//        let merchList = Inventory()
//        for merchDet in merchDetails_testData {
//            merchList.add(details: merchDet, completion: { _ in })
//        }
    }
}
