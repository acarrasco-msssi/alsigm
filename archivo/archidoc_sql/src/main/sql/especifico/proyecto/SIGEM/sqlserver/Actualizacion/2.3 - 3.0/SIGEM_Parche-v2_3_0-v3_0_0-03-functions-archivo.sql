CREATE FUNCTION dbo.GREATEST (
@Value1 smallint,
@Value2 smallint
)
RETURNS smallint
AS
BEGIN


			DECLARE @MaxValue smallint
			IF (@Value1 > @Value2)
				SET @MaxValue = @Value1
			ELSE
				SET @MaxValue = @Value2
			RETURN @MaxValue
END
GO

-- Nuevo procedimiento de comprobacion de marcas
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

/************************************************************************************************************************************/
--	devuelve el digito en la posicion indicada por el parametro @iPosicion, del numero binario resultante de convertir
--  el numero en base decimal que recibe como primer parametro (@iNumeroBase)
--
-- Ejemplos de uso:
--	El N�mero 473 en binario es							111011001
--	PRINT dbo.devolverMarca(473,10)								0
--	PRINT dbo.devolverMarca(473,9)								0
--	PRINT dbo.devolverMarca(473,8)								1
--	PRINT dbo.devolverMarca(473,7)								1
--	PRINT dbo.devolverMarca(473,6)								1
--	PRINT dbo.devolverMarca(473,5)								0
--	PRINT dbo.devolverMarca(473,4)								1
--	PRINT dbo.devolverMarca(473,3)								1
--	PRINT dbo.devolverMarca(473,2)								0
--	PRINT dbo.devolverMarca(473,1)								0
--	PRINT dbo.devolverMarca(473,0)								1
--	PRINT dbo.devolverMarca(473,-1)								0
--	PRINT dbo.devolverMarca(473,-2)								0
--		...				...									   ...
--	PRINT dbo.devolverMarca(473,-10)							0
/************************************************************************************************************************************/
CREATE FUNCTION [dbo].[DEVOLVERMARCA]
(	@iNumeroBase10		INT,
	@iPosicion			INT)	--la posicion del primer caracter por la derecha es la 0
RETURNS BIT
AS
BEGIN
	DECLARE @vNumeros		VARCHAR(10)
	SELECT @vNumeros= '0123456789'

	DECLARE @vNuevoNumero	VARCHAR(120)
	SELECT @vNuevoNumero = ''


	-- Algoritmo generico de conversion de un numero en su equivalente en otra base:
	-- 1) Se divide el numero original (en base-10) entre la nueva base sucesivamente, hasta que el cociente de esta division (entera) sea 0
	--    (en ese momento el numero a dividir, sera mas peque�o que la nueva base).
	-- 2) Se compone el numero final convertido, digito a digito, a partir de los restos de cada division, desde la ultima a la primera, componiendo el numero de derecha a izquierda.
	--
	-- Ej pasar a binario 6 (base-10)
	--	6/2=3	6%2=0
	--	3/2=1	3%2=1
	--	1/2=0	1%2=1	--paramos de dividir
	--
	-- ahora componemos el numero final de derecha a izquierda, desde el ultimo resto al primero
	-- 1 1 0
	-- resultado final	110

	WHILE @iNumeroBase10 <> 0
	BEGIN
		SELECT @vNuevoNumero = SUBSTRING(@vNumeros, (@iNumeroBase10 % 2) + 1, 1) + @vNuevoNumero
		SELECT @iNumeroBase10 = @iNumeroBase10 / 2
	END --While

	IF SUBSTRING(@vNuevoNumero, LEN(@vNuevoNumero)-@iPosicion, 1) = '1' BEGIN RETURN 1 END

	RETURN 0
END --Procedure
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[CALCULARFINALCODREFPADRE]
(	@vCodReferencia		VARCHAR(255),
	@vCodRefFondo		VARCHAR(255),
	@vCodigo			VARCHAR(255),
	@vFinalCodRefPadreActual	VARCHAR(255),
	@vDelimitador		VARCHAR(255))
