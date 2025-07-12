USE airindiadb;

DROP VIEW IF EXISTS luggage_report_summary_view;

CREATE VIEW luggage_report_summary_view AS
SELECT
    l.Report_ID,
    pl.Name AS Passenger_Name,
    pl.Gender,
    pl.Contact,
    l.Flight_No,
    fl.Origin,
    fl.Destination,
    fl.Flight_Date,
    l.Description AS Lost_Item_Description,
    l.Report_Date,
    l.Status AS Report_Status,
    r.Resolution_Status,
    r.Action_Taken,
    r.Resolution_Date,
    t.Officer_Name AS Investigation_Officer,
    t.Base_Airport,
    t.Region
FROM luggage_report l
JOIN passenger_lost_luggage pl ON l.Passenger_ID = pl.Passenger_ID
JOIN flight_lost_luggage fl ON l.Flight_No = fl.Flight_No
LEFT JOIN resolution_log r ON l.Report_ID = r.Report_ID
LEFT JOIN investigation_team t ON r.Team_ID = t.Team_ID;
