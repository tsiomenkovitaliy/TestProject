struct Door {
    let name: String
    let locationName: String
    var status: DoorStatus
    
    init(name: String, status: DoorStatus, locationName: String) {
        self.name = name
        self.status = status
        self.locationName = locationName
    }
}
