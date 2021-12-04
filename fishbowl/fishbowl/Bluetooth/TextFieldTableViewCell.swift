//  Adapted from from Tim Oliver's DittoLive Project (see acknowledgements)
//

import UIKit

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    public var textFieldChangedHandler: ((String) -> Void)?

    // MARK: Text Field Delegate

    func textFieldDidEndEditing(_ textField: UITextField) {
        var deviceName = textField.text
        if deviceName?.count ?? 0 == 0 { deviceName = textField.placeholder ?? "Ditto" }

        textFieldChangedHandler?(deviceName!)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
