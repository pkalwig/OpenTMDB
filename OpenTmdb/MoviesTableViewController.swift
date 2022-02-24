//
//  MoviesTableViewController.swift
//  OpenTmdb
//
//  Created by ingenico on 24/02/2022.
//

import Foundation
import UIKit

class MoviesTableViewController : UITableViewController
{
    var movies = Array<String>()
    
    override func viewDidLoad() {
        self.title = "The Movies DB"
        movies = ["Shrek", "Tron Legacy", "Friends"]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        cell.textLabel?.text = movies[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
}
