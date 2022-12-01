import Foundation

class Transport {
    let productionYear: Int
    let brand: String
    let typeOfFuel: Fuel
    let fuelСonsumption: Double
    let maxFuelCapacity: Double
    var currentFuelLevel: Double
    let color: String
    var orders: [Order] = []
    
    var hasOrders: Bool {
        !orders.isEmpty
    }
    
    init(productionYear: Int,
         brand: String,
         typeOfFuel: Fuel,
         fuelСonsumption: Double,
         maxFuelCapacity: Double,
         color: String) {
        
        self.productionYear = productionYear
        self.brand = brand
        self.typeOfFuel = typeOfFuel
        self.fuelСonsumption = fuelСonsumption
        self.maxFuelCapacity = maxFuelCapacity
        self.currentFuelLevel = maxFuelCapacity
        self.color = color
    }
    
    final func refuelVehicle(typeOfFuel:Fuel, amount: Double) {
        if typeOfFuel != self.typeOfFuel {
            print("This vehicle needs \(self.typeOfFuel.rawValue)")
            return
        }
        currentFuelLevel = currentFuelLevel + amount > maxFuelCapacity ? maxFuelCapacity : currentFuelLevel + amount
        print("Current fuel amount is \(currentFuelLevel)")
    }
    
    func doServiceWorks() {
        repairVehicle()
    }
    
    final func repairVehicle() {
        print("Car repaired")
    }
    
    final func addOrder(_ order: Order) {
        if checkOrderToAdd(order) {
            print("Order added")
            orders.append(order)
            loadOrder(order)
        }
    }
    
    internal func checkOrderToAdd(_ order: Order) -> Bool {
        return false
    }
    
    internal func loadOrder(_ order: Order) {
        
    }
    
    internal func unloadOrder(_ order: Order) {
        
    }
    
    internal func isReadyToComplete() -> Bool {
        return true
    }
    
    private func isEnoughFuel(for order: Order) -> Bool {
        currentFuelLevel > (order.distance / 100) * fuelСonsumption
    }
    
    final func completeOrder() {
        if let orderToComplete = orders.first, isEnoughFuel(for: orderToComplete), isReadyToComplete()  {
            currentFuelLevel -= orderToComplete.distance * fuelСonsumption
            unloadOrder(orderToComplete)
            orders.removeFirst()
        }
    }
    
    final func printInfo() {
        print("fuel - \(currentFuelLevel)")
        printCapacityInfo()
        orders.forEach{ $0.printDescription() }
    }
    
    func printCapacityInfo() {
        
    }
}

class CargoTransport: Transport {
    var maxTruckVolume: Double
    var currentTruckVolume: Double
    var typeTruckBody: TruckBody
    var isSealed: Bool = false
    
    init(productionYear: Int,
         brand: String,
         typeOfFuel: Fuel,
         fuelСonsumption: Double,
         maxFuelCapacity: Double,
         color: String,
         maxTruckVolume: Double,
         typeTruckBody: TruckBody) {
        
        self.maxTruckVolume = maxTruckVolume
        self.currentTruckVolume = maxTruckVolume
        self.typeTruckBody = typeTruckBody
        
        super.init(productionYear: productionYear, brand: brand, typeOfFuel: typeOfFuel, fuelСonsumption: fuelСonsumption, maxFuelCapacity: maxFuelCapacity, color: color)
    }
    
    override func doServiceWorks() {
        super.doServiceWorks()
        sealBodyOfTruck()
    }
    
    func sealBodyOfTruck(){
        if isSealed {
            print("Already sealed")
        } else {
            isSealed = true
            print("Truck body successfully sealed")
        }
    }
    
    override func checkOrderToAdd(_ order: Order) -> Bool {
        if let order = order as? CargoOrder {
            return order.weight <= currentTruckVolume && typeTruckBody.typeOfCargo == order.typeOfCargo
        } else {
            print("This transport can carry only CargoOrder")
            return false
        }
    }
    
    override func loadOrder(_ order: Order) {
        guard let order = order as? CargoOrder else { return }
        currentTruckVolume -= order.weight
    }
    
    override func unloadOrder(_ order: Order) {
        guard let order = order as? CargoOrder else { return }
        currentTruckVolume += order.weight
    }
    
    override func isReadyToComplete() -> Bool {
        isSealed
    }
    
    override func printCapacityInfo() {
        print("current capacity - \(currentTruckVolume)kg")
    }
}

class PassengerTransport: Transport {
    let maxPassengerСapacity: Int
    var currentPassengerCapacity: Int
    var isDisinfected: Bool = false
    let numberOfDoors: Int
    
