
import UIKit

class StoreItemListTableViewController: UITableViewController {
    let storeItemController = StoreItemController()
   
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var filterSegmentedControl: UISegmentedControl!
    
    // add item controller property
    
    var items: [StoreItem] = []
    var photos: [UIImage] = []
    
    let queryOptions = ["movie", "music", "software", "ebook"]
    
    let indicator = UIActivityIndicatorView(style: .large);
    
     
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.addSubview(indicator)
        searchBar.accessibilityScroll(.down) 
        
    }
    
    func fetchMatchingItems() {
        indicator.center = CGPoint(x: Int(self.searchBar.frame.size.width)/2, y: Int(searchBar.frame.height))
        
        indicator.hidesWhenStopped = true
        self.items = []
        
        self.tableView.reloadData()
        
        let searchTerm = searchBar.text ?? ""
        let mediaType = queryOptions[filterSegmentedControl.selectedSegmentIndex]
        
        if !searchTerm.isEmpty {
            let query = [
                "term": searchTerm,
                "media": mediaType,
                "lang": "en_us",
                "limit": "20"

            ]
            Task {
                do {
                    let storeItem = try await storeItemController.fetchItems(matching: query)
                    self.items = storeItem
                    
                        
                    
                    indicator.stopAnimating()
                    tableView.reloadData()
                    storeItem.forEach { item in
                        
                        print("""
                            Artist Name:  \(item.artistName)
                            Track name:   \(item.trackName)
                            Kind:         \(item.kind)
                            Description:  \(String(describing: item.description))
                            Url:          \(item.url)
                            

                            """)
                        
                    }
                } catch  {
                    print(error)
                    indicator.stopAnimating()
                    
                }
            }
            // set up query dictionary
            
            // use the item controller to fetch items
            // if successful, use the main queue to set self.items and reload the table view
            // otherwise, print an error to the console
        }
    }
    
    
    
    
    
    
    func configure(cell: ItemCell, forItemAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        //let photo = photos[indexPath.row]
        
        cell.titleLabel.text = " \(item.trackName)"
        cell.detailLabel.text = item.artistName
        Task{
            do {
                let photo = try await storeItemController.fetchPhoto(from: item.url)
                cell.itemImageView.image = photo
               // self.photos = images
            } catch {
                print(error.localizedDescription)
                cell.itemImageView.image = UIImage(named: "photo.fill")
            }
        }
        
        //cell.itemImageView.image =
        // set cell.titleLabel to the item's name
        
        // set cell.detailLabel to the item's artist
        
        // set cell.itemImageView to the system image "photo"
        
        // initialize a network task to fetch the item's artwork
        
        // if successful, use the main queue capture the cell, to initialize a UIImage, and set the cell's image view's image to the
    }
    
    @IBAction func filterOptionUpdated(_ sender: UISegmentedControl) {
        
        fetchMatchingItems()
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemCell
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       // imageLoadTasks[indexPath] = Task{
            
       // }
    }
    
    
}

extension StoreItemListTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        indicator.startAnimating()
        fetchMatchingItems()
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        indicator.startAnimating()
        fetchMatchingItems()
        
    }
    
}

