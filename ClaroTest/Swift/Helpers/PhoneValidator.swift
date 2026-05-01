//
//  PhoneValidator.swift
//  ClaroTest
//
//  Created by Luis Santana on 1/5/26.
//


struct PhoneValidator {
    static func validatePhoneInput(_ value: String) -> String {
        
        var digits = value.filter { $0.isNumber }
        
        if digits.count > 10 {
            digits = String(digits.prefix(10))
        }
        
        guard digits.count > 0 else { return "" }
        
        if !digits.hasPrefix("8") {
            return ""
        }
        
        let validPrefixes = ["809", "829", "849"]
        
        if digits.count < 3 {
            return digits
        }
        
        let prefix = String(digits.prefix(3))
        
        if validPrefixes.contains(prefix) {
            return digits
        } else {
            return String(digits.dropLast())
        }
    }
}
