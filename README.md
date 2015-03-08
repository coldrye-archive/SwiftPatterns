Swift Patterns
--------------


Collection of patterns and how they can be realized using the Swift programming language.



Singleton
---------

Here we take a look at how the singleton can be implemented. First, we use the
simple singleton approach using a nested struct and static properties to hold
our instance and required token for dispatch_once.

Next, we expand on that by introducing the managed singleton. It uses a central
manager for all of your singleton instances. This approach has numerous benefits
of which the most interesting would be the reduction of duplicate code and also
the ability to actually destroy the instances in for example low memory 
situations or reconfiguration of the system and so on.



See also:

.. GitHub

 - https://github.com/ochococo/Design-Patterns-In-Swift
 - https://github.com/hpique/SwiftSingleton

.. Blogs

 - http://code.martinrue.com/posts/the-singleton-pattern-in-swift
