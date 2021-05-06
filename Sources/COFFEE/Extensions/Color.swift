//
//  Color.swift
//  COFFEE
//
//  Created by Victor Prüfer on 05.05.21.
//

import Foundation
import SwiftUI

extension Color {
    
    public init(hexString: String) {
        self.init(UIColor(hexString: hexString))
    }
    
    /// Returns a lighter variant of the provided color
    public func lighter(by amount: CGFloat = 0.3) -> Self {
        Self(UIColor(self).lighter(by: amount))
    }
    
    /// Returns a darker variant of the provided color
    public func darker(by amount: CGFloat = 0.3) -> Self {
        Self(UIColor(self).darker(by: amount))
    }
    
    /// Return the hex value of the UIColor instance
    public var hexString: String {
        return UIColor(self).hexString
    }
}
