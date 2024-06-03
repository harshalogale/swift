//
//  QuakeListViewControllerTests.swift
//  SampleQuake
//
//  Created by Harshal Ogale on 2/27/17.
//  Copyright © 2017. All rights reserved.
//

import XCTest
@testable import SampleQuake

final class QuakeListViewControllerTests: XCTestCase {
    var listVC: QuakeListViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        listVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "listVC") as? QuakeListViewController
        
        // force loading subviews and setting outlets
        let _ = listVC.view
        listVC.viewDidLoad()
    }
    
    func testTableViewDelegate() {
        XCTAssertTrue(listVC.isKind(of: UIViewController.self))
        XCTAssertTrue(listVC.conforms(to: UITableViewDelegate.self))
        XCTAssertTrue(listVC.conforms(to: UITableViewDataSource.self))
    }
    
}
