//
//  DroidUtilities.swift
//  DroidTimeSelection
//
//  Created by Dan Draiman on 4/18/21.
//

import Combine

@available(iOS 13.0, *)
final class QueryDebouncer<T: Equatable, S: Scheduler> {
    typealias OnValueReceived =  (T) -> Void
    private var subscriptions = Set<AnyCancellable>()
    private var debouncer: PassthroughSubject<T, Never> = .init()
    
    init(debounce: S.SchedulerTimeType.Stride, queue: S, onValueReceived: @escaping OnValueReceived) {
        debouncer
            .removeDuplicates()
            .debounce(for: debounce, scheduler: queue)
            .sink(receiveValue: { value in
                onValueReceived(value)
            }).store(in: &subscriptions)
    }
    
    func update(value: T) {
        debouncer.send(value)
    }
}
