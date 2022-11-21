USE sales;
SELECT COUNT(*) FROM agents;
SELECT DISTINCT COUNT(*) FROM owners;
SELECT COUNT(*) FROM owners WHERE fname="Bill";
SELECT COUNT(*) FROM dealers WHERE state="AL";
SELECT COUNT(*) FROM dealers WHERE city="Sawyer" AND state="TN";
SELECT COUNT(*) FROM owners WHERE lname="Walker";
 SELECT COUNT(*) FROM agents WHERE owner_id="20";

