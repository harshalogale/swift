//
//  QuakeDetailsViewControllerTests.swift
//  SampleQuake
//
//  Created by Harshal Ogale on 2/27/17.
//  Copyright © 2017. All rights reserved.
//

import XCTest
@testable import SampleQuake

final class QuakeDetailsViewControllerTests: XCTestCase {
    var detailsVC: QuakeDetailsViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailsVC") as? QuakeDetailsViewController
        
        // force loading subviews and setting outlets
        let _ = detailsVC.view
        detailsVC.viewDidLoad()
    }
    
    func testTableViewDelegate() {
        XCTAssertTrue(detailsVC.isKind(of: UIViewController.self))
        XCTAssertTrue(detailsVC.conforms(to: UITableViewDelegate.self))
        XCTAssertTrue(detailsVC.conforms(to: UITableViewDataSource.self))
    }
    
    func testPropertiesTable() {
        var quake = Quake()
        quake.code = "15442458";
        quake.datetime = 1488746079.539;
        quake.depth = 41.9;
        quake.identifier = "ak15442458";
        quake.latitude = 62.1421;
        quake.longitude = -150.059;
        quake.magnitude = 2.1;
        quake.magnitudeType = "ml";
        quake.place = "11km W of Y = Alaska";
        quake.status = "automatic";
        quake.title = "M 2.1 - 11km W of Y = Alaska";
        quake.type = "earthquake";
        
        detailsVC.quake = quake;
        
        detailsVC.viewWillAppear(false)
        
        XCTAssertEqual(8, detailsVC.propertiesTable.numberOfRows(inSection: 0))
        
        var cell = detailsVC.propertiesTable.cellForRow(at: IndexPath(row: 0, section: 0)) as! QuakePropertyTableViewCell
        XCTAssertEqual("ID", cell.nameLabel.text)
        XCTAssertEqual("ak15442458", cell.valueLabel.text)
        
        cell = detailsVC.propertiesTable.cellForRow(at: IndexPath(row: 1, section: 0)) as! QuakePropertyTableViewCell
        XCTAssertEqual("Code", cell.nameLabel.text)
        XCTAssertEqual("15442458", cell.valueLabel.text)
        
        cell = detailsVC.propertiesTable.cellForRow(at: IndexPath(row: 2, section: 0)) as! QuakePropertyTableViewCell
        XCTAssertEqual("Place", cell.nameLabel.text)
        XCTAssertEqual("11km W of Y = Alaska", cell.valueLabel.text)
        
        cell = detailsVC.propertiesTable.cellForRow(at: IndexPath(row: 3, section: 0)) as! QuakePropertyTableViewCell
        XCTAssertEqual("Coordinates", cell.nameLabel.text)
        XCTAssertEqual("62.1421, -150.059", cell.valueLabel.text)
        
        cell = detailsVC.propertiesTable.cellForRow(at: IndexPath(row: 4, section: 0)) as! QuakePropertyTableViewCell
        XCTAssertEqual("Depth", cell.nameLabel.text)
        XCTAssertEqual("41.9 km", cell.valueLabel.text)
        
        cell = detailsVC.propertiesTable.cellForRow(at: IndexPath(row: 5, section: 0)) as! QuakePropertyTableViewCell
        XCTAssertEqual("Datetime", cell.nameLabel.text)
        XCTAssertEqual("Sun, Mar 5, 2017, 20:34:39 UTC", cell.valueLabel.text)
        
        cell = detailsVC.propertiesTable.cellForRow(at: IndexPath(row: 6, section: 0)) as! QuakePropertyTableViewCell
        XCTAssertEqual("Magnitude", cell.nameLabel.text)
        XCTAssertEqual("2.1 ml", cell.valueLabel.text)
        
        cell = detailsVC.propertiesTable.cellForRow(at: IndexPath(row: 7, section: 0)) as! QuakePropertyTableViewCell
        XCTAssertEqual("Status", cell.nameLabel.text)
        XCTAssertEqual("automatic", cell.valueLabel.text)
    }
}
