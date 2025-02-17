<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-html-el.tld" prefix="html-el" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-bean-el.tld" prefix="bean-el" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="/WEB-INF/taglibs/displaydepositotags.tld" prefix="archivo"%>
<%@ taglib uri="/WEB-INF/archigest-adds.tld" prefix="pa" %>

<bean:struts id="actionMapping" mapping="/gestionMotivosRechazo" />
<c:set var="motivo" value="${sessionScope[appConstants.solicitudes.MOTIVO_KEY]}"/>

<tiles:insert template="/pages/tiles/PABoxLayout.jsp">
	<tiles:put name="boxTitle" direct="true">
		<bean:message key="NavigationTitle_MOTIVO_RECHAZO_DATOS"/>
	</tiles:put>

	<tiles:put name="buttonBar" direct="true">
		<table cellpadding=0 cellspacing=0>
			<tr>
				<td>
					<c:url var="eliminarMotivoURL" value="/action/gestionMotivosRechazo">
						<c:param name="method" value="eliminarMotivo"/>
						<c:param name="idMotivo" value="${motivo.id}" />
					</c:url>

					<a class="etiquetaAzul12Bold" href='<c:out value="${eliminarMotivoURL}" escapeXml="false" />'>
					<html:img page="/pages/images/deleteDoc.gif" altKey="archigest.archivo.eliminar" titleKey="archigest.archivo.eliminar" styleClass="imgTextMiddle" />
					&nbsp;<bean:message key="archigest.archivo.eliminar"/></a>
	      	  	</td>
	      	  	<td width="10">&nbsp;</td>
				<td nowrap>
					<tiles:insert definition="button.closeButton" flush="false" />
				</td>
			</tr>
		</table>
	</tiles:put>

	<tiles:put name="boxContent" direct="true">
		<tiles:insert template="/pages/tiles/PABlockLayout.jsp">
			<tiles:put name="blockTitle" direct="true">
      			<bean:message key="archigest.archivo.informacion"/>
    		</tiles:put>

			<tiles:put name="buttonBar" direct="true">
				<table cellpadding=0 cellspacing=0>
					<tr>
						<td>
							<c:url var="editarMotivoURL" value="/action/gestionMotivosRechazo">
								<c:param name="method" value="editarMotivo"/>
								<c:param name="idMotivo" value="${motivo.id}"/>
							</c:url>

							<a class="etiquetaAzul12Bold" href="<c:out value="${editarMotivoURL}" escapeXml="false" />" >
								<html:img page="/pages/images/editDoc.gif" altKey="archigest.archivo.editar"
									titleKey="archigest.archivo.editar" styleClass="imgTextMiddle" />
								<bean:message key="archigest.archivo.editar"/>
							</a>
						</td>
					</tr>
				</table>
			</tiles:put>

			<tiles:put name="blockContent" direct="true">
				<table class="formulario" width="99%">
			    	<tr>
			          <td class="tdTitulo" width="200px">
			            <bean:message key="archigest.archivo.descripcion"/>:&nbsp;
			          </td>
			          <td class="tdDatos"><bean:write name="motivo" property="motivo"/></td>
			        </tr>
			    </table>
			    <table class="formulario" width="99%">
			    	<tr>
			          <td class="tdTitulo" width="200px">
			            <bean:message key="archigest.archivo.solicitudes.tipoSolicitud"/>:&nbsp;
			          </td>
			          <td class="tdDatos">
						<c:choose>
			          		<c:when test="${motivo.tipoSolicitud == 1}">
			          			<bean:message key="archigest.archivo.solicitudes.consulta"/>
			          		</c:when>
			          		<c:when test="${motivo.tipoSolicitud == 2}">
			          			<bean:message key="archigest.archivo.solicitudes.prestamo"/>
			          		</c:when>
			          		<c:when test="${motivo.tipoSolicitud == 3}">
			          			<bean:message key="archigest.archivo.solicitudes.prorroga"/>
			          		</c:when>
			          	</c:choose>
					  </td>
			        </tr>
			    </table>
			</tiles:put>
		</tiles:insert>
	</tiles:put>
</tiles:insert>