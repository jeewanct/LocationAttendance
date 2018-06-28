//
//  ReleaseType.swift
//  bdPresence
//
//  Created by Sourabh Shekhar Singh on 27/06/18.
//  Copyright © 2018 Raghvendra. All rights reserved.
//

import Foundation
enum ReleaseType {
    case Unknown
    case Debug
    case Alpha
    case Release
    static func currentConfiguration() -> ReleaseType {
        #if DEBUG
        return .Debug
        #elseif ALPHA
        return .Alpha
        #elseif RELEASE
        return .Release
        #else
        return Unknown
        #endif
    }
}
