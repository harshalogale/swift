//
//  SearchViewController.swift
//  SpotifySample1
//
//  Created by Harshal Ogale
//

import UIKit
import AVFoundation

class SearchViewController: UITableViewController {

    static let DEFAULT_TABLE_ROW_HEIGHT : CGFloat = 80
    
    static let USER_DEFAULTS_KEY_FAVORITES = "sp_favorites"
    
    static let DEFAULT_ALBUM_IMAGE = UIImage(named: "music_album")!
    static let IMAGE_ADD_FAVORITE = UIImage(named: "star_plus")!
    static let IMAGE_REMOVE_FAVORITE = UIImage(named: "star_minus")!
    
    static let REUSE_ID_SEARCH_TABLE_VIEW_CELL = "searchResultCell"
    static let REUSE_ID_MESSAGE_TABLE_VIEW_CELL = "messageCell"
    
    static let STRING_EMPTY = ""
    static let STRING_CANCEL = "Cancel"
    static let STRING_NO_SEARCH_RESULTS = "No Search Results Found"
    static let STRING_KEYWORD_SEARCH = "Enter Keywords To Search Spotify"
    
    var searchTextCanceled = false
    
    var searchResultMetadata : SPSearchResultMetadata?
    var searchResultItems : [SPAlbum]?
    
    var audioPlayer : AVAudioPlayer?
    
