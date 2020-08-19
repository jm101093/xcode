
//
//  FontUtility.swift
//  Notv
//
//  Created by Bitcot Inc on 1/31/16.
//  Copyright © 2016 bitcot. All rights reserved.
//

import UIKit

public func navigationTitleFont() -> UIFont{
    return UIFont(name: "Montserrat-Regular", size: 17.0)!
}

public func navigationTitleFont(size:CGFloat) -> UIFont{
    return UIFont(name: "Montserrat-Regular", size: size)!
}

public func instructoNavigationTitleFont() -> UIFont{
    return UIFont(name: "Montserrat-Regular", size: 16.0)!
}

public func navigationBarButtonTitleFont() -> UIFont{
    if #available(iOS 8.2, *) {
        return UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.light)
    } else {
        // Fallback on earlier versions
        return UIFont.systemFont(ofSize: 18.0)
    }
}

public func placeHolderFont() -> UIFont{
    return UIFont(name: "Montserrat-Regular", size: 16.0)!
}

public func defaultBoldFont(size: CGFloat = 17) -> UIFont {
    return UIFont(name: "Montserrat-Bold", size: size)!
}

public func defaultFont(size:CGFloat) -> UIFont{
    return UIFont(name: "Montserrat-Regular", size: size)!
}
