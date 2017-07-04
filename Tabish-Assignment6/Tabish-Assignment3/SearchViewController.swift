//
//  SearchViewController.swift
//  Tabish-Assignment3
//
//  Created by Tabish Umer Farooqui on 16/06/2017.
//  Copyright © 2017 Tabish Umer Farooqui. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UITableViewController, EntityViewControllerInterface {

    @IBOutlet weak var refreshHandler: UIRefreshControl!
    
    var entity:EntityBase?
    private var entityArray = [EntityBase]()
    private var filteredEntityArray = [EntityBase]()
    
    var fetchedResultsController: NSFetchedResultsController<Item>!
    let backgroundDataCoordinator:BackgroundDataCoordinator = BackgroundDataCoordinator()
    
    let searchController = UISearchController(searchResultsController: nil)
    let allScope = "All"
    var currentScope:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.topItem?.title = "Item Search"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelHandler(sender:)))
        self.loadTableData()
        currentScope = allScope
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = [allScope, String(describing: EntityType.Item), String(describing: EntityType.Bin), String(describing: EntityType.Location)]
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func initializeFetchedResultsController() {
        let coreDataFetch:CoreDataFetch = CoreDataFetch()
        fetchedResultsController = coreDataFetch.getFetchedResultsController()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func loadTableData()    {
        backgroundDataCoordinator.requestAndLoadEntities(objectType: "Item")
//        do {
//            let fetchUtility = FetchUtility()
//            entityArray = fetchUtility.fetchSortedLocation()!
//        } catch {
//            print("Fetch error \(error.localizedDescription)")
//        }
//        filteredEntityArray = entityArray
        
//        entityArray.append(Item(name: "Swift Training", qty:1, bin: Bin(name: "Information Technology", location: Location(name: "Central Library"))))
//        entityArray.append(Item(name: "iOS Swift Basics", qty:12, bin: Bin(name: "iOS APPs Development", location: Location(name: "City Library"))))
//        entityArray.append(Item(name: "Inferno by Dan Brown", bin: Bin(name: "Literature", location: Location(name: "Uni Library"))))
//        entityArray.append((entityArray[0] as! Item).bin!)
//        entityArray.append((entityArray[1] as! Item).bin!)
//        entityArray.append((entityArray[2] as! Item).bin!)
//        entityArray.append((entityArray[0] as! Item).bin!.location!)
//        entityArray.append((entityArray[1] as! Item).bin!.location!)
//        entityArray.append((entityArray[2] as! Item).bin!.location!)
//        filteredEntityArray = entityArray
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell", for: indexPath)
        let item = self.fetchedResultsController?.object(at: indexPath)
        cell.textLabel?.text = "\(item?.entityTypeValue ?? "<none>"): \((item?.name!)!)"
        cell.detailTextLabel?.text = "Bin: \(item?.itemToBinFK?.name ?? "<none>"), Location: \(item?.itemToBinFK?.binToLocationFK?.name ?? "<none>")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.entity = filteredEntityArray[indexPath.row]
        print("\(String(describing: self.entity?.name!)) selected")
        self.performSegue(withIdentifier: "unwindToAddItem", sender: self)
    }
    
    
    func filterContentForSearchText(_ searchText: String, scope: String) {
//        filteredEntityArray = entityArray.filter({[weak self] ( entity : EntityBase) -> Bool in
//            self!.currentScope = scope
//            let entityTypeMatch = (self!.currentScope == self!.allScope || String(describing:entity.entityType!) == scope)
//            let name = entity.name!.lowercased()
//            print("\(String(describing:entity.entityType!)) \(name) entityTypeMatch: \(entityTypeMatch) searchTextMatch: \(searchText == "" || entity.name!.lowercased().contains(searchText.lowercased()))")
//            return entityTypeMatch && (searchText == "" || entity.name!.lowercased().contains(searchText.lowercased()))
//        })
//        tableView.reloadData()
    }
    
    func cancelHandler(sender: UIBarButtonItem) {
        print("Cancel clicked!")
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
