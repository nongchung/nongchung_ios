//
//  ReviewWriteViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 7..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import YangMingShan
import Cosmos

class ReviewWriteViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UITextView!
    @IBOutlet weak var titleLable: UILabel!
    var images: NSArray! = []
    var reviewImage: NSArray! = []
    var isImage: Bool = false
    
    var reviewTitle: String?
    var startDate: String?
    var endDate: String?
    var period: String?
    var idx: Int?
    
    var placeholderLabel : UILabel!
    
    var reviews: ReviewEditDataVO?
    
    
    @IBAction func presentPhotoPicker(_ sender: AnyObject) {
        let pickerViewController = YMSPhotoPickerViewController.init()
        
        //MARK: 사진 선택 개수 제한
        pickerViewController.numberOfPhotoToSelect = 20
        self.yms_presentCustomAlbumPhotoView(pickerViewController, delegate: self)
    }
    
    // 이미지 삭제 시
    @objc func deletePhotoImage(_ sender: UIButton!) {
        let mutableImages: NSMutableArray! = NSMutableArray.init(array: images)
        print(sender.tag)
        print(images)
        mutableImages.removeObject(at: sender.tag)
        
        self.images = NSArray.init(array: mutableImages)
        self.collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [IndexPath.init(item: sender.tag, section: 0)])
        }) { (finished) in
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
        }
    }
    
    // 네비게이션바의 완료 버튼을 눌렀을 때
    @objc func addTapped(){
        ReviewService.writeImageReview(rImages: images as! [UIImage], content: contentLabel.text, scheIdx: String(idx!), star: ratingLabel.text!) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(addTapped))
        
        cameraButton.addTarget(self, action: #selector(presentPhotoPicker(_:)), for: .touchUpInside)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        cosmosView.didTouchCosmos = didTouchCosmos
        cosmosView.didFinishTouchingCosmos = didFinishTouchingCosmos
        updateRating()
        
        self.titleLable.text = reviewTitle
        let date = "\(gsno(startDate)) ~ \(gsno(endDate)) (\(gsno(period)))"
        self.dateLabel.text = date
        
        //MARK: TextView Placeholder
        contentLabel.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "내용을 입력하세요"
        //placeholderLabel.font = UIFont.italicSystemFont(ofSize: (contentLabel.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        contentLabel.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (contentLabel.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !contentLabel.text.isEmpty
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    // Star rating bar setting
    private func updateRating() {
        self.ratingLabel.text = ReviewWriteViewController.formatValue(cosmosView.rating)
    }
    
    private class func formatValue(_ value: Double) -> String {
        return String(format: "%.1f", value)
    }
    
    private func didTouchCosmos(_ rating: Double) {
        ratingLabel.text = ReviewWriteViewController.formatValue(rating)
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        self.ratingLabel.text = ReviewWriteViewController.formatValue(rating)
    }
    
}

extension ReviewWriteViewController: YMSPhotoPickerViewControllerDelegate {
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
}

extension ReviewWriteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WriteReviewCollectionViewCell", for: indexPath) as! WriteReviewCollectionViewCell
        
        cell.photoImageView.image =  self.images.object(at: (indexPath as NSIndexPath).item) as? UIImage
        cell.deleteButton.tag = (indexPath as NSIndexPath).item
        cell.deleteButton.addTarget(self, action: #selector(ReviewWriteViewController.deletePhotoImage(_:)), for: .touchUpInside)
        
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
