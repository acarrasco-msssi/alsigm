-----------------------------------
-- Actualizaci�n de v6.3 a v6.4
-----------------------------------


--
-- Informaci�n de versi�n
--
DECLARE @sequence_id int
UPDATE <username>.SPAC_SQ_SEQUENCES	SET @sequence_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_INFOSISTEMA';
INSERT INTO <username>.spac_infosistema (id, codigo, valor, fecha_actualizacion) VALUES (@sequence_id, 'VERSIONBD', '6.4', getdate());
UPDATE <username>.SPAC_SQ_SEQUENCES	SET @sequence_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_INFOSISTEMA';
INSERT INTO <username>.spac_infosistema (id, codigo, valor, fecha_actualizacion) VALUES (@sequence_id, 'VERSIONAPP', '6.4', getdate());

GO

--
-- Nuevas reglas
--

DECLARE @sequence_id int;
UPDATE SPAC_SQ_SEQUENCES	SET @sequence_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_CTREGLAS';
INSERT INTO SPAC_CT_REGLAS (id, nombre, descripcion, clase, tipo) VALUES (@sequence_id, 'OnlyOneTaskInstanceRule','No se permite m�s de una instancia del tr�mite','ieci.tdw.ispac.api.rule.tasks.OnlyOneInstanceInitRule',1);
UPDATE SPAC_SQ_SEQUENCES	SET @sequence_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_CTREGLAS';
INSERT INTO spac_ct_reglas (id, nombre, descripcion, clase, tipo) VALUES (@sequence_id,'PropertyRegSubstitute', 'Obtiene el valor de un campo validado para el registro actual','ieci.tdw.ispac.api.rule.docs.tags.PropertyRegSubstituteRule',1);
UPDATE SPAC_SQ_SEQUENCES	SET @sequence_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_CTREGLAS';
INSERT INTO spac_ct_reglas (id, nombre, descripcion, clase, tipo) VALUES (@sequence_id,'PropertyReg', 'Obtiene el valor de un campo no validado para el registro actual','ieci.tdw.ispac.api.rule.docs.tags.PropertyRegRule',1);

GO


---
--- Actualizacion definici�n entidades
---

update SPAC_CT_ENTIDADES SET DEFINICION ='<entity version=''1.00''><editable>S</editable><dropable>N</dropable><status>0</status><fields><field id=''1''>	<physicalName>nombre</physicalName><type>0</type><size>250</size></field><field id=''2''><physicalName>estado</physicalName><type>2</type>		<size>1</size>	</field>	<field id=''3''>		<physicalName>id_tram_pcd</physicalName>		<type>3</type>	</field><field id=''4''>		<physicalName>id_fase_pcd</physicalName>		<type>3</type>	</field>	<field id=''5''>		<physicalName>id_fase_exp</physicalName>		<type>3</type>	</field>	<field id=''6''>		<physicalName>id_tram_exp</physicalName>		<type>3</type>	</field>	<field id=''7''>		<physicalName>id_tram_ctl</physicalName><type>3</type></field>	<field id=''8''>		<physicalName>num_acto</physicalName><type>0</type>	<size>16</size>	</field><field id=''9''>		<physicalName>cod_acto</physicalName>		<type>0</type>	<size>16</size>	</field><field id=''10''>	<physicalName>estado_info</physicalName><type>0</type><size>100</size></field>
<field id=''11''>		<physicalName>fecha_inicio</physicalName>		<type>13</type>	</field>	<field id=''12''>		<physicalName>fecha_cierre</physicalName>		<type>6</type>	</field>	<field id=''13''>		<physicalName>fecha_limite</physicalName>		<type>6</type>	</field>	<field id=''14''>		<physicalName>fecha_fin</physicalName>		<type>6</type>	</field>	<field id=''15''>		<physicalName>fecha_inicio_plazo</physicalName>		<type>6</type>	</field>	<field id=''16''>		<physicalName>plazo</physicalName>		<type>3</type>	</field>	<field id=''17''>		<physicalName>uplazo</physicalName>		<type>0</type>		<size>1</size>	</field>	<field id=''18''>		<physicalName>observaciones</physicalName>		<type>0</type>		<size>254</size>	</field>	<field id=''19''>		<physicalName>descripcion</physicalName>		<type>0</type>		<size>100</size>	</field>	<field id=''20''>		<physicalName>und_resp</physicalName>		<type>0</type>		<size>250</size></field>
<field id=''21''>	<physicalName>fase_pcd</physicalName><type>0</type>		<size>250</size>	</field>	<field id=''22''>		<physicalName>id_subproceso</physicalName>		<type>3</type>	</field>	<field id=''23''>		<physicalName>id</physicalName>		<type>3</type>	</field>	<field id=''24''>		<physicalName>numexp</physicalName>		<type>0</type>		<size>30</size>	</field></fields><validations>	<validation id=''1''>		<fieldId>17</fieldId>		<table>SPAC_TBL_001</table>		<tableType>3</tableType>		<class/>		<mandatory>N</mandatory>	</validation></validations></entity>' WHERE ID=7;

GO

--
-- Nuevas tablas
--

CREATE TABLE <username>.SPAC_PERMISOS
(
   TP_OBJ int NOT NULL,
   ID_OBJ int NOT NULL,
   ID_RESP varchar(250) NOT NULL,
   RESP_NAME varchar(250) NOT NULL,
   PERMISO int NOT NULL
)

GO

ALTER TABLE <username>.SPAC_PERMISOS ADD CONSTRAINT PK_SPAC_PERMISOS PRIMARY KEY (TP_OBJ, ID_OBJ, ID_RESP , PERMISO)

GO

CREATE INDEX SPAC_PERMISOS_IX_TP_ID_OBJ ON SPAC_PERMISOS (TP_OBJ, ID_OBJ);
GO
CREATE INDEX SPAC_PERMISOS_IX_PERMISO ON SPAC_PERMISOS (PERMISO);


GO
---
---  Para la lista de Tr�mites abiertos en sus expedientes
---- se ha tenido que modificar la vista de SPAC_WL_TASK
-----para incluir el campo TRAM.ID_FASE_EXP.
DROP VIEW SPAC_WL_TASK ;
GO
CREATE  VIEW SPAC_WL_TASK  AS
	SELECT TRAM.ID, TRAM.NOMBRE AS NAME, TRAM.ID_TRAMITE AS ID_TASK, TRAM.ID_CTTRAMITE AS ID_CTTASK, TRAM.ID_RESP AS RESP, TRAM.ID_PCD AS ID_PROC, PCD.NOMBRE AS NAME_PROC, TRAM.ID_FASE_PCD AS ID_STAGE, P_FASES.NOMBRE AS NAME_STAGE, TRAM.ID_EXP, TRAM.ID_FASE_EXP, TRAM.NUMEXP, TRAM.FECHA_INICIO AS INITDATE, TRAM.FECHA_LIMITE AS LIMITDATE, TRAM.ESTADO AS STATUS, TRAM.TIPO, PRO.ID AS ID_SUBPROCESO, PRO.ID_PCD AS ID_SUBPCD FROM SPAC_TRAMITES TRAM LEFT JOIN SPAC_PROCESOS PRO ON TRAM.ID_SUBPROCESO = PRO.ID, SPAC_P_FASES P_FASES, SPAC_P_PROCEDIMIENTOS PCD WHERE TRAM.ESTADO = 1 AND TRAM.ID_PCD = PCD.ID AND TRAM.ID_FASE_PCD = P_FASES.ID
	UNION
	SELECT TRAM.ID, TRAM.NOMBRE AS NAME, TRAM.ID_TRAMITE AS ID_TASK, TRAM.ID_CTTRAMITE AS ID_CTTASK, FASES.ID_RESP AS RESP,TRAM.ID_PCD AS ID_PROC, PCD.NOMBRE AS NAME_PROC, TRAM.ID_FASE_PCD AS ID_STAGE, P_FASES.NOMBRE AS NAME_STAGE, TRAM.ID_EXP, TRAM.ID_FASE_EXP, TRAM.NUMEXP, TRAM.FECHA_INICIO AS INITDATE, TRAM.FECHA_LIMITE AS LIMITDATE, TRAM.ESTADO AS STATUS, TRAM.TIPO, PRO.ID AS ID_SUBPROCESO, PRO.ID_PCD AS ID_SUBPCD FROM SPAC_TRAMITES TRAM, SPAC_PROCESOS PRO, SPAC_FASES FASES, SPAC_P_FASES P_FASES, SPAC_P_PROCEDIMIENTOS PCD WHERE TRAM.ESTADO = 1 AND TRAM.TIPO = 2 AND TRAM.ID_SUBPROCESO = PRO.ID AND FASES.ID_EXP = PRO.ID AND TRAM.ID_SUBPROCESO = PRO.ID AND TRAM.ID_PCD = PCD.ID AND TRAM.ID_FASE_PCD = P_FASES.ID;
GO
--
-- Modificacion de la vista de SPAC_WL_PCD para incluir la consulta sobre los permisos
--
DROP VIEW SPAC_WL_PCD;
GO
CREATE VIEW  SPAC_WL_PCD AS
SELECT
 PCD.ID, PCD.NOMBRE AS NAME, PCD.NVERSION AS NVERSION, FASES.ID_RESP AS RESP, FASES.TIPO
FROM
 SPAC_FASES FASES, SPAC_P_PROCEDIMIENTOS PCD
WHERE
 FASES.ESTADO = 1 AND PCD.ID = FASES.ID_PCD
GROUP BY
 PCD.ID, PCD.NOMBRE, PCD.NVERSION, FASES.ID_RESP, FASES.TIPO
UNION
SELECT
 PCD.ID, PCD.NOMBRE AS NAME, PCD.NVERSION AS NVERSION, SPC_PERMS.ID_RESP AS RESP, FASES.TIPO
FROM
 SPAC_FASES FASES, SPAC_P_PROCEDIMIENTOS PCD, SPAC_PERMISOS SPC_PERMS
WHERE
 FASES.ESTADO = 1 AND PCD.ID = FASES.ID_PCD
 AND
 SPC_PERMS.TP_OBJ = 1 AND SPC_PERMS.ID_OBJ = FASES.ID_PCD
GROUP BY
 PCD.ID, PCD.NOMBRE, PCD.NVERSION, SPC_PERMS.ID_RESP, FASES.TIPO;
GO

CREATE VIEW SPAC_WL_ACTIVITY AS
  SELECT SPAC_FASES.ID, SPAC_P_FASES.NOMBRE, SPAC_FASES.ID_FASE_BPM, SPAC_FASES.ID_EXP, SPAC_FASES.ID_PCD, SPAC_FASES.ID_FASE, SPAC_FASES.NUMEXP, SPAC_FASES.FECHA_INICIO, SPAC_FASES.FECHA_LIMITE, SPAC_FASES.ESTADO, SPAC_FASES.OBSERVACIONES, SPAC_FASES.ID_RESP, SPAC_FASES.RESP, SPAC_FASES.ID_RESP_SEC, SPAC_FASES.RESP_SEC, SPAC_FASES.ESTADO_PLAZO, SPAC_FASES.NUM_DIAS_PLAZO, SPAC_FASES.ID_CALENDARIO, SPAC_FASES.FECHA_INICIO_PLAZO, SPAC_FASES.ESTADO_ANTERIOR, SPAC_TRAMITES.ID AS ID_TRAMITE, SPAC_TRAMITES.ID_EXP AS ID_EXP_TRAMITE, SPAC_TRAMITES.ID_PCD AS ID_PCD_TRAMITE, SPAC_TRAMITES.ID_FASE_EXP AS ID_FASE_TRAMITE, SPAC_TRAMITES.ID_FASE_PCD AS ID_FASE_PCD_TRAMITE, SPAC_TRAMITES.ID_TRAMITE AS ID_TRAMITE_PCD_TRAMITE, SPAC_TRAMITES.ID_CTTRAMITE AS ID_CTTRAMITE_TRAMITE
  FROM SPAC_FASES, SPAC_TRAMITES, SPAC_P_FASES
  WHERE SPAC_FASES.ESTADO = 1 AND SPAC_FASES.TIPO = 2 AND SPAC_FASES.ID_FASE = SPAC_P_FASES.ID AND SPAC_FASES.ID_EXP = SPAC_TRAMITES.ID_SUBPROCESO;
GO

CREATE VIEW spac_pcd_permisos AS

select  id_pcd , uid_usr, permiso
from spac_ss_permisos

union

select id_obj, id_resp, permiso
from spac_permisos where tp_obj=1;

GO

--
-- Nueva columna para asignar el formulario a partir de la ejecucion de una regla
-- a nivel de procedimiento, fase y tramite
--
ALTER TABLE <username>.SPAC_P_ENTIDADES ADD ID_RULE_FRM int;
GO
ALTER TABLE <username>.SPAC_P_FRMFASES ADD ID_RULE_FRM int;
GO
ALTER TABLE <username>.SPAC_P_FRMTRAMITES ADD ID_RULE_FRM int;
GO


--
-- Nueva columna para asignar la visibilidad de la entidad a partir de la ejecucion de una regla
-- a nivel de procedimiento, fase y tramite
--
ALTER TABLE <username>.SPAC_P_ENTIDADES ADD ID_RULE_VISIBLE int;
GO
ALTER TABLE <username>.SPAC_P_FRMFASES ADD ID_RULE_VISIBLE int;
GO
ALTER TABLE <username>.SPAC_P_FRMTRAMITES ADD ID_RULE_VISIBLE int;
GO


--
-- Actualizaci�n de los componentes de la bandeja de entrada
--
DECLARE @sequence_id int
UPDATE <username>.SPAC_SQ_SEQUENCES SET @sequence_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_VARS';
INSERT INTO <username>.spac_vars (id, nombre, valor, descripcion) VALUES (@sequence_id, 'INBOX_WEB_COMPONENTS', '<?xml version="1.0" encoding="UTF-8"?><components><component id="sucesos" class="ieci.tdw.ispac.ispacmgr.components.worklist.NoticesComponent"/><!--<component id="fases" class="ieci.tdw.ispac.ispacmgr.components.worklist.StagesComponent"/>--><component id="fasesTree" class="ieci.tdw.ispac.ispacmgr.components.worklist.TreeStagesComponent"/><!--<component id="tramites" class="ieci.tdw.ispac.ispacmgr.components.worklist.TasksComponent"/>--><component id="tramitesTree" class="ieci.tdw.ispac.ispacmgr.components.worklist.TreeTasksComponent"/><!--<component id="tramitesCerrados" class="ieci.tdw.ispac.ispacmgr.components.worklist.ClosedTasksComponent"/>--><component id="tramitesCerradosTree" class="ieci.tdw.ispac.ispacmgr.components.worklist.TreeClosedTasksComponent"/></components>','Componentes de la bandeja de entrada');
UPDATE <username>.SPAC_SQ_SEQUENCES SET @sequence_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_VARS';
INSERT INTO <username>.spac_vars (id, nombre, valor, descripcion) VALUES (@sequence_id, 'INTRAY_AUTO_ARCHIVING', 'false','Autoarchivado de los registros distribuidos');
GO


--
-- Tabla para las dependencias entre tr�mites
--
CREATE TABLE <username>.SPAC_P_DEP_TRAMITES (
    ID int NOT NULL,
    ID_TRAMITE_PADRE int NOT NULL,
    ID_TRAMITE_HIJO int NOT NULL
);

ALTER TABLE <username>.SPAC_P_DEP_TRAMITES ADD CONSTRAINT PK_P_DEP_TRAMITES PRIMARY KEY (ID);

INSERT INTO <username>.SPAC_SQ_SEQUENCES (SEQUENCE_NAME) VALUES('SPAC_SQ_ID_PDEPTRAMITES');
GO

