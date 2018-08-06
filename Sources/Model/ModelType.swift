//
//  ModelType.swift
//  Boomerang
//
//  Created by Stefano Mondino on 06/08/18.
//

import Foundation
/**
    A single entity that represents a listable object in the MVVM pattern, inside the Model layer.
 
    A Model object is usually something that is created somewhere in the model layer, usually (but not necessarily) immutable, in response to an API call, a local database query, or after reading local files.
    It should be something easy to understand, maintain and manipulate by the developer, but not ready yet to be presented to the final user.
 
    The protocol is empty at the moment, but should be implemented by every object that is intended to be used as model inside Boomerang.
 
 Example:
 
     ```
 struct Product: ModelType {
        var id: String
        var name: String
    }
 
    ```
 */
public protocol ModelType {}
