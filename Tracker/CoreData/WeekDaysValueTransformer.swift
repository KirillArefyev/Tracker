//
//  WeekDaysValueTransformer.swift
//  Tracker
//
//  Created by Кирилл Арефьев on 01.08.2024.
//

import Foundation

@objc (WeekDaysValueTransformer)
final class WeekDaysValueTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass { NSData.self }
    
    override class func allowsReverseTransformation() -> Bool { true }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [WeekDay] else { return nil }
        do {
            let data = try JSONEncoder().encode(days)
            return data
        } catch {
            assertionFailure("Failed to transform `[WeekDay]` to `Data`")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        do {
            let days = try JSONDecoder().decode([WeekDay].self, from: data as Data)
            return days
        } catch {
            assertionFailure("Failed to transform `Data` to `[WeekDay]`")
            return nil
        }
    }
}

extension WeekDaysValueTransformer {
    static func register() {
        let name = NSValueTransformerName(rawValue: String(describing: WeekDaysValueTransformer.self))
        let transformer = WeekDaysValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
