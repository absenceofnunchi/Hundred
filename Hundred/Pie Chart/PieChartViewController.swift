


import UIKit
import Charts

class PieChartViewController: BaseViewController {
    var chartView: PieChartView!
    var goals: [Goal]? {
        didSet {
            setupPieChart(goals: goals)
        }
    }
    var noData: String? {
        didSet {
            if noData == "no data" {
                emptyPieChart()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupPieChart(goals: [Goal]?) {
        chartView = nil
        //        chartView = PieChartView(frame: CGRect(origin: CGPoint(x: 0, y: 20), size: CGSize(width: 250, height: 250)))
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
        
        var entries: [PieChartDataEntry] = Array()
        
        if let goals = goals {
            for goal in goals {
                entries.append(PieChartDataEntry(value: Double(goal.progress.count), label: goal.title))
            }
        }
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        
        let c1 = NSUIColor(hex: 0x34ace0)
        let c2 = NSUIColor(hex: 0x40407a)
        let c3 = NSUIColor(hex: 0x706fd3)
        let c4 = NSUIColor(hex: 0xf7f1e3)
        let c5 = NSUIColor(hex: 0x33d9b2)
        let c6 = NSUIColor(hex: 0xff5252)
        let c7 = NSUIColor(hex: 0xff793f)
        let c8 = NSUIColor(hex: 0xd1ccc0)
        let c9 = NSUIColor(hex: 0xffb142)
        let c10 = NSUIColor(hex: 0xffda79)
        let c11 = NSUIColor(hex: 0x78e08f)
        
        dataSet.colors = [c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11]
        dataSet.drawValuesEnabled = true
        
        let data = PieChartData(dataSet: dataSet)
        chartView.data = data
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .none
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
    }
    
    func emptyPieChart() {
        chartView = nil
        chartView = PieChartView()
        chartView.delegate = self
        view.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        chartView.heightAnchor.constraint(equalTo: chartView.widthAnchor).isActive = true
        chartView.topAnchor.constraint(equalTo: view.topAnchor, constant: -20).isActive = true
        
        chartView.legend.enabled = false
//        chartView.usePercentValuesEnabled = true
//        chartView.drawSlicesUnderHoleEnabled = true
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
//        chartView.chartDescription?.enabled = true
//        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
//        chartView.drawCenterTextEnabled = true
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "No data")
        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 13)!,
                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        chartView.centerAttributedText = centerText
        
        let dataSet = PieChartDataSet(entries: [PieChartDataEntry(value: 1.0, label: nil)], label: "")
        
        let c2 = NSUIColor(hex: 0x34ace0)
        let c3 = NSUIColor(hex: 0x40407a)
        let c4 = NSUIColor(hex: 0x706fd3)
        let c5 = NSUIColor(hex: 0xf7f1e3)
        let c6 = NSUIColor(hex: 0x33d9b2)
        let c1 = NSUIColor(hex: 0xff5252)
        let c7 = NSUIColor(hex: 0xff793f)
        let c8 = NSUIColor(hex: 0xd1ccc0)
        let c9 = NSUIColor(hex: 0xffb142)
        let c10 = NSUIColor(hex: 0xffda79)
        let c11 = NSUIColor(hex: 0x78e08f)
        
        dataSet.colors = [c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11]
        dataSet.drawValuesEnabled = false
        
        let data = PieChartData(dataSet: dataSet)
        chartView.data = data
    }
}

