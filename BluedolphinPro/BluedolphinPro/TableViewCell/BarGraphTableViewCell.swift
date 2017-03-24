//
//  BarGraphTableViewCell.swift
//  BluedolphinPro
//
//  Created by Raghvendra on 21/03/17.
//  Copyright © 2017 raremediacompany. All rights reserved.
//

import UIKit
import Charts

class BarGraphTableViewCell: UITableViewCell {

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var chartDateLabel: UILabel!
    @IBOutlet weak var chartLabel: UILabel!
     weak var axisFormatDelegate: IAxisValueFormatter?
    override func awakeFromNib() {
        super.awakeFromNib()
          axisFormatDelegate = self
        // Initialization code
    }
    func configureCell(title:String,dateString:String,barData:[GraphValue]){
        chartLabel.text = title
        chartDateLabel.text = dateString
        updateChartWithData(data: barData)
        
    }
    func updateChartWithData(data:[GraphValue]) {
        var dataEntries: [BarChartDataEntry] = []
        for value in data {
            let dataEntry = BarChartDataEntry(x: Double(value.date!.timeIntervalSince1970), y: Double(value.completedData))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Completed")
        
        chartDataSet.barBorderWidth = 10.0
        chartDataSet.barBorderColor = .cyan
        chartDataSet.colors = ChartColorTemplates.colorful()
        let chartData = BarChartData(dataSet: chartDataSet)
        // no data text
        barChartView.noDataText = "No data available"
        // user interaction
        barChartView.isUserInteractionEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawAxisLineEnabled = false
        barChartView.leftAxis.drawLabelsEnabled = false
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.drawLabelsEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
      
    

        barChartView.xAxis.labelPosition = .bottom
        
        barChartView.xAxis.setLabelCount(7, force: true)
        
        barChartView.data = chartData
        
        // 3b. animation
        barChartView.animate(xAxisDuration:  1.0)
        barChartView.chartDescription = nil
    
        
        
        let xaxis = barChartView.xAxis
        xaxis.valueFormatter = axisFormatDelegate
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: axisFormatDelegate
extension BarGraphTableViewCell: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
 
        return Date(timeIntervalSince1970: value).dayOfWeek()!
    }
    
}
