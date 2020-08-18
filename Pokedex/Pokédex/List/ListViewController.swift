import UIKit
import ObjectLibrary

class ListViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pokeTable: UITableView!
    
    private var model: ListModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? DetailViewController else { return }
        detailViewController.pokémon = sender as? Pokémon
    }
}

extension ListViewController {
    private func configureModel() {
        model = ListModel(
            pokédexPersistence: PokédexPersistence(directoryName: "Pokédex"),
            pokémonPersistence: PokémonPersistence(directoryName: "Pokémon"),
            serviceClient: PokéAPIServiceClient.instance,
            delegate: self
        )
        model.loadPokédex()
    }
}

extension ListViewController: ListModelDelegate {
    func willDownload() {
        DispatchQueue.main.async {
            [weak self] in
            guard let strongboi = self else {return}
            strongboi.activityIndicator.startAnimating()
        }
    }
    func didDownload(error: ServiceCallError?, reloadData: Bool) {
        DispatchQueue.main.async {
            [weak self] in
            guard let strongboi = self else {return}
            strongboi.activityIndicator.stopAnimating()
            
            if error != nil {
                strongboi.presentSingleActionAlert(alerTitle: "Hey Nerd", message: "I can'''naught seem to find any data", actionTitle: "Whatever Homey", completion: {})
            } else if reloadData {
                strongboi.pokeTable.reloadData()
            }
        }
    }
    func show(_ pokémon: Pokémon) {
        DispatchQueue.main.async {
            [weak self] in
            guard let strongboi = self else {return}
            
            strongboi.performSegue(withIdentifier: "pokemon", sender: pokémon)
        }
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.loadPokemon(index: indexPath.row)
        pokeTable.deselectRow(at: indexPath, animated: true)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.pokédex?.entries.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemon") as! ListTableViewCell
        cell.setup(pokemon: model.pokédex.entries[indexPath.row])
        return cell
    }
}
