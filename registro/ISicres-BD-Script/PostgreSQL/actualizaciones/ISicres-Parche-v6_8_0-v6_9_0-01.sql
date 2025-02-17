/***********************************************************************************************************************************************************/
/*Unidades administrativas*/

CREATE TABLE scr_orgslang (
	id integer NOT NULL,
	language integer NOT NULL,
	name character varying(250) NOT NULL
);
CREATE INDEX scr_orgslang0 ON scr_orgslang USING btree (id);
CREATE UNIQUE INDEX scr_orgslang1 ON scr_orgslang USING btree (id,language);


CREATE VIEW SCR_ORGS_EU (ID,CODE,ID_FATHER,ACRON,NAME,CREATION_DATE,DISABLE_DATE,TYPE,ENABLED,CIF) AS 
SELECT A.ID,A.CODE,A.ID_FATHER,A.ACRON,CASE WHEN B.NAME IS NULL THEN A.NAME ELSE B.NAME END AS NAME, A.CREATION_DATE,A.DISABLE_DATE,A.TYPE,A.ENABLED,A.CIF
FROM SCR_ORGS A LEFT OUTER JOIN SCR_ORGSLANG B ON B.ID = A.ID AND B.LANGUAGE=45;

CREATE VIEW SCR_ORGS_CT (ID,CODE,ID_FATHER,ACRON,NAME,CREATION_DATE,DISABLE_DATE,TYPE,ENABLED,CIF)
AS SELECT A.ID,A.CODE,A.ID_FATHER,A.ACRON,CASE WHEN B.NAME IS NULL THEN A.NAME ELSE B.NAME END AS NAME, A.CREATION_DATE,A.DISABLE_DATE,A.TYPE,A.ENABLED,A.CIF
FROM SCR_ORGS A LEFT OUTER JOIN SCR_ORGSLANG B ON B.ID = A.ID AND B.LANGUAGE=3;

CREATE VIEW SCR_ORGS_GL (ID,CODE,ID_FATHER,ACRON,NAME,CREATION_DATE,DISABLE_DATE,TYPE,ENABLED,CIF)
AS SELECT A.ID,A.CODE,A.ID_FATHER,A.ACRON,CASE WHEN B.NAME IS NULL THEN A.NAME ELSE B.NAME END AS NAME, A.CREATION_DATE,A.DISABLE_DATE,A.TYPE,A.ENABLED,A.CIF
FROM SCR_ORGS A LEFT OUTER JOIN SCR_ORGSLANG B ON B.ID = A.ID AND B.LANGUAGE=86;



/************************************************************************************************************************************************************/
/*Tipos de instituciones */

CREATE TABLE scr_typeadmlang (
	id integer NOT NULL,
	language integer NOT NULL,
	name character varying(50) NOT NULL
);
CREATE INDEX scr_typeadmlang0 ON scr_typeadmlang USING btree (id);
CREATE UNIQUE INDEX scr_typeadmlang1 ON scr_typeadmlang USING btree (id,language);


CREATE VIEW SCR_TYPEADM_EU (ID,CODE,DESCRIPTION)
AS SELECT A.ID,A.CODE,CASE WHEN B.NAME IS NULL THEN A.DESCRIPTION ELSE B.NAME END AS DESCRIPTION
FROM SCR_TYPEADM A LEFT OUTER JOIN SCR_TYPEADMLANG B ON B.ID = A.ID AND B.LANGUAGE=45;

CREATE VIEW SCR_TYPEADM_CT (ID,CODE,DESCRIPTION)
AS SELECT A.ID,A.CODE,CASE WHEN B.NAME IS NULL THEN A.DESCRIPTION ELSE B.NAME END AS DESCRIPTION
FROM SCR_TYPEADM A LEFT OUTER JOIN SCR_TYPEADMLANG B ON B.ID = A.ID AND B.LANGUAGE=3;

CREATE VIEW SCR_TYPEADM_GL (ID,CODE,DESCRIPTION)
AS SELECT A.ID,A.CODE,CASE WHEN B.NAME IS NULL THEN A.DESCRIPTION ELSE B.NAME END AS DESCRIPTION
FROM SCR_TYPEADM A LEFT OUTER JOIN SCR_TYPEADMLANG B ON B.ID = A.ID AND B.LANGUAGE=86;



/************************************************************************************************************************************************************/
/*Oficinas de registro */

