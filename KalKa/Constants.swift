//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit

struct Constants {
    
    struct System {
        static let DateFormat = "yyyy-MM-dd"
        static let SupportedMiniumScreenHeight: CGFloat = 667.0
        static let SupportedMiniumScreenWidth: CGFloat = 375.0
        static let AppLanguages: [String] = [
            "English", "简体中文", "繁體中文"
        ]
        
        static let AppLanguageMapping: [String: AppLangauge] = [
            "English": .english,
            "简体中文": .chineseCN,
            "繁體中文": .chineseTW
        ]
    }
    
    struct UI {
        let TabBarHeight = 49
        
        struct Spacing {
            struct Height {
                static let ExSmall: CGFloat = Constants.System.SupportedMiniumScreenHeight * 0.005
                static let Small: CGFloat = Constants.System.SupportedMiniumScreenHeight * 0.01
                static let Medium: CGFloat = Constants.System.SupportedMiniumScreenHeight * 0.025
                static let Large: CGFloat = Constants.System.SupportedMiniumScreenHeight * 0.05
                static let ExLarge: CGFloat = Constants.System.SupportedMiniumScreenHeight * 0.075
            }
            
            struct Width {
                static let ExSmall: CGFloat = Constants.System.SupportedMiniumScreenWidth * 0.005
                static let Small: CGFloat = Constants.System.SupportedMiniumScreenWidth * 0.01
                static let Medium: CGFloat = Constants.System.SupportedMiniumScreenWidth * 0.025
                static let Large: CGFloat = Constants.System.SupportedMiniumScreenWidth * 0.05
                static let ExLarge: CGFloat = Constants.System.SupportedMiniumScreenWidth * 0.075
            }
        }
        
        struct Font {
            struct Bold {
                static let ExSmall = UIFont.boldSystemFont(ofSize: 10)
                static let Small = UIFont.boldSystemFont(ofSize: 12.5)
                static let Medium = UIFont.boldSystemFont(ofSize: 15)
                static let Large = UIFont.boldSystemFont(ofSize: 17.5)
                static let ExLarge = UIFont.boldSystemFont(ofSize: 20)
                static let Hero = UIFont.boldSystemFont(ofSize: 35)
            }
            
            struct Italic {
                static let ExSmall = UIFont.italicSystemFont(ofSize: 10)
                static let Small = UIFont.italicSystemFont(ofSize: 12.5)
                static let Medium = UIFont.italicSystemFont(ofSize: 15)
                static let Large = UIFont.italicSystemFont(ofSize: 17.5)
                static let ExLarge = UIFont.italicSystemFont(ofSize: 20)
                static let Hero = UIFont.italicSystemFont(ofSize: 35)
            }
            
            struct Plain {
                static let ExSmall = UIFont.systemFont(ofSize: 10)
                static let Small = UIFont.systemFont(ofSize: 12.5)
                static let Medium = UIFont.systemFont(ofSize: 15)
                static let Large = UIFont.systemFont(ofSize: 17.5)
                static let ExLarge = UIFont.systemFont(ofSize: 20)
                static let Hero = UIFont.systemFont(ofSize: 35)
            }
        }
        
        struct Sizing {
            struct Height {
                static let ExSmall: CGFloat = Constants.System.SupportedMiniumScreenHeight * 0.05
                static let Small: CGFloat = Constants.System.SupportedMiniumScreenHeight * 0.1
                static let Medium: CGFloat = Constants.System.SupportedMiniumScreenHeight * 0.25
                static let Large: CGFloat = Constants.System.SupportedMiniumScreenHeight * 0.5
                static let ExLarge: CGFloat = Constants.System.SupportedMiniumScreenHeight * 0.75
                static let TextFieldDefault: CGFloat = Constants.System.SupportedMiniumScreenHeight * 0.05 * 1.25
            }
            
            struct Width {
                static let ExSmall: CGFloat = Constants.System.SupportedMiniumScreenWidth * 0.05
                static let Small: CGFloat = Constants.System.SupportedMiniumScreenWidth * 0.1
                static let Medium: CGFloat = Constants.System.SupportedMiniumScreenWidth * 0.25
                static let Large: CGFloat = Constants.System.SupportedMiniumScreenWidth * 0.5
                static let ExLarge: CGFloat = Constants.System.SupportedMiniumScreenWidth * 0.75
            }
        }
    }
}
