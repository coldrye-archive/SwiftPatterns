//
//  SimpleSingleton.swift
//
//  Created by Carsten Klein on 15-03-07.
//

import Foundation

/// This is the standard singleton pattern.
///
/// See also:
///     - http://code.martinrue.com/posts/the-singleton-pattern-in-swift
///     - https://github.com/hpique/SwiftSingleton
class SimpleSingleton {

    class var INSTANCE : SimpleSingleton {
        struct Static {
            static var instance : SimpleSingleton?
            static var token : dispatch_once_t = 0
        }

        dispatch_once(&Static.token) {
            Static.instance = SimpleSingleton()
        }

        return Static.instance!
    }
}

// MARK: Usage

SimpleSingleton.INSTANCE