CREATE TABLE scr_oficlang (
	id integer NOT NULL,
	language integer NOT NULL,
	name character varying(32) NOT NULL
);
CREATE INDEX scr_oficlang0 ON scr_oficlang USING btree (id);
CREATE UNIQUE INDEX scr_oficlang1 ON scr_oficlang USING btree (id,language);


CREATE VIEW SCR_OFIC_EU (ID,CODE,ACRON,NAME,CREATION_DATE,DISABLE_DATE,ID_ORGS,STAMP,DEPTID,TYPE)
AS SELECT A.ID,A.CODE,A.ACRON,CASE WHEN B.NAME IS NULL THEN A.NAME ELSE B.NAME END AS NAME,A.CREATION_DATE,A.DISABLE_DATE,A.ID_ORGS,A.STAMP,A.DEPTID,A.TYPE
FROM SCR_OFIC A LEFT OUTER JOIN SCR_OFICLANG B ON B.ID = A.ID AND B.LANGUAGE=45;

CREATE VIEW SCR_OFIC_CT (ID,CODE,ACRON,NAME,CREATION_DATE,DISABLE_DATE,ID_ORGS,STAMP,DEPTID,TYPE)
AS SELECT A.ID,A.CODE,A.ACRON,CASE WHEN B.NAME IS NULL THEN A.NAME ELSE B.NAME END AS NAME,A.CREATION_DATE,A.DISABLE_DATE,A.ID_ORGS,A.STAMP,A.DEPTID,A.TYPE
FROM SCR_OFIC A LEFT OUTER JOIN SCR_OFICLANG B ON B.ID = A.ID AND B.LANGUAGE=3;

CREATE VIEW SCR_OFIC_GL (ID,CODE,ACRON,NAME,CREATION_DATE,DISABLE_DATE,ID_ORGS,STAMP,DEPTID,TYPE)
AS SELECT A.ID,A.CODE,A.ACRON,CASE WHEN B.NAME IS NULL THEN A.NAME ELSE B.NAME END AS NAME,A.CREATION_DATE,A.DISABLE_DATE,A.ID_ORGS,A.STAMP,A.DEPTID,A.TYPE
FROM SCR_OFIC A LEFT OUTER JOIN SCR_OFICLANG B ON B.ID = A.ID AND B.LANGUAGE=86;



/************************************************************************************************************************************************************/
/*Tipos de asunto */

CREATE TABLE scr_calang (
	id integer NOT NULL,
	language integer NOT NULL,
	name character varying(250) NOT NULL
);
CREATE INDEX scr_calang0 ON scr_calang USING btree (id);
CREATE UNIQUE INDEX scr_calang1 ON scr_calang USING btree (id,language);


CREATE VIEW SCR_CA_EU (ID,CODE,MATTER,FOR_EREG,FOR_SREG,ALL_OFICS,ID_ARCH,CREATION_DATE,DISABLE_DATE,ENABLED,ID_ORG)
AS SELECT A.ID,A.CODE,CASE WHEN B.NAME IS NULL THEN A.MATTER ELSE B.NAME END AS MATTER,A.FOR_EREG,A.FOR_SREG,A.ALL_OFICS,A.ID_ARCH,A.CREATION_DATE,A.DISABLE_DATE,A.ENABLED,A.ID_ORG
FROM SCR_CA A LEFT OUTER JOIN SCR_CALANG B ON B.ID = A.ID AND B.LANGUAGE=45;

CREATE VIEW SCR_CA_CT (ID,CODE,MATTER,FOR_EREG,FOR_SREG,ALL_OFICS,ID_ARCH,CREATION_DATE,DISABLE_DATE,ENABLED,ID_ORG)
AS SELECT A.ID,A.CODE,CASE WHEN B.NAME IS NULL THEN A.MATTER ELSE B.NAME END AS MATTER,A.FOR_EREG,A.FOR_SREG,A.ALL_OFICS,A.ID_ARCH,A.CREATION_DATE,A.DISABLE_DATE,A.ENABLED,A.ID_ORG
FROM SCR_CA A LEFT OUTER JOIN SCR_CALANG B ON B.ID = A.ID AND B.LANGUAGE=3;

CREATE VIEW SCR_CA_GL (ID,CODE,MATTER,FOR_EREG,FOR_SREG,ALL_OFICS,ID_ARCH,CREATION_DATE,DISABLE_DATE,ENABLED,ID_ORG)
AS SELECT A.ID,A.CODE,CASE WHEN B.NAME IS NULL THEN A.MATTER ELSE B.NAME END AS MATTER,A.FOR_EREG,A.FOR_SREG,A.ALL_OFICS,A.ID_ARCH,A.CREATION_DATE,A.DISABLE_DATE,A.ENABLED,A.ID_ORG
FROM SCR_CA A LEFT OUTER JOIN SCR_CALANG B ON B.ID = A.ID AND B.LANGUAGE=86;




