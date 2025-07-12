CREATE DATABASE AirIndiaDB;
USE AirIndiaDB;

-- ========================================
-- SECTION 1: FLIGHT BOOKING SYSTEM QUERIES
-- ========================================
-- Q1:Find all bookings along with passenger name and flight number.
SELECT b.Booking_ID, p.Name,p.Seat_No, f.Flight_No
FROM passenger_info p
left JOIN booking_info b ON b.Passenger_ID = p.Passenger_ID
left JOIN flight_info f on p.Flight_No = f.Flight_No;

-- Q2: List passengers who booked in June
SELECT * FROM Passenger_info
WHERE Passenger_ID IN (
    SELECT Passenger_ID FROM Booking_info
    WHERE Booking_Date BETWEEN '2025-06-01' AND '2025-06-30'
);

-- Q3:List the total payment made by each Passenger.
SELECT p.Name, SUM(pay.Amount) AS TotalPaid
FROM Passenger_info p
JOIN booking_info b ON p.Passenger_ID = b.Passenger_ID
JOIN payment_info pay ON b.Booking_ID = pay.Booking_ID
GROUP BY p.Name;

-- Q4 : Show flights that go from Delhi to Mumbai.
select * from booking_info
where source='Delhi' and Destination ='Mumbai';

-- Q5 : Find all flights booked with a payment method as 'UPI'.
SELECT b.Booking_ID, p.Name, f.Flight_No, pay.Payment_Mode, pay.Payment_Status
FROM passenger_info p
JOIN booking_info b ON b.Passenger_ID = p.Passenger_ID
JOIN payment_info pay ON pay.Passenger_ID = p.Passenger_ID
JOIN flight_info f ON f.Flight_No = b.Flight_No
WHERE pay.Payment_Mode = 'UPI';

-- Q6 : Find the most expensive ticket paid.
select p.Passenger_ID,p.Name,pay.Payment_ID,pay.Payment_Mode,pay.Amount
from passenger_info p
join payment_info pay on p.Passenger_ID=pay.Passenger_ID
order by pay.Amount desc
limit 1;

-- Q7 : Count the number of passengers per flight.
SELECT f.Flight_No, COUNT(b.Passenger_ID) AS PassengerCount
FROM flight_info f
JOIN booking_info b ON f.Flight_No = b.Flight_No
GROUP BY f.Flight_No;

-- Q8 : Show all payments made after the booking date.

SELECT b.Booking_ID, b.Booking_Date, pay.Payment_Date
FROM booking_info b
JOIN payment_info pay ON b.Booking_ID = pay.Booking_ID
WHERE pay.Payment_Date > b.Booking_Date;

-- Q9 : List all investigation_teaml flights with their origin and destination city names.

SELECT f.Flight_No, b.Source,b.Destination,f.Aircraft_Type,f.Departure_Time,f.Arrival_Time
FROM flight_info f
JOIN booking_info b ON b.Flight_NO=f.Flight_No;

-- Q10 : Find passengers who have booked more than one flight. 
SELECT Passenger_ID, COUNT(*) AS TotalBookings
FROM booking_info
GROUP BY Passenger_ID
HAVING COUNT(*) > 1;


-- ============================================
-- SECTION 2: LOST LUGGAGE MANAGEMENT QUERIES
-- ============================================
-- Q1 : 🔍 Find all passengers who reported lost luggage but haven’t received a resolution yet.
SELECT p.Name, l.Report_ID, l.Description, r.Resolution_Status
FROM luggage_report l
JOIN passenger_lost_luggage p ON p.Passenger_ID = l.Passenger_ID
LEFT JOIN resolution_log r ON l.Report_ID = r.Report_ID
WHERE r.Resolution_Status IS NULL OR r.Resolution_Status = 'Pending';

-- Q2 : 📅 List all flights that had more than one luggage lost report. 
SELECT Flight_No, COUNT(*) AS Report_Count
FROM luggage_report
GROUP BY Flight_No
HAVING COUNT(*) > 1;

-- Q3 : 🧑‍✈️ Show which investigation team resolved the most number of reports.
SELECT t.Officer_Name, COUNT(r.Resolution_ID) AS Total_Resolved
FROM resolution_log r
JOIN investigation_team t ON r.Team_ID = t.Team_ID
WHERE r.Resolution_Status = 'Found'
GROUP BY t.Team_ID, t.Officer_Name
ORDER BY Total_Resolved DESC;

-- Q4 : 📈 Get number of lost luggage reports per destination city.
SELECT f.Destination, COUNT(l.Report_ID) AS Reports
FROM luggage_report l
JOIN flight_lost_luggage f ON l.Flight_No = f.Flight_No
GROUP BY f.Destination
ORDER BY Reports DESC;

-- Q5 : ⏱️ Reports that took more than 3 days to resolve. 
SELECT l.Report_ID, DATEDIFF(r.Resolution_Date, l.Report_Date) AS Days_Taken
FROM luggage_report l
JOIN resolution_log r ON l.Report_ID = r.Report_ID
WHERE r.Resolution_Date IS NOT NULL AND DATEDIFF(r.Resolution_Date, l.Report_Date) > 3;

-- Q6 : 🎯 Find reports resolved with "Compensation".
SELECT r.Report_ID, p.Name, r.Action_Taken,r.Resolution_Status
FROM resolution_log r
JOIN luggage_report l ON r.Report_ID = l.Report_ID
JOIN passenger_lost_luggage p ON l.Passenger_ID = p.Passenger_ID
WHERE r.Resolution_Status = 'Compensation';

-- Q7 : 📊 Total number of cases handled by each investigation team and their resolution rate.
SELECT 
    t.Officer_Name,
    COUNT(r.Resolution_ID) AS Total_Cases,
    SUM(CASE WHEN r.Resolution_Status = 'Found' THEN 1 ELSE 0 END) AS Resolved_Cases
FROM resolution_log r
JOIN investigation_team t ON r.Team_ID = t.Team_ID
GROUP BY t.Officer_Name;

-- Q8 : 🔗 Detailed resolution log for a given report ID (say 'LR010').
SELECT r.*, t.Officer_Name, t.Base_Airport
FROM resolution_log r
JOIN investigation_team t ON r.Team_ID = t.Team_ID
WHERE r.Report_ID = 'LR005';

-- Q9 : 📍 Count of reports grouped by report status and resolution status.
SELECT l.Status AS Report_Status, r.Resolution_Status, COUNT(*) AS Count
FROM luggage_report l
JOIN resolution_log r ON l.Report_ID = r.Report_ID
GROUP BY l.Status, r.Resolution_Status;

-- Q 10 : 📧 Get contact info of passengers whose reports are still pending.
SELECT p.Name, p.Email, p.Contact
FROM passenger_lost_luggage p
JOIN luggage_report l ON p.Passenger_ID = l.Passenger_ID
JOIN resolution_log r ON l.Report_ID = r.Report_ID
WHERE r.Resolution_Status = 'Pending';

-- Q 11 : 🗓️ Reports filed in last 7 days.
SELECT * 
FROM luggage_report
WHERE Report_Date >= CURDATE() - INTERVAL 7 DAY;








