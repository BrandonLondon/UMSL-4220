extension Contact {
    
    var description: String {
        let firstName = value(for: InputField.firstName) ?? ""
        let lastName = value(for: InputField.lastName) ?? ""
        let phone = value(for: InputField.phone) ?? ""
        let email = value(for: InputField.email) ?? ""
        let street = value(for: InputField.street) ?? ""
        let apartment = value(for: InputField.apartment) ?? ""
        let city = value(for: InputField.city) ?? ""
        let state = value(for: InputField.state) ?? ""
        let zipcode = value(for: InputField.zipcode) ?? ""
        let emergency = value(for: InputField.emergency) ?? ""
        return """
        isEmpty: \(isEmpty)
        \(InputField.firstName.rawValue): \(firstName), isValid: \(InputField.firstName.isValid(value: firstName))
        \(InputField.lastName.rawValue): \(lastName), isValid: \(InputField.lastName.isValid(value: lastName))
        \(InputField.phone.rawValue): \(phone), isValid: \(InputField.phone.isValid(value: phone))
        \(InputField.email.rawValue): \(email), isValid: \(InputField.email.isValid(value: email))
        \(InputField.street.rawValue): \(street), isValid: \(InputField.street.isValid(value: street))
        \(InputField.apartment.rawValue): \(apartment), isValid: \(InputField.apartment.isValid(value: apartment))
        \(InputField.city.rawValue): \(city), isValid: \(InputField.city.isValid(value: city))
        \(InputField.state.rawValue): \(state), isValid: \(InputField.state.isValid(value: state))
        \(InputField.zipcode.rawValue): \(zipcode), isValid: \(InputField.zipcode.isValid(value: zipcode))
        \(InputField.emergency.rawValue): \(emergency)
        """
    }
}
