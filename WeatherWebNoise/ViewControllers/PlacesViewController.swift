import UIKit
import CoreLocation

class PlacesViewController: BaseViewController {
    // MARK: - IBOutlets
    @IBOutlet weak private var placesTableView: UITableView!
    
    // MARK: - Properties
    private lazy var viewModel = PlacesViewModel()
    let TempCellIdentifier = "PlaceDetailsCell"
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
    }
    
    func initViewModel() {
        
        viewModel.updateLoadingStatus = {
            
            DispatchQueue.main.async {
                [weak self] () in
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.showActivityIndicator()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.placesTableView.alpha = 0.0
                    })
                } else {
                    self?.hideActivityIndicator()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.placesTableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure =  {
            [weak self] () in
            DispatchQueue.main.async {
                self?.placesTableView.reloadData()
            }
        }
        
        viewModel.showAlertClosure =  {
            [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.initializeLocationManager()
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Activity Indicator
    
    /**
     This method creates and show the Activity indicator which is required to show when async is made.
     */
    func showActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style =
            .gray
        
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            window.addSubview(activityIndicator)
            window.backgroundColor = .white
            activityIndicator.startAnimating()
        }
    }
    
    /**
     This method hides Activity indicator which is shown earlier on async call.
     */
    func hideActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }
}

// MARK: - TableViewDataSource
extension PlacesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TempCellIdentifier, for: indexPath) as! PlaceDetailsCell
        cell.viewModel = viewModel.getModel(at: indexPath)
        return cell
    }
}

extension PlacesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK:- Custom Cell
class PlaceDetailsCell: UITableViewCell {
    @IBOutlet weak private var labelArea: UILabel!
    @IBOutlet weak private var labelTemperature: UILabel!
    @IBOutlet weak private var labelHumidity: UILabel!
    
    var viewModel: PlaceCellRepresentable? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        labelArea.text = viewModel?.area
        labelTemperature.text = viewModel?.temparature
        labelHumidity.text = viewModel?.humidity
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelArea.text = nil
        labelTemperature.text = nil
        labelHumidity.text = nil
    }
}
