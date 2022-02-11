//
//  BeerDetailViewController.swift
//  BreweryApp
//
//  Created by HyeonSoo Kim on 2022/02/11.
//

import UIKit

class BeerDetailViewController: UITableViewController {
    
    var beer: Beer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation바 타이틀 설정.
        title = beer?.name ?? "이름 없는 맥주"
        
        //테이블뷰 구성 ; 이 테이블뷰컨의 tableView를 UITableView로 선언
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BeerDetailListCell") //별다른 커스텀셀없이 기본 셀 사용.
        tableView.rowHeight = UITableView.automaticDimension //테이블뷰가 알아서 자동으로 설정함.
   
        //헤더뷰 구성
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        let headerView = UIImageView(frame: frame)
        let imageURL = URL(string: beer?.imageURL ?? "")
        
        headerView.contentMode = .scaleAspectFit
        headerView.kf.setImage(with: imageURL, placeholder: UIImage(named: "beer_icon"))
    
        tableView.tableHeaderView = headerView //전체 테이블뷰의 헤더
    }
}

//UITableView DataSource, Delegate
extension BeerDetailViewController {
    
    //섹션 갯수
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    //섹션마다 표시할 row수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3:
            return beer?.foodPairing?.count ?? 0
        default:
            return 1
        }
    }
    
    //각 섹션의 헤더 타이틀
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "ID"
        case 1:
            return "DESCRIPTION"
        case 2:
            return "BREWERS TIPS"
        case 3:
            let isFoodPairingEmpty = beer?.foodPairing?.isEmpty ?? true
            return isFoodPairingEmpty ? nil : "FOOD PAIRING"
        default:
            return nil
        }
    }
    
    //셀 설정
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "BeerDetailListCell")
        
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = String(beer?.id ?? 0)
            return cell
        case 1:
            cell.textLabel?.text = beer?.description ?? "설명 없는 맥주"
            return cell
        case 2:
            cell.textLabel?.text = beer?.brewersTips ?? "팁 없는 맥주"
            return cell
        case 3:
            cell.textLabel?.text = beer?.foodPairing?[indexPath.row] ?? ""
            return cell
        default:
            return cell
        }
    }
}
