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
    let amount : Int      // money amount
    let currency : String // currency unit
    
    //let validCurrencies : [String] = ["USD", "GBP", "EUR", "CAN"] // valid currency units
    
    // Takes an integer of money amount (could be negative) and a string (case sensitive) of currency name as parameters
    // Constructs a Money object
    // Note: allowing negative money amount input to take care of the "subtract" method below
    
    /* make sure to include code to reject unknown currencies
     
     // ??????????????????????????????????????????????????????
     
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
public class Job {
    let title : String // name of job
    let type : JobType // wage type, hourly or salary
    
    // !!!!!!!!!!!!!!!!!!!!CHANGE THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    var hourlyWage : Double = 15.0 // initial hourly wage
    var yearlySalary : Int = 1000  // initial yearly salarly
    
    public enum JobType {
        case Hourly(Double) // hourly wage
        case Salary(UInt)   // yearly salary
    }
    
    // Takes a string and an enumeration of wage type (hourly or yearly) as parameters
    // Constructs a Job object with given title name and wage type
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    // Takes an integer of working time in a year as a parameter
    // Returns the amount of money made in a calendar year in corresponding job position:
    //  - Hourly: (hourly wage) * (working time in a year)
    //  - Salary: yearly salarly
    func calculateIncome(_ workingTime: Int) -> Int {
        switch self.type {
        case .Hourly:
            // hourly wage = 15.0
            return Int(hourlyWage) * workingTime
        case .Salary:
            return yearlySalary
        }
    }
    
    /*
     ????????????????ACCESS the parameter value inside JobType????????????????????????
     see line 142 - 144
    
    // Takes an integer value representing the raise amount
    // Updates the wage/salary information for this Job object
    func raise(byAmount: Int) {
        switch self.type {
        case .Hourly:
            hourlyWage += Double(byAmount)
        case .Salary:
            yearlySalary += byAmount
        }
    }
    
    // Takes a double value representing the raise amount
    // Updates the wage/salary information for this Job object
    func raise(byAmount: Double) {
        switch self.type {
        case .Hourly:
            hourlyWage += byAmount
        case .Salary:
            yearlySalary += Int(byAmount)
        }
    }
     
     */
    
    // Takes a double value representing the raise amount of hourly wage
    // Updates the wage information for this Job object
    func raise(byAmount: Double) {
        hourlyWage += byAmount
    }
    
    // Takes an integer value representing the raise amount of yearly salarly
    // Updates the yearly salary information for this Job object
    func raise(byAmount: Int) {
        yearlySalary += byAmount
    }
    
    // Takes a double between (0.0 and 1.0 inclusively) representing the raise increase ratio
    // Updates the wage/salary for this Job object
    func raise(byPercent: Double) {
        switch self.type {
        case .Hourly:
            hourlyWage *= (1 + byPercent)
        case .Salary:
            yearlySalary = Int((1 + byPercent) * Double(yearlySalary))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    let firstName : String
    let lastName : String
    let age : Int
    
    /*
    if (age >= 18) {
        var job : Job?
        var spouse : Person?
    } else {
        let job : Job? = nil
        let spouse : Person? = nil
    }
     */
    
    var job : Job?       // nullable & changeable
    var spouse : Person? // nullable % changeable
    
    // Constructs a Person object with given first name, last name, and age information
    // Note: Defaults of job and spouse are both nil when constructing this object
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = nil
        self.spouse = nil
    }
    
    // Returns a string of the information about this Person object
    func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(Optional(self.job)! as Any) spouse:\(Optional(self.spouse)! as Any)]"
    }
}

////////////////////////////////////
// Family
//
//public class Family {
//}
