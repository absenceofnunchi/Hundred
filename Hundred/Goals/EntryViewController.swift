//
//  EntryViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-06.
//  Copyright © 2020 J. All rights reserved.
//

import CalendarHeatmap
import Charts
import UIKit
import CoreSpotlight
import MobileCoreServices
import MapKit
import CoreData

class EntryViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 25, bottom: 0, trailing: 25)
        scrollView.addSubview(stackView)
        return stackView
    }()
    
    var uiImage: UIImage!
    var progress: Progress! {
        didSet {
            commentLabel.text = progress.comment
            if let image = progress.image {
                let imagePath = getDocumentsDirectory().appendingPathComponent(image)
                if let data = try? Data(contentsOf: imagePath) {
                    uiImage = UIImage(data: data)
                    imageView.image = uiImage
                }
            } else {
                imageView.image = nil
            }
        }
    }
    
    var metrics: [String]?
    var data: [String: UIColor]!
    var detailTableVCDelegate: DetailTableViewController?
    var indexPathRow: Int!
    var indexPath: IndexPath!
    var addressLine: String = ""
    var imageView = UIImageView()
    
    private lazy var dateLabel: UILabel = {
        let dLabel = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        dLabel.text = dateFormatter.string(from: progress.date)
        dLabel.textAlignment = .right
        dLabel.textColor = .lightGray
        return dLabel
    }()
    
    private var commentLabel: UILabel = {
        let comment = UILabel()
        comment.numberOfLines = 0
        comment.adjustsFontSizeToFitWidth = false
        comment.lineBreakMode = .byTruncatingTail
        comment.font = UIFont.preferredFont(forTextStyle: .body)
        return comment
    }()
    
    private lazy var calendarHeatMap: CalendarHeatmap = {
        var config = CalendarHeatmapConfig()
        config.backgroundColor = UIColor(ciColor: .white)
        //        config.backgroundColor = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1.0)
        // config item
        config.selectedItemBorderColor = .white
        config.allowItemSelection = true
        // config month header
        config.monthHeight = 30
        config.monthStrings = DateFormatter().shortMonthSymbols
        config.monthFont = UIFont.systemFont(ofSize: 18)
        config.monthColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1.0)
        // config weekday label on left
        config.weekDayFont = UIFont.systemFont(ofSize: 12)
        config.weekDayWidth = 30
        config.weekDayColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1.0)
        
        var dateComponent = DateComponents()
        let yearsBefore = -1
        dateComponent.year = yearsBefore
        if let startDate = Calendar.current.date(byAdding: dateComponent, to: Date()) {
            let calendar = CalendarHeatmap(config: config, startDate: startDate, endDate: Date())
            calendar.delegate = self
            return calendar
        } else {
            let calendar = CalendarHeatmap(config: config, startDate: Date(2019, 1, 1), endDate: Date())
            calendar.delegate = self
            return calendar
        }
    }()
    
    var lineChartView = LineChartView()
    var mapView = MKMapView()
    var buttonPanel = UIView()
    
    private lazy var editButton: UIButton = {
        let gButton = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium, scale: .medium)
        let uiImage = UIImage(systemName: "pencil.circle", withConfiguration: largeConfig)
        gButton.tintColor = UIColor(red: 75/255, green: 123/255, blue: 236/255, alpha: 0.9)
        gButton.setImage(uiImage, for: .normal)
        gButton.tag = 1
        gButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        self.buttonPanel.addSubview(gButton)
        return gButton
    }()
    
    private lazy var deleteButton: UIButton = {
        let gButton = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium, scale: .medium)
        let uiImage = UIImage(systemName: "trash.circle", withConfiguration: largeConfig)
        gButton.tintColor = UIColor(red: 252/255, green: 92/255, blue: 101/255, alpha: 0.9)
        gButton.setImage(uiImage, for: .normal)
        gButton.tag = 2
        gButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        self.buttonPanel.addSubview(gButton)
        return gButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dataImporter = DataImporter(goalTitle: progress.goal.title)
        data = dataImporter.data
        
        configureUI()
        setConstraints()
        
        print("progress.recordName: -------------------- \(String(describing: progress.recordName))")
    }
    
    func configureUI() {
        title = progress.goal.title
        
        scrollView.addSubview(imageView)
        stackView.addArrangedSubview(dateLabel)
        stackView.setCustomSpacing(30, after: dateLabel)
        addCard(text: "Comment", subItem: commentLabel, stackView: stackView, containerHeight: 40, isShadowBorder: true)
        addCard(text: "Calendar", subItem: calendarHeatMap, stackView: stackView, containerHeight: 270, isShadowBorder: true)
        
        if progress.metric.count > 0 {
            lineChartView.data = loadMetricsData()
            lineChartView.rightAxis.enabled = false
            lineChartView.pinchZoomEnabled = true
            lineChartView.dragEnabled = true
            lineChartView.setScaleEnabled(true)
            lineChartView.drawBordersEnabled = false
            lineChartView.delegate = self
            
            let l = lineChartView.legend
            l.form = .circle
            l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
            l.textColor = .black
            l.horizontalAlignment = .right
            l.verticalAlignment = .top
            l.orientation = .horizontal
            l.drawInside = false
            l.xEntrySpace = 7
            
            let yAxis = lineChartView.leftAxis
            yAxis.labelFont = .boldSystemFont(ofSize: 12)
            yAxis.setLabelCount(6, force: false)
            yAxis.labelTextColor = .gray
            yAxis.axisLineColor = UIColor(white: 0.2, alpha: 0.4)
            yAxis.labelPosition = .outsideChart
            yAxis.gridColor = UIColor(white: 0.8, alpha: 0.4)
            
            let xAxis = lineChartView.xAxis
            xAxis.labelPosition = .bottom
            xAxis.labelFont = .boldSystemFont(ofSize: 10)
            xAxis.labelTextColor = .gray
            xAxis.axisLineColor = UIColor(white: 0.2, alpha: 0.4)
            xAxis.gridColor = UIColor(white: 0.8, alpha: 0.4)
            xAxis.drawLimitLinesBehindDataEnabled = true
            xAxis.drawAxisLineEnabled = false
            xAxis.granularityEnabled = true
            xAxis.granularity = 86400
            //                xAxis.valueFormatter = ChartXAxisFormatter(usingMetrics: metricsArr)
            xAxis.valueFormatter = ChartXAxisFormatter()
            
            let chartContainer = UIStackView()
            chartContainer.axis = .vertical
            chartContainer.distribution = .fill
            chartContainer.alignment = .fill
        }
        
        addCard(text: "Progress Chart", subItem: lineChartView, stackView: stackView, containerHeight: 270, isShadowBorder: true)

        if let latitude = progress.latitude, let longitude = progress.longitude, latitude != 0, longitude != 0 {
            mapView.delegate = self
            
            let location = CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
            let regionRadius: CLLocationDistance = 10000
            let coorindateRegion = MKCoordinateRegion.init(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coorindateRegion, animated: true)
            
            var annotation: MKAnnotation!
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude.doubleValue, longitude: longitude.doubleValue)) { (placemarks, error) in
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
                    
                    annotation = MyAnnotation(title:  self.addressLine, locationName: "hello", discipline: "", coordinate: location)
                    self.mapView.addAnnotation(annotation)
                    
                } else {
                    annotation = MyAnnotation(title:  "", locationName: "location name", discipline: "", coordinate: location)
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
                
        let mapContainerView = UIView()
        BorderStyle.customShadowBorder(for: mapContainerView)
        mapContainerView.addSubview(mapView)
        mapView.pin(to: mapContainerView)
        stackView.addArrangedSubview(mapContainerView)
        stackView.setCustomSpacing(70, after: mapContainerView)
        
        stackView.addArrangedSubview(buttonPanel)
    }
    
    var imageConstraints: [NSLayoutConstraint]!
    
    func setConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        if progress.image != nil {
            imageConstraints = [
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, constant: 9/16),
                stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
            ]
        } else {
            imageConstraints = [stackView.topAnchor.constraint(equalTo: scrollView.topAnchor)]
        }
        
        NSLayoutConstraint.activate(imageConstraints)
        
