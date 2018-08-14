//
//  ViewController.swift
//  WorldCupApp
//
//  Created by Sebastian DeRossi on 2018-07-30.
//  Copyright © 2018 Sebastian DeRossi. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var cellHeight:CGFloat = 230.0;
    
    public var rounds = [MatchDetail]();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Do any additional setup after loading the view, typically from a nib.
        collectionView?.backgroundColor = UIColor(red: 30/255, green: 39/255, blue: 61/255, alpha: 1.0);
        collectionView?.alwaysBounceVertical = true;
        collectionView?.register(DataCell.self, forCellWithReuseIdentifier: "dataCell");
        
        navigationController?.navigationBar.tintColor = .white;
        
    }
    
    func _loadData(file:String) -> [ListItem]{
        //SD: Find data source
        let path = Bundle.main.path(forResource: file, ofType: "json");
        do {
            //SD:Parse JSON file
            if let urlPath = path {
                let data = try Data(contentsOf: URL(fileURLWithPath: urlPath), options: .mappedIfSafe);
                return try JSONDecoder().decode([ListItem].self, from: data);
            }else {
                return [];
            }
            
        }catch {
            print("ERROR", error.localizedDescription, error);
        }
        return []
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rounds.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dataCell", for: indexPath) as! DataCell;
        let selectedData = self.rounds[indexPath.row];
        cell.data = selectedData as MatchDetail;
        
        return cell;
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-20, height: cellHeight);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

