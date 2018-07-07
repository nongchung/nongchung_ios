//
//  ReviewTestViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 7..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import YangMingShan
import Cosmos

class ReviewTestViewController: UIViewController, YMSPhotoPickerViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    
    @IBOutlet weak var collectionView: UICollectionView!

    
    @IBOutlet weak var cameraButton: UIButton!
    
    var images: NSArray! = []
    
    @IBAction func presentPhotoPicker(_ sender: AnyObject) {
        //        if self.numberOfPhotoSelectionTextField.text!.count > 0
        //            && UInt(self.numberOfPhotoSelectionTextField.text!) != 1 {
        //            let pickerViewController = YMSPhotoPickerViewController.init()
        //
        //            pickerViewController.numberOfPhotoToSelect = UInt(self.numberOfPhotoSelectionTextField.text!)!
        //
        //            let customColor = UIColor.init(red:248.0/255.0, green:217.0/255.0, blue:44.0/255.0, alpha:1.0)
        //
        //            pickerViewController.theme.titleLabelTextColor = UIColor.black
        //            pickerViewController.theme.navigationBarBackgroundColor = customColor
        //            pickerViewController.theme.tintColor = UIColor.black
        //            pickerViewController.theme.orderTintColor = customColor
        //            pickerViewController.theme.orderLabelTextColor = UIColor.black
        //            pickerViewController.theme.cameraVeilColor = customColor
        //            pickerViewController.theme.cameraIconColor = UIColor.white
        //            pickerViewController.theme.statusBarStyle = .default
        //
        //            self.yms_presentCustomAlbumPhotoView(pickerViewController, delegate: self)
        //        }
        //        else {
        
        let pickerViewController = YMSPhotoPickerViewController.init()
        
        pickerViewController.numberOfPhotoToSelect = 2
        self.yms_presentCustomAlbumPhotoView(pickerViewController, delegate: self)
    }
    
    @objc func deletePhotoImage(_ sender: UIButton!) {
        let mutableImages: NSMutableArray! = NSMutableArray.init(array: images)
        mutableImages.removeObject(at: sender.tag)
        
        self.images = NSArray.init(array: mutableImages)
        self.collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [IndexPath.init(item: sender.tag, section: 0)])
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        cameraButton.addTarget(self, action: #selector(presentPhotoPicker(_:)), for: .touchUpInside)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        cosmosView.didTouchCosmos = didTouchCosmos
        cosmosView.didFinishTouchingCosmos = didFinishTouchingCosmos
        updateRating()
    }
    
    private func updateRating() {
        self.ratingLabel.text = ReviewTestViewController.formatValue(cosmosView.rating)
    }
    
    private class func formatValue(_ value: Double) -> String {
        return String(format: "%.1f", value)
    }
    
    private func didTouchCosmos(_ rating: Double) {
        ratingLabel.text = ReviewTestViewController.formatValue(rating)
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        self.ratingLabel.text = ReviewTestViewController.formatValue(rating)
    }
    
    func photoPickerViewControllerDidReceivePhotoAlbumAccessDenied(_ picker: YMSPhotoPickerViewController!) {
        let alertController = UIAlertController.init(title: "Allow photo album access?", message: "Need your permission to access photo albumbs", preferredStyle: .alert)
        let dismissAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction.init(title: "Settings", style: .default) { (action) in
            UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func photoPickerViewControllerDidReceiveCameraAccessDenied(_ picker: YMSPhotoPickerViewController!) {
        let alertController = UIAlertController.init(title: "Allow camera album access?", message: "Need your permission to take a photo", preferredStyle: .alert)
        let dismissAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction.init(title: "Settings", style: .default) { (action) in
            UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        picker.present(alertController, animated: true, completion: nil)
    }
    
    func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPicking image: UIImage!) {
        picker.dismiss(animated: true) {
            self.images = [image]
            self.collectionView.reloadData()
        }
    }
    
    func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPickingImages photoAssets: [PHAsset]!) {
        
        picker.dismiss(animated: true) {
            let imageManager = PHImageManager.init()
            let options = PHImageRequestOptions.init()
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            options.isSynchronous = true
            
            let mutableImages: NSMutableArray! = []
            
            for asset: PHAsset in photoAssets
            {
                let scale = UIScreen.main.scale
                let targetSize = CGSize(width: (self.collectionView.bounds.width - 20*2) * scale, height: (self.collectionView.bounds.height - 20*2) * scale)
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
                    mutableImages.add(image!)
                })
            }
            
            self.images = mutableImages.copy() as? NSArray
            self.collectionView.reloadData()
            print("didFinishPickingImages")
        }
    }
    
    
    // MARK - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WriteReviewCollectionViewCell", for: indexPath) as! WriteReviewCollectionViewCell
        
        cell.photoImageView.image =  self.images.object(at: (indexPath as NSIndexPath).item) as? UIImage
        cell.deleteButton.tag = (indexPath as NSIndexPath).item
        cell.deleteButton.addTarget(self, action: #selector(ReviewTestViewController.deletePhotoImage(_:)), for: .touchUpInside)
    
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    
}
