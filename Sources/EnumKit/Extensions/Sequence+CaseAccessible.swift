//
//  Sequence+CaseAccessible.swift
//  EnumKit
//
//  Created by Giuseppe Lanza on 13/08/2019.
//

import Foundation

public extension Sequence where Element: CaseAccessible {
    func filter(case: Element) -> [Element] {
        return filter {
            $0 ~= `case`
        }
    }
    
    func filter<AssociatedValue>(case pattern: (AssociatedValue) -> Element) -> [Element] {
        return filter {
            $0 ~= pattern
        }
    }
    
    func exclude(case: Element) -> [Element] {
        return filter {
            $0 !~= `case`
        }
    }
    
    func exclude<AssociatedValue>(case pattern: (AssociatedValue) -> Element) -> [Element] {
        return filter {
            $0 !~= pattern
        }
    }
    
    func flatMap<S: Sequence, AssociatedValue, T>(case pattern: (AssociatedValue) -> Element,
                                                  _ transform: (AssociatedValue) throws -> S) rethrows -> [T] where S.Element == T {
        return try associatedValues(case: pattern)
            .flatMap { try transform($0) }
    }
    
    func compactMap<AssociatedValue, T>(case pattern: (AssociatedValue) -> Element,
                                        _ transform: (AssociatedValue) throws -> T?) rethrows -> [T] {
        return try compactMap { try $0.flatMap(case: pattern, transform) }
    }
    
    func associatedValues<AssociatedValue>(case pattern: (AssociatedValue) -> Element) -> [AssociatedValue] {
        return compactMap { $0[case: pattern] }
    }
    
    func forEach<AssociatedValue>(case pattern: (AssociatedValue) -> Element, _ body: (AssociatedValue) throws -> Void) rethrows {
        try forEach {
            guard let value = $0.associatedValue(matching: pattern) else { return }
            try body(value)
        }
    }
}
