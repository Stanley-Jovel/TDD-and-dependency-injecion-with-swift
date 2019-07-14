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
      pokemonNameLabel.text = pokemon.name?.capitalized
      apiWrapper?.getPokemonWith(id: pokemon.name!).subscribe(
        onSuccess: { pokemon in
          self.pokemonImageView.kf.setImage(
            with: URL(string: pokemon.sprite!),
            placeholder: self.activityIndicator as! PlaceholderView
          )
          
          let dataSource = RxTableViewSectionedReloadDataSource<SectionOfPokemonDetails>(
            configureCell: { dataSource, tableView, indexPath, item in
              let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
              cell.textLabel?.text = item.capitalized
              
              return cell
            }
          )
          
          dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
          }
          
          let sections = [
            SectionOfPokemonDetails(header: "Types", items: pokemon.types ?? []),
            SectionOfPokemonDetails(header: "Abilities", items: pokemon.abilities ?? []),
            SectionOfPokemonDetails(header: "Moves", items: pokemon.moves ?? []),
          ]
          
          Observable.just(sections)
            .bind(to: self.detailsTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        }
      ).disposed(by: disposeBag)
    }
  }
}
