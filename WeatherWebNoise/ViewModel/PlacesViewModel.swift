import Foundation
import CoreLocation

class PlacesViewModel: NSObject {
    //MARK:- Variables
    lazy var locationManager = CLLocationManager()
    //model array reload closure
    var placesCellModels: [PlaceCellViewModel] = [PlaceCellViewModel]() {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return placesCellModels.count
    }
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    func initializeLocationManager() {
        
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func getPlaces(with appLocation: AppLocation = AppLocation(latitude: 18.572390, longitude: 73.906548)) {
        self.isLoading = true
        APIService().fetchPlaces(for: appLocation) { [weak self] (results: Result<PlacesResponse>) in
            guard let strongSelf = self else { return }
            strongSelf.isLoading = false
            switch results {
            case .success(let data):
                var placesVM = [PlaceCellViewModel]()
                data.list!.forEach({ (place) in
                    placesVM.append(PlaceCellViewModel(model: place))
                })
                strongSelf.placesCellModels += placesVM
            case .error( _):
                DispatchQueue.main.async {
                    self?.alertMessage = "fail to get response"
                }
            }
        }
    }
    
    //MARK:- Utility Methods
    func getModel(at indexpath: IndexPath) -> PlaceCellRepresentable {
        return placesCellModels[indexpath.row]
    }
}

extension PlacesViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        getPlaces(with: AppLocation(latitude: locValue.latitude, longitude: locValue.longitude))
        locationManager.stopUpdatingLocation()
    }
}


protocol PlaceCellRepresentable {
    var area: String? { get set }
    var temparature: String? { get set }
    var humidity: String? { get set }
}

class PlaceCellViewModel: PlaceCellRepresentable {
    var area: String?
    var temparature: String?
    var humidity: String?
    
    init(model: Place) {
        self.area = model.name
        self.temparature = "\(model.main?.temp ?? 0)"
        self.humidity = "\(model.main?.humidity ?? 0)"
    }
}
