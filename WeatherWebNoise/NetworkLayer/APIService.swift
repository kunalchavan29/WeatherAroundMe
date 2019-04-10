import Foundation

enum Result<T> {
    case success(T)
    case error(String)
}

protocol ApiServiceProtocol {
    func fetchPlaces(for location: AppLocationPresentable, completion: @escaping (Result<PlacesResponse>) -> Void )
}

class APIService: ApiServiceProtocol {
    init() {
    }
    
    private var baseUrl: String {
        return AppUtility.getValueFromPlist(for: "baseUrl") as? String ?? ""
    }
    
    private var APIKey: String {
        return AppUtility.getValueFromPlist(for: "APIKey") as? String ?? ""
    }
    
    enum ApiEndPoints: String {
        case getLocations = "/data/2.5/find"
    }
   
    func fetchPlaces(for location: AppLocationPresentable, completion: @escaping (Result<PlacesResponse>) -> Void ) {
        
        let urlString = baseUrl + ApiEndPoints.getLocations.rawValue + "?" +  (["lat": location.latitude, "lon": location.longitude, "cnt": 10, "appid": APIKey].queryString?.dropLast() ?? "")
        
        guard let url = URL(string: urlString) else { return completion(.error("Invalid URL, we can't update your feed")) }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else { return completion(.error(error!.localizedDescription)) }
            guard let data = data else { return completion(.error(error?.localizedDescription ?? "There are no new Items to show"))
            }
            do {
                let json = try JSONDecoder().decode(PlacesResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(json))
                }
            } catch let error {
                return completion(.error(error.localizedDescription))
            }
        }.resume()
    }
}

