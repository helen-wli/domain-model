struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    let amount : Int
    let currency : String
    let validCurrencies : [String] = ["USD", "GBP", "EUR", "CAN"]
    
    // Takes an integer of money amount and a string (case sensitive) of currency name as parameters
    // Constructs a Money object
    /* make sure to include code to reject unknown currencies
    init(amount: Int, currency: String) {
        //if (validCurrencies.contains(currency) && amount >= 0) {
        // NOTE: Allowing negative amount value to take care of the "subtract" method below
        if (validCurrencies.contains(currency)) {
            self.amount = amount
            self.currency = currency
        } else {
            print("Invalid currency input, constructor fails.")
        }
    }
     */
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    // Takes a currency name as a parameter
    // Returns a new Money object with converted amounts
    func convert(_ currencyName: String) -> (Money) {
        let upperCurrencyName = currencyName.uppercased()
        
        if (self.currency != upperCurrencyName) {
            if (self.currency == "USD") {
                switch upperCurrencyName {
                case "GBP": // 1 USD = 0.5 GBP
                    let convertedAmount : Int = Int(Double(self.amount) / 2)
                    return Money(amount: convertedAmount, currency: upperCurrencyName)
                case "EUR": // 1 USD = 1.5 EUR
                    let convertedAmount : Int = Int(Double(self.amount) * 1.5)
                    return Money(amount: convertedAmount, currency: upperCurrencyName)
                case "CAN": // 1 USD = 1.25 CAN
                    let convertedAmount : Int = Int(Double(self.amount) * 1.25)
                    return Money(amount: convertedAmount, currency: upperCurrencyName)
                default:
                    print("\(currencyName) is not a valid currency for converting")
                }
            } else if (self.currency == "GBP") {
                switch upperCurrencyName {
                case "USD": // 1 GBP = 2 USD
                    let convertedAmount : Int = self.amount * 2
                    return Money(amount: convertedAmount, currency: upperCurrencyName)
                case "EUR": // 1 GBP = 3 EUR
                    let convertedAmount : Int = self.amount * 3
                    return Money(amount: convertedAmount, currency: upperCurrencyName)
                case "CAN": // 1 GBP = 2.5 EUR
                    let convertedAmount : Int = Int(Double(self.amount) * 2.5)
                    return Money(amount: convertedAmount, currency: upperCurrencyName)
                default:
                    print("\(currencyName) is not a valid currency for converting")
                }
            } else if (self.currency == "EUR") {
                switch upperCurrencyName {
                case "USD": // 1 EUR = (2/3) USD
                    let convertedAmount : Int = Int(Double(self.amount) * 2 / 3)
                    return Money(amount: convertedAmount, currency: upperCurrencyName)
                case "GBP": // 1 EUR = (1/3) GBP
                    let convertedAmount : Int = Int(Double(self.amount) / 3)
                    return Money(amount: convertedAmount, currency: upperCurrencyName)
                case "CAN": // 1 EUR = (5/6) CAN
                    let convertedAmount : Int = Int(Double(self.amount) * 5 / 6)
                    return Money(amount: convertedAmount, currency: upperCurrencyName)
                default:
                    print("\(currencyName) is not a valid currency for converting")
                }
            } else { // self.currency == "CAN"
                switch upperCurrencyName {
                case "USD": // 1 CAN = (4/5) USD
                    let convertedAmount : Int = Int(Double(self.amount) * 4 / 5)
                    return Money(amount: convertedAmount, currency: upperCurrencyName)
                case "GBP": // 1 CAN = (2/5) GBP
                    let convertedAmount : Int = Int(Double(self.amount) * 2 / 5)
                    return Money(amount: convertedAmount, currency: upperCurrencyName)
                case "EUR": // 1 CAN = (6/5) EUR
                    let convertedAmount : Int = Int(Double(self.amount) * 6 / 5)
                    return Money(amount: convertedAmount, currency: upperCurrencyName)
                default:
                    print("\(currencyName) is not a valid currency for converting")
                }
            }
        }
        
        return Money(amount: self.amount, currency: self.currency)
    }
    
    // Takes a Money object as a parameter
    // Returns a new Money object in the same currency unit as the given Money object that is the sum of this Money object and the given Money object
    func add(_ otherMoney : Money) -> (Money) {
        if (otherMoney.currency == self.currency) {
            let sumAmount = self.amount + otherMoney.amount
            return Money(amount: sumAmount, currency: otherMoney.currency)
        } else { // otherMoney.currency != self.currency
            let sumAmount = convert(otherMoney.currency).amount + otherMoney.amount
            return Money(amount: sumAmount, currency: otherMoney.currency)
        }
    }
    
    // Takes a Money object as a parameter
    // Returns a new Money object in the same currency unit as the given Money object that is the difference of this Money object and the given Money object (this object subtracts the given object)
    func subtract(_ otherMoney : Money) -> (Money) {
        if (otherMoney.currency == self.currency) {
            let diffAmount = self.amount - otherMoney.amount
            return Money(amount: diffAmount, currency: otherMoney.currency)
        } else { // otherMoney.currency != self.currency
            let diffAmount = convert(otherMoney.currency).amount - otherMoney.amount
            return Money(amount: diffAmount, currency: otherMoney.currency)
        }
    }
}

////////////////////////////////////
// Job
//
//public class Job {
//    public enum JobType {
//        case Hourly(Double)
//        case Salary(UInt)
//    }
//}

////////////////////////////////////
// Person
//
//public class Person {
//}

////////////////////////////////////
// Family
//
//public class Family {
//}