RETURNS VARCHAR(255)
AS
BEGIN
	-- algoritmo: Ej
	-- vCodReferencia			ES/NA/AJRP/CF1/CF2/F1/CS1/CS2/S1/U1
	-- vCodRefFondo				ES/NA/AJRP/CF1/CF2/F1
	-- vCodigo					U1
	-- vFinalCodRefPadreActual	CF1/CF2/F2/CS1/CS2/S1/U1
	-- vDelimitador				/

	-- valor retornado:
	--	sin lanzar excepciones:		CS1/CS2/S1
	--	si algo fala:				CF1/CF2/F2/CS1/CS2/S1/U1

	--reemplazar en la cadena la parte del fondo+delimitador por la cadena vacia
	DECLARE @vCodRefSinCodRefFondo	VARCHAR(255)
	DECLARE @iNumCars INT
	DECLARE @vReturnValue VARCHAR(255)

	-- El codigo de referencia del fondo nunca puede llegar nulo, si llega nulo => error
	IF(LEN(@vCodRefFondo)=0) BEGIN
		RETURN @vFinalCodRefPadreActual
	END

	-- El codigo de referencia nunca puede llegar nulo, si llega nulo => error
	IF(LEN(@vCodReferencia)=0) BEGIN
		RETURN @vFinalCodRefPadreActual
	END

	-- Si el codigo de referencia del fondo no esta contenido ,en el codigo de referencia => error
	IF(CHARINDEX(@vCodRefFondo,@vCodReferencia)=0) BEGIN
		RETURN @vFinalCodRefPadreActual
	END

	-- Quitamos la parte con el codigo de referencia del fondo, del codigo de referencia
	SELECT @vCodRefSinCodRefFondo = REPLACE(@vCodReferencia, @vCodRefFondo + @vDelimitador,'')

	-- codigo vacio
	IF(LEN(@vCodigo)=0) BEGIN
		RETURN @vCodRefSinCodRefFondo
	END

	-- quitamos el codigo al final de la cadena y el caracter delimitador
	SELECT @iNumCars=LEN(@vCodRefSinCodRefFondo)-LEN(@vCodigo)
	SELECT @vReturnValue=null

	IF (@iNumCars>0) BEGIN
		SELECT @vReturnValue=SUBSTRING(@vCodRefSinCodRefFondo,1,@iNumCars-1)
	END

	RETURN @vReturnValue
END --Procedure
GO

CREATE FUNCTION [dbo].[GETNUMERICPOSITIVE]
(	@Source		VARCHAR(40))
RETURNS BIGINT
AS
BEGIN
	DECLARE @ret	BIGINT;
	SELECT @ret = -1
	IF ISNUMERIC(@Source)='1'
	BEGIN
		select @ret = CONVERT (BIGINT,@Source)
	END

	RETURN @ret
END
GO

CREATE FUNCTION [dbo].[GETCODREF](@IDELEMENTO VARCHAR(32),@SEPARATOR VARCHAR(1))
RETURNS VARCHAR(1024)
AS
BEGIN
    DECLARE @ELEMENTOS TABLE (ID VARCHAR, CODIGO VARCHAR, IDPADRE VARCHAR);
	DECLARE @AUXCODREFERENCIA VARCHAR(1024);
	DECLARE @ID VARCHAR(32);
	DECLARE @CODIGO VARCHAR(128);
	DECLARE @IDPADRE VARCHAR(32);

	IF (@IDELEMENTO IS NULL) BEGIN
		SET @AUXCODREFERENCIA = NULL;
	END	ELSE BEGIN
		SET @AUXCODREFERENCIA = '';
		DECLARE ELEMENTOS CURSOR FOR
			WITH CTE_ELEMENTOS (ID, CODIGO, IDPADRE) AS
			(
				SELECT ID, CODIGO, IDPADRE FROM ASGFELEMENTOCF WHERE ID = @IDELEMENTO
				UNION ALL
				SELECT A.ID, A.CODIGO, A.IDPADRE FROM ASGFELEMENTOCF A
				INNER JOIN CTE_ELEMENTOS CTE ON A.ID = CTE.IDPADRE
			)
			SELECT ID, CODIGO, IDPADRE FROM CTE_ELEMENTOS;

		OPEN ELEMENTOS;
		FETCH NEXT FROM ELEMENTOS INTO @ID, @CODIGO, @IDPADRE;

		WHILE @@FETCH_STATUS = 0 BEGIN
			IF (@CODIGO IS NOT NULL) BEGIN
				IF (LEN(@CODIGO) > 0) BEGIN
					IF (@AUXCODREFERENCIA = '') BEGIN
						SET @AUXCODREFERENCIA = @CODIGO;
					END ELSE BEGIN
						SET @AUXCODREFERENCIA = @CODIGO + @SEPARATOR + @AUXCODREFERENCIA;
					END
				END
			END
			FETCH NEXT FROM ELEMENTOS INTO @ID, @CODIGO, @IDPADRE;
		END

		CLOSE ELEMENTOS;
		DEALLOCATE ELEMENTOS;

		IF (@AUXCODREFERENCIA = '') BEGIN
			SET @AUXCODREFERENCIA=NULL;
		END ELSE BEGIN
			DECLARE @CODPAIS VARCHAR(16);
			DECLARE @CODCOMUNIDAD VARCHAR(16);
			DECLARE @CODARCHIVO VARCHAR(32);

			SELECT @CODPAIS=CODPAIS, @CODCOMUNIDAD=CODCOMUNIDAD, @CODARCHIVO=CODARCHIVO FROM ASGFELEMENTOCF ASGFELEMENTOCF, ASGFFONDO ASGFFONDO
			WHERE	ASGFELEMENTOCF.ID=@IDELEMENTO AND
					ASGFELEMENTOCF.IDFONDO=ASGFFONDO.IDELEMENTOCF;

			IF(@CODPAIS IS NOT NULL AND @CODPAIS <> '') BEGIN
				SET @AUXCODREFERENCIA = @CODPAIS + @SEPARATOR + @CODCOMUNIDAD + @SEPARATOR + @CODARCHIVO + @SEPARATOR + @AUXCODREFERENCIA;
			END
		END
		IF (@AUXCODREFERENCIA = '') BEGIN
			SET @AUXCODREFERENCIA=NULL;
		END
	END
    RETURN @AUXCODREFERENCIA;
