CREATE 
VIEW `flight_revenue_summary` AS
    SELECT 
        `f`.`Flight_No` AS `Flight_No`,
        `f`.`Aircraft_Type` AS `Aircraft_Type`,
        `f`.`Departure_Time` AS `Departure_Time`,
        `f`.`Arrival_Time` AS `Arrival_Time`,
        `f`.`Status` AS `Flight_Status`,
        COUNT(DISTINCT `b`.`Booking_ID`) AS `Total_Bookings`,
        SUM(`pay`.`Amount`) AS `Total_Revenue`
    FROM
        ((`flight_info` `f`
        JOIN `booking_info` `b` ON ((`f`.`Flight_No` = `b`.`Flight_No`)))
        JOIN `payment_info` `pay` ON ((`b`.`Booking_ID` = `pay`.`Booking_ID`)))
    WHERE
        ((`b`.`Booking_Status` = 'Confirmed')
            AND (`pay`.`Payment_Status` = 'Paid'))
    GROUP BY `f`.`Flight_No` , `f`.`Aircraft_Type` , `f`.`Departure_Time` , `f`.`Arrival_Time` , `f`.`Status`