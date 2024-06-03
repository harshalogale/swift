//
//  QuakeListViewController.swift
//  SampleQuake
//
//  Created by Harshal Ogale on 2/23/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

/// View controller to show a list of earthquakes.
final class QuakeListViewController: UIViewController {

    static let REUSE_ID_QUAKE_TABLE_VIEW_CELL_WHITE = "quakeCellWhite"
    static let REUSE_ID_QUAKE_TABLE_VIEW_CELL_GRAY = "quakeCellGray"
    static let REUSE_ID_MESSAGE_TABLE_VIEW_CELL = "messageCell"
    
    /// shared date formatter for UTC timezone
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.dateFormat = "M/d/yy, HH:mm:ss"
        return df
    }()
    
    var searchResultMetadata: QuakeSearchResultMetadata?
    var earthquakes = [Quake]()
    
    @IBOutlet weak var resultsTable: UITableView!
    @IBOutlet weak var optionsView: UIView!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // use the in-built provision for list refresh
        resultsTable.refreshControl = refreshControl
        
        // partial config to support dynamic height of table view cells depending on label height
        resultsTable.estimatedRowHeight = 100
        resultsTable.rowHeight = UITableView.automaticDimension
        
        refreshQuakeList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = resultsTable.indexPathForSelectedRow {
            resultsTable.deselectRow(at: indexPath, animated: true)
        }
        
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension QuakeListViewController {
    func refreshQuakeList() {
        
        QuakeRequestHelper.fetchQuakeList { result in
            // search request completed
            
            switch result {
            case .failure(let quakeError):
                var msg:String
                switch quakeError {
                case .networkError:
                    msg = "Unable to fetch earthquake info due to network error."
                case .parsingError:
                    msg = "Unable to display earthquake info due to parsing error."
                }
                UIAlertController(title: "Error", message: msg, preferredStyle: .alert).show(self, sender: nil)
            case .success(let quakeResult):
                var newQuakes: [Quake]?
                var newMetadata: QuakeSearchResultMetadata?
                
                newQuakes = quakeResult.items
                newMetadata = quakeResult.metadata
                
                // reload table view
                OperationQueue.main.addOperation({
                    self.earthquakes.removeAll()
                    if let quakes = newQuakes {
                        self.earthquakes.append(contentsOf: quakes)
                    }
                    self.searchResultMetadata = newMetadata
                    self.resultsTable.reloadData()
                    self.resultsTable.refreshControl!.endRefreshing()
                })
            }
        }
    }
}

extension QuakeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if earthquakes.count > 0 {
            let reuseId = indexPath.row % 2 == 0 ? QuakeListViewController.self.REUSE_ID_QUAKE_TABLE_VIEW_CELL_GRAY : QuakeListViewController.self.REUSE_ID_QUAKE_TABLE_VIEW_CELL_WHITE
            let quakeCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! QuakeTableViewCell
            
            let quake = earthquakes[indexPath.row]
            quakeCell.populate(with: quake)
            cell = quakeCell
        } else {
            // show message cell when list is empty
            cell = tableView.dequeueReusableCell(withIdentifier: QuakeListViewController.self.REUSE_ID_MESSAGE_TABLE_VIEW_CELL, for: indexPath)
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(earthquakes.count, 1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionTitle: String? = nil
        
        if self.earthquakes.count > 0 {
            sectionTitle = self.searchResultMetadata?.title
        } else {
            sectionTitle = NSLocalizedString("Recent Earthquakes", comment: "default table section header")
        }
        
        return sectionTitle
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let quakeCell = sender as? QuakeTableViewCell {
            let indexPath = resultsTable.indexPath(for: quakeCell)
            let quake = earthquakes[(indexPath?.row)!]
            
            let detailsVC = segue.destination as! QuakeDetailsViewController
            detailsVC.quake = quake
        } else {
            let dest = segue.destination as! QuakeMapViewController
            dest.quakes = earthquakes
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            refreshQuakeList()
        }
    }
}

