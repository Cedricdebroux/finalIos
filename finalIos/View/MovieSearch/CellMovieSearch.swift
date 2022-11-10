//
//  MovieSearch.swift
//  finalIos
//
//  Created by Cédric Debroux on 10/11/2022.
//

import UIKit

class CellMovieSearch: UICollectionViewCell {
    let baseUrl = Api.baseImageURL
    @IBOutlet var titleMovie: UILabel!
    
    @IBOutlet var dateMovie: UILabel!
    @IBOutlet var imageMovie: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCellSearch(model: Movie){
        let dateRelease = model.releaseDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateRelease!)
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "EN-en")

        
        titleMovie.text = model.title
        if let date = date {
            dateMovie.text = dateFormatter.string(from: date)
        }
        
        
        if let posterPath = model.posterPath, let urls = URL(string:(baseUrl+(posterPath ))){
            imageMovie.af.setImage(withURL: urls)
        }
    }
}