END;
GO

CREATE FUNCTION [dbo].[GETFINCODREFPADRE](@IDELEMENTO VARCHAR(32),@SEPARATOR VARCHAR(1))
RETURNS VARCHAR(1024)
AS
BEGIN

	DECLARE @AUXFINALCODREFPADRE VARCHAR(1024);
	DECLARE @CODIGOREFERENCIAELEMENTOPADRE VARCHAR(1024);
	DECLARE @CODIGOREFERENCIAFONDO VARCHAR(1024);
	DECLARE @TIPO SMALLINT;

	IF (@IDELEMENTO IS NULL) BEGIN
		SET @AUXFINALCODREFPADRE = NULL;
	END ELSE BEGIN
		SET @AUXFINALCODREFPADRE = '';
		SET @TIPO = -1;


		SET @TIPO=(SELECT TIPO
			FROM ASGFELEMENTOCF
			WHERE ID = @IDELEMENTO);

		IF (@TIPO IN (-1,2,6)) BEGIN
			SET @AUXFINALCODREFPADRE = NULL;
		END ELSE BEGIN

			SELECT @CODIGOREFERENCIAELEMENTOPADRE=dbo.GETCODREF(IDPADRE,@SEPARATOR), @CODIGOREFERENCIAFONDO=dbo.GETCODREF(IDFONDO,@SEPARATOR)
			FROM ASGFELEMENTOCF
			WHERE ID = @IDELEMENTO;

			IF (LEN(@CODIGOREFERENCIAFONDO)>0) BEGIN
             SET @AUXFINALCODREFPADRE = REPLACE(@CODIGOREFERENCIAELEMENTOPADRE,@CODIGOREFERENCIAFONDO + @SEPARATOR,'');
             SET @AUXFINALCODREFPADRE = REPLACE(@AUXFINALCODREFPADRE,@CODIGOREFERENCIAFONDO,'');
			END ELSE BEGIN
             SET @AUXFINALCODREFPADRE = @CODIGOREFERENCIAELEMENTOPADRE;
			END;
		END;
	END;

	IF (LEN(@AUXFINALCODREFPADRE)=0) BEGIN
		SET @AUXFINALCODREFPADRE = NULL;
	END;

    RETURN @AUXFINALCODREFPADRE;
END;
GO

