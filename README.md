# The Hundred App

The Hundred App helps users track the progress of goals of any kind, be it a fitness goal or an academic goal.  It focuses on the habit-forming period of the first 100 days by allowing users to provide their own metrics flexibly to measure goals, visually track the progress through graphs, and simultaneously accessing them through multiple platforms like an iOS device or an iPadOS device.

## App Store

https://apps.apple.com/ca/app/the-hundred-app/id1533557255

## Components

### Core Data

Using `NSFetchedResultsController` and the `NSFetchedResultsControllerDelegate` methods to manage Core Data. 

```swift
var fetchedResultsController: NSFetchedResultsController<Goal>?
if fetchedResultsController == nil {
    let request = NSFetchRequest<Goal>(entityName: "Goal")
    let sort = NSSortDescriptor(key: "date", ascending: false)
    request.sortDescriptors = [sort]
    request.fetchBatchSize = 20
    
    fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController?.delegate = self
}
do {
    try fetchedResultsController?.performFetch()
} catch {
    print("Fetch failed")
}

DispatchQueue.main.async {
    self.tableView.reloadData()
}
```

In order to calculate the arithemtics of the metrics, `NSExpression` and `NSExpressionDescription` are used as part of the Core Data fetch requests. 

```swift
// sum
let sumExpression =  NSExpression(forFunction: "sum:", arguments: [keypathExpression])
let sumKey = "Sum"

let sumExpressionDescription = NSExpressionDescription()
sumExpressionDescription.name = sumKey
sumExpressionDescription.expression = sumExpression
sumExpressionDescription.expressionResultType = .decimalAttributeType

// median
let mdnExpression =  NSExpression(forFunction: "median:", arguments: [keypathExpression])
let mdnKey = "mdnValue"

let mdnExpressionDescription = NSExpressionDescription()
mdnExpressionDescription.name = mdnKey
mdnExpressionDescription.expression = mdnExpression
mdnExpressionDescription.expressionResultType = .decimalAttributeType

// standar deviation
let stdExpression =  NSExpression(forFunction: "stddev:", arguments: [keypathExpression])
let stdKey = "stdValue"

let stdExpressionDescription = NSExpressionDescription()
stdExpressionDescription.name = stdKey
stdExpressionDescription.expression = stdExpression
stdExpressionDescription.expressionResultType = .decimalAttributeType

metricFetchRequest.propertiesToFetch = [maxExpressionDescription, minExpressionDescription, avgExpressionDescription, sumExpressionDescription]
```



### Charts

