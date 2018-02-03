//
//  LocationTableViewController.swift
//  Tyme
//
//  Created by elev on 28/01/2018.
//  Copyright © 2018 Mads Bock. All rights reserved.
//

import UIKit
import CoreLocation

class LocationTableViewController: UITableViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var stops : [LocationStopInfo]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(listRefreshed(_:)), for: .valueChanged)
        
        loadLocationData()
    }
    
    func loadLocationData() {
        refreshControl?.beginRefreshing()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }
    
    @objc func listRefreshed(_ sender:Any) {
        loadLocationData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations[0]
        APILocation().stopsNearby(location: loc) {
            self.stops = $0
            DispatchQueue.main.async {
                self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error: \(error)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let stops = stops else {return 0}
        
        return stops.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loc cell", for: indexPath)
        guard let stop = stops?[indexPath.row] else {return cell}
        
        cell.textLabel?.text = stop.name
        cell.detailTextLabel?.text = "\(stop.distance)m"

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "show detail") {
            if  let detail = segue.destination as? DetailViewController,
                let cell = sender as? UITableViewCell,
                let index = tableView.indexPath(for: cell)?.row,
                let data = stops?[index] {
                
                detail.data = data
            } else {
                print("Something Went Wrong!")
            }
        } else {
            print("Segue was \(segue.identifier)")
        }
    }

}

protocol LocationStopInfo : StopInfo {
    var distance : String {get}
}