    @IBOutlet weak var resultsTable: UITableView!
    @IBOutlet weak var searchBox: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SearchViewController {
    /// Fires a web request to fetch the next page, if available, for the current search query.
    func loadMore() {
        if searchResultMetadata != nil {
            if let nextUrl = searchResultMetadata?.next {
                // fire web search request
                SpotifyWebRequestHandler.getNextPage(url: nextUrl) { resp in
                    
                    var newResultItems : [SPAlbum]?
                    var newResultMetadata : SPSearchResultMetadata?
                    
                    if let searchResponse = resp {
                        if searchResponse.count > 0 && searchResponse[0].items.count > 0 {
                            newResultItems = searchResponse[0].items
                            newResultMetadata = searchResponse[0].metadata
                        }
                    }
                    
                    // update table view UI on main thread
                    DispatchQueue.main.async {
                        if let newResults = newResultItems {
                            self.searchResultItems?.append(contentsOf: newResults)
                            self.searchResultMetadata = newResultMetadata
                            self.resultsTable.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    /// Helper method to extract stored favorites list
    func getStoredFavorites() -> [String:String]? {
        UserDefaults.standard.value(forKey: SearchViewController.USER_DEFAULTS_KEY_FAVORITES) as? [String:String]
    }
}

extension SearchViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        
        if let searchResults = searchResultItems {
            if searchResults.count > 0 {
                // non-empty search results available
                cell = tableView.dequeueReusableCell(withIdentifier: SearchViewController.REUSE_ID_SEARCH_TABLE_VIEW_CELL, for: indexPath)
                
                guard let resultCell = cell as? SearchResultCell else {
                    return cell
                }
                
                let mediaItem = searchResultItems![indexPath.row]
                
                resultCell.nameLabel.text = mediaItem.name
                resultCell.infoLabel.text = mediaItem.artists
                resultCell.itemImage.contentMode = UIView.ContentMode.scaleAspectFit
                resultCell.itemImage.image = SearchViewController.DEFAULT_ALBUM_IMAGE
                resultCell.delegate = self
                resultCell.searchResultId = mediaItem.id
                
                let dictStoredItems = getStoredFavorites()
                resultCell.favIcon.isHidden = nil == dictStoredItems?[mediaItem.id]
                
                // if this search result item contains image URLs, use the smallest (last) image as the thumbnail
                if let img = mediaItem.images.count > 0 ? mediaItem.images[mediaItem.images.count - 1] : nil {
                    
                    // make album id available to closure
                    let albumId = mediaItem.id
                    
                    // async download the image, so that table loading is not affected
                    NetworkRequestHandler.getImage(url: img.url, allowCached: true) { (data, response, error) in
                        print("inside image download handler: \(img.url)")
                        if let imgData = data {
                            // update the table view cell when the image becomes available
                            DispatchQueue.main.async {
                                // check cell album id is the same
                                if let cell = cell as? SearchResultCell, cell.searchResultId == albumId {
                                    cell.itemImage.image = UIImage(data: imgData)
                                }
                            }
                        }
                    }
                }
            } else {
                // search results were empty
                cell = tableView.dequeueReusableCell(withIdentifier: SearchViewController.REUSE_ID_MESSAGE_TABLE_VIEW_CELL, for: indexPath)
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.textAlignment = NSTextAlignment.center
                let msgText = searchTextCanceled ? SearchViewController.STRING_KEYWORD_SEARCH : SearchViewController.STRING_NO_SEARCH_RESULTS
                cell.textLabel?.text = NSLocalizedString(msgText, comment: SearchViewController.STRING_EMPTY)
            }
        } else {
            // search has not started yet
            cell = tableView.dequeueReusableCell(withIdentifier: SearchViewController.REUSE_ID_MESSAGE_TABLE_VIEW_CELL, for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = NSTextAlignment.center
            cell.textLabel?.text = NSLocalizedString(SearchViewController.STRING_KEYWORD_SEARCH, comment: SearchViewController.STRING_EMPTY)
        }
        
        return cell
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // check if the table view bottom has been reached while scrolling
        if (maximumOffset - currentOffset) <= SearchViewController.DEFAULT_TABLE_ROW_HEIGHT {
            // load next page of search results if available
            self.loadMore()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var searchItemCount = 0
        if let searchResults = searchResultItems {
            searchItemCount = searchResults.count
        }
        
        // either the table contains the search result items or 1 message row
        return max(searchItemCount, 1)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchViewController.DEFAULT_TABLE_ROW_HEIGHT
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curRow = indexPath.row
        let searchResult = self.searchResultItems![curRow];
        
        if nil != audioPlayer && (audioPlayer?.isPlaying)! {
            audioPlayer?.pause()
        } else {
            DispatchQueue.global(qos: .background).async {
                if let audioUrl = URL(string: searchResult.href) {
                    do {
                        let audioData = try Data(contentsOf: audioUrl)
                        DispatchQueue.main.async {
                            do {
                                self.audioPlayer = try AVAudioPlayer(data: audioData)
                                self.audioPlayer?.prepareToPlay()
                                self.audioPlayer?.play()
                            } catch let error as NSError {
                                print("unable to create audio player: \(error)")
                            }
                        }
                    } catch let error as NSError {
                        print("unable to download audio data from url: \(audioUrl) : \(error)")
                    }
                }
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // dismiss keyboard
        self.view.endEditing(true)
        
        // make sure input text is valid
        guard let searchText = searchBar.text else {
            return
        }
        
        let trimmedStr = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !trimmedStr.isEmpty {
            // get currently selected search scope
            let searchType = SpotifyWebRequestHandler.SpotifySearchType(rawValue:searchBar.selectedScopeButtonIndex)
            
            print("calling search for: \(trimmedStr)")
            
            // clear any pending network tasks
            URLSession.shared.getAllTasks(completionHandler: { (tasks) in
                print("canceling all session tasks: \(tasks.count)")
                for task in tasks {
                    task.cancel()
                }
            })
            
            // fire web search request
            SpotifyWebRequestHandler.search(keyword: trimmedStr, searchType: searchType!) { resp in
                // search request completed
                
                print("completed search for: \(trimmedStr)")
                
                var newResultItems : [SPAlbum]?
                var newResultMetadata : SPSearchResultMetadata?
                
                if let searchResponse = resp {
                    if searchResponse.count > 0 && searchResponse[0].items.count > 0 {
                        newResultItems = searchResponse[0].items
                        newResultMetadata = searchResponse[0].metadata
                    }
                }
                
                // reload table view
                OperationQueue.main.addOperation({
                    self.searchResultItems = newResultItems
                    self.searchResultMetadata = newResultMetadata
                    self.resultsTable.reloadData()
                })
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // dismiss keyboard
        self.view.endEditing(true)
        
        // clear search bar input text
        searchBar.text = SearchViewController.STRING_EMPTY
        
        searchTextCanceled = true
        
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.none)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchTextCanceled = false
        
        // make sure the search bar cancel button uses a localized string title
        if let classNavButton = NSClassFromString("UINavigationButton") {
            let topView = searchBar.subviews[0]
            for subView in topView.subviews {
                if (subView.isKind(of: classNavButton)) {
                    let cancelButton = subView as? UIButton
                    
                    let cancelTitle = NSLocalizedString(SearchViewController.STRING_CANCEL, comment: "Cancel Button Title")
                    cancelButton?.setTitle(cancelTitle, for:UIControl.State.normal);
                    break
                }
            }
        }
        
        // temporarily disable scope buttons for unsupported search types
        let scopeView = searchBar.subviews[0].subviews[0].subviews[1] as? UISegmentedControl
        scopeView?.setEnabled(false, forSegmentAt: 1)
        scopeView?.setEnabled(false, forSegmentAt: 2)
        scopeView?.setEnabled(false, forSegmentAt: 3)

        searchBar.showsScopeBar = true
        searchBar.sizeToFit()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.showsScopeBar = false
        
        searchBar.sizeToFit()
    }
}

// handle search result table view cell swipe gesture
extension SearchViewController: MGSwipeTableCellDelegate {
    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection) -> Bool {
        // allow left-to-right cell swipe gesture
        return direction == MGSwipeDirection.leftToRight;
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        let curIndexPath = tableView.indexPath(for: cell)!
        let curRow = curIndexPath.row
        let searchResult = self.searchResultItems![curRow];
        
        // if left-to-right cell swipe gesture is recognized
        if direction == MGSwipeDirection.leftToRight {
            swipeSettings.transition = MGSwipeTransition.border;
            expansionSettings.buttonIndex = 0;
            expansionSettings.fillOnTrigger = true;
            expansionSettings.threshold = 2;
            
            // swipe view background color
            let color = UIColor.init(red:0.0, green:198.0/255.0, blue:87/255.0, alpha:1.0);
            
            // extract stored favorites list
            var dictStoredItems = getStoredFavorites()
            if nil == dictStoredItems {
                // dictionary to store favorite items as [search_item_id:search_item_type] pairs
                dictStoredItems = [String:String]()
            }
            
            // create a swipe button view
            let isFavorite = dictStoredItems![searchResult.id] != nil
            let swipeIcon = SearchViewController.getFavoriteSwipeIcon(isFavorite: !isFavorite)
            
            // left-to-right swipe gesture button to add/remove current item to/from favorites list
            let swipeButton = MGSwipeButton(title: SearchViewController.STRING_EMPTY, icon: swipeIcon, backgroundColor: color) { [unowned unSelf = self] (cell) -> Bool in
                
                // if already stored, then remove item from favorites
                if dictStoredItems![searchResult.id] != nil {
                    let _ = dictStoredItems?.removeValue(forKey: searchResult.id)
                } else {
                    // if not already stored, then add item to favorites
                    dictStoredItems?[searchResult.id] = unSelf.searchResultMetadata?.type
                }
                
                // store the updated favorites list
                UserDefaults.standard.set(dictStoredItems, forKey: SearchViewController.USER_DEFAULTS_KEY_FAVORITES)
                
                // toggle swipe view icon/text
                let newIsFavorite = dictStoredItems![searchResult.id] != nil
                let newSwipeIcon = SearchViewController.getFavoriteSwipeIcon(isFavorite: !newIsFavorite)
                
                // change the swipe button title
                (cell.leftButtons[0] as? UIButton)?.setImage(newSwipeIcon, for: UIControl.State())
                
                // refresh the cell UI to apply the changes
                cell.refreshContentView();
                
                unSelf.tableView.reloadRows(at: [curIndexPath], with: UITableView.RowAnimation.fade)
                
                return true;
            }
            
            return [swipeButton]
        }
        
        return nil
    }
    
    /// Helper method to get button icon for table cell swipe view
    static func getFavoriteSwipeIcon(isFavorite:Bool) -> UIImage {
        return isFavorite ? IMAGE_ADD_FAVORITE : IMAGE_REMOVE_FAVORITE
    }
}
