import UIKit
import class ObjectLibrary.Contact
import enum ObjectLibrary.State
import enum ObjectLibrary.InputField

protocol ContactDetailViewControllerDelegate: class {
    func add(_ contact: Contact)
}

final class ContactDetailViewController: UIViewController {
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var streetField: UITextField!
    @IBOutlet weak var apartmentField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipcodeField: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var switchField: UISwitch!
    
    private var model: ContactDetailModel!
    private weak var delegate: ContactDetailViewControllerDelegate!
    private var pickerview: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.gestureRecognizers?.forEach {
          $0.delaysTouchesBegan = true
          $0.cancelsTouchesInView = false
        }
        
        pickerview = UIPickerView()
        pickerview.delegate = self
        pickerview.dataSource = self
        stateField.inputView = pickerview
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        phoneNumberField.delegate = self
        emailField.delegate = self
        streetField.delegate = self
        apartmentField.delegate = self
        cityField.delegate = self
        stateField.delegate = self
        zipcodeField.delegate = self
        
        firstNameField.placeholder = InputField.firstName.rawValue
        lastNameField.placeholder = InputField.lastName.rawValue
        phoneNumberField.placeholder = InputField.phone.rawValue
        emailField.placeholder = InputField.email.rawValue
        streetField.placeholder = InputField.street.rawValue
        apartmentField.placeholder = InputField.apartment.rawValue
        cityField.placeholder = InputField.city.rawValue
        stateField.placeholder = InputField.state.rawValue
        zipcodeField.placeholder = InputField.zipcode.rawValue
        
        firstNameField.text = model.contact.value(for: InputField.firstName)
        lastNameField.text = model.contact.value(for: InputField.lastName)
        phoneNumberField.text = model.contact.value(for: InputField.phone)
        emailField.text = model.contact.value(for: InputField.email)
        streetField.text = model.contact.value(for: InputField.street)
        apartmentField.text = model.contact.value(for: InputField.apartment)
        cityField.text = model.contact.value(for: InputField.city)
        statePickerView()
        zipcodeField.text = model.contact.value(for: InputField.zipcode)
        switchField.isOn = (model.contact.value(for: InputField.emergency)! as NSString).boolValue
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
            recognizer.numberOfTapsRequired = 1
            recognizer.numberOfTouchesRequired = 1
            contentView.addGestureRecognizer(recognizer)
    }
    
    private func statePickerView() {
        guard let value = model.contact.value(for: InputField.state) else { return }
        guard let state = State(rawValue: value) else { return }
        stateField.text = state.postalAbbreviation
        guard let stateIndex = State.allCases.firstIndex(of: state) else { return }
        pickerview.selectRow(stateIndex + 1, inComponent: 0, animated: true)
    }
    
    @objc func touch() {
        self.view.endEditing(true)
    }
    @IBAction func firstNameChanged(_ sender: UITextField) {model.inputHandler(sender.text, for: InputField.firstName)
    }
    
    @IBAction func lastNameChanged(_ sender: UITextField) {
        model.inputHandler(sender.text, for: InputField.lastName)
    }
    @IBAction func phoneChanged(_ sender: UITextField) {
        model.inputHandler(sender.text, for: InputField.phone)
    }
    @IBAction func emailChanged(_ sender: UITextField) {
        model.inputHandler(sender.text, for: InputField.email)
    }
    @IBAction func streetChanged(_ sender: UITextField) {
        model.inputHandler(sender.text, for: InputField.street)
    }
    @IBAction func cityChanged(_ sender: UITextField) {
        model.inputHandler(sender.text, for: InputField.city)
    }
    @IBAction func apartmentChanged(_ sender: UITextField) {
        model.inputHandler(sender.text, for: InputField.apartment)
    }
    @IBAction func stateChanged(_ sender: UITextField) {
        model.inputHandler(sender.text, for: InputField.state)
    }
    @IBAction func zipcodeChange(_ sender: UITextField) {
        model.inputHandler(sender.text, for: InputField.zipcode)
    }
    @IBAction func switchBtn(_ sender: UISwitch) {
        model.inputHandler(sender.isOn.description, for: InputField.emergency)
    }
    
    @IBAction func savebtn(_ sender: UIBarButtonItem) {
        delegate.add(model.contact)
    }

    func setup(model: ContactDetailModel, delegate: ContactDetailViewControllerDelegate) {
        self.model = model
        self.delegate = delegate
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
extension ContactDetailViewController: ContactDetailModelDelegate {
    func save(isEnabled: Bool) {
        self.navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
}

extension ContactDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

extension ContactDetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            stateField.text = ""
            model.inputHandler("", for: InputField.state)
        } else {
            let state = State.allCases[row - 1]
            stateField.text = state.postalAbbreviation
            model.inputHandler(state.rawValue, for: InputField.state)
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row == 0 ? "--" : State.allCases[row - 1].rawValue
    }
}

extension ContactDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return State.allCases.count + 1
    }
}