    init(productionYear: Int,
         brand: String,
         typeOfFuel: Fuel,
         fuelСonsumption: Double,
         maxFuelCapacity: Double,
         color: String,
         maxPassengerСapacity: Int,
         numberOfDoors: Int) {
        
        self.maxPassengerСapacity = maxPassengerСapacity
        self.numberOfDoors = numberOfDoors
        self.currentPassengerCapacity = maxPassengerСapacity
        
        super.init(productionYear: productionYear, brand: brand, typeOfFuel: typeOfFuel, fuelСonsumption: fuelСonsumption, maxFuelCapacity: maxFuelCapacity, color: color)
    }
    
    override func checkOrderToAdd(_ order: Order) -> Bool {
        if let order = order as? PassangerTransportrationOrder {
            return order.passangerNumber < currentPassengerCapacity
        } else {
            return false
        }
    }
    
    override func loadOrder(_ order: Order) {
        guard let order = order as? PassangerTransportrationOrder else { return }
        currentPassengerCapacity -= order.passangerNumber
    }
    
    override func unloadOrder(_ order: Order) {
        guard let order = order as? PassangerTransportrationOrder else { return }
        currentPassengerCapacity += order.passangerNumber
    }
    
    override func isReadyToComplete() -> Bool {
        isDisinfected
    }
    
    override func doServiceWorks() {
        super.doServiceWorks()
        disinfectSalon()
    }
    
    func disinfectSalon() {
        if isDisinfected {
            print("Already disinfected")
        } else {
            isDisinfected = true
            print("Vehicle successfully disinfected")
        }
    }
    
    override func printCapacityInfo() {
        print("current capacity - \(currentPassengerCapacity) persons")
    }
}

class CargoPassengerTransport: Transport {
    
    var maxCargoCapacity: Double
    var currentCargoCapacity: Double
    var maxPassengerСapacity: Int
    var currentPassengerCapacity: Int
    var isDisinfected: Bool = false
    var isSealed: Bool = false
    
    init(productionYear: Int, brand: String, typeOfFuel: Fuel, fuelСonsumption: Double, maxFuelCapacity:Double, color: String, maxCargoCapacity: Double, maxPassengerСapacity: Int) {
        
        self.maxCargoCapacity = maxCargoCapacity
        self.currentCargoCapacity = maxCargoCapacity
        self.maxPassengerСapacity = maxPassengerСapacity
        self.currentPassengerCapacity = maxPassengerСapacity
        
        super.init(productionYear: productionYear, brand: brand, typeOfFuel: typeOfFuel, fuelСonsumption: fuelСonsumption, maxFuelCapacity: maxFuelCapacity, color: color)
    }
    
    override func doServiceWorks() {
        super.doServiceWorks()
        disinfectSalon()
        sealBodyOfTruck()
    }
    
    func disinfectSalon() {
        if isDisinfected {
            print("Already disinfected")
        } else {
            isDisinfected = true
            print("Vehicle successfully disinfected")
        }
    }
    
    func sealBodyOfTruck(){
        if isSealed {
            print("Already sealed")
        } else {
            isSealed = true
            print("Truck body successfully sealed")
        }
    }
    
    override func checkOrderToAdd(_ order: Order) -> Bool {
        if let order = order as? CargoPassengerOrder {
            return order.passangerNumber < maxPassengerСapacity && order.weight <= currentCargoCapacity
        } else {
            return false
        }
    }
    
    override func loadOrder(_ order: Order) {
        guard let order = order as? CargoPassengerOrder else { return }
        currentCargoCapacity -= order.weight
        currentPassengerCapacity -= order.passangerNumber
    }
    
    override func unloadOrder(_ order: Order) {
        guard let order = order as? CargoPassengerOrder else { return }
        currentCargoCapacity += order.weight
        currentPassengerCapacity += order.passangerNumber
    }
    
    override func isReadyToComplete() -> Bool {
        isDisinfected && isSealed
    }
    
    override func printCapacityInfo() {
        print("current load capacity - \(currentCargoCapacity)kg")
        print("current capacity - \(currentPassengerCapacity) persons")
    }
}

class Order {
    
    let pickup: String
    let destination: String
    let distance: Double
    
    init(pickup: String, destination: String,  distance: Double ) {
        self.pickup = pickup
        self.destination = destination
        self.distance = distance
    }
    
    func printDescription() {
        print("Order:")
        print("pickup - \(pickup)")
        print("destination - \(destination)")
        print("distance - \(distance)km")
    }
}

class CargoOrder: Order {
    
    let typeOfCargo: TypeOfCargo
    let weight: Double
    
