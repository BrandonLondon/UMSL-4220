import UIKit
import struct ObjectLibrary.Pokédex
final class ListTableViewCell: UITableViewCell {
  @IBOutlet private weak var lblName: UILabel!
}

extension ListTableViewCell {
    func setup(pokemon: Pokédex.Entry) {
        lblName.text = pokemon.displayText
    }
}
