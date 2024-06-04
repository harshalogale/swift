//
//  FavoritesViewController.swift
//  SpotifySample1
//
//  Created by Harshal Ogale
//

import UIKit

class FavoritesViewController: UIViewController {
    @IBOutlet var favoritesTable: UITableView!

    static let REUSE_ID_FAVORITE_TABLE_VIEW_CELL = "favoriteCell"
    
    var favorites : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let fav = getStoredFavorites() {
            favorites = Array(fav.keys)
        } else {
            favorites = [String]()
        }
        
        favoritesTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FavoritesViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesViewController.REUSE_ID_FAVORITE_TABLE_VIEW_CELL, for: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = favorites![row]
        
        return cell
    }
}

extension FavoritesViewController {
    /// Helper method to extract stored favorites list
    func getStoredFavorites() -> [String:String]? {
        UserDefaults.standard.value(forKey: SearchViewController.USER_DEFAULTS_KEY_FAVORITES) as? [String:String]
    }
}
