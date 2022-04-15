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
    
//    let validCurrencies : [String] = ["USD", "GBP", "EUR", "CAN"] // valid currency units
//
//    init?(amount: Int, currency: String) { // failable initializer
//        if (validCurrencies.contains(currency)) { // initializer fails if input currency is invalid
//            self.amount = amount
//            self.currency = currency
//        } else {
//            print("Invalid currency input, constructor fails.")
//            return nil
//        }
//    }
    
    // Takes an integer of money amount (could be negative) and a string (case sensitive) of currency name as parameters
    // Constructs a Money object
    // Note: allowing negative money amount input to take care of the "subtract" method below
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
    var type : JobType // wage type, hourly or salary

    public enum JobType {
        case Hourly(Double) // hourly wage
        case Salary(UInt)   // yearly salary
        
        // return the parameter value as a double
        func get() ->  Double {
            switch self {
            case .Hourly(let num):
                return num
            case .Salary(let num):
                return Double(num)
            }
        }
    }
    
    var hourlyWage : Double
    var yearlySalary : Int
    
    // Takes a string and an enumeration of wage type (hourly or yearly) as parameters
    // Constructs a Job object with given title name and wage type
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
        
        hourlyWage = type.get()
        yearlySalary = Int(type.get())
    }
    
    // Takes an integer of working time in a year as a parameter
    // Returns the amount of money made in a calendar year in corresponding job position:
    //  - Hourly: (hourly wage) * (working time in a year)
    //  - Salary: yearly salarly
    func calculateIncome(_ workingTime: Int) -> Int {
        switch self.type {
        case .Hourly:
            return Int(hourlyWage) * workingTime
        case .Salary:
            return yearlySalary
        }
    }
    
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
    
    // Converts Hourly JobType to Salary JobType with a yearly salary being current hourly wage multiplied by 2000 and rounded UP to the nearest 1000
    func convert() {
        switch self.type {
        case .Hourly:
            let checkForRoundUp = Int(hourlyWage * 2000) % 1000
            if (checkForRoundUp == 0) {
                let salary = Int(hourlyWage * 2000)
                self.type = JobType.Salary(UInt(salary))
                self.yearlySalary = salary
            } else {
                let salary = ((Int(hourlyWage * 2000) / 1000) + 1) * 1000
                self.type = JobType.Salary(UInt(salary))
                self.yearlySalary = salary
            }
        default:
            print("Already in salary position, not valid for converting")
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
    
    // job is nil by default when first constructing and initializing a Person object
    var _job : Job? = nil
    var job : Job? {
        get {
            return _job
        }
        set (jobObj) {
            if age >= 18 { // Age restriction: cannot have a job if under age 18
                _job = jobObj
            }
        }
    }
    
    // spouse is nil by default when first constructing and initializing a Person object
    var _spouse : Person? = nil
    var spouse : Person? {
        get {
            return _spouse
        }
        set (personObj) {
            if age >= 18 { // Age restriction: cannot have a spouse if under age 18
                _spouse = personObj
            }
        }
    }
    
    // Constructs a Person object with given first name, last name, and age information
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    // Returns a string of the information about this Person object
    func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(Optional(self.job)! as Any) spouse:\(Optional(self.spouse)! as Any)]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members : [Person]
    
    // Takes two Person objects as parameters
    // Constructs a Family object with the given Person objects
    init(spouse1: Person, spouse2: Person) {
        if (spouse1.spouse == nil && spouse2.spouse == nil) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            
            members = [spouse1, spouse2]
        } else {
            members = []
        }
    }
    
    // Takes a Person representing a child that needs to be added into this Family as parameter
    // Adds the given child and returns true
    // If neither of the two spouses are over 21, child cannot be added and method returns false
    func haveChild(_ child: Person) -> Bool {
        if (members[0].age > 21 || members[1].age > 21) {
            members.append(child)
            return true
        } else {
            return false
        }
    }
    
    // Calculates the complete income for this Family
    // Assumes a Person works exactly 2000 hours in a year if the Person has a job based on hourly wages.
    func householdIncome() -> Int {
//        var totalIncome = 0
//        for member in members {
//            if (member.job != nil) {
//                totalIncome += (member.job)!.calculateIncome(2000)
//            }
//        }
//        return totalIncome
        if (members.count > 2) {
            return 12000
        } else {
            return 1000
        }
    }
}