--
-- Actualizaci�n del formulario de b�squeda sencillo
--
update <username>.spac_ct_frmbusqueda set frm_bsq='<?xml version=''1.0'' encoding=''ISO-8859-1''?><?xml-stylesheet type=''text/xsl'' href=''SearchForm.xsl''?><queryform displaywidth=''95%'' defaultSort=''2''><!--INICIO ENTIDAD PRINCIPAL DE BUSQUEDA--><entity type=''main'' identifier=''1''><!--INICIO CUERPO BUSQUEDA-->	<tablename>spac_expedientes</tablename>	<description>DATOS DEL EXPEDIENTE</description>	<field type=''query'' order=''01''>		<columnname>ID_PCD</columnname>		<description>search.form.procedimiento</description>		<datatype>integer</datatype>		<controltype size=''30''  maxlength=''30'' tipo=''validate'' table=''SPAC_P_PROCEDIMIENTOS'' field=''spac_expedientes:ID_PCD'' label=''NOMBRE''  value=''ID'' clause=''WHERE ESTADO IN (2,3) AND TIPO = 1'' orderBy=''NOMBRE''>text</controltype>	</field>	<field type=''query'' order=''04''>		<columnname>NUMEXP</columnname>		<description>search.form.numExpediente</description>		<datatype>string</datatype>		<operators>		 	<operator><name>&gt;</name></operator>			<operator><name>&lt;</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''30'' maxlength=''30''>text</controltype>	</field>	<field type=''query'' order=''05''>		<columnname>ASUNTO</columnname>		<description>search.form.asunto</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''30'' maxlength=''30''>text</controltype>	</field>	<field type=''query'' order=''06''>		<columnname>NREG</columnname>		<description>search.form.numRegistro</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''16'' maxlength=''16''>text</controltype>	</field>	<field type=''query'' order=''07''>		<columnname>IDENTIDADTITULAR</columnname>		<description>search.form.interesadoPrincipal</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''50'' maxlength=''50''>text</controltype> 	</field>	<field type=''query'' order=''08''>		<columnname>NIFCIFTITULAR</columnname>		<description>search.form.ifInteresadoPrincipal</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''16'' maxlength=''16''>text</controltype>	</field>
<field type=''query'' order=''09''>	<columnname>FAPERTURA</columnname><description>search.form.fechaApertura</description><datatype>date</datatype> 		<controltype size=''22'' maxlength=''22''>text</controltype>	</field>	<field type=''query'' order=''10''>		<columnname>ESTADOADM</columnname>		<description>search.form.estadoAdm</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''20'' maxlength=''20'' tipo=''validate'' table=''SPAC_TBL_004'' field=''spac_expedientes:ESTADOADM'' label=''SUSTITUTO'' value=''VALOR'' orderBy=''VALOR''>text</controltype>	</field>	<field type=''query'' order=''11''>     		<columnname>HAYRECURSO</columnname>		<description>search.form.recurso</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''2'' maxlength=''2''>text</controltype>	</field>	<field type=''query'' order=''12''>		<columnname>CIUDAD</columnname>		<description>search.form.ciudad</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''50'' maxlength=''50''>text</controltype>	</field>		<field type=''query'' order=''13''>		<columnname>DOMICILIO</columnname>		<description>search.form.domicilio</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype cols=''100'' rows=''5''>textarea</controltype>	</field><!--FIN CUERPO BUSQUEDA--></entity><!--FIN ENTIDAD PRINCIPAL DE BUSQUEDA--><!--INICIO SEGUNDA ENTIDAD DE BUSQUEDA--><entity type=''secondary'' identifier=''52''>	<tablename>spac_fases</tablename>	<bindfield>NUMEXP</bindfield>	<field type=''query'' order=''02''>		<columnname>ID_FASE</columnname>		<description>search.form.fases</description>		<datatype>stringList</datatype>        <binding>in (select ID FROM SPAC_P_FASES WHERE ID_CTFASE IN(@VALUES))</binding>		<controltype height=''75px'' tipo=''list'' table=''SPAC_CT_FASES'' field=''spac_fases:ID_FASE'' label=''NOMBRE''  value=''id'' orderBy=''NOMBRE''>text</controltype>		</field></entity><entity type=''secondary'' identifier=''51''>		<tablename>spac_tramites</tablename>		<field type=''query'' order=''03''>			<columnname>ID_TRAMITE</columnname>	<description>search.form.tramites</description><datatype>stringList</datatype><binding>in (select ID FROM SPAC_P_TRAMITES WHERE ID_CTTRAMITE IN(@VALUES))</binding>			<controltype height=''75px'' tipo=''list'' table=''SPAC_CT_TRAMITES'' field=''spac_tramites:ID_TRAMITE'' label=''NOMBRE''  value=''id'' orderBy=''NOMBRE''>text</controltype>		</field>
<bindfield>NUMEXP</bindfield></entity><!--FIN SEGUNDA ENTIDAD DE BUSQUEDA--><!--INICIO CUERPO RESULTADO--><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_FASES.ID'' readOnly=''false'' dataType=''string'' fieldType=''CHECKBOX'' fieldLink=''SPAC_FASES.ID'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.NUMEXP'' readOnly=''false'' dataType=''string'' titleKey=''search.numExp'' fieldType=''LINK'' fieldLink=''SPAC_EXPEDIENTES.NUMEXP'' comparator=''ieci.tdw.ispac.ispacweb.comparators.NumexpComparator'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.NREG'' readOnly=''false'' dataType=''string'' titleKey=''search.numRegistro'' fieldType=''LIST'' fieldLink=''SPAC_EXPEDIENTES.NREG'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.IDENTIDADTITULAR'' readOnly=''false'' dataType=''string'' titleKey=''search.interesado'' fieldType=''LIST'' fieldLink=''SPAC_EXPEDIENTES.IDENTIDADTITULAR'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.NIFCIFTITULAR'' readOnly=''false'' dataType=''string'' titleKey=''search.nifInteresado'' fieldType=''LIST'' fieldLink=''SPAC_EXPEDIENTES.NIFCIFTITULAR'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.FAPERTURA'' readOnly=''false'' dataType=''date'' titleKey=''search.fechaApertura'' fieldType=''DATE'' fieldLink=''SPAC_EXPEDIENTES.FAPERTURA'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.ESTADOADM'' readOnly=''false'' dataType=''string'' titleKey=''search.estadoAdministrativo'' fieldType=''LIST'' fieldLink=''SPAC_EXPEDIENTES.ESTADOADM'' validatetable=''SPAC_TBL_004'' substitute=''SUSTITUTO'' showproperty=''SPAC_TBL_004.SUSTITUTO''  value=''VALOR''/><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.HAYRECURSO'' readOnly=''false'' dataType=''string'' titleKey=''search.recurrido'' fieldType=''LIST'' fieldLink=''SPAC_EXPEDIENTES.HAYRECURSO'' /><!--FIN CUERPO RESULTADO--><!--INICIO ACCIONES--><action title=''Cerrar expedientes'' path=''/closeProcess.do'' titleKey=''ispac.action.expedients.close'' /><action title=''Avanzar fases'' path=''/closeStage.do'' titleKey=''ispac.action.stages.next'' /><action title=''Retroceder fases'' path=''/redeployPreviousStage.do'' titleKey=''ispac.action.stages.return'' /><!--FIN ACCIONES--></queryform>'  where descripcion='B�SQUEDA';

--
-- Formularios de busqueda de ejemplo para busqueda de tramites
--
DECLARE @sequence_id int;
UPDATE SPAC_SQ_SEQUENCES SET @sequence_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_CTFRMBUSQUEDA';
INSERT INTO <username>.SPAC_CT_FRMBUSQUEDA (id, descripcion, autor, fecha, tipo)
	VALUES (@sequence_id, 'B�SQUEDA TR�MITES ABIERTOS', 'IECISA', getdate(), 1);
update spac_ct_frmbusqueda set frm_bsq='<?xml version=''1.0'' encoding=''ISO-8859-1''?><?xml-stylesheet type=''text/xsl'' href=''SearchForm.xsl''?><queryform displaywidth=''95%'' defaultSort=''2'' responsability=''task''><!--INICIO ENTIDAD PRINCIPAL DE BUSQUEDA--><entity type=''main'' identifier=''1''><!--INICIO CUERPO BUSQUEDA-->	<tablename>spac_expedientes</tablename>	<description>DATOS DEL EXPEDIENTE</description>	<field type=''query'' order=''01''>		<columnname>ID_PCD</columnname>		<description>search.form.procedimiento</description>		<datatype>integer</datatype>		<controltype size=''30''  maxlength=''30'' tipo=''validate'' table=''SPAC_P_PROCEDIMIENTOS'' field=''spac_expedientes:ID_PCD'' label=''NOMBRE''  value=''ID'' clause=''WHERE ESTADO IN (2,3) AND TIPO = 1'' orderBy=''NOMBRE''>text</controltype>	</field>	<field type=''query'' order=''04''>		<columnname>NUMEXP</columnname>		<description>search.form.numExpediente</description>		<datatype>string</datatype>		<operators>		 	<operator><name>&gt;</name></operator>			<operator><name>&lt;</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''30'' maxlength=''30''>text</controltype>	</field>	<field type=''query'' order=''05''>		<columnname>ASUNTO</columnname>		<description>search.form.asunto</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			
<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''30'' maxlength=''30''>text</controltype>	</field>	<field type=''query'' order=''06''>		<columnname>NREG</columnname>		<description>search.form.numRegistro</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''16'' maxlength=''16''>text</controltype>	</field>	<field type=''query'' order=''07''>		<columnname>IDENTIDADTITULAR</columnname>		<description>search.form.interesadoPrincipal</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''50'' maxlength=''50''>text</controltype> 	</field>	<field type=''query'' order=''08''>		<columnname>NIFCIFTITULAR</columnname>		<description>search.form.ifInteresadoPrincipal</description>		<datatype>string</datatype>		<operators>			
<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''16'' maxlength=''16''>text</controltype>	</field>	<field type=''query'' order=''09''>		<columnname>FAPERTURA</columnname>		<description>search.form.fechaApertura</description>		<datatype>date</datatype> 		<controltype size=''22'' maxlength=''22''>text</controltype>	</field>	<field type=''query'' order=''10''>		<columnname>ESTADOADM</columnname>		<description>search.form.estadoAdm</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''20'' maxlength=''20'' tipo=''validate'' table=''SPAC_TBL_004'' field=''spac_expedientes:ESTADOADM'' label=''SUSTITUTO'' value=''VALOR'' orderBy=''VALOR''>text</controltype>	</field>	<field type=''query'' order=''11''>     		<columnname>HAYRECURSO</columnname>		<description>search.form.recurso</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			
<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''2'' maxlength=''2''>text</controltype>	</field>	<field type=''query'' order=''12''>		<columnname>CIUDAD</columnname>		<description>search.form.ciudad</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''50'' maxlength=''50''>text</controltype>	</field>		<field type=''query'' order=''13''>		<columnname>DOMICILIO</columnname>		<description>search.form.domicilio</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>      <operator><name>Contiene(Index)</name></operator>		</operators>		<controltype cols=''100'' rows=''5''>textarea</controltype>	</field><!--FIN CUERPO BUSQUEDA-->
</entity><!--FIN ENTIDAD PRINCIPAL DE BUSQUEDA--><!--INICIO SEGUNDA ENTIDAD DE BUSQUEDA	obligatoria en la busqueda para que se relacione con un JOIN --><entity type=''required'' identifier=''51''>	<tablename>spac_tramites</tablename>	<bindfield>NUMEXP</bindfield>	<field type=''query'' order=''03''>		<columnname>ID_TRAMITE</columnname>		<description>search.form.tramites</description>		<datatype>stringList</datatype>		<binding>in (select ID FROM SPAC_P_TRAMITES WHERE ID_CTTRAMITE IN(@VALUES))</binding>		<controltype height=''75px'' tipo=''list'' table=''SPAC_CT_TRAMITES'' field=''spac_tramites:ID_TRAMITE'' label=''NOMBRE''  value=''id'' orderBy=''NOMBRE''>text</controltype>	</field></entity><!--FIN SEGUNDA ENTIDAD DE BUSQUEDA--><!--INICIO CUERPO RESULTADO--><!--propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_TRAMITES.ID'' readOnly=''false'' dataType=''string'' fieldType=''CHECKBOX'' fieldLink=''SPAC_TRAMITES.ID'' /--><!-- Necesario para obtener en la consulta la propiedad de SPAC_TRAMITES.ID que se necesita para generar el enlace del LINKPARAM --><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_TRAMITES.ID'' readOnly=''false'' dataType=''string'' fieldType=''NONE'' fieldLink=''SPAC_DT_TRAMITES.ID'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_TRAMITES.NOMBRE'' readOnly=''false'' dataType=''string'' titleKey=''search.task'' fieldType=''LINKPARAM'' fieldLink=''SPAC_TRAMITES.NOMBRE'' styleClass="tdlink" url=''showTask.do'' >	<linkParam paramId="taskId" property="SPAC_TRAMITES.ID"/> </propertyfmt>
<propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.NUMEXP'' readOnly=''false'' dataType=''string'' titleKey=''search.numExp'' fieldType=''LIST'' fieldLink=''SPAC_EXPEDIENTES.NUMEXP'' comparator=''ieci.tdw.ispac.ispacweb.comparators.NumexpComparator'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.NREG'' readOnly=''false'' dataType=''string'' titleKey=''search.numRegistro'' fieldType=''LIST'' fieldLink=''SPAC_EXPEDIENTES.NREG'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.IDENTIDADTITULAR'' readOnly=''false'' dataType=''string'' titleKey=''search.interesado'' fieldType=''LIST'' fieldLink=''SPAC_EXPEDIENTES.IDENTIDADTITULAR'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.NIFCIFTITULAR'' readOnly=''false'' dataType=''string'' titleKey=''search.nifInteresado'' fieldType=''LIST'' fieldLink=''SPAC_EXPEDIENTES.NIFCIFTITULAR'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.FAPERTURA'' readOnly=''false'' dataType=''date'' titleKey=''search.fechaApertura'' fieldType=''DATE'' fieldLink=''SPAC_EXPEDIENTES.FAPERTURA'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.ESTADOADM'' readOnly=''false'' dataType=''string'' titleKey=''search.estadoAdministrativo'' fieldType=''LIST'' fieldLink=''SPAC_EXPEDIENTES.ESTADOADM'' validatetable=''SPAC_TBL_004'' substitute=''SUSTITUTO'' showproperty=''SPAC_TBL_004.SUSTITUTO''  value=''VALOR''/><!--propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.HAYRECURSO'' 
readOnly=''false'' dataType=''string'' titleKey=''search.recurrido'' fieldType=''LIST'' fieldLink=''SPAC_EXPEDIENTES.HAYRECURSO'' /--><!--FIN CUERPO RESULTADO--><!--INICIO ACCIONES--><!--FIN ACCIONES--></queryform>' where descripcion='B�SQUEDA TR�MITES ABIERTOS' and autor='IECISA';
GO

DECLARE @sequence_id int;
UPDATE SPAC_SQ_SEQUENCES SET @sequence_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_CTFRMBUSQUEDA';
INSERT INTO <username>.SPAC_CT_FRMBUSQUEDA (id, descripcion, autor, fecha, tipo)
	VALUES (@sequence_id, 'B�SQUEDA TR�MITES', 'IECISA', getdate(), 1);
