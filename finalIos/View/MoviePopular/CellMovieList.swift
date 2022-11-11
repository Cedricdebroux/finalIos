//
//  CellMovieList.swift
//  finalIos
//
//  Created by Cédric Debroux on 10/11/2022.
//

import UIKit
import AlamofireImage

class CellMovieList: UICollectionViewCell {

    let baseUrl = Api.baseImageURL
    

    @IBOutlet var circleBackground: UIView!
    
    @IBOutlet var imageFilm: UIImageView!
    
    @IBOutlet var voteAverage: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    

    
    func setupCell(model: Movie){
        circleBackground.layer.cornerRadius = circleBackground.frame.size.height/2
        circleBackground.layer.borderWidth = 5
        circleBackground.layer.borderWidth = 2
        circleBackground.layer.borderColor = UIColor.systemOrange.cgColor
        voteAverage.text = String(format: "%.01f", model.voteAverage)
        
        if let posterPath = model.posterPath, let urls = URL(string:(baseUrl+posterPath)){
            imageFilm.af.setImage(withURL: urls)
            imageFilm.layer.cornerRadius = 20
            
        }
    }
    
    // MARK: - PrepareforReuse
    
//    Permet d'effecer la cellul pour pouvoir la reutiliser, evite d'avoir le changement d'image visuel (sans ça l'autre image resterais visible jusqu'a l'arrivée de la nouvelle image)
    override func prepareForReuse() {
        imageFilm.image = nil
    }
}
