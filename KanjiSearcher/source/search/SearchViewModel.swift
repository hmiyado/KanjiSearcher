//
//  SearchViewModel.swift
//  KanjiSearcher
//
//  Created by 吉田拓真 on 2020/07/12.
//  Copyright © 2020 hmiyado. All rights reserved.
//

import RxRelay
import RxSwift

protocol SearchViewModelInput {
    var onQueryReading: BehaviorRelay<String> { get }
    var onSearch: PublishRelay<Void> { get }
}

protocol SearchViewModelOutput {
    
}

protocol SearchViewModelType {
    var input: SearchViewModelInput { get }
    var output: SearchViewModelOutput { get }
}

final class SearchViewModel : SearchViewModelType, SearchViewModelInput, SearchViewModelOutput {
    var input: SearchViewModelInput { return self }
    var output: SearchViewModelOutput { return self }
    
    var onQueryReading: BehaviorRelay<String> = BehaviorRelay.init(value: "")
    var onSearch: PublishRelay<Void> = PublishRelay.init()
    
    let disposeBag = DisposeBag()
    
    init() {
        onSearch
            .withLatestFrom(onQueryReading)
            .subscribe { queryReading in print("onSearch: \(queryReading)")}
            .disposed(by: disposeBag)
    }
}
