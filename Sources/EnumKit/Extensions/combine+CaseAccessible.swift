//
//  combine+CaseAccessible.swift
//  EnumKit
//
//  Created by Giuseppe Lanza on 17/08/2019.
//

#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Output: CaseAccessible {
    func filter(case: Output) -> Publishers.Filter<Self> {
        return filter { $0 ~= `case` }
    }
    
    func filter<AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Output) -> Publishers.Filter<Self> {
        return filter { $0 ~= pattern }
    }
    
    func exclude(case: Output) -> Publishers.Filter<Self> {
        return filter { $0 !~= `case` }
    }
    
    func exclude<AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Output) -> Publishers.Filter<Self> {
        return filter { $0 !~= pattern }
    }
    
    func capture(case: Output) -> Publishers.CompactMap<Self, Void> {
        return compactMap { $0 ~= `case` ? () : nil }
    }
    
    func capture<AssociatedValue>(case pattern: @escaping (AssociatedValue) -> Output) -> Publishers.CompactMap<Self, AssociatedValue> {
        return compactMap { $0[case: pattern] }
    }
    
    func compactMap<T>(case: Output, _ transorm: @escaping () -> T?) -> Publishers.CompactMap<Self, T> {
        return compactMap {
            guard $0 ~= `case` else { return nil }
            return transorm()
        }
    }
    
    func compactMap<AssociatedValue, T>(case pattern: @escaping (AssociatedValue) -> Output, _ transorm: @escaping (AssociatedValue) -> T?) -> Publishers.CompactMap<Self, T> {
        return compactMap {
            guard let value = $0[case: pattern] else { return nil }
            return transorm(value)
        }
    }
}

#endif
