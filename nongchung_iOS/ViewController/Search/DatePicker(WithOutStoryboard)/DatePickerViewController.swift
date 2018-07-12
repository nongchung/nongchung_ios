//
//  DatePickerViewController.swift
//  nongchung_iOS
//
//  Created by 갓거 on 2018. 7. 11..
//  Copyright © 2018년 농활청춘. All rights reserved.
//

import UIKit

public protocol DatePickerDelegate {
    func datePickerController(_ datePickerController: DatePickerViewController, didSaveStartDate startDate: Date?, endDate: Date?)
}

public class DatePickerViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let monthHeaderID = "monthHeaderID"
    let cellID = "cellID"
    let dateFormatter = DateFormatter()

    var delegate: DatePickerDelegate?
    
    var selectedStartDate: Date? {
        didSet {
            footerView.isSaveEnabled = (selectedStartDate == nil || selectedEndDate != nil)
        }
    }
    var startDateIndexPath: IndexPath?
    var selectedEndDate: Date? {
        didSet {
            footerView.isSaveEnabled = (selectedStartDate == nil || selectedEndDate != nil)
        }
    }
    var endDateIndexPath: IndexPath?
    var today: Date!
    var calendar: Calendar {
        return Utility.calendar
    }
    
    var isLoadingMore = false
    var initialNumberOfMonths = 24
    var subsequentMonthsLoadCount = 12
    var lastNthMonthBeforeLoadMore = 12
    
    var months: [Date]!
    var days: [(days: Int, prepend: Int, append: Int)]!
    
    var itemWidth: CGFloat {
        return floor(view.frame.size.width / 7)
    }
    var collectionViewWidthConstraint: NSLayoutConstraint?

    
    // MARK: - Initialization
    
    convenience init(dateFrom: Date?, dateTo: Date?) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
        today = Date()
        initDates()
    
        // put in closure to trigger didSet
        ({ selectedStartDate = dateFrom })()
        ({ selectedEndDate = dateTo })()
        
        if selectedStartDate != nil && startDateIndexPath == nil {
            startDateIndexPath = findIndexPath(forDate: selectedStartDate!)
            if let indexPath = startDateIndexPath {
                collectionView?.selectItem(at: indexPath, animated: false, scrollPosition: .left)
            }
        }
        
        if selectedEndDate != nil && endDateIndexPath == nil {
            endDateIndexPath = findIndexPath(forDate: selectedEndDate!)
            if let indexPath = endDateIndexPath {
                collectionView?.selectItem(at: indexPath, animated: false, scrollPosition: .left)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(DatePickerViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func initDates() {
        let month = calendar.component(.month, from: today)
        let year = calendar.component(.year, from: today)
        var dateComp = DateComponents(year: year, month: month, day: 1)
        var curMonth = calendar.date(from: dateComp)
        
        months = [Date]()
        days = [(days: Int, prepend: Int, append: Int)]()
        
        for _ in 0..<initialNumberOfMonths {
            months.append(curMonth!)
            
            let numOfDays = calendar.range(of: .day, in: .month, for: curMonth!)!.count
            let firstWeekDay = calendar.component(.weekday, from: curMonth!.startOfMonth())
            let lastWeekDay = calendar.component(.weekday, from: curMonth!.endOfMonth())
            
            days.append((days: numOfDays, prepend: firstWeekDay - 1, append: 7 - lastWeekDay))
            
            curMonth = calendar.date(byAdding: .month, value: 1, to: curMonth!)
            
        }
    }
    
    // MARK: - View Components
    
    lazy var dismissButton: UIBarButtonItem = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "Delete"), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        btn.addTarget(self, action: #selector(DatePickerViewController.handleDismiss), for: .touchUpInside)
        let barBtn = UIBarButtonItem(customView: btn)
        return barBtn
    }()
    
    lazy var clearButton: UIBarButtonItem = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("초기화", for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        btn.titleLabel?.font = UIFont(name: "NanumSquareRoundB", size: 20)
        btn.addTarget(self, action: #selector(DatePickerViewController.handleClearInput), for: .touchUpInside)
        let barBtn = UIBarButtonItem(customView: btn)
        return barBtn
    }()
    
    var headerView: DatePickerHeader = {
        let view = DatePickerHeader()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.3215686275, blue: 0.7647058824, alpha: 1)
        return view
    }()
    
    var headerSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.3215686275, blue: 0.7647058824, alpha: 1)
        return view
    }()
    
    lazy var footerView: DatePickerFooter = {
        let view = DatePickerFooter()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.delegate = self
        return view
    }()
    
    var footerSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return view
    }()
    
    
    // MARK: - View Setups
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupViews()
        setupLayout()
        setupNavigationBar()
        
    }
    
    @objc func rotated() {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        self.navigationItem.setLeftBarButton(dismissButton, animated: true)
        self.navigationItem.setRightBarButton(clearButton, animated: true)
    }
    
    
    func setupViews() {
        setupHeaderView()
        setupFooterView()
        setupCollectionView()
    }
    
    func setupHeaderView() {
        view.addSubview(headerView)
        
        headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        headerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        headerView.heightAnchor.constraint(lessThanOrEqualToConstant: 180).isActive = true
        
        view.addSubview(headerSeparator)
        
        headerSeparator.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        headerSeparator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerSeparator.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        headerSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func setupCollectionView() {
        collectionView?.contentInsetAdjustmentBehavior = .automatic
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.allowsMultipleSelection = true
        //collectionView?.collectionViewLayout = UICollectionViewFlowLayout.init()
        //collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 375, height: 400), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView?.register(DatePickerCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(DatePickerMonthHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: monthHeaderID)
        print("야이색히야")
        collectionView?.topAnchor.constraint(equalTo: headerSeparator.bottomAnchor, constant: 0).isActive = true
        collectionView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: footerSeparator.topAnchor).isActive = true
        
        let gap = view.frame.size.width - (itemWidth * 7)
        collectionViewWidthConstraint = collectionView?.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -gap)
        collectionViewWidthConstraint?.isActive = true
    }
    
    func setupLayout() {
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 5
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets()
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            
        }
    }
    
    func setupFooterView() {
        view.addSubview(footerView)
        
        footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        footerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        footerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        view.addSubview(footerSeparator)
        
        footerSeparator.bottomAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
        footerSeparator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        footerSeparator.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        footerSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    // MARK: - Collection View Delegates
    
    override public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return months.count
    }
    
    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days[section].prepend + days[section].days + days[section].append
    }
    
    override public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Load more months on reaching last (n)th month
        if indexPath.section == (months.count - lastNthMonthBeforeLoadMore) && !isLoadingMore {
            let originalCount = months.count
            isLoadingMore = true
            
            DispatchQueue.global(qos: .background).async {
                self.loadMoreMonths(completion: {
                    () in
                    DispatchQueue.main.async {
                        collectionView.performBatchUpdates({
                            () in
                            let range = originalCount..<originalCount.advanced(by: self.subsequentMonthsLoadCount)
                            let indexSet = IndexSet(integersIn: range)
                            collectionView.insertSections(indexSet)
                            
                        }, completion: {
                            (res) in
                            self.isLoadingMore = false
                        })
                    }
                })
            }
        }
    }
    
    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! DatePickerCell
        
        configure(cell: cell, withIndexPath: indexPath)
        
        return cell
    }

    public override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: monthHeaderID, for: indexPath) as! DatePickerMonthHeader
        
        let monthData = months[indexPath.section]
        let curYear = calendar.component(.year, from: today)
        let year = calendar.component(.year, from: monthData)
        let month = calendar.component(.month, from: monthData)
        
        if (curYear == year) {
            header.monthLabel.text = dateFormatter.monthSymbols[month - 1]
        } else {
            header.monthLabel.text = "\(dateFormatter.shortMonthSymbols[month - 1]) \(year)"
        }
        
        return header
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 50)
    }
    
    override public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath) as! DatePickerCell
        cell.type.insert(.Selected)
        
        let selectedMonth = months[indexPath.section]
        
        let year = calendar.component(.year, from: selectedMonth)
        let month = calendar.component(.month, from: selectedMonth)
        
        var dateComp = DateComponents(year: year, month: month, day: Int(cell.dateLabel.text!))
        let selectedDate = calendar.date(from: dateComp)!
        
        if selectedStartDate == nil || (selectedEndDate == nil && selectedDate < selectedStartDate!) {
            if startDateIndexPath != nil, let prevStartCell = collectionView.cellForItem(at: startDateIndexPath!) as? DatePickerCell {
                prevStartCell.type.remove(.Selected)
                prevStartCell.configureCell()
                collectionView.deselectItem(at: startDateIndexPath!, animated: false)
            }
            
            selectedStartDate = selectedDate
            startDateIndexPath = indexPath
            
        } else if selectedEndDate == nil {
            selectedEndDate = selectedDate
            endDateIndexPath = indexPath
            
            // select start date to trigger cell UI change
            if let startCell = collectionView.cellForItem(at: startDateIndexPath!) as? DatePickerCell {
                startCell.type.insert(.SelectedStartDate)
                startCell.configureCell()
            }
            
            // select end date to trigger cell UI change
            if let endCell = collectionView.cellForItem(at: endDateIndexPath!) as? DatePickerCell {
                endCell.type.insert(.SelectedEndDate)
                endCell.configureCell()
            }
            
            // loop through cells in between selected dates and select them
            selectInBetweenCells()
            
        } else {
            
            // deselect previously selected cells
            deselectSelectedCells()
            
            selectedStartDate = selectedDate
            selectedEndDate = nil
            
            startDateIndexPath = indexPath
            endDateIndexPath = nil
            
            if let newStartCell = collectionView.cellForItem(at: startDateIndexPath!) as? DatePickerCell {
                newStartCell.type.insert(.Selected)
                newStartCell.configureCell()
            }
        }
        
        cell.configureCell()
        
    }
    
    override public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! DatePickerCell
        
        return cell.type.contains(.Date)
    }
    
    override public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DatePickerCell

        if isInBetween(indexPath: indexPath) {
            deselectSelectedCells()
            
            let selectedMonth = months[indexPath.section]
            
            let year = calendar.component(.year, from: selectedMonth)
            let month = calendar.component(.month, from: selectedMonth)
            
            var dateComp = DateComponents(year: year, month: month, day: Int(cell.dateLabel.text!))
            let selectedDate = calendar.date(from: dateComp)!
            
            selectedStartDate = selectedDate
            selectedEndDate = nil
            
            startDateIndexPath = indexPath
            endDateIndexPath = nil
            
            if let newStartCell = collectionView.cellForItem(at: startDateIndexPath!) as? DatePickerCell {
                newStartCell.type.insert(.Selected)
                newStartCell.configureCell()
                collectionView.selectItem(at: startDateIndexPath!, animated: false, scrollPosition: .left)
            }
        }
    }
    
    override public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if selectedEndDate == nil && startDateIndexPath == indexPath {
            return false
        }
        return true
    }
    
    override public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DatePickerCell
        
        cell.type.insert(.Highlighted)
        cell.configureCell()
    }
    
    override public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! DatePickerCell

        return cell.type.contains(.Date)
    }
    
    override public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DatePickerCell
        
        cell.type.remove(.Highlighted)
        cell.configureCell()
    }
    
    func configure(cell: DatePickerCell, withIndexPath indexPath: IndexPath) {
        let dateData = days[indexPath.section]
        let month = calendar.component(.month, from: months[indexPath.section])
        let year = calendar.component(.year, from: months[indexPath.section])
        
        if indexPath.item < dateData.prepend || indexPath.item >= (dateData.prepend + dateData.days) {
            cell.dateLabel.text = ""
            cell.type = [.Empty]
        } else {
            let todayYear = calendar.component(.year, from: today)
            let todayMonth = calendar.component(.month, from: today)
            let todayDay = calendar.component(.day, from: today)
            
            let curDay = indexPath.item - dateData.prepend + 1
            let isPastDate = year == todayYear && month == todayMonth && curDay < todayDay
            
            cell.dateLabel.text = String(curDay)
            cell.dateLabel.textColor =  UIColor.white
            cell.type = isPastDate ? [.PastDate] : [.Date]
            
            if todayDay == curDay, todayMonth == month, todayYear == year  {
                cell.type.insert(.Today)
            }
        }
        
        if startDateIndexPath != nil && indexPath == startDateIndexPath {
            if endDateIndexPath == nil {
                cell.type.insert(.Selected)
            } else {
                cell.type.insert(.SelectedStartDate)
            }
        }
        
        if endDateIndexPath != nil {
            if indexPath == endDateIndexPath {
                cell.type.insert(.SelectedEndDate)
            } else if isInBetween(indexPath: indexPath) {
                cell.type.insert(.InBetweenDate)
            }
        }
        
        cell.configureCell()
    }
    
    
    func isInBetween(indexPath: IndexPath) -> Bool {
        if let start = startDateIndexPath, let end = endDateIndexPath {
            return (indexPath.section > start.section || (indexPath.section == start.section && indexPath.item > start.item))
                && (indexPath.section < end.section || (indexPath.section == end.section && indexPath.item < end.item))
        }
        return false
    }
    
    func selectInBetweenCells() {
        var section = startDateIndexPath!.section
        var item = startDateIndexPath!.item
        
        var indexPathArr = [IndexPath]()
        while section < months.count, section <= endDateIndexPath!.section {
            let curIndexPath = IndexPath(item: item, section: section)
            if let cell = collectionView?.cellForItem(at: curIndexPath) as? DatePickerCell {
                if curIndexPath != startDateIndexPath && curIndexPath != endDateIndexPath {
                    cell.type.insert(.InBetweenDate)
                    cell.configureCell()
                }
                indexPathArr.append(curIndexPath)
            }
            
            if section == endDateIndexPath!.section && item >= endDateIndexPath!.item {
                // stop iterating beyond end date
                break
            } else if item >= (collectionView!.numberOfItems(inSection: section) - 1) {
                // more than num of days in the month
                section += 1
                item = 0
            } else {
                item += 1
            }
        }
        
        collectionView?.performBatchUpdates({
            () in
            self.collectionView?.reloadItems(at: indexPathArr)
        }, completion: nil)
    }
    
    func deselectSelectedCells() {
        if let start = startDateIndexPath {
            var section = start.section
            var item = start.item + 1
            
            if let cell = collectionView?.cellForItem(at: start) as? DatePickerCell {
                cell.type.remove([.InBetweenDate, .SelectedStartDate, .SelectedEndDate, .Selected])
                cell.configureCell()
                collectionView?.deselectItem(at: start, animated: false)
            }
            
            if let end = endDateIndexPath {
                var indexPathArr = [IndexPath]()
                while section < months.count, section <= end.section {
                    let curIndexPath = IndexPath(item: item, section: section)
                    if let cell = collectionView?.cellForItem(at: curIndexPath) as? DatePickerCell {
                        cell.type.remove([.InBetweenDate, .SelectedStartDate, .SelectedEndDate, .Selected])
                        cell.configureCell()
                        collectionView?.deselectItem(at: curIndexPath, animated: false)
                    }
                    
                    if section == end.section && item >= end.item {
                        // stop iterating beyond end date
                        break
                    } else if item >= (collectionView!.numberOfItems(inSection: section) - 1) {
                        // more than num of days in the month
                        section += 1
                        item = 0
                    } else {
                        item += 1
                    }
                }
                
                collectionView?.performBatchUpdates({
                    () in
                    self.collectionView?.reloadItems(at: indexPathArr)
                }, completion: nil)
            }
        }
    }
    
    // MARK: - Event Handlers
    
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleClearInput() {
        deselectSelectedCells()
        selectedStartDate = nil
        selectedEndDate = nil
        
        startDateIndexPath = nil
        endDateIndexPath = nil
    }
    
    func loadMoreMonths(completion: (() -> Void)?) {
        let lastDate = months.last!
        let month = calendar.component(.month, from: lastDate)
        let year = calendar.component(.year, from: lastDate)
        var dateComp = DateComponents(year: year, month: month + 1, day: 1)
        var curMonth = calendar.date(from: dateComp)
        
        for _ in 0..<subsequentMonthsLoadCount {
            months.append(curMonth!)
            
            let numOfDays = calendar.range(of: .day, in: .month, for: curMonth!)!.count
            let firstWeekDay = calendar.component(.weekday, from: curMonth!.startOfMonth())
            let lastWeekDay = calendar.component(.weekday, from: curMonth!.endOfMonth())
            
            days.append((days: numOfDays, prepend: firstWeekDay - 1, append: 7 - lastWeekDay))
            curMonth = calendar.date(byAdding: .month, value: 1, to: curMonth!)
            
        }
        
        if let handler = completion {
            handler()
        }
    }
    
    // MARK: - Functions
    
    func findIndexPath(forDate date: Date) -> IndexPath? {
        var indexPath: IndexPath? = nil
        if let section = months.index(where: {
            calendar.component(.year, from: $0) == calendar.component(.year, from: date) && calendar.component(.month, from: $0) == calendar.component(.month, from: date)}) {
            let item = days[section].prepend + calendar.component(.day, from: date) - 1
            indexPath = IndexPath(item: item, section: section)
        }
        return indexPath
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - AirbnbDatePickerFooterDelegate

extension DatePickerViewController: DatePickerFooterDelegate {
    func didSave() {
        if let del = delegate {
            del.datePickerController(self, didSaveStartDate: selectedStartDate, endDate: selectedEndDate)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

