//
//  JSONValue.swift
//  Alembic
//
//  Created by Ryo Aoyama on 3/14/16.
//  Copyright © 2016 Ryo Aoyama. All rights reserved.
//

import Foundation

public struct JSONValue {
    let value: AnyObject
    
    private init(value: AnyObject) {
        self.value = value
    }
}

public extension JSONValue {
    init(_ number: NSNumber) {
        value = number
    }
    
    init(_ string: String) {
        value = string
    }
    
    init<T: JSONValueConvertible>(_ array: [T]) {
        value = array.map { $0.jsonValue().value }
    }
    
    init<T: JSONValueConvertible>(_ dictionary: [String: T]) {
        value = dictionary.reduce([String: AnyObject]()) { (var new, old) in
            new[old.0] = old.1.jsonValue().value
            return new
        }
    }
    
    static func null() -> JSONValue {
        return JSONValue(value: NSNull())
    }
}

extension JSONValue: StringLiteralConvertible {
    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension JSONValue: IntegerLiteralConvertible {
    public init(integerLiteral value: Int) {
        self.init(NSNumber(integer: value))
    }
}

extension JSONValue: FloatLiteralConvertible {
    public init(floatLiteral value: Float) {
        self.init(NSNumber(float: value))
    }
}

extension JSONValue: BooleanLiteralConvertible {
    public init(booleanLiteral value: Bool) {
        self.init(NSNumber(bool: value))
    }
}

extension JSONValue: NilLiteralConvertible {
    public init(nilLiteral: ()) {
        self = JSONValue.null()
    }
}

extension JSONValue: ArrayLiteralConvertible {
    public init(arrayLiteral elements: JSONValueConvertible...) {
        let array = elements.map { $0.jsonValue().value }
        self.init(value: array)
    }
}

extension JSONValue: DictionaryLiteralConvertible {
    public init(dictionaryLiteral elements: (String, JSONValueConvertible)...) {
        let dictionary = elements.reduce([String: AnyObject](minimumCapacity: elements.count)) { (var new, element) in
            new[element.0] = element.1.jsonValue().value
            return new
        }
        self.init(value: dictionary)
    }
}