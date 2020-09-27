//
//  UserDetailViewController.swift
//  Hundred
//
//  Created by J C on 2020-09-13.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CloudKit
import Charts
import MapKit
import CoreData

class UserDetailViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    var stackView: UIStackView!
    var user: CKRecord?
    var analytics: [CKRecord]?
    var coverImageView = UIImageView()
    var imageConstraints: [NSLayoutConstraint] = []
    let metricCard = MetricCard()
    var commentLabel: UILabel!
    var streakContainer: UIView!
    var currentStreakLabel: UILabel!
    var longestStreakLabel: UILabel!
    var currentStreakTitle: UILabel!
    var longestStreakTitle: UILabel!
    var subTitleLabel: CustomLabel!
    var goalTitle: String?
    var userId: String?
    var email: String?
    var date: Date?
    var username: String?
    var comment: String?
    var entryCount: Int?
    var metricsDict: [String: String]?
    var currentStreak: Int?
    var longestStreak: Int?
    var currentMetricsContainer: UIStackView!
    var barChart: BarChartView!
    let borderColor = UIColor.gray
    var longitude: Double?
    var latitude: Double?
    var mapView: MKMapView!
    var addressLine: String!
    var isSubscribed: Bool! {
        didSet {
            if isSubscribed == true {
                let unsubscribeButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"), style: .done, target: self, action: #selector(self.unsubscribe))
                unsubscribeButton.tintColor = .black
                
                self.navigationItem.rightBarButtonItems = [unsubscribeButton]
            } else {
                let subscribeButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .done, target: self, action: #selector(self.subscribe))
                subscribeButton.tintColor = .black
                
                self.navigationItem.rightBarButtonItems = [subscribeButton]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setConstraints()
    }
    
    func configureUI() {
        scrollView.addSubview(coverImageView)
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 30
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 25, bottom: 0, trailing: 25)
        scrollView.addSubview(stackView)
        
        // image
        if let user = user, let imageAsset = user.object(forKey: MetricAnalytics.image.rawValue) as? CKAsset {
            metricCard.loadCoverPhoto(imageAsset: imageAsset) { (image) in
                if let image = image {
                    self.coverImageView.image = image
                    self.coverImageView.contentMode = .scaleAspectFill
                    self.coverImageView.clipsToBounds = true
                }
            }
        }
        
        if let user = user {
            self.title = user.object(forKey: MetricAnalytics.goal.rawValue) as? String
            userId = user.object(forKey: MetricAnalytics.userId.rawValue) as? String
            email = user.object(forKey: MetricAnalytics.email.rawValue) as? String
            date = user.object(forKey: MetricAnalytics.date.rawValue) as? Date
            username = user.object(forKey: MetricAnalytics.username.rawValue) as? String
            comment = user.object(forKey: MetricAnalytics.comment.rawValue) as? String
            entryCount = user.object(forKey: MetricAnalytics.entryCount.rawValue) as? Int
            // today's metric/value pair, not the analytics
            metricsDict = try? user.decode(forKey: MetricAnalytics.metrics.rawValue) as [String: String]
            currentStreak = user.object(forKey: MetricAnalytics.currentStreak.rawValue) as? Int
            longestStreak = user.object(forKey: MetricAnalytics.longestStreak.rawValue) as? Int
            longitude = user.object(forKey: MetricAnalytics.longitude.rawValue) as? Double
            latitude = user.object(forKey: MetricAnalytics.latitude.rawValue) as? Double
            
            // bookmark button
            if !user.wasCreatedByThisUser {
                if let userId = userId {
                    // if the post doesn't belong to the current user, show the subscribe/unsubscribe button
                    let subscriptionRequest = NSFetchRequest<Subscription>(entityName: "Subscription")
                    subscriptionRequest.predicate = NSPredicate(format: "userId == %@", userId as CVarArg)
                    if let fetchedSubscriptions = try? self.context.fetch(subscriptionRequest) {
                        print("fetchedSubscriptions-------------------: \(fetchedSubscriptions)")
                        if fetchedSubscriptions.count > 0 {
                            isSubscribed = true
                        } else {
                            isSubscribed = false
                        }
                    }
                }
            } else {
                // the post belongs to the current user
                
            }
        }
        
        // date
        if let date = date {
            let dateLabelTheme = UILabelTheme(font: UIFont.body.with(weight: .regular), color: .gray, lineBreakMode: .byTruncatingTail, textAlignment: .right)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d y"
            let dateLabel = UILabel(theme: dateLabelTheme, text: dateFormatter.string(from: date))
            stackView.addArrangedSubview(dateLabel)
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            stackView.setCustomSpacing(0, after: dateLabel)
        }
        
        // username
        if let username = username {
            let usernameLabelTheme = UILabelTheme(font: UIFont.body.with(weight: .bold), color: .darkGray, lineBreakMode: .byTruncatingTail, textAlignment: .right)
            let usernameLabel = UILabel(theme: usernameLabelTheme, text: username)
            stackView.addArrangedSubview(usernameLabel)
            usernameLabel.translatesAutoresizingMaskIntoConstraints = false
            usernameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        
        // comment
        commentLabel = UILabel()
        commentLabel.numberOfLines = 0
        commentLabel.adjustsFontSizeToFitWidth = false
        commentLabel.lineBreakMode = .byTruncatingTail
        commentLabel.font = UIFont.preferredFont(forTextStyle: .body)
        commentLabel.text = comment ?? " "
        
        addCard(text: "Comment", subItem: commentLabel, stackView: stackView, containerHeight: 40, bottomSpacing: nil, insert: nil, tag: nil, topInset: nil, bottomInset: nil, widthMultiplier: nil, isShadowBorder: false)
        
        streakContainer = UIView()
        streakContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        streakContainer.layer.borderWidth = 0.8
        streakContainer.layer.cornerRadius = 7.0
        stackView.addArrangedSubview(streakContainer)
        streakContainer.translatesAutoresizingMaskIntoConstraints = false
        streakContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //longest, current streaks
        let unitLabelTheme = UILabelTheme(font: UIFont.caption.with(weight: .bold), color: .lightGray, lineBreakMode: .byTruncatingTail)
        currentStreakTitle = UILabel(theme: unitLabelTheme, text: "Current Streak")
        longestStreakTitle = UILabel(theme: unitLabelTheme, text: "Longest Streak")
        
        currentStreakLabel = UILabel()
        currentStreakLabel.text = String(currentStreak ?? 0)
        
        longestStreakLabel = UILabel()
        longestStreakLabel.text = String(longestStreak ?? 0)
        
        streakContainer.addSubview(currentStreakLabel)
        streakContainer.addSubview(longestStreakLabel)
        streakContainer.addSubview(currentStreakTitle)
        streakContainer.addSubview(longestStreakTitle)
        
        // bar chart
        barChart = BarChartView()
        barChart = metricCard.setupBarChart(entryCount: entryCount ?? 0)
        addCard(text: "Progress Chart", subItem: barChart, stackView: stackView, containerHeight: 100, bottomSpacing: nil, insert: nil, tag: nil, topInset: nil, bottomInset: nil, widthMultiplier: nil, isShadowBorder: false)
        
        // current metrics
        currentMetricsContainer = UIStackView()
        currentMetricsContainer.axis = .vertical
        currentMetricsContainer.alignment = .fill
        currentMetricsContainer.spacing = 10
        currentMetricsContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        currentMetricsContainer.layer.borderWidth = 0.8
        currentMetricsContainer.layer.cornerRadius = 7.0
        currentMetricsContainer.isLayoutMarginsRelativeArrangement = true
        currentMetricsContainer.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0)
        currentMetricsContainer.translatesAutoresizingMaskIntoConstraints = false
        currentMetricsContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        if let metricsDict = metricsDict, !metricsDict.isEmpty {
            //            let metricsDictt = ["lbs": "23", "km": "223", "kg": "30", "jik": "209", "dkj": "2090"]
            for currentMetricPair in metricsDict {
                let pairContainer = UIView()
                
                currentMetricsContainer.addArrangedSubview(pairContainer)
                pairContainer.translatesAutoresizingMaskIntoConstraints = false
                pairContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
                
                let currentMetricLabel = UILabel()
                currentMetricLabel.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
                currentMetricLabel.layer.borderWidth = 0.8
                //                currentMetricLabel.layer.cornerRadius = 7.0
                currentMetricLabel.text = currentMetricPair.key
                currentMetricLabel.textAlignment = .center
                currentMetricLabel.lineBreakMode = .byTruncatingTail
                currentMetricLabel.backgroundColor = UIColor(red: 104/255, green: 144/255, blue: 136/255, alpha: 1.0)
                currentMetricLabel.textColor = .white
                pairContainer.addSubview(currentMetricLabel)
                
                let currentMetricValue = UILabel()
                currentMetricValue.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
                currentMetricValue.layer.borderWidth = 0.8
                currentMetricValue.text = currentMetricPair.value
                currentMetricValue.textAlignment = .center
                currentMetricValue.lineBreakMode = .byTruncatingTail
                pairContainer.addSubview(currentMetricValue)
                
                currentMetricLabel.translatesAutoresizingMaskIntoConstraints = false
                currentMetricLabel.leadingAnchor.constraint(equalTo: pairContainer.leadingAnchor, constant: 13).isActive = true
                currentMetricLabel.trailingAnchor.constraint(equalTo: currentMetricValue.leadingAnchor).isActive = true
                currentMetricLabel.widthAnchor.constraint(greaterThanOrEqualTo: pairContainer.widthAnchor, multiplier: 0.45).isActive = true
                currentMetricLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
                
                currentMetricValue.translatesAutoresizingMaskIntoConstraints = false
                currentMetricValue.leadingAnchor.constraint(equalTo: currentMetricLabel.trailingAnchor).isActive = true
                currentMetricValue.trailingAnchor.constraint(equalTo: pairContainer.trailingAnchor, constant: -13).isActive = true
                currentMetricValue.widthAnchor.constraint(greaterThanOrEqualTo: pairContainer.widthAnchor, multiplier: 0.45).isActive = true
                currentMetricValue.heightAnchor.constraint(equalToConstant: 30).isActive = true
            }
        } else {
            let subTitleLabel = CustomLabel()
            subTitleLabel.text = "No Metrics"
            subTitleLabel.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
            subTitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
            subTitleLabel.textAlignment = .center
            currentMetricsContainer.addArrangedSubview(subTitleLabel)
            currentMetricsContainer.isLayoutMarginsRelativeArrangement = true
            currentMetricsContainer.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        }
        
        addCard(text: "Today's Metrics", subItem: currentMetricsContainer, stackView: stackView, containerHeight: 60, bottomSpacing: nil, insert: nil, tag: nil, topInset: nil, bottomInset: nil, widthMultiplier: nil, isShadowBorder: false)
        
        if let analytics = analytics {
            for result in analytics {
                let metricTitle = result.object(forKey: MetricAnalytics.metricTitle.rawValue) as! String
                let max = result.object(forKey: MetricAnalytics.Max.rawValue) as! String
                let min = result.object(forKey: MetricAnalytics.Min.rawValue) as! String
                let average = result.object(forKey: MetricAnalytics.Average.rawValue) as! String
                let sum = result.object(forKey: MetricAnalytics.Sum.rawValue) as! String
                let dict: [String: NSDecimalNumber] = [
                    MetricAnalytics.Max.rawValue: UnitConversion.stringToDecimal(string: max),
                    MetricAnalytics.Min.rawValue: UnitConversion.stringToDecimal(string: min),
                    MetricAnalytics.Average.rawValue: UnitConversion.stringToDecimal(string: average),
                    MetricAnalytics.Sum.rawValue: UnitConversion.stringToDecimal(string: sum)
                ]
                
                DispatchQueue.main.async {
                    self.metricCard.displayMetrics(metricStackView: self.stackView, metric: metricTitle, dict: dict)
                }
            }
        }
        
        if let latitude = latitude, let longitude = longitude {
            mapView = MKMapView()
            mapView.delegate = self
            
            let location = CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))
            let regionRadius: CLLocationDistance = 10000
            let coorindateRegion = MKCoordinateRegion.init(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coorindateRegion, animated: true)
            
            var annotation: MKAnnotation!
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { (placemarks, error) in
                if error == nil {
                    let placemark = placemarks?[0]
                    if let placemark = placemark {
                        let firstSpace = (placemark.thoroughfare != nil && placemark.subThoroughfare != nil) ? " ": ""
                        let comma = (placemark.subThoroughfare != nil || placemark.thoroughfare != nil) && (placemark.subAdministrativeArea != nil || placemark.administrativeArea != nil) ? ", ": ""
                        let secondSpace = (placemark.subAdministrativeArea != nil && placemark.administrativeArea != nil) ? " ": ""
                        self.addressLine = String(
                            format: "%@%@%@%@%@%@%@",
                            // street number
                            placemark.subThoroughfare ?? "",
                            firstSpace,
                            // street name
                            placemark.thoroughfare ?? "",
                            comma,
                            //city
                            placemark.locality ?? "",
                            secondSpace,
                            // state or province
                            placemark.administrativeArea ?? ""
                        )
                    }
                    
                    DispatchQueue.main.async {
                        annotation = MyAnnotation(title:  self.addressLine, locationName: "", discipline: "", coordinate: location)
                        self.mapView.addAnnotation(annotation)
                    }
                } else {
                    DispatchQueue.main.async {
                        annotation = MyAnnotation(title:  "", locationName: "", discipline: "", coordinate: location)
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
            
            let mapContainerView = UIView()
            BorderStyle.customShadowBorder(for: mapContainerView)
            mapContainerView.addSubview(mapView)
            mapView.pin(to: mapContainerView)
            stackView.addArrangedSubview(mapContainerView)
            mapContainerView.translatesAutoresizingMaskIntoConstraints = false
            mapContainerView.heightAnchor.constraint(equalTo: mapContainerView.widthAnchor).isActive = true
        }
    }
    
    func setConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        if let user = user, let _ = user.object(forKey: MetricAnalytics.image.rawValue) as? CKAsset {
            coverImageView.translatesAutoresizingMaskIntoConstraints = false
            coverImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            coverImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor, multiplier: 9/16).isActive = true
            stackView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 30).isActive = true
        } else {
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        }
        
        barChart.translatesAutoresizingMaskIntoConstraints = false
        barChart.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        currentStreakLabel.translatesAutoresizingMaskIntoConstraints = false
        currentStreakLabel.widthAnchor.constraint(equalTo: streakContainer.widthAnchor, multiplier: 0.5).isActive = true
        currentStreakLabel.leadingAnchor.constraint(equalTo: streakContainer.leadingAnchor, constant: 15).isActive = true
        currentStreakLabel.topAnchor.constraint(equalTo: streakContainer.topAnchor, constant: 10).isActive = true
        
        longestStreakLabel.translatesAutoresizingMaskIntoConstraints = false
        longestStreakLabel.widthAnchor.constraint(equalTo: streakContainer.widthAnchor, multiplier: 0.5).isActive = true
        longestStreakLabel.leadingAnchor.constraint(equalTo: currentStreakLabel.trailingAnchor, constant: 5).isActive = true
        longestStreakLabel.topAnchor.constraint(equalTo: streakContainer.topAnchor, constant: 10).isActive = true
        
        currentStreakTitle.translatesAutoresizingMaskIntoConstraints = false
        currentStreakTitle.widthAnchor.constraint(equalTo: streakContainer.widthAnchor, multiplier: 0.5).isActive = true
        currentStreakTitle.topAnchor.constraint(equalTo: currentStreakLabel.bottomAnchor).isActive = true
        currentStreakTitle.leadingAnchor.constraint(equalTo: streakContainer.leadingAnchor, constant: 15).isActive = true
        currentStreakTitle.bottomAnchor.constraint(greaterThanOrEqualTo: streakContainer.bottomAnchor, constant: -10).isActive = true
        
        longestStreakTitle.translatesAutoresizingMaskIntoConstraints = false
        longestStreakTitle.widthAnchor.constraint(equalTo: streakContainer.widthAnchor, multiplier: 0.5).isActive = true
        longestStreakTitle.leadingAnchor.constraint(equalTo: currentStreakTitle.trailingAnchor, constant: 5).isActive = true
        longestStreakTitle.topAnchor.constraint(equalTo: longestStreakLabel.bottomAnchor).isActive = true
        longestStreakTitle.bottomAnchor.constraint(greaterThanOrEqualTo: streakContainer.bottomAnchor, constant: -10).isActive = true
    }
    
    @objc func subscribe() {
        if let userId = userId {
            // creaet a subscription using userID
            let predicate = NSPredicate(format: "userId == %@", userId)
            let subscription = CKQuerySubscription(recordType: MetricAnalytics.Progress.rawValue, predicate: predicate, options: .firesOnRecordCreation)
            
            // notification format for when the new post is posted
            let notification = CKSubscription.NotificationInfo()
            notification.title = "The Hundred App"
            notification.alertBody = "\(self.username ?? "A person you're following") made a new post"
            notification.soundName = "default"
            subscription.notificationInfo = notification
            
            let database = CKContainer.default().publicCloudDatabase
            // first attempt to save on public cloud
            database.save(subscription) { (result, error) in
                if let error = error {
                    // if there is a duplicate subscription, delete the existing one
                    if error.localizedDescription.contains("duplicate") {
                        // get the subscription ID from the error message
                        if let duplicateSubscriptionID = error.localizedDescription.slice(from: "'", to: "'") {
                            database.delete(withSubscriptionID: duplicateSubscriptionID) { (result, error) in
                                if let error = error {
                                    print("error from duplicate error handling:  \(error.localizedDescription)")
                                    self.showAlert(title: "Error", message: "Sorry, there was an error subscribing to this user. Please try again", action: nil)
                                } else {
                                    // second attempt to save after deleting the duplicate
                                    database.save(subscription) { (result, error) in
                                        if let error = error {
                                            print("error from a second attempt to save:  \(error.localizedDescription)")
                                            self.showAlert(title: "Error", message: "Sorry, there was an error subscribing to this user. Please try again", action: nil)
                                        } else if let result = result {
                                            DispatchQueue.main.async {
                                                // check for an existing subscription for this post's creator in Core Data
                                                let subscriptionRequest = NSFetchRequest<Subscription>(entityName: "Subscription")
                                                subscriptionRequest.predicate = NSPredicate(format: "userId == %@", userId)
                                                if let fetchedSubscriptions = try? self.context.fetch(subscriptionRequest) {
                                                    // create a new subscription in Core Data since none exists
                                                    if fetchedSubscriptions.count == 0 {
                                                        let newSubscription = Subscription(context: self.context)
                                                        newSubscription.email = self.email ?? ""
                                                        newSubscription.userId = userId
                                                        newSubscription.username = self.username ?? ""
                                                        newSubscription.subscriptionId = result.subscriptionID
                                                        self.saveContext()
                                                        print("newSubscription1: \(newSubscription)")

                                                    } else {
                                                        for fetchedSubscription in fetchedSubscriptions {
                                                            self.context.delete(fetchedSubscription)
                                                        }
                                                        let newSubscription = Subscription(context: self.context)
                                                        newSubscription.email = self.email ?? ""
                                                        newSubscription.userId = userId
                                                        newSubscription.username = self.username ?? ""
                                                        newSubscription.subscriptionId = result.subscriptionID
                                                        self.saveContext()
                                                        print("newSubscription2: \(newSubscription)")

                                                    }
                                                }
                                                
                                                self.isSubscribed = true
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            // as a last resort, if the error message doesn't contain the subscription ID,
                            // delete the entire subscriptions from SKSubscriptions and start over
                            var subscriptionArr: [CKSubscription] = []
                            
                            // fetch all the subscription IDs from Core Data and reconstruct new subscriptions
                            DispatchQueue.main.async {
                                let subscriptionRequest = NSFetchRequest<Subscription>(entityName: "Subscription")
                                if let fetchedSubscriptions = try? self.context.fetch(subscriptionRequest) {
                                    for fetchedSubscription in fetchedSubscriptions {
                                        // create a subscription using userID
                                        let newPredicate = NSPredicate(format: "userId == %@", fetchedSubscription.userId)
                                        let newSubscription = CKQuerySubscription(recordType: MetricAnalytics.Progress.rawValue, predicate: newPredicate, options: .firesOnRecordCreation)
                                        
                                        // notification format for when the new post is posted
                                        let newNotification = CKSubscription.NotificationInfo()
                                        newNotification.title = "The Hundred App"
                                        newNotification.alertBody = "\(fetchedSubscription.username) made a new post"
                                        newNotification.soundName = "default"
                                        subscription.notificationInfo = newNotification
                                        
                                        subscriptionArr.append(newSubscription)
                                        
                                        // update Core Data with the new subscription IDs
                                        fetchedSubscription.subscriptionId = newSubscription.subscriptionID
                                    }
                                }
                            }

                            // fetch all the subscriptions to be deleted
                            var IDsToBeDeleted: [CKSubscription.ID] = []
                            database.fetchAllSubscriptions { (subscriptions, error) in
                                if let error = error {
                                    print("error from fetch all subscriptions: \(error.localizedDescription)")
                                } else if let subscriptions = subscriptions {
                                    for subscription in subscriptions {
                                        IDsToBeDeleted.append(subscription.subscriptionID)
                                    }
                                }
                            }
                            
                            let operation = CKModifySubscriptionsOperation(subscriptionsToSave: subscriptionArr, subscriptionIDsToDelete: IDsToBeDeleted)
                            operation.modifySubscriptionsCompletionBlock = { saved, deleted, error in
                              if let error = error{
                                print("error from modifySubscriptionsCompletionBlock: \(error.localizedDescription)")
                              }else{
                                print("Subscriptions saved: \(String(describing: saved))\nSubscriptions deleted: \(String(describing: deleted))")
                                DispatchQueue.main.async {
                                    // only save the newly updated data to Core Data if the subscription update is successful
                                    self.saveContext()
                                }
                              }
                            }

                            database.add(operation)
                        }
                    } else {
                        self.showAlert(title: "Error", message: "Sorry, there was an error subscribing to this user. Please try again", action: nil)
                    }
                } else if let result = result {
                    DispatchQueue.main.async {
                        // check for an existing subscription for this post's creator in Core Data
                        let subscriptionRequest = NSFetchRequest<Subscription>(entityName: "Subscription")
                        subscriptionRequest.predicate = NSPredicate(format: "userId == %@", userId)
                        if let fetchedSubscriptions = try? self.context.fetch(subscriptionRequest) {
                            // create a new subscription in Core Data since none exists
                            if fetchedSubscriptions.count == 0 {
                                let newSubscription = Subscription(context: self.context)
                                newSubscription.email = self.email ?? ""
                                newSubscription.userId = userId
                                newSubscription.username = self.username ?? ""
                                newSubscription.subscriptionId = result.subscriptionID
                                self.saveContext()
                                print("newSubscription3: \(newSubscription)")

                            } else {
                                for fetchedSubscription in fetchedSubscriptions {
                                    self.context.delete(fetchedSubscription)
                                }
                                let newSubscription = Subscription(context: self.context)
                                newSubscription.email = self.email ?? ""
                                newSubscription.userId = userId
                                newSubscription.username = self.username ?? ""
                                newSubscription.subscriptionId = result.subscriptionID
                                self.saveContext()
                                print("newSubscription4: \(newSubscription)")

                            }
                        }
                        
                        self.isSubscribed = true
                    }
                }
            }
        }
    }
    
    @objc func unsubscribe() {
        if let userId = userId {
            let subscriptionRequest = NSFetchRequest<Subscription>(entityName: "Subscription")
            subscriptionRequest.predicate = NSPredicate(format: "userId == %@", userId)
            if let fetchedSubscriptions = try? self.context.fetch(subscriptionRequest) {
                if fetchedSubscriptions.count > 0 {
                    var IDsToBeDeleted: [CKSubscription.ID] = []
                    for fetchedSubscription in fetchedSubscriptions {
                        IDsToBeDeleted.append(fetchedSubscription.subscriptionId)
                    }
                    
                    let operation = CKModifySubscriptionsOperation(subscriptionsToSave: nil, subscriptionIDsToDelete: IDsToBeDeleted)
                    operation.modifySubscriptionsCompletionBlock = { saved, deleted, error in
                      if let error = error{
                        print("error from modifySubscriptionsCompletionBlock: \(error.localizedDescription)")
                        self.showAlert(title: "Error", message: "Sorry, there was an error unsubscribing from this user. Please try again", action: nil)
                      }else{
                        print("Subscriptions saved: \(String(describing: saved))\nSubscriptions deleted: \(String(describing: deleted))")
                        DispatchQueue.main.async {
                            // only save the newly updated data to Core Data if the subscription update is successful
                            for fetchedSubscription in fetchedSubscriptions {
                                self.context.delete(fetchedSubscription)
                            }
                            self.saveContext()
                            self.isSubscribed = false
                        }
                      }
                    }

                    let database = CKContainer.default().publicCloudDatabase
                    database.add(operation)
                }
            }
        }
    }
    
    func showAlert(title: String, message: String, action: UIAlertAction?) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if let action = action {
                ac.addAction(action)
            }
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            if let popoverController = ac.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            self.present(ac, animated: true, completion: {() -> Void in
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.alertClose))
                ac.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
            })
        }
    }
}

extension UserDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MyAnnotation else { return nil }
        let identifier = "markerForEntry"
        var annotationView: MKMarkerAnnotationView
        if let deqeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            deqeuedView.annotation = annotation
            annotationView = deqeuedView
        } else {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .system)
        }
        
        return annotationView
    }
}

extension String {

    func slice(from: String, to: String) -> String? {

        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
