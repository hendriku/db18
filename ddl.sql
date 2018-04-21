/* Wir haben Oracle X11g Express benutzt, da es bereits durch die Vorlesung installiert und eingerichtet war. Daher mussten wir
nur einen neuen Datenbankbenutzer anlegen und konnten unsere in der Vorlesung bereits unter Beweis gestellten Kenntnisse direkt
anwenden.*/

-- Create skeleton (CHECK)
-- Delete everything again (CHECK)
-- Add constraints
-- generate random content in insert sql

CREATE TABLE ZUG(
    ZUG_ID NUMBER(10),
    ZUG_TYP VARCHAR(8)
);

CREATE TABLE MITFAHRER(
    VERBINDUNGS_ID NUMBER(10),
    MITARBEITER_ID NUMBER(10)
);

CREATE TABLE HALTESTELLE(
    HALTESTELLEN_ID NUMBER(10),
    HALTESTELLEN_NAME VARCHAR(144),
    BARRIEREFREI CHARACTER(1)
);

CREATE TABLE STRECKE(
    STRECKEN_ID NUMBER(10),
    HALTESTELLEN_ID NUMBER(10),
    POS_INDEX NUMBER(10)
);

CREATE TABLE VERBINDUNG(
    VERBINDUNGS_ID NUMBER(10),
    STRECKEN_ID NUMBER(10),
    POS_INDEX NUMBER(10),
    ZUG_ID NUMBER(10),
    ANKUNFTSZEIT DATE,
    ABFAHRTSZEIT DATE,
    GLEIS NUMBER(3)
);

CREATE TABLE MITARBEITER(
    MITARBEITER_ID NUMBER(10),
    MITARBEITER_TYP VARCHAR(16),
    MITARBEITER_VORNAME VARCHAR(32),
    MITARBEITER_NAME VARCHAR(32)
);

CREATE TABLE URLAUB(
    MITARBEITER_ID NUMBER(10),
    URLAUBSANFANG DATE,
    URLAUBSENDE DATE
);