Config = {}

Config.Debug = false

Config.Notify = {
    enter_seat = 'Press to sit in seat: %s',
    no_vehicle = 'No vehicle nearby!',
    seat_taken = 'This seat is already occupied!',
    vehicle_locked = 'This vehicle is locked!'
}

Config.SeatLabels = {
    [-1] = 'Driver Seat',
    [0] = 'Front Passenger Seat',
    [1] = 'Rear Left Seat',
    [2] = 'Rear Right Seat',
    [3] = 'Extra Seat', -- For vehicles with extra seats
    [4] = 'Extra Seat 2', -- For vehicles with extra seats
    [5] = 'Extra Seat 3', -- For vehicles with extra seats
    [6] = 'Extra Seat 4', -- For vehicles with extra seats
    [7] = 'Extra Seat 5', -- For vehicles with extra seats
    [8] = 'Extra Seat 6', -- For vehicles with extra seats
    [9] = 'Extra Seat 7', -- For vehicles with extra seats
    [10] = 'Extra Seat 8', -- For vehicles with extra seats
    [11] = 'Extra Seat 9', -- For vehicles with extra seats
    [12] = 'Extra Seat 10', -- For vehicles with extra seats
    [13] = 'Extra Seat 11', -- For vehicles with extra seats
    [14] = 'Extra Seat 12', -- For vehicles with extra seats
    [15] = 'Extra Seat 13', -- For vehicles with extra seats
    [16] = 'Extra Seat 14', -- For vehicles with extra seats
}

-- Search radius for detecting nearby vehicles
Config.SearchRadius = 10.0  -- Adjust if needed for larger vehicl
Config.DoorRange = 2.0  -- Distance to be considered "near" a door/trunk/hood