/************************************************************************************************************************************************************/
/*Tipos de transporte */

CREATE TABLE scr_ttlang (
	id integer NOT NULL,
	language integer NOT NULL,
	name character varying(31) NOT NULL
);
CREATE INDEX scr_ttlang0 ON scr_ttlang USING btree (id);
CREATE UNIQUE INDEX scr_ttlang1 ON scr_ttlang USING btree (id,language);


INSERT INTO scr_ttlang(id, "language", "name") VALUES (1, 3, 'CATALAN - CORREO ELECTRONICO');
INSERT INTO scr_ttlang(id, "language", "name") VALUES (2, 3, 'CATALAN - CORREO POSTAL');
INSERT INTO scr_ttlang(id, "language", "name") VALUES (3, 3, 'CATALAN - CORREO URGENTE');
INSERT INTO scr_ttlang(id, "language", "name") VALUES (4, 3, 'CATALAN - CCORREO INTERNO');

INSERT INTO scr_ttlang(id, "language", "name") VALUES (1, 45, 'EUSKERA - CORREO ELECTRONICO');
INSERT INTO scr_ttlang(id, "language", "name") VALUES (2, 45, 'EUSKERA - CORREO POSTAL');
INSERT INTO scr_ttlang(id, "language", "name") VALUES (3, 45, 'EUSKERA - CORREO URGENTE');
INSERT INTO scr_ttlang(id, "language", "name") VALUES (4, 45, 'EUSKERA - CCORREO INTERNO');

INSERT INTO scr_ttlang(id, "language", "name") VALUES (1, 86, 'GALLEGO - CORREO ELECTRONICO');
INSERT INTO scr_ttlang(id, "language", "name") VALUES (2, 86, 'GALLEGO - CORREO POSTAL');
INSERT INTO scr_ttlang(id, "language", "name") VALUES (3, 86, 'GALLEGO - CORREO URGENTE');
INSERT INTO scr_ttlang(id, "language", "name") VALUES (4, 86, 'GALLEGO - CCORREO INTERNO');


CREATE VIEW SCR_TT_EU (ID,TRANSPORT)
AS SELECT A.ID,CASE WHEN B.NAME IS NULL THEN A.TRANSPORT ELSE B.NAME END AS TRANSPORT
FROM SCR_TT A LEFT OUTER JOIN SCR_TTLANG B ON B.ID = A.ID AND B.LANGUAGE=45;

CREATE VIEW SCR_TT_CT (ID,TRANSPORT)
AS SELECT A.ID,CASE WHEN B.NAME IS NULL THEN A.TRANSPORT ELSE B.NAME END AS TRANSPORT
FROM SCR_TT A LEFT OUTER JOIN SCR_TTLANG B ON B.ID = A.ID AND B.LANGUAGE=3;

CREATE VIEW SCR_TT_GL (ID,TRANSPORT)
AS SELECT A.ID,CASE WHEN B.NAME IS NULL THEN A.TRANSPORT ELSE B.NAME END AS TRANSPORT
FROM SCR_TT A LEFT OUTER JOIN SCR_TTLANG B ON B.ID = A.ID AND B.LANGUAGE=86;



/************************************************************************************************************************************************************/
/*Informes */

CREATE TABLE scr_reportslang (
	id integer NOT NULL,
	language integer NOT NULL,
	name character varying(250) NOT NULL
);
CREATE INDEX scr_reportslang0 ON scr_reportslang USING btree (id);
CREATE UNIQUE INDEX scr_reportslang1 ON scr_reportslang USING btree (id,language);


CREATE VIEW SCR_REPORTS_EU (ID,REPORT,TYPE_REPORT,TYPE_ARCH,ALL_ARCH,ALL_OFICS,ALL_PERFS,DESCRIPTION,DATA)
AS SELECT A.ID,A.REPORT,A.TYPE_REPORT,A.TYPE_ARCH,A.ALL_ARCH,A.ALL_OFICS,A.ALL_PERFS,CASE WHEN B.NAME IS NULL THEN A.DESCRIPTION ELSE B.NAME END AS DESCRIPTION,A.DATA
FROM SCR_REPORTS A LEFT OUTER JOIN SCR_REPORTSlANG B ON B.ID = A.ID AND B.LANGUAGE=45;

