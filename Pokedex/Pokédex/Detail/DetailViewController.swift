import UIKit
import class AVFoundation.AVAudioPlayer
import struct ObjectLibrary.Pokémon

final class DetailViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var pokémonPic: UIImageView!
    @IBOutlet private weak var lblHeight: UILabel!
    @IBOutlet private weak var lblType: UILabel!
    // MARK: - Properties
    
    var pokémon: Pokémon!
    private var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = pokémon.displayName
        pokémonPic.image = pokémon.image
        lblHeight.text = "Height: \(pokémon.height)"
        lblType.text = "Type: \(pokémon.displayTypes)"

        NSDataAsset(name: pokémon.displayName).flatMap {
            audioPlayer = try? AVAudioPlayer(data: $0.data, fileTypeHint: "wav")
        }
    }
    
    // MARK: - IBActions
    
    @IBAction private func playButtonTapped(_ sender: Any) {
        if let audio = self.audioPlayer {
            audio.play()
            return
        }
        
        presentSingleActionAlert(alerTitle: "", message: "Audio not available", actionTitle: "OK", completion: {})
    }
}
