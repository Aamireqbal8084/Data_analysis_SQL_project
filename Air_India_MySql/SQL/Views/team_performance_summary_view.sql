CREATE 
VIEW `team_performance_summary_view` AS
    SELECT 
        `t`.`Team_ID` AS `Team_ID`,
        `t`.`Officer_Name` AS `Officer_Name`,
        `t`.`Region` AS `Region`,
        COUNT(`r`.`Resolution_ID`) AS `Total_Cases_Assigned`,
        SUM((CASE
            WHEN (`r`.`Resolution_Status` = 'Found') THEN 1
            ELSE 0
        END)) AS `Found_Cases`,
        SUM((CASE
            WHEN (`r`.`Resolution_Status` = 'Compensation') THEN 1
            ELSE 0
        END)) AS `Compensation_Cases`,
        SUM((CASE
            WHEN (`r`.`Resolution_Status` = 'Not Found') THEN 1
            ELSE 0
        END)) AS `Not_Found_Cases`,
        SUM((CASE
            WHEN (`r`.`Resolution_Status` = 'Pending') THEN 1
            ELSE 0
        END)) AS `Pending_Cases`
    FROM
        (`investigation_team` `t`
        LEFT JOIN `resolution_log` `r` ON ((`t`.`Team_ID` = `r`.`Team_ID`)))
    GROUP BY `t`.`Team_ID` , `t`.`Officer_Name` , `t`.`Region`