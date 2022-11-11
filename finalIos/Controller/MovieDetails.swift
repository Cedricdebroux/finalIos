//
//  MovieDetailsViewController.swift
//  finalIos
//
//  Created by Cédric Debroux on 10/11/2022.
//

import UIKit
import Alamofire
import AlamofireImage

class MovieDetails: UIViewController {
    var api = Api()
    static let identifier = "MovieDetails"
    let baseUrl = Api.baseImageURL
    var movie: Movie!
    private var movies = [Movie]()
    private var circle: CircularProgressView!
    
    //    MARK: - IBOutlet
    
    
    @IBOutlet var backgroundImage: UIImageView!
    
    @IBOutlet var posterImage: UIImageView!
    
    @IBOutlet var titleMovie: UILabel!
    
    @IBOutlet var descriptionMovie: UITextView!
    
    @IBOutlet var voteAverage: UILabel!
    
    @IBOutlet var similarMovies: UICollectionView!
    @IBOutlet var circleBackground: UIView!
    
    
    //    MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        similarMovies.dataSource = self
        similarMovies.delegate = self
        similarMovies.register(UINib(nibName: CellMovieDetails.identifier, bundle: .main), forCellWithReuseIdentifier: CellMovieDetails.identifier)
        similarMovies.setCollectionViewLayout(createLayout(), animated: true, completion: nil)
//        circle = CircularProgressView(frame: circleBackground.frame, lineWidth: 3, rounded: true)
//        circle.progressColor = .green
//        circle.trackColor = .black
//        circle.frame.origin = CGPoint(x: 0, y: 0)
//        view.addSubview(circle)
        setupValue()
        circleBackground.layer.cornerRadius = circleBackground.frame.size.height/2
        posterImage.layer.cornerRadius = 17
        backgroundImage.layer.cornerRadius = 20
        circleBackground.layer.borderWidth = 2
        circleBackground.layer.borderColor = UIColor.systemOrange.cgColor
        posterImage.layer.borderWidth = 6
        posterImage.layer.borderColor = UIColor.white.cgColor
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        movies = [Movie]()
        similarMovies.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        api = Api()
    }
    
    //    MARK: - Setup Value
    
    func setupValue(){
        titleMovie.text = movie.title
        descriptionMovie.text = movie.overview
        voteAverage.text = String(format: "%.01f", movie.voteAverage)
//        circle.progress = Float(movie.voteAverage)/10
        if let posterPath = movie.posterPath, let url = URL(string:(baseUrl+posterPath)){
            posterImage.af.setImage(withURL: url)
        }
        if let backdropPath = movie.backdropPath, let backgroundPath = URL(string:(baseUrl+backdropPath)){
            backgroundImage.af.setImage(withURL: backgroundPath)
        }
        fetchMovieRecommended()
    }
    
    
    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        let layout = UICollectionViewCompositionalLayout(sectionProvider:
                                                            { (sectionIndex: Int,
                                                               layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = Constants.spacingInsets
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
                                                         ,configuration: config)
        return layout
    }
    
    func fetchMovieRecommended(){
        guard let url = api.urlSimilar(movie: movie.id) else { return }
        api.fetch(url: url)
        {
            [weak self] response in
            switch response {
            case .success(let data):
                guard let self else {return}
                self.movies = data.results
                self.similarMovies.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MovieDetails: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellMovieDetails.identifier, for: indexPath) as? CellMovieDetails else {
            fatalError("error !!!!!!!")
        }
        
        let data = movies[indexPath.row]
        cell.setupCellRecommended(model: data)
        return cell
    }
}
extension MovieDetails: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.movie = movies[indexPath.row]
        setupValue()
        
    }
    
}

fileprivate enum Constants {
    static let defaultSpacing = CGFloat(5)
    static let spacingInsets = NSDirectionalEdgeInsets(top: defaultSpacing, leading: defaultSpacing, bottom: defaultSpacing, trailing: defaultSpacing)
}
