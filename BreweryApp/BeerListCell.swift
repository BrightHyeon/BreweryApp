//
//  BeerListCell.swift
//  BreweryApp
//
//  Created by HyeonSoo Kim on 2022/02/11.
//

import UIKit
import SnapKit //오토레이아웃 잡아주기.
import Kingfisher //이미지 뿌려주기.

class BeerListCell: UITableViewCell {
    
    let beerImageView = UIImageView()
    let nameLabel = UILabel()
    let taglineLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [beerImageView, nameLabel, taglineLabel].forEach {
            contentView.addSubview($0)
        }
        
        beerImageView.contentMode = .scaleAspectFit //이미지뷰에 이미지가 들어가는 형태?
        
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.numberOfLines = 2
        
        taglineLabel.font = .systemFont(ofSize: 14, weight: .light)
        taglineLabel.textColor = .systemBlue
        taglineLabel.numberOfLines = 0
        
        //SnapKit 활용한 오토레이아웃
        beerImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.top.bottom.equalToSuperview().inset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(120)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(beerImageView.snp.trailing).offset(10) //beerImageView의 오른쪽으로부터 10정도 띄어지도록.
            $0.bottom.equalTo(beerImageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        taglineLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
    }
    
    //외부에서 데이터를 가져와 구성할 수 있도록 함수 구현.
    func configure(with beer: Beer) {
        //image_url주소 받아오기
        let imageURL = URL(string: beer.imageURL ?? "")
        beerImageView.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "beer_icon")) //placeholder : image가 제대로 오지않았을 경우를 대비해서 기본 이비지를 설정해줌.
        nameLabel.text = beer.name ?? "이름 없는 맥주"
        taglineLabel.text = beer.tagLine
        
        accessoryType = .disclosureIndicator //이 코드 적용하면 셀의 우측에 ">" 모양의 꺽새괄호가 추가된다.
        selectionStyle = .none //셀을 탭하더라도 회색 음영이 발생하지않음.
    }
}
