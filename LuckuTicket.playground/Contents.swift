import Foundation


func isLucky(ticketNumber: Int) -> Bool {
    
    let digits = String(ticketNumber).compactMap{Int(String($0))}
    if digits.count > 1 && digits.count < 9 && digits.count % 2 == 0 {
        let firstHalf = digits[0..<digits.count/2]
        let lastHalf = digits[digits.count/2..<digits.count]
        return firstHalf.reduce(0, +) == lastHalf.reduce(0, +)
    }
    
    return false
}



