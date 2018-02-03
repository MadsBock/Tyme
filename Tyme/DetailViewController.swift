//
//  SearchDetailTableViewController.swift
//  Tyme
//
//  Created by elev on 20/01/2018.
//  Copyright © 2018 Mads Bock. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let favorites = FavouritesController.instance
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titlebar: UINavigationItem!
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    @IBAction func FavouriteButtonClicked(_ sender: UIBarButtonItem) {
        if let data = data {
            let success = favorites.AddFavourite(withID: data.id, andName: data.name)
            if !success {
                favorites.RemoveFavourite(withID: data.id)
            }
        }
        UpdateFavouriteButton()
    }
    public var data : StopInfo? {
        didSet {
            refreshData()
        }
    }
    
    func refreshData() {
        guard let id = data?.id else {return}
        
        APIDetail().GetDetails(id: id) {
            self.details = $0
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    private var details : [APIDetail.Details]?
    override func viewDidLoad() {
        super.viewDidLoad()
        titlebar.title = data?.name
        UpdateFavouriteButton()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.addTarget(self, action: #selector(refreshList(_:)), for: .valueChanged)
    }
    
    @objc func refreshList(_ sender: Any) {
        refreshData()
    }
    
    func UpdateFavouriteButton() {
        guard let id = data?.id else {return}
        
        favouriteButton.title = favorites.FavouriteExists(withID: id) ? "★" : "☆"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let r = details?.count {
            return r
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchDetail", for: indexPath)
        let detail = details![indexPath.row]
        cell.textLabel?.text = "\(detail.name) - \(detail.direction)"
        cell.detailTextLabel?.text = detail.time
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
