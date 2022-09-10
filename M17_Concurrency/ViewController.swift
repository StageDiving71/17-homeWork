//
//  ViewController.swift
//  M17_Concurrency
//
//  Created by Maxim NIkolaev on 08.12.2021.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var images1 = [UIImage]()
    let service = Service()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
        indicator.center = view.center
        return indicator
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        onLoad()
    }

    
    private func setupViews() {
        view.addSubview(stackView)
     
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin) //вью будут добавляться в безопасную зону (ниже динамика сверху)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalToSuperview()
        }
        stackView.addArrangedSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func onLoad() {
        
        let group = DispatchGroup()
        
        for _ in 0...3 {
            
            group.enter()

        service.getImageURL { urlString, error in
            guard
                let urlString = urlString
            else {
                return
            }
            
                
                    guard let image = self.service.loadImage(urlString: urlString) else { return }
                    self.images1.append(image)
                    group.leave()
                }
        }

        
            group.notify(queue: .main) {
                
                for i in self.images1 {
                    let image111 = UIImageView(image: UIImage())
                    image111.image = i
                    self.stackView.addArrangedSubview(image111)
                    self.activityIndicator.stopAnimating()
                    self.stackView.removeArrangedSubview(self.activityIndicator )
                    
                    print(self.images1.count)
                }
            }
        
    }
}