    init(pickup: String, destination: String, distance: Double,typeOfCargo: TypeOfCargo, weight: Double) {
        
        self.typeOfCargo = typeOfCargo
        self.weight = weight
        super.init(pickup: pickup, destination: destination, distance: distance)
    }
    
    override func printDescription() {
        super.printDescription()
        print("weight - \(weight)kg")
        print("type Of Cargo - \(typeOfCargo.rawValue)")
    }
}

class PassangerTransportrationOrder: Order {
    
    let passangerNumber: Int
    
    init(pickup: String, destination: String, distance: Double, passangerNumber: Int) {
        self.passangerNumber = passangerNumber
        super.init(pickup: pickup, destination: destination, distance: distance)
    }
    
    override func printDescription() {
        super.printDescription()
        print("passengesr Number - \(passangerNumber)")
    }
}

class CargoPassengerOrder: Order {
    
    let typeOfCargo: TypeOfCargo
    let weight: Double
    let passangerNumber: Int
    
    init(pickup: String, destination: String, distance: Double,typeOfCargo: TypeOfCargo, weight: Double, passangerNumber: Int) {
        self.typeOfCargo = typeOfCargo
        self.weight = weight
        self.passangerNumber = passangerNumber
        super.init(pickup: pickup, destination: destination, distance: distance)
    }
    
    override func printDescription() {
        super.printDescription()
        print("passengesr Number - \(passangerNumber)")
        print("weight - \(weight)kg")
        print("type Of Cargo - \(typeOfCargo.rawValue)")
    }
}


enum Fuel: String {
    case diesel
    case petrol92
    case petrol95
    case petrol98
    case gas
}

enum TypeOfCargo: String {
    case manufacturedGoods
    case perishableProducts
    case liquids
}

enum TruckBody{
    case awningTruck
    case refrigerator
    case tank
    
    var typeOfCargo: TypeOfCargo {
        switch self {
        case .awningTruck:
            return .manufacturedGoods
        case .refrigerator:
            return .perishableProducts
        case .tank:
            return .liquids
        }
    }
}

let transport: [Transport] = [
    CargoTransport(productionYear: 2000, brand: "Toyota", typeOfFuel: .diesel, fuelСonsumption: 15, maxFuelCapacity: 200, color: "Black", maxTruckVolume: 1000, typeTruckBody: .refrigerator),
    CargoTransport(productionYear: 2000, brand: "Toyota", typeOfFuel: .gas, fuelСonsumption: 10, maxFuelCapacity: 120, color: "Green", maxTruckVolume: 500, typeTruckBody: .awningTruck),
    CargoTransport(productionYear: 2000, brand: "Toyota", typeOfFuel: .petrol92, fuelСonsumption: 11, maxFuelCapacity: 110, color: "Blue", maxTruckVolume: 200, typeTruckBody: .tank),
    PassengerTransport(productionYear: 2022, brand: "Volkswagen", typeOfFuel: .petrol98, fuelСonsumption: 12, maxFuelCapacity: 130, color: "Pink", maxPassengerСapacity: 8, numberOfDoors: 3),
    CargoPassengerTransport(productionYear: 2008, brand: "Volkswagen", typeOfFuel: .diesel, fuelСonsumption: 20, maxFuelCapacity: 200, color: "Black", maxCargoCapacity: 500, maxPassengerСapacity: 20)
]

let orders: [Order] = [
    CargoOrder(pickup: "Minsk", destination: "Warsaw", distance: 500, typeOfCargo: .liquids, weight: 100),
    CargoOrder(pickup: "Minsk", destination: "Vilnius", distance: 300, typeOfCargo: .manufacturedGoods, weight: 200),
    CargoOrder(pickup: "Minsk", destination: "Brest", distance: 330, typeOfCargo: .perishableProducts, weight: 500),
    PassangerTransportrationOrder(pickup: "minsk", destination: "Vitebsk", distance: 300, passangerNumber: 12),
    PassangerTransportrationOrder(pickup: "minsk", destination: "Vitebsk", distance: 300, passangerNumber: 5),
    CargoPassengerOrder(pickup: "Minsk", destination: "Smolensk", distance: 600, typeOfCargo: .perishableProducts, weight: 300, passangerNumber: 10),
    CargoPassengerOrder(pickup: "Minsk", destination: "Smolensk", distance: 600, typeOfCargo: .perishableProducts, weight: 300, passangerNumber: 30)
]

for car in transport {
    print("\n\n\(car.brand)\n\n")
    car.doServiceWorks()
    car.refuelVehicle(typeOfFuel: car.typeOfFuel, amount: 100)
    
    orders.forEach { car.addOrder($0) }
    
    car.printInfo()
    
    while car.hasOrders {
        car.completeOrder()
    }
    
    car.doServiceWorks()
}
