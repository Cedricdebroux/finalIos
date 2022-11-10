//
//  CellMovieDetails.swift
//  finalIos
//
//  Created by Cédric Debroux on 10/11/2022.
//

import UIKit

class CellMovieDetails: UICollectionViewCell {
    
    
    let baseUrl = Api.baseImageURL
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var imageFilm: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    func setupCellRecommended(model: Movie){
        titleLabel.text = model.title
        
        if let posterPath = model.posterPath, let url = URL(string: (baseUrl+posterPath)){
            imageFilm.af.setImage(withURL: url)
        }
    }
}
