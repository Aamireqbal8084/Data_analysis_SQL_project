CREATE 
VIEW `passenger_booking_payment_summary` AS
    SELECT 
        `p`.`Passenger_ID` AS `Passenger_ID`,
        `p`.`Name` AS `Name`,
        `p`.`Age` AS `Age`,
        `p`.`Gender` AS `Gender`,
        `p`.`Travel_Class` AS `Travel_Class`,
        `p`.`Source` AS `Source`,
        `p`.`Destination` AS `Destination`,
        `b`.`Flight_No` AS `Flight_No`,
        `f`.`Departure_Time` AS `Departure_Time`,
        `f`.`Arrival_Time` AS `Arrival_Time`,
        `f`.`Status` AS `Flight_Status`,
        `b`.`Booking_Date` AS `Booking_Date`,
        `b`.`Travel_Date` AS `Travel_Date`,
        `b`.`Booking_Status` AS `Booking_Status`,
        `pay`.`Payment_Mode` AS `Payment_Mode`,
        `pay`.`Amount` AS `Amount`,
        `pay`.`Payment_Status` AS `Payment_Status`
    FROM
        (((`passenger_info` `p`
        JOIN `booking_info` `b` ON ((`p`.`Passenger_ID` = `b`.`Passenger_ID`)))
        JOIN `flight_info` `f` ON ((`b`.`Flight_No` = `f`.`Flight_No`)))
        LEFT JOIN `payment_info` `pay` ON ((`b`.`Booking_ID` = `pay`.`Booking_ID`)))