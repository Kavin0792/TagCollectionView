//
//  ViewController.swift
//  BSTagView
//
//  Created by Sami on 5/15/20.
//  Copyright © 2020 Hungrynaki.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var snapshotView: UIView?
    fileprivate var snapshotIndexPath: IndexPath?
    fileprivate var snapshotPanPoint: CGPoint?
    
    private var selected = [String]()
    private var titles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titles = [
            "a",
            "Bangladesh",
            "China",
            "Denmark",
            "Egypt",
            "Finland Finland",
            "Germany 123",
            "Holand",
            "Italy",
            "Japan"
        ]
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragInteractionEnabled = true
        let layout = TagFlowLayout()
        layout.estimatedItemSize = CGSize(width: 40, height: 40)
        collectionView.collectionViewLayout = layout
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognized(_:)))
        gestureRecognizer.minimumPressDuration = 0.2
        collectionView!.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func longPressRecognized(_ recognizer: UILongPressGestureRecognizer) {
        let location = recognizer.location(in: collectionView)
        let indexPath = collectionView?.indexPathForItem(at: location)
        
        switch recognizer.state {
        case UIGestureRecognizer.State.began:
            guard let indexPath = indexPath else { return }
            
            let cell = cellForRow(at: indexPath)
            snapshotView = cell.snapshotView(afterScreenUpdates: true)
            collectionView!.addSubview(snapshotView!)
            cell.contentView.alpha = 0.0
            
            UIView.animate(withDuration: 0.2, animations: {
                self.snapshotView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.snapshotView?.alpha = 0.9
            })
            
            snapshotPanPoint = location
            snapshotIndexPath = indexPath
        case UIGestureRecognizer.State.changed:
            guard let snapshotPanPoint = snapshotPanPoint else { return }
            
            let translation = CGPoint(x: location.x - snapshotPanPoint.x, y: location.y - snapshotPanPoint.y)
            snapshotView?.center.x += translation.x
            snapshotView?.center.y += translation.y
            self.snapshotPanPoint = location
            
            guard let indexPath = indexPath else { return }
            titles.swapAt(snapshotIndexPath!.item, indexPath.item)
            
            collectionView!.moveItem(at: snapshotIndexPath!, to: indexPath)
            snapshotIndexPath = indexPath
        default:
            guard let snapshotIndexPath = snapshotIndexPath else { return }
            let cell = cellForRow(at: snapshotIndexPath)
            UIView.animate(
                withDuration: 0.2,
                animations: {
                    self.snapshotView?.center = cell.center
                    self.snapshotView?.transform = CGAffineTransform.identity
                    self.snapshotView?.alpha = 1.0
                },
                completion: { finished in
                    cell.contentView.alpha = 1.0
                    self.snapshotView?.removeFromSuperview()
                    self.snapshotView = nil
                })
            self.snapshotIndexPath = nil
            self.snapshotPanPoint = nil
        }
    }
    
    fileprivate func cellForRow(at indexPath: IndexPath) -> TagCollectionViewCell {
      return collectionView?.cellForItem(at: indexPath) as! TagCollectionViewCell
    }

}

extension ViewController:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell",
                                                            for: indexPath) as? TagCollectionViewCell else {
            return TagCollectionViewCell()
        }
        cell.tagLabel.text = titles[indexPath.row]
        cell.tagLabel.preferredMaxLayoutWidth = collectionView.frame.width - 16
        
        if selected.contains(titles[indexPath.row]) {
            cell.backgroundColor = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
        } else {
            cell.backgroundColor = .lightGray
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TagCollectionViewCell, let text = cell.tagLabel.text else {return}
        
        if selected.contains(text) {
            selected = selected.filter{$0 != text}
        } else {
            selected.append(text)
        }
        collectionView.reloadData()
    }
}

