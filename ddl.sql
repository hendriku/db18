/* Wir haben Oracle X11g Express benutzt, da es bereits durch die Vorlesung installiert und eingerichtet war. Daher mussten wir
nur einen neuen Datenbankbenutzer anlegen und konnten unsere in der Vorlesung bereits unter Beweis gestellten Kenntnisse direkt
anwenden.*/

-- Create skeleton (CHECK)
-- Delete everything again (CHECK)
-- Add constraints
-- generate random content in insert sql

-- Eine Tabelle, die den Zuegen ihren Typ zuordnet
CREATE TABLE ZUG(
    ZUG_ID NUMBER NOT NULL,
    ZUG_TYP VARCHAR2(8) NOT NULL,
    CONSTRAINT ZUG_PK PRIMARY KEY(
        ZUG_ID
    ) ENABLE
);
COMMENT ON TABLE ZUG IS 'Eine Tabelle mit allen Zuegen';
COMMENT ON COLUMN ZUG.ZUG_ID IS 'eine Nummer, die einen physischen Zug eindeutig identifiziert';
COMMENT ON COLUMN ZUG.ZUG_TYP IS 'der Typ des Zugs, z.B. ICE, IC oder SBAHN';

-- Eine Tabelle, die Mitfahrer einer Verbindung zuordnet
CREATE TABLE MITFAHRER(
    VERBINDUNGS_ID NUMBER NOT NULL,
    MITARBEITER_ID NUMBER NOT NULL,
    CONSTRAINT MITFAHRER_PK PRIMARY KEY(
        VERBINDUNGS_ID,
        MITARBEITER_ID
    ) ENABLE
);
COMMENT ON TABLE MITFAHRER IS 'Eine Tabelle, in der die Mitarbeiter Verbindungen zugeteilt werden. (Mindestens 1 LOKFUEHRER pro Verbindung, je nach Zugtyp KELLNER)';
COMMENT ON COLUMN MITFAHRER.VERBINDUNGS_ID IS 'die Idenfikationsnummer einer Verbindung, in der der unter MITARBEITER_ID definierte Mitarbeiter mitfaehrt.';
COMMENT ON COLUMN MITFAHRER.MITARBEITER_ID IS 'die Identifikationsnummer des Mitarbeiters, der in der unter VERBINDUNGS_ID definierten Verbindung mitfaehrt.';

-- Eine Tabelle, die Haltestellen einen Namen und die Eigenschaft BARRIEREFREIHET zuordnet
CREATE TABLE HALTESTELLE(
    HALTESTELLEN_ID NUMBER NOT NULL,
    HALTESTELLEN_NAME VARCHAR2(144) NOT NULL,
    BARRIEREFREI CHARACTER(1) DEFAULT 'N' NOT NULL,
    CONSTRAINT HALTESTELLE_PK PRIMARY KEY(
        HALTESTELLEN_ID
    ) ENABLE
);
COMMENT ON TABLE HALTESTELLE IS 'eine Uebersicht der Haltestellen mit Zusatzinformationen';
COMMENT ON COLUMN HALTESTELLE.HALTESTELLEN_ID IS 'eine Nummer, die eine Haltestelle eindeutig identifiziert';
COMMENT ON COLUMN HALTESTELLE.HALTESTELLEN_NAME IS 'der Name der Haltestelle (muss nicht eindeutig sein)';
COMMENT ON COLUMN HALTESTELLE.BARRIEREFREI IS 'J oder N, gibt an ob eine Haltestelle barrierefrei ist';

/*  
    Eine Tabelle, die alle Strecken enthaelt.
    Eine Strecke wird durch die STRECKEN_ID identifiziert. Sie enthaelt mehrere Haltestellen, denen ihre Position auf der Strecke zugeordnet ist.
    0 ist dabei dem Starthalt, die hoechste Zahl dem Endhalt zugeordnet.
    Die STRECKEN_ID liefert alle Eintraege von indizierten Haltestellen in der Tabelle zurueck. Einzelne Eintraege erhaelt man durch
    Angabe von STRECKEN_ID und dem POS_INDEX (Positions-Index).
*/
CREATE TABLE STRECKE(
    STRECKEN_ID NUMBER NOT NULL,
    HALTESTELLEN_ID NUMBER NOT NULL,
    POS_INDEX NUMBER NOT NULL,
    CONSTRAINT STRECKE_PK PRIMARY KEY(
        STRECKEN_ID,
        POS_INDEX
    ) ENABLE
);
COMMENT ON TABLE STRECKE IS 'Eine Tabelle mit allen Strecken. Eine Strecke hat mehrere Haltestellen, die eine Position auf der Strecke haben (0 ist Starthalt, hoechste Zahl Endhalt). Die STRECKEN_ID liefert alle Eintraege fuer eine eine Strecke, einzelne Eintraege werden mit STRECKEN_ID und POS_INDEX selektiert.';
COMMENT ON COLUMN STRECKE.STRECKEN_ID IS 'eine Nummer, die eine Strecke eindeutig identifiziert, bildet mit POS den Schluessel';
COMMENT ON COLUMN STRECKE.HALTESTELLEN_ID IS 'die Identifikationsnummer einer Haltestelle, die auf der Strecke liegt';
COMMENT ON COLUMN STRECKE.POS_INDEX IS 'eine Nummer, die die Position eines Halts auf der Strecke angibt';

