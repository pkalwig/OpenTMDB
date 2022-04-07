//
//  MovieDetailsViewController.swift
//  OpenTmdb
//
//  Created by ingenico on 01/04/2022.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let movie = movie else {
            title = "Movie details"
            return
        }
        
        title = movie.title
    }
}
