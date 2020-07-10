import Foundation
import class ObjectLibrary.Player
import enum ObjectLibrary.Die

protocol PigModelDelegate: class {
    func update(_ die: Die)
    func update(_ rolledPoints: Int)
    func updateScore(for player: Player)
    func willChange(player: Player)
    func updateGameLog(text: String)
    func notifyWinner(alerTitle: String, message: String, actionTitle: String)
}

final class PigModel {
    // MARK: - Properties

    private let players: [Player]
    private weak var delegate: PigModelDelegate?
    private var isPlayerTurnToggle: Bool = false { didSet { delegate?.willChange(player: currentPlayer) }}
    private var rolledPoints: Int = 0
    private var currentPlayer: Player { players[Int(truncating: isPlayerTurnToggle as NSNumber)] }
    private let maxPoints = 100
        
    init(delegate: PigModelDelegate) {
        self.delegate = delegate
        players = Player.Identifier.allCases.map { Player(id: $0) }
    }
    
    // MARK: - Public methods for use by `PigViewController`
    
    func beginNewGame() {
        rolledPoints = 0
        players.forEach {
            $0.resetTotalPoints()
            delegate?.updateScore(for: $0)
        }
        isPlayerTurnToggle = false
        delegate?.updateGameLog(text: "Welcome to pig \(currentPlayer.name)\n Roll To begin playing")
    }
    
    func roll() {
        let randomDice = Die.allCases.randomElement()!
        delegate?.update(randomDice)
        let rolledPoints = randomDice.value
        var rolledText = "\(currentPlayer.name) rolled a \(rolledPoints). "
        if randomDice == Die.one {
            rolledText += "\(nextPlayer().name) is now playing"
            toggleTurn()
        } else {
            self.rolledPoints += rolledPoints
        }
        delegate?.update(self.rolledPoints)
        delegate?.updateGameLog(text: rolledText)
    }
    
    func hold() {
        updatePlayersScore()
        if currentPlayer.totalPoints < maxPoints {
            delegate?.updateGameLog(text: "\(currentPlayer.name) holds \n \(nextPlayer().name) You're up")
            toggleTurn()
            
        } else {
            delegate?.updateGameLog(text: "\(currentPlayer.name) has won! You Must Very Proud")
            delegate?.notifyWinner(alerTitle: "You Won", message: "\(currentPlayer.name), \nyou won with a score of \(currentPlayer.totalPoints)", actionTitle: "New Game")
            
        }
        delegate?.update(rolledPoints)
    }
    
    private func updatePlayersScore() {
        currentPlayer.updateScore(byAdding: rolledPoints)
        delegate?.updateScore(for: currentPlayer)
    }
    private func toggleTurn() {
        rolledPoints = 0
        isPlayerTurnToggle.toggle()
    }
    private func nextPlayer() -> Player {
      return players[(Int(truncating: isPlayerTurnToggle as NSNumber) + 1) % 2]
    }
}