/*  
    Eine Tabelle, die alle Verbindungen enthaelt.
    Eine Verbindung wird durch die VERBINDUNGS_ID identifiziert. Sie enthaelt mehrere Haltestellen aus der ihr zugeordneten Strecke, denen ihre Position auf der Strecke zugeordnet ist.
    0 ist dabei dem Starthalt, die hoechste Zahl dem Endhalt zugeordnet. Weitere zugeordnete Informationen sind Ankunfts- und Abfahrtszeit sowie das Gleis, da dieses bei verschiedenen Verbindungen auf der gleichen Strecke variieren koennte.
    Die VERBINDUNGS_ID liefert alle Eintraege von indizierten Haltestellen in der Tabelle zurueck. Einzelne Eintraege erhaelt man durch
    Angabe von STRECKEN_ID und dem POS_INDEX (Positions-Index).
*/
CREATE TABLE VERBINDUNG(
    VERBINDUNGS_ID NUMBER NOT NULL,
    STRECKEN_ID NUMBER NOT NULL,
    POS_INDEX NUMBER NOT NULL,
    ZUG_ID NUMBER NOT NULL,
    ANKUNFTSZEIT DATE,
    ABFAHRTSZEIT DATE,
    GLEIS NUMBER NOT NULL,
    CONSTRAINT VERBINDUNG PRIMARY KEY(
        VERBINDUNGS_ID,
        POS_INDEX
    ) ENABLE
);
COMMENT ON TABLE VERBINDUNG IS 'Eine Tabelle mit allen Verbindungen. Sie ordnet den einzelnen Eintraegen fuer eine Strecke Uhrzeiten und Gleise zu. Eine VERBINDUNGS_ID liefert alle Eintraege zu einer Verbindung, VERBINDUNGS_ID und POS_INDEX einer Haltestelle sind der Primaersschluessel.';
COMMENT ON COLUMN VERBINDUNG.VERBINDUNGS_ID IS 'eine Nummer, die eine Verbindung eindeutig identifiziert';
COMMENT ON COLUMN VERBINDUNG.STRECKEN_ID IS 'eine Nummer, die befahrene Strecke eindeutig identifiziert';
COMMENT ON COLUMN VERBINDUNG.POS_INDEX IS 'eine Nummer, die die Position eines Halts auf der Strecke angibt';
COMMENT ON COLUMN VERBINDUNG.ZUG_ID IS 'eine Nummer, die den Zug der die Verbindung faehrt identifiziert';
COMMENT ON COLUMN VERBINDUNG.ANKUNFTSZEIT IS 'eine Uhrzeit (DATE), die die Ankunftszeit an einem Halt angibt. Ist NULL fuer den Startbahnhof';
COMMENT ON COLUMN VERBINDUNG.ABFAHRTSZEIT IS 'eine Uhrzeit (DATE), die die Abfahrtszeit an einem Halt angibt. Ist NULL fuer den Endbahnhof';
COMMENT ON COLUMN VERBINDUNG.GLEIS IS 'eine Nummer, die das Gleis angibt, an dem der Zug am Halt haelt';

