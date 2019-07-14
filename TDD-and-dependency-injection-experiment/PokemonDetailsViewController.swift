import UIKit
import SwiftyJSON
import RxSwift
import Kingfisher
import RxDataSources

struct SectionOfPokemonDetails {
  var header: String
  var items: [Item]
}

extension SectionOfPokemonDetails: SectionModelType {
  typealias Item = String
  
  init(original: SectionOfPokemonDetails, items: [Item]) {
    self = original
    self.items = items
  }
}

class PokemonDetailsViewController: UIViewController {
  var apiWrapper: ApiWrapper?
  var pokemon: Pokemon?
  var disposeBag = DisposeBag()
  
  @IBOutlet weak var pokemonImageView: UIImageView!
  @IBOutlet weak var pokemonNameLabel: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var detailsTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let pokemon = pokemon {
      pokemonNameLabel.text = pokemon.name
      apiWrapper?.getPokemonWith(id: pokemon.name!).subscribe(
        onSuccess: { pokemon in
          self.pokemonImageView.kf.setImage(
            with: URL(string: pokemon["sprites"]["front_default"].string!),
            placeholder: self.activityIndicator as! PlaceholderView
          )
          
          let dataSource = RxTableViewSectionedReloadDataSource<SectionOfPokemonDetails>(
            configureCell: { dataSource, tableView, indexPath, item in
              let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
              cell.textLabel?.text = item
              
              return cell
            }
          )
          
          dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
          }
          
          let types = pokemon["types"].map({ pair in
            let (_, type) = pair
            let name = type["type"]["name"].string!
            
            return name
          } as ((String, JSON)) -> String)
          
          let abilities = pokemon["abilities"].map({ pair in
            let (_, ability) = pair
            let name = ability["ability"]["name"].string!
            
            return name
          } as ((String, JSON)) -> String)
          
          let moves = pokemon["moves"].map({ pair in
            let (_, move) = pair
            let name = move["move"]["name"].string!
            
            return name
          } as ((String, JSON)) -> String)
          
          let sections = [
            SectionOfPokemonDetails(header: "Types", items: types),
            SectionOfPokemonDetails(header: "Abilities", items: abilities),
            SectionOfPokemonDetails(header: "Moves", items: moves),
          ]
          
          Observable.just(sections)
            .bind(to: self.detailsTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        }
      ).disposed(by: disposeBag)
    }
  }
}
