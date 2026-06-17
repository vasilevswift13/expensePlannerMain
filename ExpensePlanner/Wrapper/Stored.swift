//
//  Stored.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 23.04.2026.
//

import SwiftUI

@propertyWrapper
struct Stored<Value: Codable>: DynamicProperty {
    let key: String
    let defaultValue: Value

    @State private var value: Value

    var wrappedValue: Value {
        get { value }
        nonmutating set {
            value = newValue
            save(newValue)
        }
    }

    init(wrappedValue: Value, _ key: String) {
        self.key = key
        self.defaultValue = wrappedValue

        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode(Value.self, from: data) {
            _value = State(initialValue: decoded)
        } else {
            _value = State(initialValue: wrappedValue)
        }
    }

    private func save(_ newValue: Value) {
        if let data = try? JSONEncoder().encode(newValue) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