//        if progress.image != nil {
//            imageView.translatesAutoresizingMaskIntoConstraints = false
//            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
//            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, constant: 9/16).isActive = true
//            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
//            if uiImage.size.width > uiImage.size.height {
//                imageView.contentMode = .scaleAspectFit
//            } else {
//                imageView.contentMode = .scaleAspectFill
//            }
//        } else {
//            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        }
        
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        mapView.heightAnchor.constraint(equalToConstant: 270).isActive = true
        
        buttonPanel.translatesAutoresizingMaskIntoConstraints = false
        buttonPanel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.centerXAnchor.constraint(equalTo: buttonPanel.centerXAnchor, constant: -50).isActive = true
        editButton.centerYAnchor.constraint(equalTo: buttonPanel.centerYAnchor).isActive = true
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.centerXAnchor.constraint(equalTo: buttonPanel.centerXAnchor, constant: 50).isActive = true
        deleteButton.centerYAnchor.constraint(equalTo: buttonPanel.centerYAnchor).isActive = true
    }
    
    var metricDict = [String: [ChartDataEntry]]()
    var metricsArr: [Metric] = []
    
    func loadMetricsData() -> LineChartData {
        let metricsRequest = NSFetchRequest<Metric>(entityName: "Metric")
        metricsRequest.predicate = NSPredicate(format: "metricToGoal.title == %@", progress.goal.title)
        let sort = NSSortDescriptor(key: "date", ascending: true)
        metricsRequest.sortDescriptors = [sort]
        
        if let fetchedMetrics = try? self.context.fetch(metricsRequest) {
            if fetchedMetrics.count > 0 {
                metricsArr = fetchedMetrics
                for fetchedMetric in fetchedMetrics {
                    let date = fetchedMetric.date.timeIntervalSince1970
                    if var yValues = metricDict[fetchedMetric.unit] {
                        yValues.append(ChartDataEntry(x: date, y: Double(truncating: fetchedMetric.value)))
                        metricDict.updateValue(yValues, forKey: fetchedMetric.unit)
                    } else {
                        metricDict.updateValue([ChartDataEntry(x: date, y: Double(truncating: fetchedMetric.value))], forKey: fetchedMetric.unit)
                    }
                }
                
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
            }
        }
        return LineChartData(dataSets: nil)
    }
    
    @objc func buttonPressed(sender: UIButton!) {
        switch sender.tag {
        case 1:
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditEntry") as? EditEntryViewController {
                vc.progress = progress
                vc.delegate = self
                vc.locationText = addressLine
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 2:
            let ac = UIAlertController(title: "Delete", message: "Are you sure you want to delete your entry?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
                self.deleteEntry()
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            if let popoverController = ac.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            present(ac, animated: true)
        default:
            print("default")
        }
    }
    

    
    func deleteEntry() {
        deleteSingleItem(progress: self.progress)
        
        self.navigationController?.popToRootViewController(animated: true)
        
//                if let indexPathRow = self.indexPathRow {
//                    if let vc = (tabBarController?.viewControllers?[0] as? UINavigationController)?.topViewController as? DetailTableViewController {
//                        vc.progresses.remove(at: indexPathRow)
//                        vc.tableView.deleteRows(at: [self.indexPath], with: .fade)
//                        _ = self.navigationController?.popViewController(animated: true)
//                    }
//                }
    }
}

