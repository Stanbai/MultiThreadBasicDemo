//
//  CollectionViewController.swift
//  NSOperation
//
//  Created by Stan on 2017-07-24.
//  Copyright © 2017 stan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let imageLoadQueu = OperationQueue()
    var items = [UIImage]()
    var imageOps = [(Item, Operation?)]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageLoadQueu.maxConcurrentOperationCount = 2
        imageLoadQueu.qualityOfService = .userInitiated
        
        //        使用map 函数进行改造，创建imageOps
        imageOps = Item.creatItems(count: 100).map({ (images) -> (Item, Operation?) in
            return (images, nil)
        })
        
        self.collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if imageOps.count < 1 {
            return 1
        }
        return imageOps.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionCell

        cell.imageView.image = nil
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! CollectionCell
        let (item, operation) = imageOps[indexPath.row]
        //        只是以防万一，我们先停止一下操作
        operation?.cancel()
        weak var weakCell = cell
        
        let newOp = ImageLoadOperation(forItem: item) { (image) in
            DispatchQueue.main.async {
                weakCell?.imageView.image = image
            }
        }
        
        imageLoadQueu.addOperation(newOp)
        imageOps[indexPath.row] = (item, newOp)
    }
    
    
    
    //    MARK: - UICollectionViewDelegateFlowLayout代理方法
    
    ///调整CollectionCell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = UIScreen.main.bounds.width * 0.5 - 5.0
        return CGSize(width: w, height: w)
    }
    
    
    
}

extension CollectionViewController {
    func loadImages(count: Int, complete: @escaping([UIImage]) -> Void) -> () {
        var images = [UIImage]()
        for index in 0...count {
            if let url = URL(string: "https://placeholdit.imgix.net/~text?txtsize=33&txt=image+\(index + 1)&w=300&h=300") {
                
                do {
                    let imageData = try Data(contentsOf: url)
                    guard let image = UIImage(data: imageData) else { return }
                    images.append(image)
                } catch {
                    print(error)
                }
            }
        }
        complete(images)
    }
}