--PROCEDIMIENTOS
CREATE  PROCEDURE dbo.IdsDescendientesNoAsignable ( @Root varchar(32) ) AS
BEGIN
 DECLARE @level int
 SET @level = 1
 DECLARE @descendientesNoAsignable TABLE (
   idHijo varchar(32) NULL,
     nombreHijo varchar(64) NULL,
    idPadre varchar(32)  NULL,
    level int NOT NULL
 )

 INSERT @descendientesNoAsignable (
   idHijo,
    nombreHijo,
   idPadre ,
   level
 )(
 SELECT
  id,
  nombre,
  idPadre,
  @level
 FROM
  asgdelemnoasig
 WHERE
  idPadre=@Root)


 WHILE EXISTS
  (SELECT 1
   FROM
   asgdelemnoasig
   WHERE
   idPadre IN (
    SELECT idHijo
    FROM @descendientesNoAsignable
    WHERE level = @level
    )
  )

  BEGIN
   INSERT @descendientesNoAsignable(idHijo,
        nombreHijo,
        idPadre,
        level)
   SELECT  id,
    nombre,
    idPadre,
    @level + 1
   FROM asgdelemnoasig WHERE idpadre IN
     (SELECT idHijo
     FROM @descendientesNoAsignable
     WHERE level = @level)

   SET @level = @level + 1
  END
 SELECT * FROM @descendientesNoAsignable
END;
GO

