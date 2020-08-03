import struct Foundation.UUID
import class ObjectLibrary.Contact
import enum ObjectLibrary.State
import enum ObjectLibrary.InputField

protocol ContactDetailModelDelegate: class {
    func save(isEnabled: Bool)
}

final class ContactDetailModel {
    private(set) var contact: Contact
    private weak var delegate: ContactDetailModelDelegate?
    init(contact: Contact, delegate: ContactDetailModelDelegate) {
        self.contact = contact
        self.delegate = delegate
        self.delegate?.save(isEnabled: isValid(contact: self.contact))
    }
    
    func inputHandler(_ value: String?, for type: InputField) {
        guard let value = value else { return }
        contact = contact.copy(withNewValue: value, for: type)
        self.delegate?.save(isEnabled: isValid(contact: self.contact))
        //Used For testing
        print("---\n\(contact.description)\n---")
        print(isValid(contact: self.contact))
        }
}

extension ContactDetailModel {
   private func isValid(contact: Contact) -> Bool {
        guard !contact.isEmpty else { return false }
        for fields in InputField.sections {
            for inputField in fields {
                guard let fieldValue = contact.value(for: inputField) else { continue }
                guard inputField.isValid(value: fieldValue) else { return false }
            }
        }
        return true
    }
}
