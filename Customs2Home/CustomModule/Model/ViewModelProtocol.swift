import Foundation

protocol ViewModelProtocol:InstanceProtocol {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
