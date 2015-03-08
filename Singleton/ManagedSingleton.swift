//
//  ManagedSingleton.swift
//
//  Created by Carsten Klein on 15-03-07.
//

import Foundation


// MARK: Public

/// Protocol to which all singletons must conform.
protocol Singleton : AnyObject {}

/// Protocol to which all long lived singletons must conform.
protocol LongLivedSingleton : Singleton {}

/// The class `SingletonManager` models a singelton manager for instances of
/// `Singleton`.
class SingletonManager : LongLivedSingleton {

    /// Gets the singleton instance for this.
    class var INSTANCE : SingletonManager {
        return SingletonManager.getInstance(SingletonManager.self) {
            SingletonManager()
        }
    }

    /// Returns the singleton instance for the specified type.
    func getInstance<T: Singleton>(
        type: T.Type, factory: () -> AnyObject) -> T {
            return SingletonManager.getInstance(type, factory: factory)
    }

    /// Removes all singletons except for instances of `LongLivedSingleton`.
    class func gc() {
        for key in instances.keys {
            let instance : Instance = instances[key]!
            if !(instance.type is LongLivedSingleton) {
                instance.gc()
            }
        }
    }

    /// Destroys all instances.
    class func destroy() {
        instances.removeAll(keepCapacity: false)
    }

    ///
    private class func getInstance<T: Singleton>(
        type: T.Type, factory: () -> AnyObject) -> T {
            let fqname : String = toString(type)
            var instance : Instance? = instances[fqname]
            if instance == nil {
                instance = Instance(type: type, factory: factory as () -> AnyObject)
                instances[fqname] = instance
            }
            return instance!.getInstance() as! T
    }
}

// MARK: Private

/// The class `Instance` models a holder for singleton instances and their
/// respective factories.
class Instance {
    var factory: () -> AnyObject
    var type: AnyClass
    var token: dispatch_once_t = 0
    var instance: AnyObject? = nil

    func getInstance() -> AnyObject {
        dispatch_once(&self.token) {
            self.instance = self.factory()
        }
        return self.instance!
    }

    init(type: AnyClass, factory: () -> AnyObject) {
        self.type = type
        self.factory = factory
    }

    func gc() {
        self.instance = nil
        self.token = 0
    }
}

/// The singleton instances.
var instances = [String: Instance]()


// MARK: Usage

class ExampleShortLivedSingleton : Singleton {

    /// Use either computed properties or getters or methods here.
    ///
    /// **Note** Do not use stored properties as we do not want to hold a
    /// reference to the instance here.
    class var INSTANCE : ExampleShortLivedSingleton {
        return SingletonManager.INSTANCE.getInstance(
            ExampleShortLivedSingleton.self) {
                ExampleShortLivedSingleton()
        }
    }

    // The same but with a getter.
    class var INSTANCE2 : ExampleShortLivedSingleton {
        get {
            return SingletonManager.INSTANCE.getInstance(
                ExampleShortLivedSingleton.self) {
                    ExampleShortLivedSingleton()
            }
        }
    }

    // The same but with a function
    class func INSTANCE3() -> ExampleShortLivedSingleton {
        return SingletonManager.INSTANCE.getInstance(
            ExampleShortLivedSingleton.self) {
                ExampleShortLivedSingleton()
        }
    }
}


class ExampleLongLivedSingleton : LongLivedSingleton {

    class var INSTANCE : ExampleLongLivedSingleton {
        return SingletonManager.INSTANCE.getInstance(ExampleLongLivedSingleton.self) {
            ExampleLongLivedSingleton()
        }
    }
}


// Access the instances so that they become available
ExampleShortLivedSingleton.INSTANCE
ExampleLongLivedSingleton.INSTANCE

// Garbage collect all short lived singletons
SingletonManager.gc()

// We will get a new instance...
ExampleShortLivedSingleton.INSTANCE2

// The same instance as before
ExampleLongLivedSingleton.INSTANCE

// Garbage collect all singletons
SingletonManager.destroy()

// A new instance
SingletonManager.INSTANCE
ExampleShortLivedSingleton.INSTANCE3()
// Also a new instance
ExampleLongLivedSingleton.INSTANCE