extension EntryViewController: CalendarHeatmapDelegate {
    func didSelectedAt(dateComponents: DateComponents) {
        guard let year = dateComponents.year,
            let month = dateComponents.month,
            let day = dateComponents.day else { return }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CalendarDetail") as? CalendarDetailTableViewController {
            let date = [year, month, day]
            let startDate = "\(date[0])-\(date[1])-\(date[2]) 00:00"
            let endDate = "\(date[0])-\(date[1])-\(date[2]) 23:59"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let formattedStartDate = dateFormatter.date(from: startDate)
            let formattedEndDate = dateFormatter.date(from: endDate)
            
            vc.progressPredicate = NSPredicate(format: "(date >= %@) AND (date <= %@) AND (goal.title == %@)", formattedStartDate! as CVarArg, formattedEndDate! as CVarArg, progress.goal.title as CVarArg)
            present(vc, animated: true)
        }
    }
    
    func colorFor(dateComponents: DateComponents) -> UIColor {
        guard let year = dateComponents.year,
            let month = dateComponents.month,
            let day = dateComponents.day else { return .clear}
        let dateString = "\(year).\(month).\(day)"
        
        return data[dateString] ?? UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    }
    
    func finishLoadCalendar() {
        calendarHeatMap.scrollTo(date: progress.date, at: .left, animated: false)
    }
}

extension EntryViewController: MKMapViewDelegate {
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

protocol CallBackDelegate {
    func callBack(value: Progress, location: CLLocationCoordinate2D?, locationLabel: String?)
}

extension EntryViewController: CallBackDelegate {
    func callBack(value: Progress, location: CLLocationCoordinate2D?, locationLabel: String?) {
        progress = value
        lineChartView.data = loadMetricsData()
        
        if let location = location {
            mapView.removeAnnotations(mapView.annotations)
            
            let annotation = MyAnnotation(title: locationLabel ?? "", locationName: "", discipline: "", coordinate: location)
            self.mapView.addAnnotation(annotation)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
        
//        if stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive == true {
//            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = false
//        } else {
////            NSLayoutConstraint.deactivate([
////                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
////                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
////                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, constant: 9/16),
////                stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
////            ])
//            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = false
//            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = false
//            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, constant: 9/16).isActive = false
//            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = false
//        }

        NSLayoutConstraint.deactivate(imageConstraints)
        
        if progress.image != nil {
            imageConstraints = [
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, constant: 9/16),
                stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
            ]
        } else {
            imageConstraints = [stackView.topAnchor.constraint(equalTo: scrollView.topAnchor)]
        }
        
        NSLayoutConstraint.activate(imageConstraints)
//        if value.image != nil {
//            imageView.translatesAutoresizingMaskIntoConstraints = false
//            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
//            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, constant: 9/16).isActive = true
//            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
//            if uiImage.size.width > uiImage.size.height {
//                imageView.contentMode = .scaleAspectFit
//            } else {
//                imageView.contentMode = .scaleAspectFill
//            }
//        } else {
//            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        }
//
//        scrollView.layoutIfNeeded()
//        stackView.layoutIfNeeded()
        
    }
}

//self.context.delete(self.progress)
//self.saveContext()
//_ = self.navigationController?.popViewController(animated: true)
//if let indexPathRow = self.indexPathRow {
//    self.detailTableVCDelegate?.progresses.remove(at: indexPathRow)
//    DispatchQueue.main.async {
//        self.detailTableVCDelegate?.tableView.deleteRows(at: [self.indexPath], with: .fade)
//        _ = self.navigationController?.popViewController(animated: true)
//    }
//}
