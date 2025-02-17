<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%
String rutaEstilos = (String)session.getAttribute("PARAMETRO_RUTA_ESTILOS");
if (rutaEstilos == null) rutaEstilos = "";
String rutaImagenes = (String)session.getAttribute("PARAMETRO_RUTA_IMAGENES");
if (rutaImagenes == null) rutaImagenes = "";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="es" xml:lang="es">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta name="author" content="IECISA" />
<title>sigem</title>
<link href="css/<%=rutaEstilos%>estilos.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" language="javascript" src="js/idioma.js"></script>
</head>
<body>
<div id="contenedora">
  <!-- Inicio Cabecera -->
	<jsp:include page="cabecera.jsp"/>
	
  <div id="migas">
  <img src="img/<%=rutaImagenes%>flecha_migas.gif" width="13" height="9" class="margen" alt=""/>
  <a href="<html:rewrite page="/buscarLiquidaciones.do"/>"><bean:message key="ieci.tecdoc.sgm.pe.struts.common.liquidaciones.label"/></a> &gt;<span class="activo"> <bean:message key="ieci.tecdoc.sgm.pe.struts.common.formularioPago"/></span></div>
  <!-- Fin Cabecera -->
  <!-- Inicio Contenido -->
  <div id="contenido">
    <div class="cuerpo">
      <div class="cuerporight">
        <div class="cuerpomid">
          <h1><bean:message key="ieci.tecdoc.sgm.pe.struts.common.liquidaciones.formulario.title"/></h1>
          <div class="submenu3">
            <ul>
            </ul>
          </div>
          <div class="cuadro">
          <div class="cuadroForm" style="width: 750px;">
			<logic:present name="mensajeError">
			<p style="font-weight:bold;color: #ff0000;text-align: middle;">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<bean:write name="mensajeError"/></p>
			</logic:present>
	          <html:form action="mostrarLiquidacionParaFirmar.do" styleId="formulario">
			<div style="position:relative;left:50px;top:0px;width:690px;height:370px;">          	          
				<%=request.getAttribute("formulario")%>
			</div>
			<div style="position:relative;left:270px;height:60px;">     
				<html:button property="Enviar" styleId="boton" onclick="javascript:validarEnvio();"><bean:message key="ieci.tecdoc.sgm.pe.struts.common.validate"/></html:button>
			</div>
	          </html:form>			
          </div>
          </div>
        </div>
      </div>
    </div>
    <div class="cuerpobt">
      <div class="cuerporightbt">
        <div class="cuerpomidbt"></div>
      </div>
    </div>
  </div>
  <!-- Fin Contenido -->
  <div id="pie"></div>
</div>
</body>
</html>
