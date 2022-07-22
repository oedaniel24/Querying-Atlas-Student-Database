# Querying-Atlas-Student-Database
### Queries used for exploratory analysis of a fictitious college club's database.
The database was downloaded from [data.world](https://data.world/atlas-query/student-club) and contains 7 tables -
* Attendance
* Budget 
* Event 
* Expense
* Income
* Major
* Member
* Zip_code

![Database Schema](https://db-schema.blogspot.com/2020/04/student-club.html)

Exploratory analysis was carried out on the database, using joins to combine and summarise different tables to investigate possible trends, spot anomalies and generate insights from the database.
The database was queried to answer the following questions:


1. Member Activity - This query returns information about all club members and the number of events they have attended (their activity). 
The most active members were **Phillip Cullen** and **Elijah Allen**, the current Vice President and Treasurer having attended a total of 16 events each.

2. Count of Members per State - This query returns the total number of members in every state in the US. We see that the state with the most members (5) is **New York**.

3. Day of the Week Most Event Held - This query returns the number of events held for each day of the week. **29** of the **42** events held were on a **Tuesday**, making Tuesday the most preferred weekday to host events by the club.

4. Event Table - Returns a table containing a list of all events, the date the event was held, the event type, total attendance, total budget, total amount spent and the total amount remaining.

5. Attendance per Event Type - There are eight event types in the event table-registration, guest speaker, meeting, social, game, community service, budget and election. The most attended event type was the **Registration** event type with an average attendance of 30.

6. Members That Are Yet To Pay Their Dues- returns a list of members with no record of paying their membership dues, they include **Randy Woodward** and **Keith Dunlop**.
