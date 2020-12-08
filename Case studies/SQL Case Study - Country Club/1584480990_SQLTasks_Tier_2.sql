/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


--- QUESTIONS 
/*Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT 
  name 
FROM 
  country_club.Facilities 
WHERE 
  membercost <> '0.0';


/* Q2: How many facilities do not charge a fee to members? */
SELECT 
  COUNT(*) 
FROM 
  country_club.Facilities 
WHERE 
  membercost = '0.0';


/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT 
  facid, 
  name, 
  membercost, 
  monthlymaintenance 
FROM 
  country_club.Facilities 
WHERE 
  membercost <> '0.0' 
  AND membercost < 0.20 * monthlymaintenance;



/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */
SELECT 
  * 
FROM 
  country_club.Facilities 
WHERE 
  facid IN (1, 5);


/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */
SELECT 
  name, 
  monthlymaintenance, 
  CASE WHEN monthlymaintenance > 100 THEN 'Expensive' WHEN monthlymaintenance <= 100 THEN 'Cheap' END AS pricecategory 
FROM 
  country_club.Facilities;


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */
SELECT
    firstname,
    surname,
    joindate
FROM
    country_club.Members 
WHERE joindate =
  (SELECT MAX(joindate) 
   FROM 
       country_club.Members)
ORDER BY
    joindate DESC;

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
SELECT DISTINCT
( CONCAT( m.firstName, ' ', m.surname ) ) AS membername,
   f.name 
FROM
   country_club.Members AS m 
   LEFT JOIN
      country_club.Bookings AS b 
      ON m.memid = b.memid 
   LEFT JOIN
      country_club.Facilities AS f 
      ON f.facid = b.facid 
WHERE
   f.name IN 
   (
      'Tennis Court 1',
      'Tennis Court 2' 
   )
ORDER BY
   membername;

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
SELECT 
  DISTINCT (
    CONCAT(m.firstName, ' ', m.surname)
  ) AS membername, 
  f.name, 
  CASE WHEN (
    b.memid = 0 
    AND (b.slots * f.guestcost > 30)
  ) THEN (b.slots * f.guestcost) ELSE b.slots * f.membercost END AS Cost 
FROM 
  country_club.Bookings AS b 
  LEFT JOIN country_club.Members AS m ON m.memid = b.memid 
  LEFT JOIN country_club.Facilities AS f ON f.facid = b.facid 
WHERE 
  (
    b.starttime >= '2012-09-14 00:00:00' 
    AND b.starttime <= '2012-09-14 23:59:59'
  ) 
  AND CASE WHEN b.memid = 0 THEN (f.guestcost * b.slots) ELSE (f.membercost * b.slots) END > 30 
ORDER BY 
  Cost DESC;


/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT 
  sub3.membername, 
  sub3.facilityname, 
  sub3.Cost 
FROM 
  (
    SELECT 
      sub2.membername AS membername, 
      f.name AS facilityname, 
      CASE WHEN sub2.Type = 'Member' 
      AND (
        sub2.slotNumber * f.membercost > 30
      ) THEN sub2.slotNumber * f.membercost WHEN sub2.Type = 'Guest' 
      AND (sub2.slotNumber * f.guestcost > 30) THEN sub2.slotNumber * f.guestcost END AS Cost 
    FROM 
      (
        SELECT 
          DISTINCT (
            CONCAT(m.firstName, ' ', m.surname)
          ) AS membername, 
          sub1.memid AS memberId, 
          sub1.facid AS facilityId, 
          sub1.slots AS slotNumber, 
          sub1.UserType AS Type 
        FROM 
          (
            SELECT 
              memId, 
              facid, 
              slots, 
              CASE WHEN memid = 0 THEN 'Guest' WHEN memid <> 0 THEN 'Member' END AS UserType 
            FROM 
              country_club.Bookings 
            WHERE 
              starttime >= '2012-09-14 00:00:00' 
              AND starttime <= '2012-09-14 23:59:59'
          ) AS sub1 
          LEFT JOIN country_club.Members m ON m.memid = sub1.memid
      ) AS sub2 
      LEFT JOIN country_club.Facilities f ON f.facid = sub2.facilityId
  ) AS sub3 
WHERE 
  sub3.Cost > 30 
ORDER BY 
  sub3.Cost DESC;


/*PART 2: SQLite
#Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.*/

---QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT 
  sub2.name AS facilityname, 
  sub2.totalrevenue AS totalrevenue 
FROM 
  (
    SELECT 
      sub1.facilityname AS name, 
      SUM(sub1.revenue) AS totalrevenue 
    FROM 
      (
        SELECT 
          b.bookid, 
          f.name AS facilityname, 
          CASE WHEN b.memid = 0 THEN (b.slots * f.guestcost) ELSE b.slots * f.membercost END AS Revenue 
        FROM 
          Bookings AS b 
          LEFT JOIN Members AS m ON m.memid = b.memid 
          LEFT JOIN Facilities AS f ON f.facid = b.facid
      ) AS sub1 
    GROUP BY 
      sub1.facilityname
  ) AS sub2 
GROUP BY 
  facilityname 
HAVING 
  totalrevenue < 1000 
ORDER BY 
  totalrevenue DESC;



/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

SELECT 
  sub2.memberName AS membername, 
  sub2.recommenderfirstname || ', ' || sub2.recommendersurname AS recommendername 
FROM 
  (
    SELECT 
      sub1.memberName AS memberName, 
      sub1.recommenderId AS memberId, 
      m.firstname AS recommenderfirstname, 
      m.surname AS recommendersurname 
    FROM 
      (
        SELECT 
          m2.memid AS memberId, 
          m1.firstname || ', ' || m1.surname AS memberName, 
          m2.recommendedby AS recommenderId 
        FROM 
          Members AS m1 
          INNER JOIN Members AS m2 ON m1.memid = m2.memid 
        WHERE 
          (
            m2.recommendedby IS NOT NULL 
            OR m2.recommendedby <> ' ' 
            OR m2.recommendedby <> ''
          ) 
          AND m1.memid <> 0
      ) AS sub1 
      LEFT JOIN Members AS m ON sub1.recommenderId = m.memid 
    WHERE 
      m.memid <> 0
  ) AS sub2;


/* Q12: Find the facilities with their usage by member, but not guests */
SELECT 
  f.name AS facilityname, 
  SUM(b.slots) AS slot_usage 
FROM 
  Bookings AS b 
  LEFT JOIN Facilities AS f ON f.facid = b.facid 
  LEFT JOIN Members AS m ON m.memid = b.memid 
WHERE 
  b.memid <> 0 
GROUP BY 
  facilityname 
ORDER BY 
  slot_usage DESC;


/* Q13: Find the facilities usage by month, but not guests */
SELECT 
  sub.MONTH AS MONTH, 
  sub.facilityname AS facility, 
  SUM(sub.slotNumber) AS slotusage 
FROM 
  (
    SELECT 
      strftime('%m', starttime) AS MONTH, 
      f.name AS facilityname, 
      b.slots AS slotNumber 
    FROM 
      Bookings AS b 
      LEFT JOIN Facilities AS f ON f.facid = b.facid 
      LEFT JOIN Members AS m ON m.memid = b.memid 
    WHERE 
      b.memid <> 0
  ) sub 
GROUP BY 
  MONTH, 
  facility 
ORDER BY 
  MONTH, 
  slotusage DESC;

