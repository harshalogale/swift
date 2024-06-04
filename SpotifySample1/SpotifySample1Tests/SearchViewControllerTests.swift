//
//  SearchViewControllerTests.swift
//  SpotifySample1
//
//  Created by Harshal Ogale
//

import XCTest
@testable import SpotifySample1

final class SearchViewControllerTests: XCTestCase {
    private var searchVC: SearchViewController!
    
    override func setUp() {
        super.setUp()

        searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchViewController") as? SearchViewController
        
        // force loading subviews and setting outlets
        let _ = searchVC.view
        searchVC.viewDidLoad()
    }
    
    func testSearchBarDelegate() {
        XCTAssertTrue(searchVC.isKind(of: UITableViewController.self))
        XCTAssertTrue(searchVC.conforms(to: UISearchBarDelegate.self))
        
        if let searchDelegate = searchVC.searchBox.delegate {
            XCTAssertTrue(searchDelegate === searchVC)
        } else {
            XCTFail("search bar delegate should have been set")
        }
    }
    
}
