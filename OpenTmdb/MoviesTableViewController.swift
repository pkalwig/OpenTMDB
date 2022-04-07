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
        self.title = "Popular movies"

        let apiClient = TheMovieDbApiClient(urlSession: URLSession.shared, apiKey: AppSettings.apiKey)
        let task = apiClient.getPopularMovies() {[weak self] data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                error == nil
            else {
                print("Request failed.")
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let response = response as? HTTPURLResponse{
                    print(response.statusCode)
                    print(response.description)
                }
                
                return
            }
            
            print("Request successfull.")
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let popularMovies = try decoder.decode(PagedResponse<Movie>.self, from: data)
                for popularMovie in popularMovies.results {
                    self?.movies.append(popularMovie)
                }
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
            catch {
                print("Decoding JSON failed \(error)")
            }
        }
        task.resume()
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
