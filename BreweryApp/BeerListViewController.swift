//
//  BeerListViewController.swift
//  BreweryApp
//
//  Created by HyeonSoo Kim on 2022/02/11.
//

import UIKit
//import SwiftUI

class BeerListViewController: UITableViewController {
    
    var beerList = [Beer]()
    var dataTasks = [URLSessionTask]()
    var currentPage = 1 //page기반으로 가져올 것. ; 1번째 페이지.(기본설정 25맥주)
//        didSet {
//            fetchBeer(of: currentPage)
//        }
//    }  didSet나오면 정해진 325종류까지 한번에 쫙 로딩되게됨.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //네비게이션바 Custom하게 설정
        title = "뭐 마실래? ㅋ"
        navigationController?.navigationBar.prefersLargeTitles = true //큰 타이틀 네비게이션바 <TRUE>
        
        //UITableView 설정
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150 //Delegate로 해도되지만 이렇게도 가능.
        
        //prefetch DataSource 프로토콜 설정 ;
        tableView.prefetchDataSource = self
        
        //data 가져오기.
        fetchBeer(of: currentPage)
    }
}

//UITableView DataSource, Delegate
extension BeerListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("RRows: \(indexPath.row)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as? BeerListCell else { return UITableViewCell()}
        cell.configure(with: beerList[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = beerList[indexPath.row]
        let beerDetailViewController = BeerDetailViewController()
        
        beerDetailViewController.beer = selectedBeer
        self.show(beerDetailViewController, sender: nil)
    }
    
}

//Data Fetching
private extension BeerListViewController {
    func fetchBeer(of page: Int) {
        //URL 설정
        guard let url = URL(string: "\(Storage().apiKey)?page=\(page)"),
              dataTasks.firstIndex(where: { $0.originalRequest?.url == url }) == nil
              else {
                  print("겹치는 것 있었음!!!") //테스트 결과 중복 fetch 없음. 그러나 추후 사용할 수 있는 방법이니 코드 그대로 유지.
                  return }
        
        //request 설정
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //task 설정 ; shared싱글톤
        let dataTask = URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard error == nil,
                  let self = self,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let beers = try? JSONDecoder().decode([Beer].self, from: data) else { print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
                      return
                  }
            switch response.statusCode {
            case (200...299): //성공
                self.beerList += beers //[Beer] 리스트 추가
                self.currentPage += 1 //성공 시 page값 올라가며 2페이지 가져오고 반복 ... 3,4,5... 하도록 다른데서 설정.
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                } //GCD;(Grand Central Dispatch) 부연설명 맨 아래 ▼
                
            case (400...499): //클라이언트 에러
                print("""
                    ERROR: Client ERROR \(response.statusCode)
                    Response: \(response)
                """)
            case (500...599): //서버 에러
                print("""
                    ERROR: Server ERROR \(response.statusCode)
                    Response: \(response)
                """)
            default:
                print("""
                    ERROR: \(response.statusCode)
                    Response: \(response)
                """)
            }
        }
        //task 작업 완료후에는 반드시 resume() 해줘야 한다.!!!
        dataTask.resume()
        dataTasks.append(dataTask)
    }
}

//prefetch - cellForRowAt에서 보면 화면에 곧 나올? 갓 나온? row를 그린다. 하지만 prefetch는 미래에 나올 row까지 미리 그린다.
extension BeerListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        indexPaths.forEach {
//            print("PrefetchRows: \($0.row)")
//        }
        guard currentPage != 1 else { return }
        indexPaths.forEach {
            if ($0.row + 1)/25 + 1 == currentPage { //특정 시점에 2, 3, 4페이지도 ... 쭉 순차적으로 fetch!!! didSet과 달리 한 번에 가져오는 것이 아님! 좋군.
                self.fetchBeer(of: currentPage)
            }
        }
    }
}

/*
 DispatchQueue.main.async { code } ?????
 
 tableview.reloadData()를 DispatchQueue 블럭 정의없이 실행하면,
 앱 자체가 실행이 안되며 보라색 경고표시 발생한다.
 
 Error: "UITableViewController.tableView must be used from main thread only"
 
 */