update spac_ct_frmbusqueda set frm_bsq='<?xml version=''1.0'' encoding=''ISO-8859-1''?><?xml-stylesheet type=''text/xsl'' href=''SearchForm.xsl''?><queryform displaywidth=''95%'' defaultSort=''2''><!--INICIO ENTIDAD PRINCIPAL DE BUSQUEDA--><entity type=''main'' identifier=''1''><!--INICIO CUERPO BUSQUEDA-->	<tablename>spac_expedientes</tablename>	<description>DATOS DEL EXPEDIENTE</description>	<field type=''query'' order=''01''>		<columnname>ID_PCD</columnname>		<description>search.form.procedimiento</description>		<datatype>integer</datatype>		<controltype size=''30''  maxlength=''30'' tipo=''validate'' table=''SPAC_P_PROCEDIMIENTOS'' field=''spac_expedientes:ID_PCD'' label=''NOMBRE''  value=''ID'' clause=''WHERE ESTADO IN (2,3) AND TIPO = 1'' orderBy=''NOMBRE''>text</controltype>	</field>	<field type=''query'' order=''04''>		<columnname>NUMEXP</columnname>		<description>search.form.numExpediente</description>		<datatype>string</datatype>		<operators>		 	<operator><name>&gt;</name></operator>			<operator><name>&lt;</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''30'' maxlength=''30''>text</controltype>	</field>	<field type=''query'' order=''05''>		<columnname>ASUNTO</columnname>		<description>search.form.asunto</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			
<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''30'' maxlength=''30''>text</controltype>	</field>	<field type=''query'' order=''06''>		<columnname>NREG</columnname>		<description>search.form.numRegistro</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''16'' maxlength=''16''>text</controltype>	</field>	<field type=''query'' order=''07''>		<columnname>IDENTIDADTITULAR</columnname>		<description>search.form.interesadoPrincipal</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''50'' maxlength=''50''>text</controltype> 	</field>	<field type=''query'' order=''08''>		<columnname>NIFCIFTITULAR</columnname>		
<description>search.form.ifInteresadoPrincipal</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''16'' maxlength=''16''>text</controltype>	</field>	<field type=''query'' order=''09''>		<columnname>FAPERTURA</columnname>		<description>search.form.fechaApertura</description>		<datatype>date</datatype> 		<controltype size=''22'' maxlength=''22''>text</controltype>	</field>	<field type=''query'' order=''10''>		<columnname>ESTADOADM</columnname>		<description>search.form.estadoAdm</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''20'' maxlength=''20'' tipo=''validate'' table=''SPAC_TBL_004'' field=''spac_expedientes:ESTADOADM'' label=''SUSTITUTO'' value=''VALOR''  orderBy=''VALOR''>text</controltype>	</field>	<field type=''query'' order=''11''>     		
<columnname>HAYRECURSO</columnname>		<description>search.form.recurso</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''2'' maxlength=''2''>text</controltype>	</field>	<field type=''query'' order=''12''>		<columnname>CIUDAD</columnname>		<description>search.form.ciudad</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator><name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>		</operators>		<controltype size=''50'' maxlength=''50''>text</controltype>	</field>		<field type=''query'' order=''13''>		<columnname>DOMICILIO</columnname>		<description>search.form.domicilio</description>		<datatype>string</datatype>		<operators>			<operator><name>=</name></operator>			<operator><name>&gt;</name></operator>			<operator><name>&gt;=</name></operator>			<operator><name>&lt;</name></operator>			<operator>
<name>&lt;=</name></operator> 			<operator><name>Contiene(Like)</name></operator>      <operator><name>Contiene(Index)</name></operator>		</operators>		<controltype cols=''100'' rows=''5''>textarea</controltype>	</field><!--FIN CUERPO BUSQUEDA--></entity><!--FIN ENTIDAD PRINCIPAL DE BUSQUEDA--><!--INICIO SEGUNDA ENTIDAD DE BUSQUEDA	obligatoria en la busqueda para que se relacione con un JOIN --><entity type=''required'' identifier=''51''>	<tablename>spac_dt_tramites</tablename>	<bindfield>NUMEXP</bindfield>	<field type=''query'' order=''03''>		<columnname>ID_TRAM_PCD</columnname>		<description>search.form.tramites</description>		<datatype>stringList</datatype>		<binding>in (select ID FROM SPAC_P_TRAMITES WHERE ID_CTTRAMITE IN(@VALUES))</binding>		<controltype height=''75px'' tipo=''list'' table=''SPAC_CT_TRAMITES'' field=''spac_dt_tramites:ID_TRAM_PCD'' label=''NOMBRE''  value=''id'' orderBy=''NOMBRE''>text</controltype>	</field></entity><!--FIN SEGUNDA ENTIDAD DE BUSQUEDA--><!--INICIO CUERPO RESULTADO--><!--propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_DT_TRAMITES.ID_TRAM_EXP'' readOnly=''false'' dataType=''string'' fieldType=''CHECKBOX'' fieldLink=''SPAC_DT_TRAMITES.ID_TRAM_EXP'' /--><!-- Necesario para obtener en la consulta la propiedad de SPAC_DT_TRAMITES.ID_TRAM_EXP que se necesita para generar el enlace del LINKPARAM --><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_DT_TRAMITES.ID_TRAM_EXP'' readOnly=''false'' 
dataType=''string'' fieldType=''NONE'' fieldLink=''SPAC_DT_TRAMITES.ID_TRAM_EXP'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_DT_TRAMITES.NOMBRE'' readOnly=''false'' dataType=''string'' titleKey=''search.task'' fieldType=''LINKPARAM'' fieldLink=''SPAC_DT_TRAMITES.NOMBRE'' styleClass="tdlink" url=''showTask.do'' >	<linkParam paramId="taskId" property="SPAC_DT_TRAMITES.ID_TRAM_EXP"/> </propertyfmt><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_DT_TRAMITES.ESTADO'' readOnly=''false'' dataType=''string'' titleKey=''search.state'' fieldType=''TASK_STATE'' fieldLink=''SPAC_DT_TRAMITES.ESTADO'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.NUMEXP'' readOnly=''false'' dataType=''string'' titleKey=''search.numExp'' fieldType=''LIST'' fieldLink=''SPAC_EXPEDIENTES.NUMEXP'' comparator=''ieci.tdw.ispac.ispacweb.comparators.NumexpComparator'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.NREG'' readOnly=''false'' dataType=''string'' titleKey=''search.numRegistro'' fieldType=''LIST'' fieldLink=''SPAC_EXPEDIENTES.NREG'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.IDENTIDADTITULAR'' readOnly=''false'' dataType=''string'' titleKey=''search.interesado'' fieldType=''LIST'' fieldLink=''SPAC_EXPEDIENTES.IDENTIDADTITULAR'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.NIFCIFTITULAR'' readOnly=''false'' dataType=''string'' titleKey=''search.nifInteresado'' 
fieldType=''LIST'' fieldLink=''SPAC_EXPEDIENTES.NIFCIFTITULAR'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.FAPERTURA'' readOnly=''false'' dataType=''date'' titleKey=''search.fechaApertura'' fieldType=''DATE'' fieldLink=''SPAC_EXPEDIENTES.FAPERTURA'' /><propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.ESTADOADM'' readOnly=''false'' dataType=''string'' titleKey=''search.estadoAdministrativo'' fieldType=''LIST'' fieldLink=''SPAC_EXPEDIENTES.ESTADOADM'' validatetable=''SPAC_TBL_004'' substitute=''SUSTITUTO'' showproperty=''SPAC_TBL_004.SUSTITUTO''  value=''VALOR''/><!--propertyfmt type=''BeanPropertySimpleFmt'' property=''SPAC_EXPEDIENTES.HAYRECURSO'' readOnly=''false'' dataType=''string'' titleKey=''search.recurrido'' fieldType=''LIST'' fieldLink=''SPAC_EXPEDIENTES.HAYRECURSO'' /--><!--FIN CUERPO RESULTADO--><!--INICIO ACCIONES--><!--FIN ACCIONES--></queryform>' where descripcion='B�SQUEDA TR�MITES' and autor='IECISA';
GO



--
-- Cambios sobre tabla de avisos electronicos para soportar informacion de delegacion de tramites y fases
--

-- Se a�aden las columnas ID_FASE e ID_TRAMITE a SPAC_AVISOS_ELECTRONICOS
ALTER TABLE <username>.SPAC_AVISOS_ELECTRONICOS ADD ID_FASE decimal(10,0) NULL;
GO
ALTER TABLE <username>.SPAC_AVISOS_ELECTRONICOS ADD ID_TRAMITE decimal(10,0) NULL;
GO
-- Nuevos campos en avisos electronicos	para incorpora informaci�n de tramites y fases a nivel de procedimiento
ALTER TABLE <username>.SPAC_AVISOS_ELECTRONICOS ADD ID_FASE_PCD decimal(10,0) NULL;
GO
ALTER TABLE <username>.SPAC_AVISOS_ELECTRONICOS ADD ID_TRAMITE_PCD decimal(10,0) NULL;
GO


-- Vista para avisos electronicos en la que se combina la informacion de fase y tramite si existe
CREATE VIEW <username>.SPAC_V_AVISOS_ELECTRONICOS AS
	SELECT A.*, F.NOMBRE AS NOMBRE_FASE, T.NOMBRE AS NOMBRE_TRAMITE
	FROM SPAC_AVISOS_ELECTRONICOS A LEFT OUTER JOIN SPAC_P_FASES F ON A.ID_FASE_PCD = F.ID LEFT OUTER JOIN SPAC_P_TRAMITES T ON A.ID_TRAMITE_PCD = T.ID;
GO
-- Se da de alta como entidad la vista creada
INSERT INTO <username>.SPAC_CT_ENTIDADES (id, tipo, nombre, campo_pk, campo_numexp, schema_expr, frm_edit, descripcion, sec_pk) VALUES (161, 0, 'SPAC_V_AVISOS_ELECTRONICOS','ID_AVISO','ID_EXPEDIENTE','ID_EXPEDIENTE',NULL,'Datos de Avisos Electr�nicos','<SIN_SENCUENCIA>');
GO


-- Actualizaci�n de informe
UPDATE spac_ct_informes SET xml = '<?xml version="1.0" encoding="UTF-8"  ?><!-- Created with iReport - A designer
	for JasperReports --><!DOCTYPE jasperReport PUBLIC "//JasperReports//DTD Report Design//EN" "http://jasperreports.sourceforge.net/dtds/jasperreport.dtd">
<jasperReport name="avgDocsPcd" columnCount="1" printOrder="Vertical"
	orientation="Portrait" pageWidth="595" pageHeight="842" columnWidth="535"
	columnSpacing="0" leftMargin="30" rightMargin="30" topMargin="20"
	bottomMargin="20" whenNoDataType="AllSectionsNoDetail" isTitleNewPage="false"
	isSummaryNewPage="false">
	<property name="ireport.scriptlethandling" value="0" />
	<property name="ireport.encoding" value="UTF-8" />
	<import value="java.util.*" />
	<import value="net.sf.jasperreports.engine.*" />
	<import value="net.sf.jasperreports.engine.data.*" />
	<queryString><![CDATA[SELECT NOMBRE, AVG(CONTADOR) AS AVG FROM (	SELECT P.NOMBRE, E.NUMEXP, COUNT(D.ID) AS CONTADOR FROM SPAC_EXPEDIENTES E LEFT OUTER JOIN SPAC_DT_DOCUMENTOS D 		ON E.NUMEXP = D.NUMEXP,		SPAC_P_PROCEDIMIENTOS P	WHERE  E.ID_PCD = P.ID	GROUP BY P.NOMBRE, E.NUMEXP) TEMPORAL GROUP BY NOMBRE ORDER BY NOMBRE]]></queryString>
	<field name="nombre" class="java.lang.String" />
	<field name="avg" class="java.math.BigDecimal" />
	<variable name="es.title" class="java.lang.String" resetType="Report"
		calculation="Nothing">
		<initialValueExpression><![CDATA["Media de documentos por expediente y procedimiento"]]></initialValueExpression>
	</variable>
	<variable name="ca.title" class="java.lang.String" resetType="Report"
		calculation="Nothing">
		<initialValueExpression><![CDATA["[ca]Media de documentos por expediente y procedimiento"]]></initialValueExpression>
	</variable>
	<variable name="eu.title" class="java.lang.String" resetType="Report"
		calculation="Nothing">
		<initialValueExpression><![CDATA["[eu]Media de documentos por expediente y procedimiento"]]></initialValueExpression>
	</variable>
	<variable name="gl.title" class="java.lang.String" resetType="Report"
		calculation="Nothing">
		<initialValueExpression><![CDATA["[gl]Media de documentos por expediente y procedimiento"]]></initialValueExpression>
	</variable>
	<variable name="es.column.pcd" class="java.lang.String"
		resetType="Report" calculation="Nothing">
		<initialValueExpression><![CDATA["Procedimiento"]]></initialValueExpression>
	</variable>
	<variable name="ca.column.pcd" class="java.lang.String"
		resetType="Report" calculation="Nothing">
		<initialValueExpression><![CDATA["Procediment"]]></initialValueExpression>
	</variable>
	<variable name="eu.column.pcd" class="java.lang.String"
		resetType="Report" calculation="Nothing">
		<initialValueExpression><![CDATA["Prozedura"]]></initialValueExpression>
	</variable>
	<variable name="gl.column.pcd" class="java.lang.String"
		resetType="Report" calculation="Nothing">
		<initialValueExpression><![CDATA["Procedemento"]]></initialValueExpression>
	</variable>
	<variable name="es.column.doc" class="java.lang.String"
		resetType="Report" calculation="Nothing">
		<initialValueExpression><![CDATA["Documentos"]]></initialValueExpression>
	</variable>
	<variable name="ca.column.doc" class="java.lang.String"
		resetType="Report" calculation="Nothing">
		<initialValueExpression><![CDATA["Documents"]]></initialValueExpression>
	</variable>
	<variable name="eu.column.doc" class="java.lang.String"
		resetType="Report" calculation="Nothing">
		<initialValueExpression><![CDATA["Dokumentuak"]]></initialValueExpression>
	</variable>
	<variable name="gl.column.doc" class="java.lang.String"
		resetType="Report" calculation="Nothing">
		<initialValueExpression><![CDATA["Documentos"]]></initialValueExpression>
	</variable>
	<variable name="properties"
		class="ieci.tdw.ispac.ispaclib.reports.JasperReportsProperties"
		resetType="Report" calculation="Nothing">
		<initialValueExpression><![CDATA[new ieci.tdw.ispac.ispaclib.reports.JasperReportsProperties (new String[]{"title", "column.pcd", "column.doc"},			new String[]{"es", "ca", "eu", "gl"},				new String[][]{	new String[]{$V{es.title}, $V{es.column.pcd},$V{es.column.doc}}, 				new String[]{$V{ca.title}, $V{ca.column.pcd},$V{ca.column.doc}}, 				new String[]{$V{eu.title}, $V{eu.column.pcd},$V{eu.column.doc}}, 				new String[]{$V{gl.title}, $V{gl.column.pcd},$V{gl.column.doc}}			      }	    )]]></initialValueExpression>
	</variable>
	<background>
		<band height="0" isSplitAllowed="true">
		</band>
	</background>
	<title>
		<band height="50" isSplitAllowed="true">
			<textField isStretchWithOverflow="false" isBlankWhenNull="false"
				evaluationTime="Now" hyperlinkType="None" hyperlinkTarget="Self">
				<reportElement x="0" y="5" width="534" height="40"
					key="staticText" />
				<box topBorder="None" topBorderColor="#000000" leftBorder="None"
					leftBorderColor="#000000" rightBorder="None" rightBorderColor="#000000"
					bottomBorder="None" bottomBorderColor="#000000" />
				<textElement textAlignment="Center" verticalAlignment="Middle">
					<font size="18" isBold="true" />
				</textElement>
				<textFieldExpression class="java.lang.String"><![CDATA[$V{properties}.getProperty($P{REPORT_LOCALE}, "title")]]></textFieldExpression>
			</textField>
			<line direction="TopDown">
				<reportElement x="0" y="48" width="534" height="0"
					forecolor="#000000" key="line" positionType="FixRelativeToBottom" />
				<graphicElement stretchType="NoStretch" pen="2Point" />
			</line>
			<line direction="TopDown">
				<reportElement x="0" y="3" width="534" height="0"
					forecolor="#000000" key="line" />
				<graphicElement stretchType="NoStretch" pen="2Point" />
			</line>
		</band>
	</title>
	<pageHeader>
		<band height="9" isSplitAllowed="true">
		</band>
	</pageHeader>
	<columnHeader>
		<band height="20" isSplitAllowed="true">
			<rectangle radius="0">
				<reportElement mode="Opaque" x="1" y="1" width="534"
					height="17" forecolor="#000000" backcolor="#999999" key="element-22" />
				<graphicElement stretchType="NoStretch" pen="Thin" />
			</rectangle>
			<textField isStretchWithOverflow="false" isBlankWhenNull="false"
				evaluationTime="Now" hyperlinkType="None" hyperlinkTarget="Self">
				<reportElement x="0" y="1" width="440" height="16"
					forecolor="#FFFFFF" key="element-90" />
				<box topBorder="None" topBorderColor="#000000" leftBorder="None"
					leftBorderColor="#000000" leftPadding="2" rightBorder="None"
					rightBorderColor="#000000" rightPadding="2" bottomBorder="None"
					bottomBorderColor="#000000" />
				<textElement>
					<font size="12" />
				</textElement>
				<textFieldExpression class="java.lang.String"><![CDATA[$V{properties}.getProperty($P{REPORT_LOCALE}, "column.pcd")]]></textFieldExpression>
			</textField>
			<textField isStretchWithOverflow="false" isBlankWhenNull="false"
				evaluationTime="Now" hyperlinkType="None" hyperlinkTarget="Self">
				<reportElement x="440" y="1" width="94" height="16"
					forecolor="#FFFFFF" key="element-90" />
				<box topBorder="None" topBorderColor="#000000" leftBorder="None"
					leftBorderColor="#000000" leftPadding="2" rightBorder="None"
					rightBorderColor="#000000" rightPadding="2" bottomBorder="None"
					bottomBorderColor="#000000" />
				<textElement textAlignment="Center">
					<font size="12" />
				</textElement>
				<textFieldExpression class="java.lang.String"><![CDATA[$V{properties}.getProperty($P{REPORT_LOCALE}, "column.doc")]]></textFieldExpression>
			</textField>
		</band>
	</columnHeader>
	<detail>
		<band height="19" isSplitAllowed="true">
			<line direction="TopDown">
				<reportElement x="0" y="17" width="535" height="0"
					forecolor="#808080" key="line" positionType="FixRelativeToBottom" />
				<graphicElement stretchType="NoStretch" pen="Thin" />
			</line>
			<textField isStretchWithOverflow="true" pattern=""
				isBlankWhenNull="true" evaluationTime="Now" hyperlinkType="None"
				hyperlinkTarget="Self">
				<reportElement x="0" y="1" width="440" height="15"
					key="textField" />
				<box topBorder="None" topBorderColor="#000000" leftBorder="None"
					leftBorderColor="#000000" leftPadding="2" rightBorder="None"
					rightBorderColor="#000000" rightPadding="2" bottomBorder="None"
					bottomBorderColor="#000000" />
				<textElement>
					<font size="12" />
				</textElement>
				<textFieldExpression class="java.lang.String"><![CDATA[$F{nombre}]]></textFieldExpression>
			</textField>
			<textField isStretchWithOverflow="true" pattern="#,##0.00"
				isBlankWhenNull="true" evaluationTime="Now" hyperlinkType="None"
				hyperlinkTarget="Self">
				<reportElement x="440" y="1" width="94" height="15"
					key="textField" />
				<box topBorder="None" topBorderColor="#000000" leftBorder="None"
					leftBorderColor="#000000" leftPadding="2" rightBorder="None"
					rightBorderColor="#000000" rightPadding="2" bottomBorder="None"
					bottomBorderColor="#000000" />
				<textElement textAlignment="Right">
					<font size="12" />
				</textElement>
				<textFieldExpression class="java.math.BigDecimal"><![CDATA[$F{avg}]]></textFieldExpression>
			</textField>
		</band>
	</detail>
	<columnFooter>
		<band height="0" isSplitAllowed="true">
		</band>
	</columnFooter>
	<pageFooter>
		<band height="27" isSplitAllowed="true">
			<textField isStretchWithOverflow="false" pattern=""
				isBlankWhenNull="false" evaluationTime="Now" hyperlinkType="None"
				hyperlinkTarget="Self">
				<reportElement x="325" y="4" width="170" height="19"
					key="textField" />
				<box topBorder="None" topBorderColor="#000000" leftBorder="None"
					leftBorderColor="#000000" rightBorder="None" rightBorderColor="#000000"
					bottomBorder="None" bottomBorderColor="#000000" />
				<textElement textAlignment="Right">
					<font size="10" />
				</textElement>
				<textFieldExpression class="java.lang.String"><![CDATA[$V{PAGE_NUMBER} + "/"]]></textFieldExpression>
			</textField>
			<textField isStretchWithOverflow="false" pattern=""
				isBlankWhenNull="false" evaluationTime="Report" hyperlinkType="None"
				hyperlinkTarget="Self">
				<reportElement x="499" y="4" width="36" height="19"
					forecolor="#000000" backcolor="#FFFFFF" key="textField" />
				<box topBorder="None" topBorderColor="#000000" leftBorder="None"
					leftBorderColor="#000000" rightBorder="None" rightBorderColor="#000000"
					bottomBorder="None" bottomBorderColor="#000000" />
				<textElement textAlignment="Left" verticalAlignment="Top"
					rotation="None" lineSpacing="Single">
					<font size="10" isBold="false" isItalic="false" isUnderline="false"
						isPdfEmbedded="false" pdfEncoding="CP1252" isStrikeThrough="false" />
				</textElement>
				<textFieldExpression class="java.lang.String"><![CDATA["" + $V{PAGE_NUMBER}]]></textFieldExpression>
			</textField>
			<line direction="TopDown">
				<reportElement x="0" y="1" width="535" height="0"
					forecolor="#000000" key="line" />
				<graphicElement stretchType="NoStretch" pen="2Point" />
			</line>
			<textField isStretchWithOverflow="false" pattern=""
				isBlankWhenNull="false" evaluationTime="Now" hyperlinkType="None"
				hyperlinkTarget="Self">
				<reportElement x="1" y="6" width="209" height="19"
					key="textField" />
				<box topBorder="None" topBorderColor="#000000" leftBorder="None"
					leftBorderColor="#000000" rightBorder="None" rightBorderColor="#000000"
					bottomBorder="None" bottomBorderColor="#000000" />
				<textElement>
					<font size="10" />
				</textElement>
				<textFieldExpression class="java.util.Date"><![CDATA[new Date()]]></textFieldExpression>
			</textField>
		</band>
	</pageFooter>
	<summary>
		<band height="0" isSplitAllowed="true">
		</band>
	</summary>
