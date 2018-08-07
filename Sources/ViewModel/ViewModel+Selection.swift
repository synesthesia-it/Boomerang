//
//  Selection.swift
//  Boomerang
//
//  Created by Stefano Mondino on 06/08/18.
//

import Foundation
import Action

public protocol SelectionInput {}
public protocol SelectionOutput {}

public enum EmptySelection: SelectionOutput {
    case empty
}

public protocol ViewModelTypeSelectable: ViewModelType {
    associatedtype Input = SelectionInput
    associatedtype Output = SelectionOutput
    
    var selection: Action<Input, Output> {get set}
    
}

public protocol ViewModelTypeActionSelectable: ViewModelType {
    func select(withInput input: SelectionInput)
}

/**
 IndexPath can be used as SelectionInput in Actions
 */
extension IndexPath: SelectionInput {}
