//
//  SnackBarModel.swift
//  CleanHands
//
//  Created by hwangguk on 2021/07/17.
//

import Foundation
import UIKit

//struct SnackbarViewModel {
//    let name: String
//    let image: UIImage
//    //let hander: ()->()
//}

class SnackbarView:UIView {
    
    public static let snackbarQueue = DispatchQueue(label: "snackbar")
//    let viewModel: SnackbarViewModel
    let text:String
    let textLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
//    let image:UIImageView  = {
//        let imageView = UIImageView()
//        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
    
    init(text:String, _ view: UIView) {
        self.text = text
        let padding:CGFloat = 8;
        let adjustedFrame = CGRect(x: padding, y: view.frame.height - view.safeAreaInsets.bottom , width: view.frame.width - padding*2, height: 56)

        super.init(frame: adjustedFrame)
        
        backgroundColor = UIColor(red: 178/255, green: 211/255, blue: 227/255, alpha: 1)
        layer.cornerRadius = 14
        
        addSubview(textLabel)
        //addSubview(image)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //let imagePadding:CGFloat = 5.0
        textLabel.frame = bounds
//        image.frame = CGRect(x: imagePadding, y: imagePadding, width: frame.height-imagePadding*2, height: frame.height-imagePadding*2)
//        text.frame = CGRect(x: image.frame.width, y: 0, width: frame.width - image.frame.width, height: frame.height )
    }
    
    func configure() {
        textLabel.text = text
        //image.image = viewModel.image
    }
    
    func animate() {
        snackbarUIView!.insertSubview(self, at: 1)
        SnackbarView.snackbarQueue.async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, animations: {
                    self.frame = CGRect(x: self.frame.minX, y: self.frame.minY - 70, width: self.frame.width, height: self.frame.height)
                }, completion: { finished in
                    if (finished) {
                        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                            UIView.animate(withDuration: 0.5, animations: {
                                self.frame = CGRect(x: self.frame.minX, y: self.frame.minY + 70, width: self.frame.width, height: self.frame.height)
                            }, completion: { done in
                                if (done) {
                                    self.removeFromSuperview()
                                }
                            })
                            
                        })
                    }
                })
            }
            sleep(3)
            
        }
        
    }
}