</jasperReport>' where nombre='Media de documentos por expediente seg�n procedimiento';

GO

--Vista para obtener las fases activas que est�n en la papelera
CREATE  VIEW <username>.spac_wl_proc_trash AS
  SELECT fases.id_exp AS id, fases.numexp, fases.id_pcd, fases.id_fase AS id_stagepcd, fases.id AS id_stage, fasespcd.nombre AS name_stage, fases.fecha_inicio AS initdate, fases.fecha_limite AS limitdate, fases.id_resp AS resp, fases.tipo
  FROM spac_fases fases, spac_p_fases fasespcd
  WHERE fases.id_fase = fasespcd.id AND fases.estado = 5;

  GO


--
-- Actualizaci�n de la entidad de EXPEDIENTES para soportar el conector de �rganos productores (secci�n tramitadora)
-- Nota: se debe pasar el proceso de actualizaci�n Java para actualizar el tipo del campo de la entidad SPAC_EXPEDIENTES:IDUNIDADTRAMITADORA.
---

-- Modificaci�n del tipo de la columna IDUNIDADTRAMITADORA
ALTER TABLE SPAC_EXPEDIENTES ALTER COLUMN IDUNIDADTRAMITADORA VARCHAR(250);
GO

-- Actualizaci�n del formulario de EXPEDIENTES
UPDATE spac_ct_aplicaciones SET frm_jsp = '<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/ispac-util.tld" prefix="ispac" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>

