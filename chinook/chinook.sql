/* Wir haben Oracle X11g Express benutzt, da es bereits durch die Vorlesung installiert und eingerichtet war. Daher mussten wir
nur einen neuen Datenbankbenutzer anlegen und konnten unsere in der Vorlesung bereits unter Beweis gestellten Kenntnisse direkt
anwenden. Au�erdem unterst�tzt es alle f�r Aufgabe 6 ben�tigten Funktionalit�ten. */

-- Aufgabe 1
SELECT ROUND(AVG(t.MILLISECONDS), -3) / 1000 as "Average Length Seconds", m.NAME as "Media Type" FROM TRACK t INNER JOIN MEDIATYPE m ON t.MEDIATYPEID = m.MEDIATYPEID GROUP BY m.NAME;

SELECT * FROM ARTIST;

-- Aufgabe 2
WITH artistsComposers AS (
    SELECT t.COMPOSER, a.NAME
     FROM TRACK t
    JOIN (SELECT * FROM ALBUM alb JOIN ARTIST art ON art.ARTISTID = alb.ARTISTID) a
        ON a.ALBUMID = t.ALBUMID
    WHERE NOT t.COMPOSER IS NULL
),
artistCounter AS (
    SELECT t.COMPOSER, COUNT(t.NAME) AS "COUNTER"
    FROM artistsComposers t
    GROUP BY t.COMPOSER
),
maxArtists AS (
    SELECT * FROM artistCounter ac WHERE ac.COUNTER = (SELECT max(z.COUNTER) FROM artistCounter z)
)
SELECT DISTINCT mA.COMPOSER, aC.NAME FROM maxArtists mA JOIN artistsComposers aC ON mA.COMPOSER = aC.COMPOSER
;

-- Aufgabe 3
WITH artistsTracks AS (
    SELECT a.NAME, t.TRACKID
    FROM TRACK t
        JOIN (SELECT * FROM ALBUM alb JOIN ARTIST art ON art.ARTISTID = alb.ARTISTID) a
            ON a.ALBUMID = t.ALBUMID                                                         
),
artistsInvoices AS (
    SELECT *
    FROM artistsTracks aC JOIN INVOICELINE i ON aC.TRACKID = i.TRACKID
),
trackInvoices AS (
    SELECT aC.COMPOSER, i.UNITPRICE, i.QUANTITY
    FROM TRACK aC JOIN INVOICELINE i ON aC.TRACKID = i.TRACKID
)
SELECT * FROM (
(SELECT NVL(t1.NAME, 'unbekannt'), 'ARTIST' AS TYPE, SUM(t1.UNITPRICE * t1.QUANTITY) AS "MONEY" FROM artistsInvoices t1 GROUP BY t1.NAME)
UNION
(SELECT NVL(t2.COMPOSER, 'unbekannt'), 'COMPOSER' AS TYPE, SUM(t2.UNITPRICE * t2.QUANTITY) AS "MONEY" FROM trackInvoices t2 GROUP BY t2.COMPOSER)) u 
ORDER BY u.MONEY DESC
;

-- Aufgabe 4
CREATE VIEW employee_sales_v AS (
SELECT e.EMPLOYEEID, e.FIRSTNAME, e.LASTNAME, SUM(NVL(subE.TOTAL, 0)) AS "REVENUE"
FROM EMPLOYEE e JOIN (
   SELECT e1.EMPLOYEEID, e1.REPORTSTO, c.TOTAL FROM EMPLOYEE e1 LEFT JOIN (
        SELECT c1.CUSTOMERID, c1.SUPPORTREPID, i.TOTAL
        FROM CUSTOMER c1 JOIN INVOICE i ON i.CUSTOMERID = c1.CUSTOMERID
    ) c ON e1.EMPLOYEEID = c.SUPPORTREPID
) subE ON e.EMPLOYEEID = subE.REPORTSTO OR e.EMPLOYEEID = subE.EMPLOYEEID
GROUP BY e.EMPLOYEEID, e.FIRSTNAME, e.LASTNAME
);

-- Aufgabe 5
/* Alle tracks wurden pl�tzlich 1 cent g�nstiger. Dazu wurde simuliert, dass alle Kunden auf ihren Rechnungen 1,00� / Track bezahlt haben */
UPDATE INVOICELINE il
SET il.UNITPRICE = 1
WHERE 1 = 1;

SELECT SUM(((il.UNITPRICE - t.UNITPRICE) * il.QUANTITY)) AS "GESPART", il.CUSTOMERID, il.FIRSTNAME, il.LASTNAME 
FROM TRACK t
    JOIN (
        SELECT il.UNITPRICE, il.QUANTITY, il.TRACKID, i.CUSTOMERID, i.FIRSTNAME, i.LASTNAME
        FROM (
            SELECT c.CUSTOMERID, i.INVOICEID, c.FIRSTNAME, c.LASTNAME FROM INVOICE i JOIN CUSTOMER c ON i.CUSTOMERID = c.CUSTOMERID
        ) i JOIN INVOICELINE il ON i.INVOICEID = il.INVOICEID
    ) il ON t.TRACKID = il.TRACKID
GROUP BY il.CUSTOMERID, il.FIRSTNAME, il.LASTNAME;

-- Aufgabe 6
-- Spalte anlegen
ALTER TABLE EMPLOYEE
ADD PRIVATE_EMAIL VARCHAR2(256);

-- Bedingung definieren
ALTER TABLE EMPLOYEE
ADD CONSTRAINT EMPLOYEE_CHK_PRIVATE_EMAIL CHECK
(
    NOT PRIVATE_EMAIL LIKE '%@chinookcorp.com'
) ENABLE;

-- Pr�fe, ob die Bedingung erf�llt ist
UPDATE EMPLOYEE e
SET e.PRIVATE_EMAIL = 'lululu@chinookcorp.com'
WHERE 1 = 1;

-- Aufgabe 7

-- Betrug
UPDATE INVOICELINE il
SET il.UNITPRICE = il.UNITPRICE + (ROUND((SELECT 10000 / SUM(QUANTITY) FROM INVOICELINE), 3))
WHERE 1 = 1;

-- Update
UPDATE INVOICE u
SET u.TOTAL = (SELECT SUM(il.UNITPRICE * il.QUANTITY)
FROM INVOICE i JOIN INVOICELINE il ON i.INVOICEID = il.INVOICEID
WHERE i.INVOICEID = u.INVOICEID
GROUP BY i.INVOICEID)
WHERE 1 = 1
;

-- Zur�cksetzen 
UPDATE INVOICELINE il
SET il.UNITPRICE = il.UNITPRICE - (ROUND((SELECT 10000 / SUM(QUANTITY) FROM INVOICELINE), 3))
WHERE 1 = 1;

-- Update
UPDATE INVOICE u
SET u.TOTAL = (SELECT SUM(il.UNITPRICE * il.QUANTITY)
FROM INVOICE i JOIN INVOICELINE il ON i.INVOICEID = il.INVOICEID
WHERE i.INVOICEID = u.INVOICEID
GROUP BY i.INVOICEID)
WHERE 1 = 1
;