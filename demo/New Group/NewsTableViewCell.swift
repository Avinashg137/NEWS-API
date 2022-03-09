//
//  NewsTableViewCell.swift
//  demo
//
//  Created by MAC OS on 08/03/22.
//

import UIKit

class NewsTableViewCellViewModel {
    let title : String
    let subtitle: String
    let imageURL : URL?
    var imageData: Data? = nil
    
    init(
        title: String,
        subtitle: String,
        imageURL: URL?,
        imageData: Data?
    ){
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.imageData = imageData
    }
}

class NewsTableViewCell: UITableViewCell {

  static let identifier =  "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 25, weight: .medium)
        return label
    }()
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemRed
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier:  reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLabel.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width - 200, height: 70)
        subTitleLabel.frame = CGRect(x: 10, y: 70, width: contentView.frame.size.width - 200, height: contentView.frame.size.height/2)
        newsImageView.frame = CGRect(x: contentView.frame.size.width - 200, y: 5, width: 190, height: contentView.frame.size.height - 10)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subtitle
        
        // Image
        if let data = viewModel.imageData {
            
            newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            
            // fetch
            URLSession.shared.dataTask(with: url) { [weak self ] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
    }
}
}