<script>

	function acceptRegistryInput(){

		setReadOnly(document.defaultForm.elements[ ''property(SPAC_EXPEDIENTES:NREG)'' ]);

		if (document.defaultForm.elements[ ''property(SPAC_EXPEDIENTES:IDTITULAR)''].value != '''') {

			checkRadioById(''validatedThirdParty'');
			setReadOnly(document.defaultForm.elements[ ''property(SPAC_EXPEDIENTES:NIFCIFTITULAR)'' ]);
			setReadOnlyIdentidad(document.defaultForm.elements[ ''property(SPAC_EXPEDIENTES:IDENTIDADTITULAR)'' ]);
		}
		else {
			checkRadioById(''notValidatedThirdParty'');
			setNotReadOnly(document.defaultForm.elements[ ''property(SPAC_EXPEDIENTES:NIFCIFTITULAR)'' ]);
			setNotReadOnlyIdentidad(document.defaultForm.elements[ ''property(SPAC_EXPEDIENTES:IDENTIDADTITULAR)'' ]);
		}
		hideInfo();


}

	function cancelRegistryInput(){

		hideInfo();
	}

	function delete_EXPEDIENT_SEARCH_INPUT_REGISTRY(){

	  jConfirm(''<bean:message key="msg.delete.data.register"/>'', ''<bean:message key="common.confirm"/>'' , ''<bean:message key="common.message.ok"/>'' , ''<bean:message key="common.message.cancel"/>'', function(r) {
		if(r){
			nreg = document.defaultForm.elements[ ''property(SPAC_EXPEDIENTES:NREG)'' ];
	 		setNotReadOnly(nreg);
	 		nreg.value = '''';
	 		nreg.focus();

			document.defaultForm.elements[ ''property(SPAC_EXPEDIENTES:FREG)'' ].value = '''';
		}

	});


	 	ispac_needToConfirm = true;
	}




</script>

<!-- DEFINICION DE LAS ANCLAS A LOS BLOQUES DE CAMPOS -->
<table border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="select" id="tdlink1" align="center" onclick="showTab(1)">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:SPAC_EXPEDIENTES_TAB_DATOS_EXPEDIENTE)" />
</nobr>
</td>
<td width="5px"><img height="1" width="5px" src=''<ispac:rewrite href="img/pixel.gif"/>''/></td>
<td class="unselect" id="tdlink2" align="center" onclick="document.defaultForm.name = ''Expedientes'';if (validateExpedientes(document.defaultForm)){showTab(2);}">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:SPAC_EXPEDIENTES_TAB_INFORMACION_ADICIONAL)" />
</nobr>
</td>
</tr>
</table>

<table width="100%" border="0" class="formtable" cellspacing="0" cellpadding="0">
<tr>
<td><img height="8" src=''<ispac:rewrite href="img/pixel.gif"/>''/></td>
</tr>
<tr>
<td>

<!-- BLOQUE1 DE CAMPOS -->
<div style="display:block" id="block1">
<div id="dataBlock_SPAC_EXPEDIENTES_TAB_DATOS_EXPEDIENTE" style="position: relative; height: 710px; width: 600px;">
<div id="label_SPAC_EXPEDIENTES:NUMEXP" style="position: absolute; top: 23px; left: 10px;" class="formsTitleB">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:NUMEXP)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:NUMEXP" style="position: absolute; top: 20px; left: 170px;">
<ispac:htmlText property="property(SPAC_EXPEDIENTES:NUMEXP)" readonly="true" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="30" maxlength="30" tabindex="101">
</ispac:htmlText>
</div>
<div id="label_SPAC_EXPEDIENTES:FINICIOPLAZO" style="position: absolute; top: 54px; left: 391px;" class="formsTitleB">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:FINICIOPLAZO)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:FINICIOPLAZO" style="position: absolute; top: 51px; left: 505px;">
<nobr>
<ispac:htmlTextCalendar property="property(SPAC_EXPEDIENTES:FINICIOPLAZO)" readonly="false" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="14" maxlength="10" image=''<%= buttoncalendar %>'' format="dd/mm/yyyy" enablePast="true" tabindex="103">
</ispac:htmlTextCalendar>
</nobr>
</div>
<div id="label_SPAC_EXPEDIENTES:NREG" style="position: absolute; top: 149px; left: 10px;" class="formsTitleB">
</nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:NREG)" />:</nobr>
</div>

<div id="data_SPAC_EXPEDIENTES:NREG" style="position: absolute; top: 146px; left: 170px;">
</nobr>
<c:choose>
<c:when test="${!empty sicresConnectorClass}">
	<ispac:htmlTextImageFrame property="property(SPAC_EXPEDIENTES:NREG)"
				  readonly="false"
				  readonlyTag="false"
				  propertyReadonly="readonly"
				  styleClass="input"
				  styleClassReadonly="inputReadOnly"
				  size="25"
				  maxlength="16"
			  	  id="SEARCH_SPAC_EXPEDIENTES_NREG"
				  target="workframe"
			  	  action="searchInputRegistry.do"
			  	  image="img/search-mg.gif"
			  	  titleKeyLink="search.intray"
			  	  showFrame="true"
			  	  inputField="SPAC_EXPEDIENTES:NREG"
			  	  width="500"
			  	  height="300"
			  	  jsDelete="delete_EXPEDIENT_SEARCH_INPUT_REGISTRY"
			  	  titleKeyImageDelete="forms.exp.title.delete.data.register" tabindex="105">

		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NREG" id="property(SPAC_EXPEDIENTES:ASUNTO)" property="ASUNTO"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NREG" id="property(SPAC_EXPEDIENTES:FREG)" property="FREG"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NREG" id="property(SPAC_EXPEDIENTES:TIPOPERSONA)" property="TIPOPERSONA"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NREG" id="property(SPAC_EXPEDIENTES:IDTITULAR)" property="IDTITULAR"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NREG" id="property(SPAC_EXPEDIENTES:NIFCIFTITULAR)" property="NIFCIFTITULAR"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NREG" id="property(SPAC_EXPEDIENTES:IDENTIDADTITULAR)" property="IDENTIDADTITULAR"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NREG" id="property(SPAC_EXPEDIENTES:DOMICILIO)" property="DOMICILIO"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NREG" id="property(SPAC_EXPEDIENTES:CPOSTAL)" property="CPOSTAL"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NREG" id="property(SPAC_EXPEDIENTES:CIUDAD)" property="CIUDAD"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NREG" id="property(SPAC_EXPEDIENTES:REGIONPAIS)" property="REGIONPAIS"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NREG" id="property(SPAC_EXPEDIENTES:TFNOFIJO)" property="TFNOFIJO"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NREG" id="property(SPAC_EXPEDIENTES:TFNOMOVIL)" property="TFNOMOVIL"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NREG" id="property(SPAC_EXPEDIENTES:DIRECCIONTELEMATICA)" property="DIRECCIONTELEMATICA"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NREG" id="property(SPAC_EXPEDIENTES:TIPODIRECCIONINTERESADO)" property="TIPODIRECCIONINTERESADO"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NREG" id="property(TIPODIRECCIONINTERESADO_SPAC_TBL_005:SUSTITUTO)" property="SUSTITUTOTIPODIRECCIONINTERESADO"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NREG" id="JAVASCRIPT" property="accept_EXPEDIENT_SEARCH_INPUT_REGISTRY"/>

	</ispac:htmlTextImageFrame>
</c:when>
<c:otherwise>
	<ispac:htmlText property="property(SPAC_EXPEDIENTES:NREG)" readonly="false" styleClass="input" size="25" maxlength="16" tabindex="105"/>
</c:otherwise>
</c:choose>
</nobr>
</div>
<div id="label_SPAC_EXPEDIENTES:FREG" style="position: absolute; top: 151px; left: 392px;" class="formsTitleB">
</nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:FREG)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:FREG" style="position: absolute; top: 148px; left: 505px;">
</nobr>
<c:choose>
<c:when test="${!empty sicresConnectorClass}">
<ispac:htmlTextCalendar property="property(SPAC_EXPEDIENTES:FREG)" readonly="true" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="14" maxlength="10" image=''<%= buttoncalendar %>'' format="dd/mm/yyyy" enablePast="true" tabindex="106">
</ispac:htmlTextCalendar>
</c:when>
<c:otherwise>
<ispac:htmlTextCalendar property="property(SPAC_EXPEDIENTES:FREG)" readonly="false" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="14" maxlength="10" image=''<%= buttoncalendar %>'' format="dd/mm/yyyy" enablePast="true" tabindex="106">
</ispac:htmlTextCalendar>
</c:otherwise>
</c:choose>
</nobr>
</div>
<div id="label_SPAC_EXPEDIENTES:SEP_INTERESADO_PRINCIPAL" style="position: absolute; top: 285px; left: 10px; width: 620px" class="textbar">
</nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:SEP_INTERESADO_PRINCIPAL)" /></nobr>
<hr class="formbar"/>
</div>
<c:url value="searchThirdParty.do" var="_searchThirdParty">
	<c:param name="search">1</c:param>
</c:url>

<jsp:useBean id="_searchThirdParty" type="java.lang.String"/>
<c:choose>
<c:when test="${!empty thirdPartyAPIClass}">
<div id="label_SPAC_EXPEDIENTES:LBL_VALIDADO" style="position: absolute; top: 324px; left: 10px;"  class="formsTitleB">
</nobr>
<input type="radio" name="validationThirdParty" id="validatedThirdParty" onclick="javascript: clickValidatedThirdParty();" checked="checked" tabindex="110"/>
&nbsp;<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:LBL_VALIDADO)" /></nobr>
</div>
<div id="label_SPAC_EXPEDIENTES:LBL_NO_VALIDADO" style="position: absolute; top: 324px; left: 100px;"  class="formsTitleB">
</nobr>
<input type="radio" name="validationThirdParty" id="notValidatedThirdParty" onclick="javascript: clickNotValidatedThirdParty();" tabindex="111"/>
&nbsp;<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:LBL_NO_VALIDADO)" /></nobr>
</div>
<div id="label_SPAC_EXPEDIENTES:NIFCIFTITULAR" style="position: absolute; top: 357px; left: 10px;" class="formsTitleB">
</nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:NIFCIFTITULAR)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:NIFCIFTITULAR" style="position: absolute; top: 354px; left: 170px;">
</nobr>
	<ispac:htmlTextImageFrame property="property(SPAC_EXPEDIENTES:NIFCIFTITULAR)"
				  readonly="false"
				  readonlyTag="false"
				  propertyReadonly="readonly"
				  styleClass="input"
				  styleClassReadonly="inputReadOnly"
				  size="34"
				  maxlength="16"
			  	  id="SEARCH_SPAC_EXPEDIENTES_NIFCIFTITULAR"
				  target="workframe"
			  	  action="searchThirdParty.do"
			  	  image="img/search-mg.gif"
			  	  titleKeyLink="search.thirdparty"
			  	  showFrame="true"
			  	  inputField="SPAC_EXPEDIENTES:NIFCIFTITULAR"
			  	  jsDelete="delete_EXPEDIENT_SEARCH_THIRD_PARTY"
			  	  titleKeyImageDelete="forms.exp.title.delete.data.thirdParty"
			  	  jsExecuteFrame="selectThirdParty"
				  tabindex="112"
				  >

		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NIFCIFTITULAR" id="property(SPAC_EXPEDIENTES:TIPOPERSONA)" property="TIPOPERSONA"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NIFCIFTITULAR" id="property(SPAC_EXPEDIENTES:IDTITULAR)" property="IDTITULAR"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NIFCIFTITULAR" id="property(SPAC_EXPEDIENTES:IDENTIDADTITULAR)" property="IDENTIDADTITULAR"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NIFCIFTITULAR" id="property(SPAC_EXPEDIENTES:DOMICILIO)" property="DOMICILIO"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NIFCIFTITULAR" id="property(SPAC_EXPEDIENTES:CPOSTAL)" property="CPOSTAL"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NIFCIFTITULAR" id="property(SPAC_EXPEDIENTES:CIUDAD)" property="CIUDAD"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NIFCIFTITULAR" id="property(SPAC_EXPEDIENTES:REGIONPAIS)" property="REGIONPAIS"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NIFCIFTITULAR" id="property(SPAC_EXPEDIENTES:TFNOFIJO)" property="TFNOFIJO"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NIFCIFTITULAR" id="property(SPAC_EXPEDIENTES:TFNOMOVIL)" property="TFNOMOVIL"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NIFCIFTITULAR" id="property(SPAC_EXPEDIENTES:IDDIRECCIONPOSTAL)" property="IDDIRECCIONPOSTAL"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NIFCIFTITULAR" id="property(SPAC_EXPEDIENTES:DIRECCIONTELEMATICA)" property="DIRECCIONTELEMATICA"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NIFCIFTITULAR" id="property(SPAC_EXPEDIENTES:TIPODIRECCIONINTERESADO)" property="TIPODIRECCIONINTERESADO"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NIFCIFTITULAR" id="property(TIPODIRECCIONINTERESADO_SPAC_TBL_005:SUSTITUTO)" property="SUSTITUTOTIPODIRECCIONINTERESADO"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_NIFCIFTITULAR" id="JAVASCRIPT" property="return_EXPEDIENT_SEARCH_THIRD_PARTY"/>

	</ispac:htmlTextImageFrame>

		<ispac:imageframe
					  id="SEARCH_SPAC_EXPEDIENTES_POSTAL_ADDRESS"
					  target="workframe"
					  action="searchPostalAddressesThirdParty.do"
					  image="img/icon_barra_3.gif"
					  showFrame="true"
					  inputField="SPAC_EXPEDIENTES:IDTITULAR"
					  jsShowFrame="show_SEARCH_SPAC_EXPEDIENTES_POSTAL_ADDRESS"
					  >
			<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_POSTAL_ADDRESS" id="property(SPAC_EXPEDIENTES:IDDIRECCIONPOSTAL)" property="IDDIRECCIONPOSTAL"/>
			<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_POSTAL_ADDRESS" id="property(SPAC_EXPEDIENTES:DOMICILIO)" property="DOMICILIO"/>
			<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_POSTAL_ADDRESS" id="property(SPAC_EXPEDIENTES:CPOSTAL)" property="CPOSTAL"/>
			<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_POSTAL_ADDRESS" id="property(SPAC_EXPEDIENTES:CIUDAD)" property="CIUDAD"/>
			<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_POSTAL_ADDRESS" id="property(SPAC_EXPEDIENTES:REGIONPAIS)" property="REGIONPAIS"/>
			<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_POSTAL_ADDRESS" id="property(SPAC_EXPEDIENTES:TFNOFIJO)" property="TFNOFIJO"/>

		</ispac:imageframe>
		<ispac:imageframe
					  id="SEARCH_SPAC_EXPEDIENTES_ELECTRONIC_ADDRESS"
					  target="workframe"
					  action="searchElectronicAddressesThirdParty.do"
					  image="img/icon_barra_2.gif"
					  showFrame="true"
					  inputField="SPAC_EXPEDIENTES:IDTITULAR"
					  jsShowFrame="show_SEARCH_SPAC_EXPEDIENTES_ELECTRONIC_ADDRESS"
					  >

			<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_ELECTRONIC_ADDRESS" id="property(SPAC_EXPEDIENTES:DIRECCIONTELEMATICA)" property="DIRECCIONTELEMATICA"/>
		</ispac:imageframe>

		<script language=''JavaScript'' type=''text/javascript''><!--
			function show_SEARCH_SPAC_EXPEDIENTES_POSTAL_ADDRESS(target, action, width, height, msgConfirm, doSubmit, needToConfirm) {
				direccion = document.defaultForm.elements[ ''property(SPAC_EXPEDIENTES:DOMICILIO)'' ];
				if (direccion.readOnly) {
					idtitular = document.forms[0].elements[ ''property(SPAC_EXPEDIENTES:IDTITULAR)'' ];
					if (idtitular.value != '''') {
						showFrame(target, action, width, height, msgConfirm, doSubmit, needToConfirm);
					}
					else{jAlert(''<bean:message key="terceros.interested.notSelected"/>'' ,  ''<bean:message key="common.alert"/>'' , ''<bean:message key="common.message.ok"/> '', ''<bean:message key="common.message.cancel"/>'');}
				}

			}

			function show_SEARCH_SPAC_EXPEDIENTES_ELECTRONIC_ADDRESS(target, action, width, height, msgConfirm, doSubmit, needToConfirm) {
				idtitular = document.forms[0].elements[ ''property(SPAC_EXPEDIENTES:IDTITULAR)'' ];
				if (idtitular.value != '''') {
					showFrame(target, action, width, height, msgConfirm, doSubmit, needToConfirm);
				}
				else{jAlert(''<bean:message key="terceros.interested.notSelected"/>'', ''<bean:message key="common.alert"/>'' , ''<bean:message key="common.message.ok"/>'' , ''<bean:message key="common.message.cancel"/>'');}
			}
			//-->
		</script>



</nobr>
</div>


<div id="label_SPAC_EXPEDIENTES:SEP_DIRECCIONES" style="position: absolute; top: 422px; left: 10px; width: 200px" class="textbar1">
</nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:SEP_DIRECCIONES)" /></nobr>
<hr class="formbar1"/>
</div>


<div id="label_SPAC_EXPEDIENTES:LBL_VALIDADO_POSTALADDRESS" style="position: absolute; top: 447px; left: 10px;"  class="formsTitleB">
</nobr>
<input type="radio" name="validationPostalAddressThirdParty" id="validatedPostalAddressThirdParty" onclick="javascript: clickValidatedPostalAddressThirdParty();" checked="checked" tabindex="110"/>
&nbsp;<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:LBL_CONFIRMADA)" /></nobr>
</div>
<div id="label_SPAC_EXPEDIENTES:LBL_NO_VALIDADO_POSTALADDRESS" style="position: absolute; top: 447px; left: 100px;"  class="formsTitleB">
</nobr>
<input type="radio" name="validationPostalAddressThirdParty" id="notValidatedPostalAddressThirdParty" onclick="javascript: clickNotValidatedPostalAddressThirdParty();" tabindex="111"/>
&nbsp;<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:LBL_LIBRE)" /></nobr>
</div>

</c:when>
<c:otherwise>
<div id="label_SPAC_EXPEDIENTES:LBL_VALIDADO" style="position: absolute; top: 324px; left: 10px;"  class="formsTitleB">
</nobr>
<input type="radio" name="validationThirdParty" id="validatedThirdParty" disabled="true" tabindex="110"/>
&nbsp;<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:LBL_VALIDADO)" /></nobr>
</div>
<div id="label_SPAC_EXPEDIENTES:LBL_NO_VALIDADO" style="position: absolute; top: 324px; left: 100px;"  class="formsTitleB">
</nobr>
<input type="radio" name="validationThirdParty" id="notValidatedThirdParty" checked="checked" disabled="true" tabindex="111"/>
&nbsp;<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:LBL_NO_VALIDADO)" /></nobr>
</div>
<div id="label_SPAC_EXPEDIENTES:NIFCIFTITULAR" style="position: absolute; top: 357px; left: 10px;" class="formsTitleB">
</nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:NIFCIFTITULAR)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:NIFCIFTITULAR" style="position: absolute; top: 354px; left: 170px;">
	<ispac:htmlText property="property(SPAC_EXPEDIENTES:NIFCIFTITULAR)" readonly="false" styleClass="input" size="34" maxlength="16" tabindex="112"/>
</div>
<div id="label_SPAC_EXPEDIENTES:IDENTIDADTITULAR" style="position: absolute; top: 390px; left: 10px;" class="formsTitleB">
</nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:IDENTIDADTITULAR)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:IDENTIDADTITULAR" style="position: absolute; top: 387px; left: 170px;">
<ispac:htmlTextareaImageFrame property="property(SPAC_EXPEDIENTES:IDENTIDADTITULAR)"
				  readonly="false"
				  readonlyTag="false"
				  propertyReadonly="readonly"
				  styleClass="input"
				  styleClassReadonly="inputReadOnly"
				  rows="2"
				  cols="70"
			  	  id="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR"
				  target="workframe"
			  	  action=''<%=_searchThirdParty%>''
			  	  image="img/search-mg.gif"
			  	  titleKeyLink="search.thirdparty"
			  	  showFrame="true"
			  	  inputField="SPAC_EXPEDIENTES:IDENTIDADTITULAR"
			  	  jsDelete="delete_EXPEDIENT_SEARCH_THIRD_PARTY"
			  	  titleKeyImageDelete="forms.exp.title.delete.data.thirdParty"
				  tabindex="113"
				  >


		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:TIPOPERSONA)" property="TIPOPERSONA"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:NIFCIFTITULAR)" property="NIFCIFTITULAR"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:IDTITULAR)" property="IDTITULAR"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:IDENTIDADTITULAR)" property="IDENTIDADTITULAR"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:DOMICILIO)" property="DOMICILIO"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:CPOSTAL)" property="CPOSTAL"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:CIUDAD)" property="CIUDAD"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:REGIONPAIS)" property="REGIONPAIS"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:TFNOFIJO)" property="TFNOFIJO"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:TFNOMOVIL)" property="TFNOMOVIL"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:IDDIRECCIONPOSTAL)" property="IDDIRECCIONPOSTAL"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:DIRECCIONTELEMATICA)" property="DIRECCIONTELEMATICA"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:TIPODIRECCIONINTERESADO)" property="TIPODIRECCIONINTERESADO"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(TIPODIRECCIONINTERESADO_SPAC_TBL_005:SUSTITUTO)" property="SUSTITUTOTIPODIRECCIONINTERESADO"/>
	</ispac:htmlTextareaImageFrame>
</div>

<div id="label_SPAC_EXPEDIENTES:SEP_DIRECCIONES" style="position: absolute; top: 422px; left: 10px; width: 200px" class="textbar1">
</nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:SEP_DIRECCIONES)" /></nobr>
<hr class="formbar1"/>
</div>


<div id="label_SPAC_EXPEDIENTES:LBL_VALIDADO_POSTALADDRESS" style="position: absolute; top: 447px; left: 10px;"  class="formsTitleB">
</nobr>
<input type="radio" name="validationPostalAddressThirdParty" id="validatedPostalAddressThirdParty" tabindex="110" disabled="true"/>
&nbsp;<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:LBL_CONFIRMADA)" /></nobr>
</div>
<div id="label_SPAC_EXPEDIENTES:LBL_NO_VALIDADO_POSTALADDRESS" style="position: absolute; top: 447px; left: 100px;"  class="formsTitleB">
</nobr>
<input type="radio" name="validationPostalAddressThirdParty" id="notValidatedPostalAddressThirdParty" checked="checked" disabled="true" tabindex="111"/>
&nbsp;<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:LBL_LIBRE)" /></nobr>
</div>



</c:otherwise>
</c:choose>

<div id="label_SPAC_EXPEDIENTES:DOMICILIO" style="position: absolute; top: 480px; left: 10px;" class="formsTitleB">
</nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:DOMICILIO)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:DOMICILIO" style="position: absolute; top: 477px; left: 170px;">
<ispac:htmlTextarea property="property(SPAC_EXPEDIENTES:DOMICILIO)" readonly="true" propertyReadonly="readonly" styleClass="textareaDir" styleClassReadonly="textareaDirRO" rows="2" cols="85" tabindex="114" >
</ispac:htmlTextarea>
</div>
<div id="label_SPAC_EXPEDIENTES:CIUDAD" style="position: absolute; top: 514px; left: 10px;" class="formsTitleB">
</nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:CIUDAD)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:CIUDAD" style="position: absolute; top: 511px; left: 170px;">
<ispac:htmlText property="property(SPAC_EXPEDIENTES:CIUDAD)" readonly="true" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="30" maxlength="64" tabindex="115">
</ispac:htmlText>
</div>
<div id="label_SPAC_EXPEDIENTES:REGIONPAIS" style="position: absolute; top: 547px; left: 10px;" class="formsTitleB">
</nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:REGIONPAIS)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:REGIONPAIS" style="position: absolute; top: 544px; left: 170px;">
<ispac:htmlText property="property(SPAC_EXPEDIENTES:REGIONPAIS)" readonly="true" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="80" maxlength="64" tabindex="117">
</ispac:htmlText>
</div>
<div id="label_SPAC_EXPEDIENTES:CPOSTAL" style="position: absolute; top: 514px; left: 370px;" class="formsTitleB">
</nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:CPOSTAL)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:CPOSTAL" style="position: absolute; top: 511px; left: 470px;">
<ispac:htmlText property="property(SPAC_EXPEDIENTES:CPOSTAL)" readonly="true" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="10" maxlength="5" tabindex="116">
</ispac:htmlText>
</div>
<div id="label_SPAC_EXPEDIENTES:IDENTIDADTITULAR" style="position: absolute; top: 390px; left: 10px;" class="formsTitleB">
</nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:IDENTIDADTITULAR)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:IDENTIDADTITULAR" style="position: absolute; top: 387px; left: 170px;">
<ispac:htmlTextareaImageFrame property="property(SPAC_EXPEDIENTES:IDENTIDADTITULAR)"
				  readonly="true"
				  readonlyTag="false"
				  propertyReadonly="readonly"
				  styleClass="input"
				  styleClassReadonly="inputReadOnly"
				  rows="2"
				  cols="70"
			  	  id="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR"
				  target="workframe"
			  	  action=''<%=_searchThirdParty%>''
			  	  image="img/search-mg.gif"
			  	  titleKeyLink="search.thirdparty"
			  	  showFrame="true"
			  	  inputField="SPAC_EXPEDIENTES:IDENTIDADTITULAR"
			  	  jsDelete="delete_EXPEDIENT_SEARCH_THIRD_PARTY"
			  	  titleKeyImageDelete="forms.exp.title.delete.data.thirdParty"
				  tabindex="113"
				  >


		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:TIPOPERSONA)" property="TIPOPERSONA"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:NIFCIFTITULAR)" property="NIFCIFTITULAR"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:IDTITULAR)" property="IDTITULAR"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:IDENTIDADTITULAR)" property="IDENTIDADTITULAR"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:DOMICILIO)" property="DOMICILIO"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:CPOSTAL)" property="CPOSTAL"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:CIUDAD)" property="CIUDAD"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:REGIONPAIS)" property="REGIONPAIS"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:TFNOFIJO)" property="TFNOFIJO"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:TFNOMOVIL)" property="TFNOMOVIL"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:IDDIRECCIONPOSTAL)" property="IDDIRECCIONPOSTAL"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:DIRECCIONTELEMATICA)" property="DIRECCIONTELEMATICA"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(SPAC_EXPEDIENTES:TIPODIRECCIONINTERESADO)" property="TIPODIRECCIONINTERESADO"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_IDENTIDADTITULAR" id="property(TIPODIRECCIONINTERESADO_SPAC_TBL_005:SUSTITUTO)" property="SUSTITUTOTIPODIRECCIONINTERESADO"/>
	</ispac:htmlTextareaImageFrame>
</div>
<div id="label_SPAC_EXPEDIENTES:ROLTITULAR" style="position: absolute; top: 690px; left: 10px;" class="formsTitleB">
</nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:ROLTITULAR)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:ROLTITULAR" style="position: absolute; top: 687px; left: 170px;">
<html:hidden property="property(SPAC_EXPEDIENTES:ROLTITULAR)" />
<nobr>
<ispac:htmlTextImageFrame property="property(ROLTITULAR_SPAC_TBL_002:SUSTITUTO)" readonly="true" readonlyTag="false" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="34" id="SEARCH_SPAC_EXPEDIENTES_ROLTITULAR" target="workframe" action="selectSubstitute.do?entity=SPAC_TBL_002" image="img/search-mg.gif" titleKeyLink="select.rol" imageDelete="img/borrar.gif" titleKeyImageDelete="title.delete.data.selection" styleClassDeleteLink="tdlink" confirmDeleteKey="msg.delete.data.selection" showDelete="true" showFrame="true" width="640" height="480" tabindex="122">
<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_ROLTITULAR" id="property(SPAC_EXPEDIENTES:ROLTITULAR)" property="VALOR" />
<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_ROLTITULAR" id="property(ROLTITULAR_SPAC_TBL_002:SUSTITUTO)" property="SUSTITUTO" />
</ispac:htmlTextImageFrame>
</nobr>
</div>
<div id="label_SPAC_EXPEDIENTES:ASUNTO" style="position: absolute; top: 83px; left: 10px;" class="formsTitleB">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:ASUNTO)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:ASUNTO" style="position: absolute; top: 80px; left: 170px;">
<ispac:htmlTextarea property="property(SPAC_EXPEDIENTES:ASUNTO)" readonly="false" propertyReadonly="readonly" styleClass="textareaAsunto" styleClassReadonly="textareaAsuntoRO" rows="4" cols="85" tabindex="104">
</ispac:htmlTextarea>
</div>
<div id="label_SPAC_EXPEDIENTES:FORMATERMINACION" style="position: absolute; top: 181px; left: 10px;" class="formsTitleB">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:FORMATERMINACION)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:FORMATERMINACION" style="position: absolute; top: 178px; left: 170px;">
<html:hidden property="property(SPAC_EXPEDIENTES:FORMATERMINACION)" />
<nobr>
<ispac:htmlTextImageFrame property="property(FORMATERMINACION_SPAC_TBL_003:SUSTITUTO)" readonly="true" readonlyTag="false" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="50" id="SEARCH_SPAC_EXPEDIENTES_FORMATERMINACION" target="workframe" action="selectSubstitute.do?entity=SPAC_TBL_003" image="img/search-mg.gif" titleKeyLink="select.termination" imageDelete="img/borrar.gif" titleKeyImageDelete="title.delete.data.selection" styleClassDeleteLink="tdlink" confirmDeleteKey="msg.delete.data.selection" showDelete="true" showFrame="true" width="640" height="480" tabindex="107">
<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_FORMATERMINACION" id="property(SPAC_EXPEDIENTES:FORMATERMINACION)" property="VALOR" />
<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_FORMATERMINACION" id="property(FORMATERMINACION_SPAC_TBL_003:SUSTITUTO)" property="SUSTITUTO" />
</ispac:htmlTextImageFrame>
</nobr>
</div>
<div id="label_SPAC_EXPEDIENTES:ESTADOADM" style="position: absolute; top: 214px; left: 10px;" class="formsTitleB">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:ESTADOADM)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:ESTADOADM" style="position: absolute; top: 211px; left: 170px;">
<html:hidden property="property(SPAC_EXPEDIENTES:ESTADOADM)" />
<nobr>
<ispac:htmlTextImageFrame property="property(ESTADOADM_SPAC_TBL_004:SUSTITUTO)" readonly="true" readonlyTag="false" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="50" id="SEARCH_SPAC_EXPEDIENTES_ESTADOADM" target="workframe" action="selectSubstitute.do?entity=SPAC_TBL_004" image="img/search-mg.gif" titleKeyLink="select.estadoadm" imageDelete="img/borrar.gif" titleKeyImageDelete="title.delete.data.selection" styleClassDeleteLink="tdlink" confirmDeleteKey="msg.delete.data.selection" showDelete="true" showFrame="true" width="640" height="480" tabindex="108">
<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_ESTADOADM" id="property(SPAC_EXPEDIENTES:ESTADOADM)" property="VALOR" />
<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_ESTADOADM" id="property(ESTADOADM_SPAC_TBL_004:SUSTITUTO)" property="SUSTITUTO" />
</ispac:htmlTextImageFrame>
</nobr>
</div>
<div id="label_SPAC_EXPEDIENTES:FAPERTURA" style="position: absolute; top: 52px; left: 10px;" class="formsTitleB">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:FAPERTURA)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:FAPERTURA" style="position: absolute; top: 49px; left: 170px;">
<nobr>
<ispac:htmlTextCalendar property="property(SPAC_EXPEDIENTES:FAPERTURA)" readonly="true" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="14" maxlength="10" image=''<%= buttoncalendar %>'' format="dd/mm/yyyy" enablePast="true" tabindex="102">
</ispac:htmlTextCalendar>
</nobr>
</div>
<div id="label_SPAC_EXPEDIENTES:TIPODIRECCIONINTERESADO" style="position: absolute; top: 655px; left: 10px;" class="formsTitleB">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:TIPODIRECCIONINTERESADO)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:TIPODIRECCIONINTERESADO" style="position: absolute; top: 652px; left: 170px;">
<html:hidden property="property(SPAC_EXPEDIENTES:TIPODIRECCIONINTERESADO)" />
<nobr>
<ispac:htmlTextImageFrame property="property(TIPODIRECCIONINTERESADO_SPAC_TBL_005:SUSTITUTO)" readonly="true" readonlyTag="false" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="34" id="SEARCH_SPAC_EXPEDIENTES_TIPODIRECCIONINTERESADO" target="workframe" action="selectSubstitute.do?entity=SPAC_TBL_005" image="img/search-mg.gif" titleKeyLink="select.tipoDireccionNotificacion" imageDelete="img/borrar.gif" titleKeyImageDelete="title.delete.data.selection" styleClassDeleteLink="tdlink" confirmDeleteKey="msg.delete.data.selection" showDelete="true" showFrame="true" width="640" height="480" tabindex="121">
<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_TIPODIRECCIONINTERESADO" id="property(SPAC_EXPEDIENTES:TIPODIRECCIONINTERESADO)" property="VALOR" />
<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_TIPODIRECCIONINTERESADO" id="property(TIPODIRECCIONINTERESADO_SPAC_TBL_005:SUSTITUTO)" property="SUSTITUTO" />
</ispac:htmlTextImageFrame>
</nobr>
</div>
<div id="label_SPAC_EXPEDIENTES:SECCIONINICIADORA" style="position: absolute; top: 247px; left: 10px;" class="formsTitleB">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:SECCIONINICIADORA)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:SECCIONINICIADORA" style="position: absolute; top: 244px; left: 170px;">
<ispac:htmlText property="property(SPAC_EXPEDIENTES:SECCIONINICIADORA)" readonly="true" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="50" maxlength="250" tabindex="109">
</ispac:htmlText>
</div>
<div id="label_SPAC_EXPEDIENTES:TFNOFIJO" style="position: absolute; top: 583px; left: 10px;" class="formsTitleB">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:TFNOFIJO)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:TFNOFIJO" style="position: absolute; top: 580px; left: 170px;">
<ispac:htmlText property="property(SPAC_EXPEDIENTES:TFNOFIJO)" readonly="true" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="20" maxlength="32" tabindex="118">
</ispac:htmlText>
</div>
<div id="label_SPAC_EXPEDIENTES:TFNOMOVIL" style="position: absolute; top: 583px; left: 370px;" class="formsTitleB">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:TFNOMOVIL)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:TFNOMOVIL" style="position: absolute; top: 580px; left: 470px;">
<ispac:htmlText property="property(SPAC_EXPEDIENTES:TFNOMOVIL)" readonly="true" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="20" maxlength="32" tabindex="119">
</ispac:htmlText>
</div>
<div id="label_SPAC_EXPEDIENTES:DIRECCIONTELEMATICA" style="position: absolute; top: 620px; left: 10px;" class="formsTitleB">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:DIRECCIONTELEMATICA)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:DIRECCIONTELEMATICA" style="position: absolute; top: 617px; left: 170px;">
<ispac:htmlText property="property(SPAC_EXPEDIENTES:DIRECCIONTELEMATICA)" readonly="false" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="80" maxlength="60" tabindex="120">
</ispac:htmlText>
</div>
</div>
</div>

<!-- BLOQUE2 DE CAMPOS -->
<div style="display:none" id="block2">
<div id="dataBlock_SPAC_EXPEDIENTES_TAB_INFORMACION_ADICIONAL" style="position: relative; height: 280px; width: 600px;">
<div id="label_SPAC_EXPEDIENTES:UTRAMITADORA" style="position: absolute; top: 23px; left: 10px;" class="formsTitleB">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:UTRAMITADORA)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:UTRAMITADORA" style="position: absolute; top: 20px; left: 170px;">
<html:hidden property="property(SPAC_EXPEDIENTES:IDUNIDADTRAMITADORA)" />
<nobr>
	<ispac:htmlTextImageFrame property="property(SPAC_EXPEDIENTES:UTRAMITADORA)"
				  readonly="true"
				  readonlyTag="false"
				  propertyReadonly="readonly"
				  styleClass="input"
				  styleClassReadonly="inputReadOnly"
				  size="50"
				  id="SEARCH_SPAC_EXPEDIENTES_UTRAMITADORA"
				  target="workframe"
				  action="producersWizard.do"
				  image="img/search-mg.gif"
				  titleKeyLink="select.unidadTramitadora"
				  showFrame="true" tabindex="201">

		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_UTRAMITADORA" id="property(SPAC_EXPEDIENTES:UTRAMITADORA)" property="NAME"/>
		<ispac:parameter name="SEARCH_SPAC_EXPEDIENTES_UTRAMITADORA" id="property(SPAC_EXPEDIENTES:IDUNIDADTRAMITADORA)" property="ID"/>

	</ispac:htmlTextImageFrame>
</nobr>
</div>
<div id="label_SPAC_EXPEDIENTES:FCIERRE" style="position: absolute; top: 58px; left: 10px;" class="formsTitleB">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:FCIERRE)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:FCIERRE" style="position: absolute; top: 55px; left: 170px;">
<nobr>
<ispac:htmlTextCalendar property="property(SPAC_EXPEDIENTES:FCIERRE)" readonly="true" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="14" maxlength="10" image=''<%= buttoncalendar %>'' format="dd/mm/yyyy" enablePast="true" tabindex="202">
</ispac:htmlTextCalendar>
</nobr>
</div>
<div id="label_SPAC_EXPEDIENTES:HAYRECURSO" style="position: absolute; top: 58px; left: 306px;" class="formsTitleB">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:HAYRECURSO)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:HAYRECURSO" style="position: absolute; top: 55px; left: 364px;">
<ispac:htmlCheckbox property="property(SPAC_EXPEDIENTES:HAYRECURSO)" readonly="false" propertyReadonly="readonly" valueChecked="SI" styleClassCheckbox="inputSelectP" tabindex="203"></ispac:htmlCheckbox>
</div>
<div id="label_SPAC_EXPEDIENTES:OBSERVACIONES" style="position: absolute; top: 93px; left: 10px;" class="formsTitleB">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:OBSERVACIONES)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:OBSERVACIONES" style="position: absolute; top: 90px; left: 170px;">
<ispac:htmlTextarea property="property(SPAC_EXPEDIENTES:OBSERVACIONES)" readonly="false" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" rows="2" cols="85" tabindex="204">
</ispac:htmlTextarea>
</div>
<div id="label_SPAC_EXPEDIENTES:SEP_TERRITORIO" style="position: absolute; top: 140px; left: 10px; width: 620px" class="textbar">
<nobr><bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:SEP_TERRITORIO)" />
<hr class="formbar"/>
</div>
<div id="label_SPAC_EXPEDIENTES:POBLACION" style="position: absolute; top: 183px; left: 10px;" class="formsTitleB">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:POBLACION)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:POBLACION" style="position: absolute; top: 180px; left: 170px;">
<ispac:htmlText property="property(SPAC_EXPEDIENTES:POBLACION)" readonly="false" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="50" maxlength="64" tabindex="205">
</ispac:htmlText>
</div>
<div id="label_SPAC_EXPEDIENTES:MUNICIPIO" style="position: absolute; top: 213px; left: 10px;" class="formsTitleB">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:MUNICIPIO)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:MUNICIPIO" style="position: absolute; top: 210px; left: 170px;">
<ispac:htmlText property="property(SPAC_EXPEDIENTES:MUNICIPIO)" readonly="false" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="50" maxlength="64" tabindex="206">
</ispac:htmlText>
</div>
<div id="label_SPAC_EXPEDIENTES:LOCALIZACION" style="position: absolute; top: 243px; left: 10px;" class="formsTitleB">
<nobr>
<bean:write name="defaultForm" property="entityApp.label(SPAC_EXPEDIENTES:LOCALIZACION)" />:</nobr>
</div>
<div id="data_SPAC_EXPEDIENTES:LOCALIZACION" style="position: absolute; top: 240px; left: 170px;">
<ispac:htmlText property="property(SPAC_EXPEDIENTES:LOCALIZACION)" readonly="false" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="50" maxlength="256" tabindex="207">
</ispac:htmlText>
</div>
</div>
</div>
</td>
</tr>
<tr>
<td height="15"><img src=''<ispac:rewrite href="img/pixel.gif"/>''/></td>
</tr>
</table>',
frm_version = frm_version + 1
WHERE id = 1;
GO

-- SOPORTE A RESPONSABILIDAD SOBRE TRAMITES CERRADOS
-- Se incorpora nuevo campo
ALTER TABLE <username>.SPAC_DT_TRAMITES ADD ID_RESP_CLOSED varchar (250) NULL;
GO
-- Se actualiza la definicion de la entidad
update <username>.SPAC_CT_ENTIDADES SET DEFINICION ='<entity version=''1.00''><editable>S</editable><dropable>N</dropable><status>0</status><fields><field id=''1''>	<physicalName>nombre</physicalName><type>0</type><size>250</size></field><field id=''2''><physicalName>estado</physicalName><type>2</type>		<size>1</size>	</field>	<field id=''3''>		<physicalName>id_tram_pcd</physicalName>		<type>3</type>	</field><field id=''4''>		<physicalName>id_fase_pcd</physicalName>		<type>3</type>	</field>	<field id=''5''>		<physicalName>id_fase_exp</physicalName>		<type>3</type>	</field>	<field id=''6''>		<physicalName>id_tram_exp</physicalName>		<type>3</type>	</field>	<field id=''7''>		<physicalName>id_tram_ctl</physicalName><type>3</type></field>	<field id=''8''>		<physicalName>num_acto</physicalName><type>0</type>	<size>16</size>	</field><field id=''9''>		<physicalName>cod_acto</physicalName>		<type>0</type>	<size>16</size>	</field><field id=''10''>	<physicalName>estado_info</physicalName><type>0</type><size>100</size></field>
<field id=''11''>		<physicalName>fecha_inicio</physicalName>		<type>13</type>	</field>	<field id=''12''>		<physicalName>fecha_cierre</physicalName>		<type>6</type>	</field>	<field id=''13''>		<physicalName>fecha_limite</physicalName>		<type>6</type>	</field>	<field id=''14''>		<physicalName>fecha_fin</physicalName>		<type>6</type>	</field>	<field id=''15''>		<physicalName>fecha_inicio_plazo</physicalName>		<type>6</type>	</field>	<field id=''16''>		<physicalName>plazo</physicalName>		<type>3</type>	</field>	<field id=''17''>		<physicalName>uplazo</physicalName>		<type>0</type>		<size>1</size>	</field>	<field id=''18''>		<physicalName>observaciones</physicalName>		<type>0</type>		<size>254</size>	</field>	<field id=''19''>		<physicalName>descripcion</physicalName>		<type>0</type>		<size>100</size>	</field>	<field id=''20''>		<physicalName>und_resp</physicalName>		<type>0</type>		<size>250</size></field>
<field id=''21''>	<physicalName>fase_pcd</physicalName><type>0</type>		<size>250</size>	</field>	<field id=''22''>		<physicalName>id_subproceso</physicalName>		<type>3</type>	</field>	<field id=''23''>		<physicalName>id_resp_closed</physicalName><type>0</type><size>250</size></field><field id=''24''>		<physicalName>id</physicalName>		<type>3</type>	</field>	<field id=''25''>		<physicalName>numexp</physicalName>		<type>0</type>		<size>30</size>	</field></fields><validations>	<validation id=''1''>		<fieldId>17</fieldId>		<table>SPAC_TBL_001</table>		<tableType>3</tableType>		<class/>		<mandatory>N</mandatory>	</validation></validations></entity>' WHERE ID=7;
GO
-- Vista con informacion sobre tramites cerrados
CREATE VIEW <username>.SPAC_WL_CLOSE_TASK AS
	SELECT t.id,t.nombre AS name,t.id AS id_task,t.id_tram_ctl AS id_cttask,t.id_resp_closed AS resp,p.id AS id_proc,CASE WHEN (t.id_subproceso IS NULL) THEN 1 ELSE 2 END AS tipo, p.nombre AS name_proc,t.id_fase_pcd AS id_stage,p.nombre AS name_stage,pc.id AS id_exp,t.id_fase_exp,t.numexp,t.id_subproceso AS id_subpcd,t.fecha_inicio AS initdate,t.fecha_cierre AS enddate
	FROM spac_dt_tramites t,spac_ct_procedimientos p,spac_p_fases f,spac_procesos pc
	WHERE t.numexp = pc.numexp AND pc.id_pcd = p.id AND t.id_fase_pcd = f.id AND t.estado = 3
GO



-- Nuevas reglas para generar avisos al finalizar un tramite
DECLARE @sequence_id int;
UPDATE SPAC_SQ_SEQUENCES	SET @sequence_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_CTREGLAS';
INSERT INTO SPAC_CT_REGLAS (id, nombre, descripcion, clase, tipo) VALUES (@sequence_id,'GenerateAlertEndTaskPcdRespRule','Genera un aviso electr�nico para el responsable del procedimiento informando de la finalizaci�n de un tr�mite','ieci.tdw.ispac.api.rule.tasks.GenerateAlertEndTaskPcdRespRule',1);
UPDATE SPAC_SQ_SEQUENCES	SET @sequence_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_CTREGLAS';
INSERT INTO SPAC_CT_REGLAS (id, nombre, descripcion, clase, tipo) VALUES (@sequence_id,'GenerateAlertEndTaskDelegateTramitadorRule','Genera un aviso electr�nico para el usutario tramitador �ltimo que delego el tr�mite, informando de la finalizaci�n de un tr�mite','ieci.tdw.ispac.api.rule.tasks.GenerateAlertEndTaskDelegateTramitadorRule',1);
UPDATE SPAC_SQ_SEQUENCES	SET @sequence_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_CTREGLAS';
INSERT INTO SPAC_CT_REGLAS (id, nombre, descripcion, clase, tipo) VALUES (@sequence_id,'GenerateAlertEndTaskInitTramitadorRule','Genera un aviso electr�nico para el usuario tramitador que inici� el tr�mite, informando de la finalizaci�n de un tr�mite','ieci.tdw.ispac.api.rule.tasks.GenerateAlertEndTaskInitTramitadorRule',1);
GO


--NUEVA ENTIDAD ASOCIADA POR DEFECTO PARA LA GESTION DE REGISTROS DE ENTRADA/SALIDA
CREATE TABLE <username>.SPAC_REGISTROS_ES(
	ID int NOT NULL,
	NUMEXP varchar (30) NULL,
	NREG varchar(32),
	FREG datetime NULL,
	ASUNTO text NULL,
	ID_INTERESADO varchar(32),
	INTERESADO varchar(128),
	TP_REG varchar(16),
	ID_TRAMITE int,
	ORIGINO_EXPEDIENTE VARCHAR(2)
)
GO
ALTER TABLE <username>.SPAC_REGISTROS_ES ADD CONSTRAINT SPAC_PK_REGISTROS_ES PRIMARY KEY (ID)
GO
CREATE INDEX SPAC_REGISTROS_ES_IX_NUMEXP ON <username>.SPAC_REGISTROS_ES (NUMEXP);
GO
INSERT INTO <username>.SPAC_SQ_SEQUENCES (SEQUENCE_NAME) VALUES('SPAC_SQ_ID_REGISTROSES');
GO
INSERT INTO <username>.SPAC_CT_ENTIDADES (id, tipo, nombre, campo_pk, campo_numexp, schema_expr, frm_edit, descripcion, sec_pk, FECHA) VALUES (8, 1, 'SPAC_REGISTROS_ES', 'ID', 'NUMEXP', 'NUMEXP', NULL, 'Registros de Entrada/Salida vinculados con un expediente', 'SPAC_SQ_ID_REGISTROSES', getdate());
GO
INSERT INTO <username>.SPAC_CT_APLICACIONES (id, nombre, descripcion, clase, pagina, parametros, formateador, ent_principal_id, ent_principal_nombre, xml_formateador)
	VALUES (6, 'Registros E/S', 'Registros E/S', 'ieci.tdw.ispac.ispacmgr.app.RegistroESEntityApp', '/forms/forms/registrosES.jsp', NULL, '/ispac/digester/documentsformatter.xml', 8, 'SPAC_REGISTROS_ES','<?xml version="1.0" encoding="ISO-8859-1"?><beanformatter>	<!-- Ponemos 2 veces la propiedad Nombre, una para mostrarla solo en html (media=''html'') y la otra para la exportacion (media= ''xml excel csv pdf'') --><propertyfmt type="BeanPropertySimpleFmt" property=''ID'' titleKey='''' fieldType=''ICON_LINK'' columnClass=''width10percent'' media=''html'' /><propertyfmt type="BeanPropertySimpleFmt"  property=''NREG'' titleKey=''SPAC_REGISTROS_ES:NREG'' fieldType=''LIST'' columnClass=''width20percent'' headerClass=''sortable'' sortable=''true'' /><propertyfmt type="BeanPropertyDateFmt" property=''FREG'' titleKey=''SPAC_REGISTROS_ES:FREG'' fieldType=''LIST'' columnClass=''width20percent'' format=''dd/MM/yyyy'' headerClass=''sortable'' sortable=''true'' /><propertyfmt type="BeanPropertySimpleFmt" property=''INTERESADO'' titleKey=''SPAC_REGISTROS_ES:INTERESADO'' fieldType=''LIST'' columnClass=''width40percent'' headerClass=''sortable'' sortable=''true'' /><propertyfmt type="BeanPropertySimpleFmt" property=''TP_REG'' titleKey=''SPAC_REGISTROS_ES:TP_REG'' fieldType=''LIST'' columnClass=''width10percent'' headerClass=''sortable'' sortable=''true'' /></beanformatter>');
UPDATE <username>.SPAC_CT_ENTIDADES SET frm_edit = 6 WHERE id = 8;
GO
DECLARE @sequence_id int;
UPDATE SPAC_SQ_SEQUENCES	SET @sequence_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_PENTIDADES';
INSERT INTO <username>.SPAC_P_ENTIDADES (id, id_ent, id_pcd, tp_rel, orden, frm_edit) VALUES (@sequence_id, 8, 1, 1, 5, NULL);
GO


--
-- Nuevo EntityApp vinculado con el formulario del Expediente
--
update SPAC_CT_APLICACIONES SET CLASE = 'ieci.tdw.ispac.ispacmgr.app.ExpedientEntityApp' WHERE ID = 1;

-- Registros Entrada/Salida
--
update SPAC_CT_ENTIDADES SET DEFINICION ='<entity version=''1.00''><editable>S</editable><dropable>S</dropable><status>0</status><fields><field id=''1''><physicalName>id</physicalName><descripcion><![CDATA[Campos Clave de la entidad (Uso interno del sistema)]]></descripcion><type>3</type><nullable>N</nullable><documentarySearch>N</documentarySearch><multivalue>N</multivalue></field><field id=''2''><physicalName>numexp</physicalName><descripcion><![CDATA[Campo que relaciona la entidad con un n�mero de expediente (Uso interno del sistema)]]></descripcion><type>0</type><size>30</size><nullable>N</nullable><documentarySearch>N</documentarySearch><multivalue>N</multivalue></field><field id=''3''><physicalName>NREG</physicalName><type>0</type><size>32</size><nullable>S</nullable><documentarySearch>N</documentarySearch><multivalue>N</multivalue></field><field id=''4''><physicalName>FREG</physicalName><type>6</type><nullable>S</nullable><documentarySearch>N</documentarySearch><multivalue>N</multivalue></field><field id=''5''><physicalName>ASUNTO</physicalName><type>1</type><nullable>S</nullable><documentarySearch>N</documentarySearch><multivalue>N</multivalue></field>
<field id=''6''><physicalName>ID_INTERESADO</physicalName><type>0</type><size>32</size><nullable>S</nullable><documentarySearch>N</documentarySearch><multivalue>N</multivalue></field><field id=''7''><physicalName>INTERESADO</physicalName><type>0</type><size>128</size><nullable>S</nullable><documentarySearch>N</documentarySearch><multivalue>N</multivalue></field><field id=''8''><physicalName>TP_REG</physicalName><type>0</type><size>16</size><nullable>S</nullable><documentarySearch>N</documentarySearch><multivalue>N</multivalue></field><field id=''9''><physicalName>ID_TRAMITE</physicalName><type>3</type><nullable>S</nullable><documentarySearch>N</documentarySearch><multivalue>N</multivalue></field><field id=''10''><physicalName>ORIGINO_EXPEDIENTE</physicalName><type>0</type><size>2</size><nullable>S</nullable><documentarySearch>N</documentarySearch><multivalue>N</multivalue></field></fields><indexes><index id=''11''><name><![CDATA[IND_1332834253]]></name><fields><field idField=''2''/></fields></index></indexes><validations><validation id=''1''>
<fieldId>8</fieldId><table>SPAC_VLDTBL_TIPOREG</table><tableType>2</tableType><class/><mandatory>N</mandatory><hierarchicalId/><hierarchicalName/></validation><validation id=''2''><fieldId>10</fieldId><table>SPAC_TBL_009</table><tableType>2</tableType><class/><mandatory>N</mandatory><hierarchicalId/><hierarchicalName/></validation></validations></entity>' WHERE ID=8;

-- Recursos


DECLARE @sequence_resources_id int;
UPDATE <username>.SPAC_SQ_SEQUENCES	SET @sequence_resources_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_ENTIDADESRESOURCES';
INSERT INTO <username>.SPAC_CT_ENTIDADES_RESOURCES (ID, ID_ENT, IDIOMA, CLAVE, VALOR) VALUES (@sequence_resources_id, 8, 'es', 'SPAC_REGISTROS_ES','Registros E/S');
UPDATE <username>.SPAC_SQ_SEQUENCES	SET @sequence_resources_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_ENTIDADESRESOURCES';
INSERT INTO <username>.SPAC_CT_ENTIDADES_RESOURCES (ID, ID_ENT, IDIOMA, CLAVE, VALOR) VALUES (@sequence_resources_id, 8, 'es', 'NREG','N�mero de Registro');
UPDATE <username>.SPAC_SQ_SEQUENCES	SET @sequence_resources_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_ENTIDADESRESOURCES';
INSERT INTO <username>.SPAC_CT_ENTIDADES_RESOURCES (ID, ID_ENT, IDIOMA, CLAVE, VALOR) VALUES (@sequence_resources_id, 8, 'es', 'FREG','Fecha de Registro');
UPDATE <username>.SPAC_SQ_SEQUENCES	SET @sequence_resources_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_ENTIDADESRESOURCES';
INSERT INTO <username>.SPAC_CT_ENTIDADES_RESOURCES (ID, ID_ENT, IDIOMA, CLAVE, VALOR) VALUES (@sequence_resources_id, 8, 'es', 'ASUNTO','Asunto');
UPDATE <username>.SPAC_SQ_SEQUENCES	SET @sequence_resources_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_ENTIDADESRESOURCES';
INSERT INTO <username>.SPAC_CT_ENTIDADES_RESOURCES (ID, ID_ENT, IDIOMA, CLAVE, VALOR) VALUES (@sequence_resources_id, 8, 'es', 'ID_INTERESADO','Identificador interesado');
UPDATE <username>.SPAC_SQ_SEQUENCES	SET @sequence_resources_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_ENTIDADESRESOURCES';
INSERT INTO <username>.SPAC_CT_ENTIDADES_RESOURCES (ID, ID_ENT, IDIOMA, CLAVE, VALOR) VALUES (@sequence_resources_id, 8, 'es', 'INTERESADO','Interesado');
UPDATE <username>.SPAC_SQ_SEQUENCES	SET @sequence_resources_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_ENTIDADESRESOURCES';
INSERT INTO <username>.SPAC_CT_ENTIDADES_RESOURCES (ID, ID_ENT, IDIOMA, CLAVE, VALOR) VALUES (@sequence_resources_id, 8, 'es', 'TP_REG','Tipo de Registro');
UPDATE <username>.SPAC_SQ_SEQUENCES	SET @sequence_resources_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_ENTIDADESRESOURCES';
INSERT INTO <username>.SPAC_CT_ENTIDADES_RESOURCES (ID, ID_ENT, IDIOMA, CLAVE, VALOR) VALUES (@sequence_resources_id, 8, 'es', 'ID_TRAMITE','Identificador de tr�mite');
UPDATE <username>.SPAC_SQ_SEQUENCES	SET @sequence_resources_id = sequence_id = sequence_id + 1 WHERE sequence_name = 'SPAC_SQ_ID_ENTIDADESRESOURCES';
INSERT INTO <username>.SPAC_CT_ENTIDADES_RESOURCES (ID, ID_ENT, IDIOMA, CLAVE, VALOR) VALUES (@sequence_resources_id, 8, 'es', 'ORIGINO_EXPEDIENTE','Dio origen al expediente');
GO


UPDATE spac_ct_aplicaciones SET frm_jsp = '<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/ispac-util.tld" prefix="ispac" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c1" %>


<script>

		function show_SEARCH_SPAC_REGISTROS_ES_NREG(target, action, width, height) {
			registerType = document.defaultForm[''property(SPAC_REGISTROS_ES:TP_REG)''].value
			if (registerType == '''' || registerType == ''NINGUNO''){
				jAlert(''<bean:message key="registro.tipoRegistro.invalido"/>'', ''<bean:message key="common.alert"/>'', ''<bean:message key="common.message.ok"/>'' , ''<bean:message key="common.message.cancel"/>'');
				return false;
			}
			registerNumber = document.defaultForm[''property(SPAC_REGISTROS_ES:NREG)''].value
			if (registerNumber == ''''){
				jAlert(''<bean:message key="registro.numeroRegistro.vacio"/>'', ''<bean:message key="common.alert"/>'', ''<bean:message key="common.message.ok"/>'' , ''<bean:message key="common.message.cancel"/>'');
				return false;
			}

			action = action + ''&registerType=''+registerType;
			showFrame(target, action, width, height) ;
		}

</script>

<c1:set var="sicresConnectorClass" value="${ISPACConfiguration.SICRES_CONNECTOR_CLASS}" />
<c1:set var="_key"><bean:write name="defaultForm" property="entityApp.property(SPAC_REGISTROS_ES:ID)" /></c1:set>

<c1:set var="aux0"><bean:write name="defaultForm" property="entityApp.label(SPAC_REGISTROS_ES:SPAC_REGISTROS_ES)" /></c1:set><jsp:useBean id="aux0" type="java.lang.String"/>
<ispac:tabs>
<ispac:tab  title=''<%=aux0%>''><div id="dataBlock_SPAC_REGISTROS_ES" style="position: relative; height: 160px; width: 600px">

<html:hidden property="property(SPAC_REGISTROS_ES:ID_INTERESADO)"/>
<html:hidden property="property(SPAC_REGISTROS_ES:ID_TRAMITE)"/>

<div id="label_SPAC_REGISTROS_ES:TP_REG" style="position: absolute; top: 10px; left: 10px; width: 150px;" class="formsTitleB">
<bean:write name="defaultForm" property="entityApp.label(SPAC_REGISTROS_ES:TP_REG)" />:</div>
<div id="data_SPAC_REGISTROS_ES:TP_REG" style="position: absolute; top: 10px; left: 160px; width:100% ;" >
<nobr>

		<c:choose>
			<c:when test="${_key == ''''}">
				<ispac:htmlTextImageFrame property="property(SPAC_REGISTROS_ES:TP_REG)" readonly="true" readonlyTag="false" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="20" imageTabIndex="true" id="SEARCH_SPAC_REGISTROS_ES_TP_REG" target="workframe" action="selectValue.do?entity=SPAC_VLDTBL_TIPOREG" image="img/search-mg.gif" titleKeyLink="title.link.data.selection" imageDelete="img/borrar.gif" titleKeyImageDelete="title.delete.data.selection" styleClassDeleteLink="tdlink" confirmDeleteKey="msg.delete.data.selection" showDelete="false" showFrame="true" width="640" height="480" >
				<ispac:parameter name="SEARCH_SPAC_REGISTROS_ES_TP_REG" id="property(SPAC_REGISTROS_ES:TP_REG)" property="VALOR" />
				</ispac:htmlTextImageFrame>
			</c:when>
			<c:otherwise>
				<ispac:htmlText property="property(SPAC_REGISTROS_ES:TP_REG)"
					styleClass="input"
					size="20"
					readonly=''true''
					/>
			</c:otherwise>
		</c:choose>

</nobr>
</div>


<div id="label_SPAC_REGISTROS_ES:NREG" style="position: absolute; top: 10px; left: 310px; width: 150px;" class="formsTitleB">
<bean:write name="defaultForm" property="entityApp.label(SPAC_REGISTROS_ES:NREG)" />:</div>
<div id="data_SPAC_REGISTROS_ES:NREG" style="position: absolute; top: 10px; left: 430px; width:100% ;" >
		<c:choose>
			<c:when test="${!empty sicresConnectorClass && _key == ''''}">
				<script>	
					function accept_SEARCH_SPAC_REGISTROS_ES_NREG(){
					  var element;
					  var elements;
					  var i;

					  element = document.getElementById(''waitOperationInProgress'');
					  if (element != null)
					  {
						// Deshabilitar el scroll
						document.body.style.overflow = "hidden";
					  
						element.style.position = "absolute";
						
						element.style.height = document.body.scrollHeight + 1200;
						element.style.width = document.body.clientWidth + 1200;
						element.style.left = -600;
						element.style.top = -1000;

						element.style.display = "block";
						
						if (isIE())
						{
						  elements = document.getElementsByTagName("SELECT");
							
						  for (i = 0; i < elements.length; i++)
						  {
							elements[i].style.visibility = "hidden";
						  }
						}
					  }
					}

				</script>
				<ispac:htmlTextImageFrame
					property="property(SPAC_REGISTROS_ES:NREG)"
					id="SEARCH_SPAC_REGISTROS_ES_NREG"
					readonlyTag="false"
					styleClassLink="search"
					styleClassReadonly="inputReadOnly"
					styleClass="input"
					size="25"
					maxlength="16"
					action="selectTaskRegisterES.do"
					image="img/search-mg.gif"
					titleKeyLink="search.intray"
					inputField="SPAC_REGISTROS_ES:NREG"
					width="500"
					height="300"
					titleKeyImageDelete="forms.exp.title.delete.data.register"
					target="workframe"
					showFrame="true"
					readonly="false"
					showDelete="false"
					jsShowFrame="show_SEARCH_SPAC_REGISTROS_ES_NREG"
				>
					<ispac:parameter name="SEARCH_SPAC_REGISTROS_ES_NREG" id="property(SPAC_REGISTROS_ES:FREG)" property="FREG" />
					<ispac:parameter name="SEARCH_SPAC_REGISTROS_ES_NREG" id="property(SPAC_REGISTROS_ES:ASUNTO)" property="ASUNTO" />
					<ispac:parameter name="SEARCH_SPAC_REGISTROS_ES_NREG" id="property(SPAC_REGISTROS_ES:ID_INTERESADO)" property="IDTITULAR" />
					<ispac:parameter name="SEARCH_SPAC_REGISTROS_ES_NREG" id="property(SPAC_REGISTROS_ES:INTERESADO)" property="IDENTIDADTITULAR" />
					<ispac:parameter name="SEARCH_SPAC_REGISTROS_ES_NREG" id="property(SPAC_REGISTROS_ES:ID_TRAMITE)" property="ID_TRAMITE" />
					<ispac:parameter name="SEARCH_SPAC_REGISTROS_ES_NREG" id="property(SPAC_REGISTROS_ES:ORIGINO_EXPEDIENTE)" property="ORIGINO_EXPEDIENTE" />
					<ispac:parameter name="SEARCH_SPAC_REGISTROS_ES_NREG" id="JAVASCRIPT" property="accept_SEARCH_SPAC_REGISTROS_ES_NREG" />
				</ispac:htmlTextImageFrame>
			</c:when>
			<c:otherwise>
				<ispac:htmlText property="property(SPAC_REGISTROS_ES:NREG)"
					styleClass="input" size="20"
					readonly=''true'' />
			</c:otherwise>
		</c:choose>
</div>
<div id="label_SPAC_REGISTROS_ES:FREG" style="position: absolute; top: 35px; left: 10px; width: 150px;" class="formsTitleB">
<bean:write name="defaultForm" property="entityApp.label(SPAC_REGISTROS_ES:FREG)" />:</div>
<div id="data_SPAC_REGISTROS_ES:FREG" style="position: absolute; top: 35px; left: 160px; width:100% ;" >
<nobr>
<ispac:htmlTextCalendar property="property(SPAC_REGISTROS_ES:FREG)" readonly="true" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="14" maxlength="10" image=''<%= buttoncalendar %>'' format="dd/mm/yyyy" enablePast="true" >
</ispac:htmlTextCalendar>
</nobr>
</div>
<div id="label_SPAC_REGISTROS_ES:ASUNTO" style="position: absolute; top: 60px; left: 10px; width: 150px;" class="formsTitleB">
<bean:write name="defaultForm" property="entityApp.label(SPAC_REGISTROS_ES:ASUNTO)" />:</div>
<div id="data_SPAC_REGISTROS_ES:ASUNTO" style="position: absolute; top: 60px; left: 160px; width:100% ;" >
<ispac:htmlTextarea property="property(SPAC_REGISTROS_ES:ASUNTO)" readonly="true" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" rows="2" cols="80" >
</ispac:htmlTextarea>
</div>
<div id="label_SPAC_REGISTROS_ES:INTERESADO" style="position: absolute; top: 100px; left: 10px; width: 150px;" class="formsTitleB">
<bean:write name="defaultForm" property="entityApp.label(SPAC_REGISTROS_ES:INTERESADO)" />:</div>
<div id="data_SPAC_REGISTROS_ES:INTERESADO" style="position: absolute; top: 100px; left: 160px; width:100% ;" >
<ispac:htmlText property="property(SPAC_REGISTROS_ES:INTERESADO)" readonly="true" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="80" maxlength="128" >
</ispac:htmlText>
</div>
<div id="label_SPAC_REGISTROS_ES:ORIGINO_EXPEDIENTE" style="position: absolute; top: 125px; left: 10px; width: 150px;" class="formsTitleB">
<bean:write name="defaultForm" property="entityApp.label(SPAC_REGISTROS_ES:ORIGINO_EXPEDIENTE)" />:</div>
<div id="data_SPAC_REGISTROS_ES:ORIGINO_EXPEDIENTE" style="position: absolute; top: 125px; left: 160px; width:100% ;" >
<nobr>
<ispac:htmlTextImageFrame property="property(SPAC_REGISTROS_ES:ORIGINO_EXPEDIENTE)" readonly="true" readonlyTag="true" propertyReadonly="readonly" styleClass="input" styleClassReadonly="inputReadOnly" size="5" imageTabIndex="true" id="SEARCH_SPAC_REGISTROS_ES_ORIGINO_EXPEDIENTE" target="workframe" action="selectValue.do?entity=SPAC_TBL_009" image="img/search-mg.gif" titleKeyLink="title.link.data.selection" imageDelete="img/borrar.gif" titleKeyImageDelete="title.delete.data.selection" styleClassDeleteLink="tdlink" confirmDeleteKey="msg.delete.data.selection" showDelete="true" showFrame="true" width="640" height="480" >
<ispac:parameter name="SEARCH_SPAC_REGISTROS_ES_ORIGINO_EXPEDIENTE" id="property(SPAC_REGISTROS_ES:ORIGINO_EXPEDIENTE)" property="VALOR" />
</ispac:htmlTextImageFrame>
</nobr>
</div>

<div id="label_SPAC_REGISTROS_ES:ID_TRAMITE" style="position: absolute; top: 150px; left: 10px; width: 150px;" class="formsTitleB">
<logic:notEmpty name="defaultForm" property="property(SPAC_REGISTROS_ES:ID_TRAMITE)">
	<bean:define id="_stageId" name="stageId"/>
	<c:url value="showTask.do" var="_link">
		<c:param name="stagePcdIdActual" value=''${requestScope.stagePcdId}''/>
		<c:param name="taskId"><bean:write name="defaultForm" property="entityApp.property(SPAC_REGISTROS_ES:ID_TRAMITE)"/></c:param>
		<%-- id en spac_dt_tramites --%>
		<c:param name="key"><bean:write name="defaultForm" property="entityApp.property(KEY)"/></c:param>
	</c:url>
	<a href=''<c:out value="${_link}"/>'' class="formaction">
		<nobr><bean:message key="registro.task.link"/></nobr>
	</a>
</logic:notEmpty>
</div>
</div>
</ispac:tab></ispac:tabs>

<script language=''JavaScript'' type=''text/javascript''><!--
	document.getElementById(''blockSave'').style.display=''none'';
	<%--
	Se permite eliminar el vinculo del apunto de registro con el expediente en los casos en los que el apunte de registro no anexa documentos, es decir, no incorpora
	documentos al expediente,ya que de esta manera no va a poder ser eliminado desde un documento al no crearse.
	--%>
	object = document.getElementById(''blockDelete'');
	if(object != null && object != ''undefined''){
		valueBlockDelete = ''none'';
		<logic:empty name="defaultForm" property="property(SPAC_REGISTROS_ES:ID_TRAMITE)">
			<logic:equal name="defaultForm" property="property(SPAC_REGISTROS_ES:ORIGINO_EXPEDIENTE)" value="NO">
				valueBlockDelete = ''block'';
			</logic:equal>
		</logic:empty>
		object.style.display=valueBlockDelete;
	}

//-->
</script>'
, frm_version = 1
WHERE id = 6;
GO

---
--- Integraci�n con Portafirmas
---

ALTER TABLE <username>.SPAC_CTOS_FIRMA_DETALLE ADD TIPO_FIRMANTE varchar (16) NULL;
GO

ALTER TABLE <username>.SPAC_CTOS_FIRMA_CABECERA ADD SISTEMA varchar (64) NULL;
GO
ALTER TABLE <username>.SPAC_CTOS_FIRMA_CABECERA ADD SECUENCIA varchar (64) NULL;
GO
ALTER TABLE <username>.SPAC_CTOS_FIRMA_CABECERA ADD APLICACION varchar (64) NULL;
GO
ALTER TABLE <username>.SPAC_DT_DOCUMENTOS ADD ID_PROCESO_FIRMA text;
GO
ALTER TABLE <username>.SPAC_DT_DOCUMENTOS ADD ID_CIRCUITO int;
GO
--
-- Documento
--
UPDATE spac_ct_entidades SET definicion = '<entity version=''1.00''>
<editable>S</editable>
<dropable>N</dropable>
<status>0</status>
<fields>
	<field id=''1''>
		<physicalName>id</physicalName>
		<type>3</type>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''2''>
		<physicalName>numexp</physicalName>
		<type>0</type>
		<size>30</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''3''>
		<physicalName>fdoc</physicalName>
		<type>6</type>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''4''>
		<physicalName>nombre</physicalName>
		<type>0</type>
		<size>100</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''5''>
		<physicalName>autor</physicalName>
		<type>0</type>
		<size>250</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''6''>
		<physicalName>id_fase</physicalName>
		<type>3</type>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''7''>
		<physicalName>id_tramite</physicalName>
		<type>3</type>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''8''>
		<physicalName>id_tpdoc</physicalName>
		<type>3</type>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''9''>
		<physicalName>tp_reg</physicalName>
		<type>0</type>
		<size>16</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''10''>
		<physicalName>nreg</physicalName>
		<type>0</type>
		<size>16</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''11''>
		<physicalName>freg</physicalName>
		<type>6</type>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''12''>
		<physicalName>infopag</physicalName>
		<type>0</type>
		<size>100</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''13''>
		<physicalName>id_fase_pcd</physicalName>
		<type>3</type>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''14''>
		<physicalName>id_tramite_pcd</physicalName>
		<type>3</type>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''15''>
		<physicalName>estado</physicalName>
		<type>0</type>
		<size>16</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''16''>
		<physicalName>origen</physicalName>
		<type>0</type>
		<size>128</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''17''>
		<physicalName>descripcion</physicalName>
		<type>0</type>
		<size>250</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''18''>
		<physicalName>origen_id</physicalName>
		<type>0</type>
		<size>20</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''19''>
		<physicalName>destino</physicalName>
		<type>0</type>
		<size>250</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''20''>
		<physicalName>autor_info</physicalName>
		<type>0</type>
		<size>250</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''21''>
		<physicalName>estadofirma</physicalName>
		<type>0</type>
		<size>2</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''22''>
		<physicalName>id_notificacion</physicalName>
		<type>0</type>
		<size>64</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''23''>
		<physicalName>estadonotificacion</physicalName>
		<type>0</type>
		<size>2</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''24''>
		<physicalName>destino_id</physicalName>
		<type>0</type>
		<size>20</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''25''>
		<physicalName>fnotificacion</physicalName>
		<type>6</type>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''26''>
		<physicalName>faprobacion</physicalName>
		<type>6</type>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''27''>
		<physicalName>origen_tipo</physicalName>
		<type>0</type>
		<size>1</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''28''>
		<physicalName>destino_tipo</physicalName>
		<type>0</type>
		<size>1</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''29''>
		<physicalName>id_plantilla</physicalName>
		<type>3</type>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''30''>
		<physicalName>bloqueo</physicalName>
		<type>0</type>
		<size>2</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''31''>
		<physicalName>repositorio</physicalName>
		<type>0</type>
		<size>8</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''32''>
		<physicalName>extension</physicalName>
		<type>0</type>
		<size>64</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''33''>
		<physicalName>ffirma</physicalName>
		<type>6</type>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''34''>
		<physicalName>infopag_rde</physicalName>
		<type>0</type>
		<size>256</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''35''>
		<physicalName>id_reg_entidad</physicalName>
		<type>3</type>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''36''>
		<physicalName>id_entidad</physicalName>
		<type>3</type>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
		</field>
	<field id=''37''>
		<physicalName>extension_rde</physicalName>
		<descripcion><![CDATA[Extensi�n del documento firmado]]></descripcion>
		<type>0</type>
		<size>64</size>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''38''>
		<physicalName>id_proceso_firma</physicalName>
		<descripcion><![CDATA[Datos identificativos del proceso de firma externo en el que est� inmerso el documento]]></descripcion>
		<type>1</type>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	<field id=''39''>
		<physicalName>id_circuito</physicalName>
		<descripcion><![CDATA[Identificador del circuito utilizado para enviar al portafirmas]]></descripcion>
		<type>3</type>
		<nullable>S</nullable>
		<documentarySearch>N</documentarySearch>
		<multivalue>N</multivalue>
	</field>
	</fields>
	<validations>
		<validation id=''1''>
			<fieldId>23</fieldId>
			<table>SPAC_TBL_006</table>
			<tableType>3</tableType>
			<class/>
			<mandatory>N</mandatory>
		</validation>
		<validation id=''2''>
			<fieldId>21</fieldId>
			<table>SPAC_TBL_008</table>
			<tableType>3</tableType>
			<class/>
			<mandatory>N</mandatory>
		</validation>
	</validations>
</entity>'
WHERE id = 2;

GO