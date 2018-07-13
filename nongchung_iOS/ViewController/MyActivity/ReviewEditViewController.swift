//
//  ReviewEditViewController.swift
//  nongchung_iOS
//
//  Created by 권민하 on 2018. 7. 11..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit
import YangMingShan
import Cosmos
import Kingfisher

class ReviewEditViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cameraCollectionView: UICollectionView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    //var array: [Any] = []
    
    //var images: NSArray! = []
    
    var images: [UIImage] = [UIImage]()
    var isImage: Bool = false
    
    //MARK: MyActivityViewController 에서 받아오는 데이터
    var reviewTitle: String?
    var startDate: String?
    var endDate: String?
    var period: String?
    var idx: Int?
    
    //MARK: 통신을 통해서 받아올 이전 후기에 대한 데이터
    var star: Int?
    //var reviewImage = [String]()
    var content: String?
    var rIdx: Int?
    
    var ImageArray : [UIImage]?
    //var urlImageArray: [String]?
    var urlImageArray: [String] = [String]()
    //   var hearts: [Heart] = [Heart]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(addTapped))
        
        cameraButton.addTarget(self, action: #selector(presentPhotoPicker(_:)), for: .touchUpInside)
        
        cameraCollectionView.delegate = self
        cameraCollectionView.dataSource = self
        
        cosmosView.didTouchCosmos = didTouchCosmos
        cosmosView.didFinishTouchingCosmos = didFinishTouchingCosmos
        updateRating()

        self.titleLabel.text = reviewTitle
        let date = "\(gsno(startDate)) ~ \(gsno(endDate)) (\(gsno(period)))"
        self.dateLabel.text = date
        
        reviewInit()
    }
    
    func reviewInit() {
        ReviewService.reviewEditInit(scheIdx: idx!) { (reviewData) in
            self.star = reviewData.star
            self.content = reviewData.content
            self.rIdx = reviewData.rIdx
            
            
            self.contentTextView.text = self.content
            self.ratingLabel.text = String(self.star!)
            self.cosmosView.rating = Double(self.star!)
   
            for i in 0 ..< reviewData.img!.count {
                let data = try? Data(contentsOf: URL(string: reviewData.img![i])!)
                if let imageData = data {
                    self.images.append(UIImage(data: imageData)!)
                    //self.images[i] = UIImage(data: imageData)
                }
            }
            
            self.cameraCollectionView.reloadData()
        }
    }
    
    @IBAction func presentPhotoPicker(_ sender: AnyObject) {
        let pickerViewController = YMSPhotoPickerViewController.init()
        
        //MARK: 사진 선택 개수 제한
        pickerViewController.numberOfPhotoToSelect = 20
        self.yms_presentCustomAlbumPhotoView(pickerViewController, delegate: self)
    }
    
    // 이미지 삭제 시
    @objc func deletePhotoImage(_ sender: UIButton!) {
        //let mutableImages: NSMutableArray! = NSMutableArray.init(array: images)
        var mutableImages: [UIImage] = images
        
        print(sender.tag)
        print(images)
        
        mutableImages.remove(at: sender.tag)
        //mutableImages.removeObject(at: sender.tag)
        
        images = mutableImages
        //self.images = NSArray.init(array: mutableImages)
        self.cameraCollectionView.performBatchUpdates({
            self.cameraCollectionView.deleteItems(at: [IndexPath.init(item: sender.tag, section: 0)])
        }) { (finished) in
            self.cameraCollectionView.reloadItems(at: self.cameraCollectionView.indexPathsForVisibleItems)
        }
    }
    
    // 네비게이션바의 완료 버튼을 눌렀을 때
    @objc func addTapped(){
//        ReviewService.writeImageReview(rImages: images as! [UIImage], content: contentTextView.text, scheIdx: String(idx!), star: ratingLabel.text!) {
//            self.navigationController?.popViewController(animated: true)
//        }
        print(121313141)
        print(rIdx)
        ReviewService.editImageReview(rIdx: String(rIdx!), content: contentTextView.text, rImages: images, star: ratingLabel.text!) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // Star rating bar setting
    private func updateRating() {
        self.ratingLabel.text = ReviewEditViewController.formatValue(cosmosView.rating)
    }
    
    private class func formatValue(_ value: Double) -> String {
        return String(format: "%.1f", value)
    }
    
    private func didTouchCosmos(_ rating: Double) {
        ratingLabel.text = ReviewEditViewController.formatValue(rating)
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        self.ratingLabel.text = ReviewEditViewController.formatValue(rating)
    }
}

extension ReviewEditViewController: YMSPhotoPickerViewControllerDelegate {
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
            self.cameraCollectionView.reloadData()
        }
    }
    
    func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPickingImages photoAssets: [PHAsset]!) {
        
        picker.dismiss(animated: true) {
            let imageManager = PHImageManager.init()
            let options = PHImageRequestOptions.init()
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            options.isSynchronous = true
            
            //let mutableImages: NSMutableArray! = []
            var mutableImages: [UIImage] = [UIImage]()
            
            for asset: PHAsset in photoAssets
            {
                let scale = UIScreen.main.scale
                let targetSize = CGSize(width: (self.cameraCollectionView.bounds.width - 20*2) * scale, height: (self.cameraCollectionView.bounds.height - 20*2) * scale)
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
                    mutableImages.append(image!)
                    //mutableImages.add(image!)
                })
            }
            self.images = mutableImages
            //self.images = mutableImages.copy() as? NSArray
            self.cameraCollectionView.reloadData()
            print("didFinishPickingImages")
        }
    }
}

extension ReviewEditViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditReviewCollectionViewCell", for: indexPath) as! EditReviewCollectionViewCell

        //cell.imageView.image =  self.images.object(at: (indexPath as NSIndexPath).item) as? UIImage
        cell.imageView.image = self.images[indexPath.row]
        cell.deleteButton.tag = indexPath.row
        //cell.deleteButton.tag = (indexPath as NSIndexPath).item
        
        cell.deleteButton.addTarget(self, action: #selector(ReviewEditViewController.deletePhotoImage(_:)), for: .touchUpInside)
        //cell.deleteButton.addTarget(self, action: #selector(ReviewEditViewController.deletePhotoImage(_:)), for: .touchUpInside)
        
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