CREATE VIEW SCR_REPORTS_CT (ID,REPORT,TYPE_REPORT,TYPE_ARCH,ALL_ARCH,ALL_OFICS,ALL_PERFS,DESCRIPTION,DATA)
AS SELECT A.ID,A.REPORT,A.TYPE_REPORT,A.TYPE_ARCH,A.ALL_ARCH,A.ALL_OFICS,A.ALL_PERFS,CASE WHEN B.NAME IS NULL THEN A.DESCRIPTION ELSE B.NAME END AS DESCRIPTION,A.DATA
FROM SCR_REPORTS A LEFT OUTER JOIN SCR_REPORTSlANG B ON B.ID = A.ID AND B.LANGUAGE=3;

CREATE VIEW SCR_REPORTS_GL (ID,REPORT,TYPE_REPORT,TYPE_ARCH,ALL_ARCH,ALL_OFICS,ALL_PERFS,DESCRIPTION,DATA)
AS SELECT A.ID,A.REPORT,A.TYPE_REPORT,A.TYPE_ARCH,A.ALL_ARCH,A.ALL_OFICS,A.ALL_PERFS,CASE WHEN B.NAME IS NULL THEN A.DESCRIPTION ELSE B.NAME END AS DESCRIPTION,A.DATA
FROM SCR_REPORTS A LEFT OUTER JOIN SCR_REPORTSlANG B ON B.ID = A.ID AND B.LANGUAGE=86;



/************************************************************************************************************************************************************/
/*Libros de registro */

CREATE TABLE scr_bookslang (
	id integer NOT NULL,
	language integer NOT NULL,
	name character varying(250) NOT NULL
);
CREATE INDEX scr_bookslang0 ON scr_bookslang USING btree (id);
CREATE UNIQUE INDEX scr_bookslang1 ON scr_bookslang USING btree (id,language);


CREATE VIEW IDOCARCHHDR_EU (ID,NAME,TBLPREFIX,TYPE,FLAGS,REMARKS,ACCESSTYPE,ACSID,CRTRID,CRTNDATE,UPDRID,UPDDATE)
AS SELECT A.ID,CASE WHEN B.NAME IS NULL THEN A.NAME ELSE B.NAME END AS NAME,A.TBLPREFIX,A.TYPE,A.FLAGS,A.REMARKS,A.ACCESSTYPE,A.ACSID,A.CRTRID,A.CRTNDATE,A.UPDRID,A.UPDDATE
FROM IDOCARCHHDR A LEFT OUTER JOIN SCR_BOOKSLANG B ON B.ID = A.ID AND B.LANGUAGE=45;

CREATE VIEW IDOCARCHHDR_CT (ID,NAME,TBLPREFIX,TYPE,FLAGS,REMARKS,ACCESSTYPE,ACSID,CRTRID,CRTNDATE,UPDRID,UPDDATE)
AS SELECT A.ID,CASE WHEN B.NAME IS NULL THEN A.NAME ELSE B.NAME END AS NAME,A.TBLPREFIX,A.TYPE,A.FLAGS,A.REMARKS,A.ACCESSTYPE,A.ACSID,A.CRTRID,A.CRTNDATE,A.UPDRID,A.UPDDATE
FROM IDOCARCHHDR A LEFT OUTER JOIN SCR_BOOKSLANG B ON B.ID = A.ID AND B.LANGUAGE=3;

CREATE VIEW IDOCARCHHDR_GL (ID,NAME,TBLPREFIX,TYPE,FLAGS,REMARKS,ACCESSTYPE,ACSID,CRTRID,CRTNDATE,UPDRID,UPDDATE)
AS SELECT A.ID,CASE WHEN B.NAME IS NULL THEN A.NAME ELSE B.NAME END AS NAME,A.TBLPREFIX,A.TYPE,A.FLAGS,A.REMARKS,A.ACCESSTYPE,A.ACSID,A.CRTRID,A.CRTNDATE,A.UPDRID,A.UPDDATE
FROM IDOCARCHHDR A LEFT OUTER JOIN SCR_BOOKSLANG B ON B.ID = A.ID AND B.LANGUAGE=86;

/************************************************************************************************************************************************************/

/* Eliminamos la relacion de la tabla SCR_REGINT con la tabla SCR_ADDRESS*/  
ALTER TABLE scr_regint DROP CONSTRAINT fk_scr_regint0 