-- Eine Tabelle, die einer MITARBEITER_ID detaillierte Informationen ueber diesen Mitarbeiter zuordnet
CREATE TABLE MITARBEITER(
    MITARBEITER_ID NUMBER NOT NULL,
    MITARBEITER_TYP VARCHAR2(16) NOT NULL,
    MITARBEITER_VORNAME VARCHAR2(32) NOT NULL,
    MITARBEITER_NAME VARCHAR2(32) NOT NULL,
    MITARBEITER_EINSTELLDATUM DATE NOT NULL,
    CONSTRAINT MITABEITER_PK PRIMARY KEY(
        MITARBEITER_ID
    ) ENABLE
);
COMMENT ON TABLE MITARBEITER IS 'Eine Tabelle, in der die Mitarbeiter mit Details aufgefuehrt werden';
COMMENT ON COLUMN MITARBEITER.MITARBEITER_ID IS 'die Identifikationsnummer eines Mitarbeiters';
COMMENT ON COLUMN MITARBEITER.MITARBEITER_TYP IS 'Jobbezeichnung des Mitarbeiters, KELLNER oder LOCKFUEHRER';
COMMENT ON COLUMN MITARBEITER.MITARBEITER_VORNAME IS 'Vorname eines Mitarbeiters';
COMMENT ON COLUMN MITARBEITER.MITARBEITER_NAME IS 'Nachname eines Mitarbeiters';

-- Eine Tabelle, die Mitarbeitern Urlaub zuordent. Ein Mitarbeiter kann mehrere Urlaube nehmen
CREATE TABLE URLAUB(
    MITARBEITER_ID NUMBER NOT NULL,
    URLAUBSANFANG DATE NOT NULL,
    URLAUBSENDE DATE NOT NULL,
    CONSTRAINT URLAUB_ID PRIMARY KEY(
        MITARBEITER_ID,
        URLAUBSANFANG,
        URLAUBSENDE
    ) ENABLE
);
COMMENT ON TABLE URLAUB IS 'Eine Tabelle, die Mitarbeitern Urlaub zuordnet. Ein Mitarbeiter kann mehrere Urlaube nehmen.';
COMMENT ON COLUMN URLAUB.MITARBEITER_ID IS 'die Identifikationsnummer eines Mitarbeiters';
COMMENT ON COLUMN URLAUB.URLAUBSANFANG IS 'das Datum, an dem man endlich Urlaub hat';
COMMENT ON COLUMN URLAUB.URLAUBSENDE IS 'das Datum des letzten Tages vom viel zu kurzen Urlaub';

-- View um alle Stops anzuzeigen
CREATE VIEW ALLE_STOPS_V (
    VERBINDUNG,
    ZUG_TYP,
    BAHNHOF,
    IST_START,
    IST_ZIEL,
    ANKUNFTSZEIT,
    ABFAHRTSZEIT
)
AS
    SELECT 
        V.VERBINDUNGS_ID,
        Z.ZUG_TYP, 
        H.HALTESTELLEN_NAME,
        CASE WHEN V.POS_INDEX = 0 THEN 'JA' ELSE 'NEIN' END,
        CASE WHEN V.POS_INDEX = MAX(V.POS_INDEX) OVER (PARTITION BY V.VERBINDUNGS_ID) THEN 'JA' ELSE 'NEIN' END,
        TO_CHAR(V.ANKUNFTSZEIT, 'HH24:MI'),
        TO_CHAR(V.ABFAHRTSZEIT, 'HH24:MI')
    FROM VERBINDUNG V 
    LEFT JOIN ZUG Z ON (V.ZUG_ID = Z.ZUG_ID)
    LEFT JOIN STRECKE S ON (V.STRECKEN_ID = S.STRECKEN_ID AND V.POS_INDEX = S.POS_INDEX)
    LEFT JOIN HALTESTELLE H ON (S.HALTESTELLEN_ID = H.HALTESTELLEN_ID)
;
COMMENT ON TABLE ALLE_STOPS_V IS 'View um alle Stops anzuzeigen';
COMMENT ON COLUMN ALLE_STOPS_V.VERBINDUNG IS 'VERBINDUNGS_ID des Stops';
COMMENT ON COLUMN ALLE_STOPS_V.ZUG_TYP IS 'Typ des Zugs, der die Verbindung faehrt.';
COMMENT ON COLUMN ALLE_STOPS_V.BAHNHOF IS 'Name des Stops';
COMMENT ON COLUMN ALLE_STOPS_V.IST_START IS 'Zeigt an, ob es sich um den Startbahnhof einer Verbindung handelt.';
COMMENT ON COLUMN ALLE_STOPS_V.IST_ZIEL IS 'Zeigt an, ob es sich um den Endbahnhof einer Verbindung handelt.';
COMMENT ON COLUMN ALLE_STOPS_V.ANKUNFTSZEIT IS 'Planmaessige Ankunftszeit des Zugs am Stop';
COMMENT ON COLUMN ALLE_STOPS_V.ABFAHRTSZEIT IS 'Planmaessige Abfahrtszeit des Zugs am Stop';







