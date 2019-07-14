import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

struct RequestError: Error {
  let errorDescription: String
  
  init(errorDescription: String) {
    self.errorDescription = errorDescription
  }
}

let apiRoot = "https://pokeapi.co/api/v2"

class ApiWrapper {
  func genericGetRequest(_ url: URL) -> Observable<JSON> {
    return Observable<JSON>.create({ observer in
      Alamofire
        .request(url, method: .get)
        .validate()
        .responseJSON(completionHandler: { response in
          if !response.result.isSuccess {
            observer.onError(RequestError(errorDescription: "Error while fetching data"))
            observer.onCompleted()
          }
          
          if let json = try? JSON(data: response.data!) {
            observer.onNext(json)
            observer.onCompleted()
          }
        })
      return Disposables.create()
    })
  }
  
  func getAllPokemons() -> Observable<[Pokemon]> {
    let url = URL(string: "\(apiRoot)/pokemon")!
    return genericGetRequest(url).map { json in
      if let results = json["results"].array {
        return results.map({ result in
          return Pokemon(json: result)
        })
      } else {
        return []
      }
    }
  }
  
  func getPokemonWith(id pokemonId: String) -> Single<Pokemon> {
    let url = URL(string: "\(apiRoot)/pokemon/\(pokemonId)")!
    return genericGetRequest(url).map { Pokemon(json: $0) }.asSingle()
  }
}
