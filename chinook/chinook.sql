/* Wir haben Oracle X11g Express benutzt, da es bereits durch die Vorlesung installiert und eingerichtet war. Daher mussten wir
nur einen neuen Datenbankbenutzer anlegen und konnten unsere in der Vorlesung bereits unter Beweis gestellten Kenntnisse direkt
anwenden. Außerdem unterstützt es alle für Aufgabe 6 benötigten Funktionalitäten. */

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
ORDER BY REVENUE DESC
);