import Foundation
import enum ObjectLibrary.InputField
import enum ObjectLibrary.State

// create a switch to valid input for each type.
extension InputField {
    func isValid(value: String) -> Bool {
        switch self {
        case .firstName:
            return value.count > 1
        case .lastName:
            return value.count > 1
        case .phone:
            return value.count > 6 && Int(value) != nil
        case .email:
            return value.contains(elements: ["@"])
        case .street:
            return value.count > 2 && letterAndNumbersOnly(value.replacingOccurrences(of: " ", with: ""))
        case .apartment:
            return value.count > 0 && letterAndNumbersOnly(value)
        case .city:
            return value.count > 2 && lettersOnly(value.replacingOccurrences(of: " ", with: ""))
        case .state:
            return State(rawValue: value) != nil
        case .zipcode:
            return value.count > 4 && digitsOnly(value.replacingOccurrences(of: " ", with: ""))
        case .emergency:
            return true
        }
        
    }
    
    //functions that act like regex
    private func lettersOnly(_ value: String) -> Bool {
        return value.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }
    
    private func digitsOnly(_ value: String) -> Bool {
        return value.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    private func letterAndNumbersOnly(_ value: String) -> Bool {
        return value.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil
    }
}
