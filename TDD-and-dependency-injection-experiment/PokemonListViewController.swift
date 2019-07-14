import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

class PokemonListViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var apiWrapper: ApiWrapper?
  var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    apiWrapper?.getAllPokemons()
      .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, pokemon, cell) in
        cell.textLabel?.text = pokemon.name?.capitalized
      }
      .disposed(by: disposeBag)
    
    tableView.rx
      .modelSelected(Pokemon.self)
      .subscribe(onNext:  { pokemon in
        self.performSegue(withIdentifier: "PokemonDetailsViewController", sender: pokemon)
      })
      .disposed(by: disposeBag)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PokemonDetailsViewController" {
      let pokemon = sender as! Pokemon
      let vc = segue.destination as! PokemonDetailsViewController
      vc.pokemon = pokemon
    }
  }

}

