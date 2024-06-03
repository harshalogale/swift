//
//  QuakeDetailsViewController.swift
//  SampleQuake
//
//  Created by Harshal Ogale on 2/25/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

/// View controller to show a details of a single earthquake.
final class QuakeDetailsViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var propertiesTable: UITableView!
    
    var dtQuake: Date? = nil
    var strDate: String? = nil
    var strLatLon: String? = nil
    var strMag: String? = nil
    
    var quake: Quake? {
        didSet {
            if let quake = quake {
                if let dt = quake.datetime {
                    dtQuake = Date.init(timeIntervalSince1970: dt)
                    strDate = "\(QuakeDetailsViewController.dateFormatter.string(from: dtQuake!)) UTC"
                }
                if let lat = quake.latitude, let lon = quake.longitude {
                    strLatLon = String.localizedStringWithFormat("%g, %g", lat, lon)
                }
                if let mag = quake.magnitude, let magType = quake.magnitudeType {
                    strMag = String.localizedStringWithFormat("\(mag) \(magType)")
                }
            }
        }
    }
    
    static let KEY_REUSE_IDENTIFIER_PROPERTY_CELL_WHITE = "propertyCellWhite"
    static let KEY_REUSE_IDENTIFIER_PROPERTY_CELL_GRAY = "propertyCellGray"
    
    static let GEOJSON_PROPERTY_ID = "ID"
    static let GEOJSON_PROPERTY_CODE = "Code"
    static let GEOJSON_PROPERTY_PLACE = "Place"
    static let GEOJSON_PROPERTY_COORDINATES = "Coordinates"
    static let GEOJSON_PROPERTY_DEPTH = "Depth"
    static let GEOJSON_PROPERTY_DATETIME = "Datetime"
    static let GEOJSON_PROPERTY_MAGNITUDE = "Magnitude"
    static let GEOJSON_PROPERTY_STATUS = "Status"
    
    /// list of properties to be extracted from the GeoJSON
    static let propertyNames = [QuakeDetailsViewController.GEOJSON_PROPERTY_ID, QuakeDetailsViewController.GEOJSON_PROPERTY_CODE, QuakeDetailsViewController.GEOJSON_PROPERTY_PLACE, QuakeDetailsViewController.GEOJSON_PROPERTY_COORDINATES, QuakeDetailsViewController.GEOJSON_PROPERTY_DEPTH, QuakeDetailsViewController.GEOJSON_PROPERTY_DATETIME, QuakeDetailsViewController.GEOJSON_PROPERTY_MAGNITUDE, QuakeDetailsViewController.GEOJSON_PROPERTY_STATUS]
    
    /// shared date formatter for UTC timezone
    static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.dateFormat = "E, MMM d, yyyy, HH:mm:ss"
        return df
    }()
    
    var propertyValues: [String]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // partial config to support dynamic height of table view cells depending on label height
        propertiesTable.estimatedRowHeight = 60
        propertiesTable.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let quake = quake {
            titleLabel.text = quake.title
            let qId = quake.identifier ?? ""
            let qCode = quake.code ?? ""
            let qPlace = quake.place ?? ""
            let qDepth = nil != quake.depth ? "\(quake.depth!) km" : ""
            let qStatus = quake.status ?? ""
            let qLatLon = strLatLon ?? ""
            let qMagnitude = strMag ?? ""
            let qDate = strDate ?? ""
            propertyValues = [qId, qCode, qPlace, qLatLon, qDepth, qDate, qMagnitude, qStatus]
        }
        
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! QuakeMapViewController
        dest.quakes = [quake!]
    }
}

extension QuakeDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QuakeDetailsViewController.propertyNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseId = indexPath.row % 2 == 0 ? QuakeDetailsViewController.KEY_REUSE_IDENTIFIER_PROPERTY_CELL_GRAY : QuakeDetailsViewController.KEY_REUSE_IDENTIFIER_PROPERTY_CELL_WHITE
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as! QuakePropertyTableViewCell
        cell.nameLabel.text = QuakeDetailsViewController.propertyNames[indexPath.row]
        cell.valueLabel.text = propertyValues![indexPath.row]
        
        return cell
    }
}

