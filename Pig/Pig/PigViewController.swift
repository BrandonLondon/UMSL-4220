import UIKit
import ObjectLibrary

final class PigViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var lblRollButton: RoundButton!
    @IBOutlet weak var lblHoldButton: RoundButton!
    @IBOutlet weak var lblResetButton: RoundButton!
    @IBOutlet weak var gametitle: UILabel!
    @IBOutlet weak var playerOnePoints: UILabel!
    @IBOutlet weak var playerTwoPoints: UILabel!
    @IBOutlet weak var playerTotalPoints: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!

    lazy var model = {
        return PigModel(delegate: self)
    }()
    
    var timer: Timer?
    var rollCount = 0

    @IBAction func rollButtonTapped(_ sender: Any) {
      rollDie()
    }
    
    func enableButtons(_ enabled: Bool) {
        lblResetButton.isEnabled = enabled
        lblHoldButton.isEnabled = enabled
        lblRollButton.isEnabled = enabled
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginNewGame()
    }
    
    @IBAction func resetButton(_ sender: Any) {
        beginNewGame()
    }
    
    @IBAction func holdButton(_ sender: Any) {
        model.hold()
        
    }
    
    @IBAction func rollButton(_ sender: Any) {
        model.roll()
    }
    
    func beginNewGame() {
        model.beginNewGame()
        imageIcon.image = UIImage(named: "pig")
        
    }
    
    func rollDie() {
         enableButtons(false)
         rollCount = Int.random(in: 10...20)
         timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(rollRandom), userInfo: nil, repeats: true)
       }
           
       @objc func rollRandom() {
         let randomDie = Die.allCases.randomElement()!
         update(randomDie)
         if rollCount == 0 {
           enableButtons(true)
           model.roll()
           timer?.invalidate()
           timer = nil
         }
         rollCount -= 1
       }
}

extension PigViewController: PigModelDelegate {
    func update(_ die: Die) {
        imageIcon.image = die.face
    }
    func update(_ rolledPoints: Int) {
        self.playerTotalPoints.text = String(rolledPoints)
        if rolledPoints > 0 {
          lblHoldButton.isEnabled = true
        }
    }
    
    func willChange(player: Player) {
        playerTotalPoints.text = "0"
        lblRollButton.isEnabled = true
        lblHoldButton.isEnabled = false
    
    }
    
    func updateScore(for player: Player) {
        let totalPoints = String(player.totalPoints)
        switch player.id {
        case Player.Identifier.one:
            playerOnePoints.text = totalPoints
        case Player.Identifier.two:
            playerTwoPoints.text = totalPoints
        }
        
    }
    
    func updateGameLog(text: String) {
        gametitle.text = text
        
    }
    
    func notifyWinner(alerTitle: String, message: String, actionTitle: String) {
        presentSingleActionAlert(alerTitle: alerTitle, message: message, actionTitle: actionTitle, completion: beginNewGame)
    }
}
