//
//  LineSpotChartView+TableView.swift
//  SpotChart
//
//  Created by amir on 9/26/22.
//

import UIKit

extension LineSpotChartView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        let peakLegend = data.filter{
            $0.legend.isPeak == true && $0.legend.isWindow == false
        }
        return peakLegend.isEmpty ? 1 : 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LegendTableViewCell.nameOfClass,
                                                 for: indexPath) as? LegendTableViewCell
        cell?.config(data: fetchLegendRow(section: indexPath.section),
                     section: indexPath.section)
        cell?.setupUI(textColor: legendTitleColor, textFont: legendTitleFont, backgroundColor: containerBackgroundColor)
        cell?.delegate = self
        return cell ?? UITableViewCell()
    }
    
    func fetchLegendRow(section: Int) -> [LineSpotChartModel] {
        let normal = data.filter{
            $0.legend.isPeak == false && $0.legend.isWindow == false
        }
        
        let peak = data.filter{
            $0.legend.isPeak == true && $0.legend.isWindow == false
        }
        
        if section == 0 {
            return normal
        } else {
            return peak
        }
    }
}

extension LineSpotChartView: LegendDelegate {
    func legendSelected(section: Int, item: Int) {
        self.tooltipView.isHidden = true
        var AllData = [[LineSpotChartModel]]()
        let normalLegend = data.filter{
            $0.legend.isPeak == false && $0.legend.isWindow == false
        }
        let peakLegend = data.filter{
            $0.legend.isPeak == true && $0.legend.isWindow == false
        }
        AllData = [normalLegend, peakLegend]
        let itemSelected = AllData[section][item]
        guard let indexSelected = data.firstIndex(where: { item in
            item.legend.key == itemSelected.legend.key
        }) else { return }
        data[indexSelected].legend.isEnable.toggle()
        reloadChart(isCompleteRefresh: false)
    }
}

extension LineSpotChartView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46.0
    }
}
