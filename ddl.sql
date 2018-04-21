/* Wir haben Oracle X11g Express benutzt, da es bereits durch die Vorlesung installiert und eingerichtet war. Daher mussten wir
nur einen neuen Datenbankbenutzer anlegen und konnten unsere in der Vorlesung bereits unter Beweis gestellten Kenntnisse direkt
anwenden.*/

-- Create skeleton (CHECK)
-- Delete everything again (CHECK)
-- Add constraints
-- generate random content in insert sql

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


CREATE TABLE STRECKE(
    STRECKEN_ID NUMBER NOT NULL,
    HALTESTELLEN_ID NUMBER NOT NULL,
    POS_INDEX NUMBER NOT NULL,
    CONSTRAINT STRECKE_PK PRIMARY KEY(
        STRECKEN_ID,
        POS_INDEX
    ) ENABLE
);
COMMENT ON TABLE STRECKE IS 'Eine Tabelle mit allen Strecken. Eine Strecke hat mehrere Haltestellen, die eine Position auf der Strecke haben. Die STRECKEN_ID liefert alle Eintraege fuer eine eine Strecke, einzelne Eintraege werden mit STRECKEN_ID und POS_INDEX selektiert.';
COMMENT ON COLUMN STRECKE.STRECKEN_ID IS 'eine Nummer, die eine Strecke eindeutig identifiziert, bildet mit POS den Schluessel';
COMMENT ON COLUMN STRECKE.HALTESTELLEN_ID IS 'die Identifikationsnummer einer Haltestelle, die auf der Strecke liegt';
COMMENT ON COLUMN STRECKE.POS_INDEX IS 'eine Nummer, die die Position eines Halts auf der Strecke angibt';

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