Uses the [Charts library](https://github.com/danielgindi/Charts) to construct line graphs for displaying the progress of the users' metrics.  

```swift
let dataSet = metricDict.map { (set) -> LineChartDataSet in
    let lineChartDataSet = LineChartDataSet(entries: set.value, label: set.key)
    lineChartDataSet.drawIconsEnabled = false
    lineChartDataSet.lineDashLengths = [5, 2.5]
    lineChartDataSet.highlightLineDashLengths = [5, 2.5]
    let randomColour = UIColor(red: CGFloat.random(in: 50..<255)/255, green: CGFloat.random(in: 0..<220)/255, blue: CGFloat.random(in: 0..<220)/255, alpha: 0.8)
    lineChartDataSet.setColor(randomColour)
    lineChartDataSet.setCircleColor(randomColour)
    lineChartDataSet.lineWidth = 1
    lineChartDataSet.circleRadius = 3
    lineChartDataSet.drawCircleHoleEnabled = false
    lineChartDataSet.valueFont = .systemFont(ofSize: 9)
    lineChartDataSet.formLineDashLengths = [5, 2.5]
    lineChartDataSet.formLineWidth = 1
    lineChartDataSet.formSize = 15
    return lineChartDataSet
}

let data = LineChartData(dataSets: dataSet)
data.setValueTextColor(.white)
data.setValueFont(.systemFont(ofSize: 9))
return data
```

Pie chart is used to show the goals in relation to each other.

```swift
chartView = PieChartView()
chartView.delegate = self
view.addSubview(chartView)
chartView.translatesAutoresizingMaskIntoConstraints = false
chartView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
chartView.heightAnchor.constraint(equalTo: chartView.widthAnchor).isActive = true
chartView.topAnchor.constraint(equalTo: view.topAnchor, constant: -20).isActive = true

chartView.chartDescription?.enabled = false
chartView.drawHoleEnabled = true
chartView.rotationAngle = 0
chartView.rotationEnabled = true
chartView.isUserInteractionEnabled = true
chartView.legend.enabled = true
chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
chartView.drawEntryLabelsEnabled = false
```

### iCloud

[NSUbiquitousKeyValueStore](https://developer.apple.com/documentation/foundation/nsubiquitouskeyvaluestore) to share the key/value information of the user’s goal metrics across all devices through iCloud. 

```swift
let dateString = dateForPlist(date: Date().toLocalTime())
let keyValStore = NSUbiquitousKeyValueStore.default
// if the heatmap key/value already exists
if var dict = keyValStore.dictionary(forKey: "heatmap") as? [String : [String : Int]] {
    // if the goal already exists, update the heatmap key/value for the existing goal
    if let oldGoalTitle = existingGoal?.title {
        if let oldGoalData = dict[oldGoalTitle] {
            if var count = oldGoalData[dateString] {
                count += 1
                dict.updateValue([dateString: count], forKey: oldGoalTitle)
                keyValStore.set(dict, forKey: "heatmap")
                keyValStore.synchronize()
            } else {
                dict.updateValue([dateString: 1], forKey: oldGoalTitle)
                keyValStore.set(dict, forKey: "heatmap")
                keyValStore.synchronize()
            }
        } else {
            dict[oldGoalTitle] = [dateString: 1]
            keyValStore.set(dict, forKey: "heatmap")
            keyValStore.synchronize()
        }
    }
    
    /// Rest abbreviated
}
```

`CKRecord` is used to post information to the `iCloud` public database.

```swift
guard isICloudContainerAvailable() == true else {
    switchControl.setOn(false, animated: true)
    return
}
guard profile != nil else { return }

// public cloud database
let progressRecord = CKRecord(recordType: MetricAnalytics.Progress.rawValue)
// public entry's unique id gets linked to the Progress entity
progress.recordName = progressRecord.recordID.recordName
goal.progress.insert(progress)
self.saveContext()

progressRecord[MetricAnalytics.goal.rawValue] = goal.title as CKRecordValue
progressRecord[MetricAnalytics.comment.rawValue] = comment as CKRecordValue

// profile
progressRecord[MetricAnalytics.username.rawValue] = profile.username
progressRecord[MetricAnalytics.userId.rawValue] = profile.userId
if let detail = profile.detail {
    progressRecord[MetricAnalytics.profileDetail.rawValue] = detail
}
if let profileImage = profile.image, profileImage != "" {
    let profileImagePath = getDocumentsDirectory().appendingPathComponent(profileImage)
    progressRecord[MetricAnalytics.profileImage.rawValue] = CKAsset(fileURL: profileImagePath)
}

// analytics
progressRecord[MetricAnalytics.longitude.rawValue] = self.location?.longitude
progressRecord[MetricAnalytics.latitude.rawValue] = self.location?.latitude

// min, max, avg, total
try? progressRecord.encode(metricDict, forKey: MetricAnalytics.metrics.rawValue)
progressRecord[MetricAnalytics.date.rawValue] = Date()

// image
if let imagePath = self.imagePath {
    progressRecord[MetricAnalytics.image.rawValue] = CKAsset(fileURL: imagePath)
}

/// Rest abbreviated

```

### IAP

Uses `StoreKit` to facilitate the use of IAP by users.  The `CloudKit` allows users to share and fetch goals and metrics to/from the iCloud public database. 

```swift
class StoreManager: NSObject {
    // MARK: - Types
    
    static let shared = StoreManager()
    
    // MARK: - Properties
    
    /// Keeps track of all valid products. These products are available for sale in the App Store.
    fileprivate var availableProducts = [SKProduct]()
    
    /// Keeps track of all invalid product identifiers.
    fileprivate var invalidProductIdentifiers = [String]()
    
    /// Keeps a strong reference to the product request.
    fileprivate var productRequest: SKProductsRequest!
    
    /// Keeps track of all valid products (these products are available for sale in the App Store) and of all invalid product identifiers.
    fileprivate var storeResponse = [Section]()
    
    weak var delegate: StoreManagerDelegate?
    
    // MARK: - Initializer
    
    private override init() {}
    
    // MARK: - Request Product Information
    
    /// Starts the product request with the specified identifiers.
    func startProductRequest(with identifiers: [String]) {
        fetchProducts(matchingIdentifiers: identifiers)
    }
    
    /// Fetches information about your products from the App Store.
    /// - Tag: FetchProductInformation
    fileprivate func fetchProducts(matchingIdentifiers identifiers: [String]) {
        // Create a set for the product identifiers.
        let productIdentifiers = Set(identifiers)
        
        // Initialize the product request with the above identifiers.
        productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        
        // Send the request to the App Store.
        productRequest.start()
    }
    
    /// Rest of the IAP code
}
```

## Screetshots

1. The GitHub style calendar for visual representation of efforts towards goals.

![](https://github.com/igibliss00/readmetest/blob/master/ReadmeAssets/1.png)

2. Posting to and fetching from iCloud public database.

![](https://github.com/igibliss00/readmetest/blob/master/ReadmeAssets/2.png)

3. Goals table view with swipe trailing options and context menus.

![](https://github.com/igibliss00/readmetest/blob/master/ReadmeAssets/3.png)

4. NSExpression and NSExpressionDescription for calculating arithmetics of goal metrics.

![](https://github.com/igibliss00/readmetest/blob/master/ReadmeAssets/4.png)

