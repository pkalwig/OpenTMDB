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
    var movies = Array<Movie>()
    
    override func viewDidLoad() {
        self.title = NSLocalizedString("PopularMoviesTitle", comment: "")

        let apiClient = TheMovieDbApiClient(urlSession: URLSession.shared, apiKey: AppSettings.apiKey)
        apiClient.getPopularMovies() {[weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let movies):
                for movie in movies {
                    self?.movies.append(movie)
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        cell.textLabel?.text = movies[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieDetailsVC = segue.destination as? MovieDetailsViewController {
            guard let selectedMovieIndexPath = tableView.indexPathForSelectedRow else {
                print("No item is selected.")
                return
            }
            
            movieDetailsVC.movie = movies[selectedMovieIndexPath.row]
        }
    }
}