CREATE PROCEDURE [dbo].[UPDATECODREF] ( @ROOT VARCHAR(32),@SEPARATOR VARCHAR(1),@UPDTABLES VARCHAR(1)) AS
BEGIN

	-- Este procedimiento requiere que se establezca el idpadre antes de llamar
	-- para actualizar los c�digos de referencia y el resto de campos

	IF(@ROOT IS NOT NULL) BEGIN
		DECLARE @TIPO_ELEMENTO SMALLINT;

		SET	@TIPO_ELEMENTO=(SELECT TIPO FROM ASGFELEMENTOCF WHERE ID=@ROOT);

		IF (@TIPO_ELEMENTO IS NOT NULL) BEGIN

			IF ((@TIPO_ELEMENTO IN (2,3,4,5,6)) AND (@UPDTABLES='S')) BEGIN

				DECLARE @IDFONDO VARCHAR(32);
				DECLARE @CODREFERENCIAFONDO VARCHAR(1024);

				WITH CTE_ELEMENTOS (ID, IDPADRE, TIPO, CODREFERENCIA) AS
				(
					SELECT ID, IDPADRE, TIPO, CODREFERENCIA FROM ASGFELEMENTOCF WHERE ID = @ROOT
					UNION ALL
					SELECT A.ID, A.IDPADRE, A.TIPO, A.CODREFERENCIA FROM ASGFELEMENTOCF A
					INNER JOIN CTE_ELEMENTOS CTE ON A.ID = CTE.IDPADRE
				)
				SELECT @IDFONDO=CTE.ID, @CODREFERENCIAFONDO=dbo.GETCODREF(CTE.ID,@SEPARATOR)
				FROM CTE_ELEMENTOS CTE
				WHERE CTE.TIPO=2;

				-- Actualizar el idfondo a todos sus hijos
				WITH CTE_ELEMENTOS (ID, IDPADRE) AS
				(
						SELECT ID, IDPADRE FROM ASGFELEMENTOCF WHERE ID = @ROOT
						UNION ALL
						SELECT A.ID, A.IDPADRE FROM ASGFELEMENTOCF A
						INNER JOIN CTE_ELEMENTOS CTE ON A.IDPADRE = CTE.ID
					)
				UPDATE ASGFELEMENTOCF SET IDFONDO=@IDFONDO WHERE ID IN (SELECT ID FROM CTE_ELEMENTOS);

				-- Actualizar el idfondo a todas sus series
				WITH CTE_ELEMENTOS (ID, IDPADRE, TIPO) AS
				(
						SELECT ID, IDPADRE, TIPO FROM ASGFELEMENTOCF WHERE ID = @ROOT
						UNION ALL
						SELECT A.ID, A.IDPADRE, A.TIPO FROM ASGFELEMENTOCF A
						INNER JOIN CTE_ELEMENTOS CTE ON A.IDPADRE = CTE.ID
					)
				UPDATE ASGFSERIE SET IDFONDO=@IDFONDO WHERE IDELEMENTOCF IN (SELECT ID FROM CTE_ELEMENTOS WHERE TIPO=4);

				-- Actualizar el idfondo a todas las unidades documentales
				WITH CTE_ELEMENTOS (ID, IDPADRE, TIPO) AS
				(
						SELECT ID, IDPADRE, TIPO FROM ASGFELEMENTOCF WHERE ID = @ROOT
						UNION ALL
						SELECT A.ID, A.IDPADRE, A.TIPO FROM ASGFELEMENTOCF A
						INNER JOIN CTE_ELEMENTOS CTE ON A.IDPADRE = CTE.ID
					)
				UPDATE ASGFUNIDADDOC SET IDFONDO=@IDFONDO WHERE IDELEMENTOCF IN (SELECT ID FROM CTE_ELEMENTOS WHERE TIPO=6);

				-- Actualizar la identificacion a todas las unidades documentales
				WITH CTE_ELEMENTOS (ID, IDPADRE, TIPO) AS
				(
						SELECT ID, IDPADRE, TIPO FROM ASGFELEMENTOCF WHERE ID = @ROOT
						UNION ALL
						SELECT A.ID, A.IDPADRE, A.TIPO FROM ASGFELEMENTOCF A
						INNER JOIN CTE_ELEMENTOS CTE ON A.IDPADRE = CTE.ID
					)
				UPDATE ASGDUDOCENUI SET IDENTIFICACION=@CODREFERENCIAFONDO + '-'+ SIGNATURAUDOC WHERE IDUNIDADDOC IN (SELECT ID FROM CTE_ELEMENTOS WHERE TIPO=6);

				-- Actualizar la identificacion de las unidades de instalaci�n
				WITH CTE_ELEMENTOS (ID, IDPADRE, TIPO) AS
				(
						SELECT ID, IDPADRE, TIPO FROM ASGFELEMENTOCF WHERE ID = @ROOT
						UNION ALL
						SELECT A.ID, A.IDPADRE, A.TIPO FROM ASGFELEMENTOCF A
						INNER JOIN CTE_ELEMENTOS CTE ON A.IDPADRE = CTE.ID
					)
				UPDATE ASGDUINSTALACION SET IDENTIFICACION=@CODREFERENCIAFONDO + '.'+ SIGNATURAUI WHERE ID IN (SELECT ASGDUDOCENUI.IDUINSTALACION FROM CTE_ELEMENTOS CTE, ASGDUDOCENUI ASGDUDOCENUI WHERE CTE.TIPO=6 AND CTE.ID=ASGDUDOCENUI.IDUNIDADDOC);

			END;

			IF ((@TIPO_ELEMENTO IN (6)) AND (@UPDTABLES='S')) BEGIN

				DECLARE @IDSERIE VARCHAR(32);

				WITH CTE_ELEMENTOS (ID, IDPADRE, TIPO) AS
				(
					SELECT ID, IDPADRE, TIPO FROM ASGFELEMENTOCF WHERE ID = @ROOT
					UNION ALL
					SELECT A.ID, A.IDPADRE, A.TIPO FROM ASGFELEMENTOCF A
					INNER JOIN CTE_ELEMENTOS CTE ON A.ID = CTE.IDPADRE
				)
				SELECT @IDSERIE=CTE.ID
				FROM CTE_ELEMENTOS CTE
				WHERE CTE.TIPO=4;

				-- Actualizar el idserie a las unidades documentales
				WITH CTE_ELEMENTOS (ID, IDPADRE, TIPO) AS
				(
						SELECT ID, IDPADRE, TIPO FROM ASGFELEMENTOCF WHERE ID = @ROOT
						UNION ALL
						SELECT A.ID, A.IDPADRE, A.TIPO FROM ASGFELEMENTOCF A
						INNER JOIN CTE_ELEMENTOS CTE ON A.IDPADRE = CTE.ID
					)
				UPDATE ASGFUNIDADDOC SET IDSERIE=@IDSERIE WHERE IDELEMENTOCF IN (SELECT ID FROM CTE_ELEMENTOS WHERE TIPO=6);
			END;

			IF (@TIPO_ELEMENTO IN (6)) BEGIN
				UPDATE ASGFELEMENTOCF SET CODREFFONDO=COALESCE(dbo.GETCODREF(IDFONDO,@SEPARATOR),NULL), CODREFERENCIA = dbo.GETCODREF(@ROOT,@SEPARATOR), FINALCODREFPADRE=dbo.GETFINCODREFPADRE(@ROOT,@SEPARATOR)
				WHERE ID=@ROOT;
			END ELSE BEGIN
				DECLARE @ID VARCHAR(32);
				DECLARE @TIPO SMALLINT;
				DECLARE ELEMENTOS_NO_SERIE CURSOR FOR
					WITH CTE_ELEMENTOS (ID, CODIGO, IDPADRE, TIPO) AS
					(
						SELECT ID, CODIGO, IDPADRE, TIPO FROM ASGFELEMENTOCF WHERE ID = @ROOT
						UNION ALL
						SELECT A.ID, A.CODIGO, A.IDPADRE, A.TIPO FROM ASGFELEMENTOCF A
						INNER JOIN CTE_ELEMENTOS CTE ON A.IDPADRE = CTE.ID
					)
					SELECT ID, TIPO FROM CTE_ELEMENTOS CTE
					WHERE CTE.TIPO NOT IN (4,6);

				OPEN ELEMENTOS_NO_SERIE;

				FETCH NEXT FROM ELEMENTOS_NO_SERIE INTO @ID, @TIPO;

				WHILE @@FETCH_STATUS = 0 BEGIN
					UPDATE ASGFELEMENTOCF SET CODREFFONDO=COALESCE(dbo.GETCODREF(IDFONDO,@SEPARATOR),NULL), CODREFERENCIA = dbo.GETCODREF(@ID,@SEPARATOR), FINALCODREFPADRE=dbo.GETFINCODREFPADRE(@ID,@SEPARATOR)
					WHERE ID=@ID;
					FETCH NEXT FROM ELEMENTOS_NO_SERIE INTO @ID, @TIPO;
				END

				CLOSE ELEMENTOS_NO_SERIE;
				DEALLOCATE ELEMENTOS_NO_SERIE;

				DECLARE ELEMENTOS_SERIE CURSOR FOR
					WITH CTE_ELEMENTOS (ID, CODIGO, IDPADRE, TIPO) AS
					(
						SELECT ID, CODIGO, IDPADRE, TIPO FROM ASGFELEMENTOCF WHERE ID = @ROOT
						UNION ALL
						SELECT A.ID, A.CODIGO, A.IDPADRE, A.TIPO FROM ASGFELEMENTOCF A
						INNER JOIN CTE_ELEMENTOS CTE ON A.IDPADRE = CTE.ID
					)
					SELECT ID, TIPO FROM CTE_ELEMENTOS CTE
					WHERE CTE.TIPO=4;

				OPEN ELEMENTOS_SERIE;

				FETCH NEXT FROM ELEMENTOS_SERIE INTO @ID, @TIPO;

				WHILE @@FETCH_STATUS = 0 BEGIN

					UPDATE ASGFELEMENTOCF SET CODREFFONDO=COALESCE(dbo.GETCODREF(IDFONDO,@SEPARATOR),NULL), CODREFERENCIA = dbo.GETCODREF(@ID,@SEPARATOR), FINALCODREFPADRE=dbo.GETFINCODREFPADRE(@ID,@SEPARATOR)
					WHERE ID=@ID;
					UPDATE ASGFELEMENTOCF SET CODREFFONDO=COALESCE(dbo.GETCODREF(IDFONDO,@SEPARATOR),NULL), CODREFERENCIA = dbo.GETCODREF(@ID,@SEPARATOR) + @SEPARATOR + CODIGO, FINALCODREFPADRE=NULL
					WHERE IDPADRE=@ID;
					FETCH NEXT FROM ELEMENTOS_SERIE INTO @ID, @TIPO;
				END

				CLOSE ELEMENTOS_SERIE;
				DEALLOCATE ELEMENTOS_SERIE;
			END;
		END;
	END;
END;
GO

-- Permisos para funciones de la versi�n 4.0
-- Es necesario modificar el nombre de usuario

DECLARE @usuario VARCHAR(50);

--SET @usuario = N'archidoc';
SET @usuario = N'archivo';

--FUNCIONES
exec ('grant execute on GREATEST                     to '+ @usuario);
exec ('grant execute on DEVOLVERMARCA                to '+ @usuario);
exec ('grant execute on CALCULARFINALCODREFPADRE     to '+ @usuario);
exec ('grant execute on GETNUMERICPOSITIVE           to '+ @usuario);
exec ('grant execute on GETCODREF           		to '+ @usuario);
exec ('grant execute on GETFINCODREFPADRE      		to '+ @usuario);
exec ('grant execute on UPDATECODREF           		to '+ @usuario);


--PROCEDIMIENTOS
exec ('grant execute on IdsDescendientesNoAsignable to '+ @usuario);
