//
//  File.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/13/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

enum NPColorScheme: Int {
    case aqua
    case blue
    case navy
    case purple
    case red
    
    var gradient: [CGColor] {
        switch self {
        case .aqua:
            return [#colorLiteral(red: 0.4862745098, green: 0.8862745098, blue: 0.9254901961, alpha: 1), #colorLiteral(red: 0.2235294118, green: 0.8274509804, blue: 0.8901960784, alpha: 1)]
        case .blue:
            return [#colorLiteral(red: 0.4862745098, green: 0.6666666667, blue: 0.9254901961, alpha: 1), #colorLiteral(red: 0.2235294118, green: 0.4941176471, blue: 0.8901960784, alpha: 1)]
        case .navy:
            return [#colorLiteral(red: 0.5176470588, green: 0.5843137255, blue: 0.9294117647, alpha: 1), #colorLiteral(red: 0.2549019608, green: 0.3607843137, blue: 0.8901960784, alpha: 1)]
        case .purple:
            return [#colorLiteral(red: 0.5294117647, green: 0.4862745098, blue: 0.9254901961, alpha: 1), #colorLiteral(red: 0.2862745098, green: 0.2235294118, blue: 0.8901960784, alpha: 1)]
        case .red:
            return [#colorLiteral(red: 0.9254901961, green: 0.5294117647, blue: 0.4862745098, alpha: 1), #colorLiteral(red: 0.8901960784, green: 0.2862745098, blue: 0.2235294118, alpha: 1)]
        }
    }
    
    var color: UIColor {
        switch self {
        case .aqua:
            return #colorLiteral(red: 0.2235294118, green: 0.8274509804, blue: 0.8901960784, alpha: 1)
        case .blue:
            return #colorLiteral(red: 0.2235294118, green: 0.4941176471, blue: 0.8901960784, alpha: 1)
        case .navy:
            return #colorLiteral(red: 0.2549019608, green: 0.3607843137, blue: 0.8901960784, alpha: 1)
        case .purple:
            return #colorLiteral(red: 0.2862745098, green: 0.2235294118, blue: 0.8901960784, alpha: 1)
        case .red:
            return #colorLiteral(red: 0.8901960784, green: 0.2862745098, blue: 0.2235294118, alpha: 1)
        }
    }
}
