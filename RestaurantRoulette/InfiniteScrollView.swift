//
//  InfiniteScrollView.swift
//  RestaurantRoulette
//
//  Created by Vanessa Bergen on 2020-08-10.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct InfiniteScrollView: UIViewRepresentable {
    
    private let uiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    @Binding var indexToScroll: Int
    var dataSource: [Result]
    @Binding var doneScrolling: Bool
    
    
    func makeUIView(context: Context) -> UICollectionView {
        
        self.uiCollectionView.dataSource = context.coordinator
        self.uiCollectionView.delegate = context.coordinator
        self.uiCollectionView.isPagingEnabled = true
        self.uiCollectionView.backgroundColor = .blue
        self.uiCollectionView.isScrollEnabled = false
        self.uiCollectionView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        
        RestaurantCell.registerWithCollectionView(collectionView: self.uiCollectionView)
        return self.uiCollectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) {

        DispatchQueue.main.async {
            // spin it three times before landing on the chosen index
            uiView.calcOffset(for: self.indexToScroll + self.dataSource.count * 3)
        }
        
    }
    
    
    class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
        var parent: InfiniteScrollView
        var finishedScrolling = false {
            didSet {
                print("finished scrolling \(finishedScrolling)")
                parent.uiCollectionView.reloadData()
                parent.doneScrolling = finishedScrolling
            }
        }
        
        init(_ parent: InfiniteScrollView) {
            self.parent = parent
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.parent.dataSource.count * 5
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCell.reuseId, for: indexPath) as! RestaurantCell
            
            if !self.finishedScrolling {
                
                cell.backgroundColor = .white
                cell.layer.borderColor = UIColor.clear.cgColor
                
            } else if indexPath.item == self.parent.indexToScroll + self.parent.dataSource.count * 3 {

                cell.backgroundColor = .white
                cell.layer.borderColor = UIColor.darkBlue.cgColor

            } else {

                cell.backgroundColor = UIColor(white: 1, alpha: 0.7)
                cell.layer.borderColor = UIColor.clear.cgColor

            }
            
            
            //cell.backgroundColor = .white
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 1.0

            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.layer.cornerRadius).cgPath

            let index = indexPath.item
            let result = self.parent.dataSource[index % self.parent.dataSource.count]
            cell.infoView.text = result.name
            cell.addressView.text = result.vicinity
            

            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            return CGSize(width: collectionView.safeAreaLayoutGuide.layoutFrame.width * 0.95, height: collectionView.bounds.size.height/5)
        }
        
        func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
            print("animation done")
            self.finishedScrolling = true
        }
            
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}

class RestaurantCell: UICollectionViewCell {
    static let reuseId = "RestaurantCell"

    static func registerWithCollectionView(collectionView: UICollectionView) {
        collectionView.register(RestaurantCell.self, forCellWithReuseIdentifier: reuseId)
    }

    static func getReusedCellFrom(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> RestaurantCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! RestaurantCell
    }

    var infoView: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var addressView: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        infoView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(self.infoView)

        infoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        infoView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        infoView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        
        addressView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(self.addressView)
        
        addressView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        addressView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        addressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) has not been implemented")
    }
}


extension UICollectionView {
    
    func autoScroll (to offset: CGFloat) {
        let co = self.contentOffset.y
        let no = co + 50
        
        UIView.animate(withDuration: 0.001, delay: 0, options: .curveEaseInOut, animations: {
            self.contentOffset = CGPoint(x: 0, y: no)
            }) { (status) in
                if co + 50 > offset {
                    self.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
                } else {
                    self.autoScroll(to: offset)
                }
        }
        
    }
    
    func calcOffset(for index: Int) {
        guard let minY = (self.layoutAttributesForItem(at: IndexPath(item: index-2, section: 0))?.frame.minY) else {
            self.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredVertically, animated: true)
            return
        }

        autoScroll(to: minY)
        
    }
}
