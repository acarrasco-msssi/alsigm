/**
 * ListaUsuarios.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.3 Oct 05, 2005 (05:23:37 EDT) WSDL2Java emitter.
 */

package es.ieci.tecdoc.sigem.AdministracionUsuariosPortalWebService;

public class ListaUsuarios  extends es.ieci.tecdoc.sigem.AdministracionUsuariosPortalWebService.RetornoServicio  implements java.io.Serializable {
    private es.ieci.tecdoc.sigem.AdministracionUsuariosPortalWebService.ArrayOfUsuario users;

    public ListaUsuarios() {
    }

    public ListaUsuarios(
           java.lang.String errorCode,
           java.lang.String returnCode,
           es.ieci.tecdoc.sigem.AdministracionUsuariosPortalWebService.ArrayOfUsuario users) {
        super(
            errorCode,
            returnCode);
        this.users = users;
    }


    /**
     * Gets the users value for this ListaUsuarios.
     * 
     * @return users
     */
    public es.ieci.tecdoc.sigem.AdministracionUsuariosPortalWebService.ArrayOfUsuario getUsers() {
        return users;
    }


    /**
     * Sets the users value for this ListaUsuarios.
     * 
     * @param users
     */
    public void setUsers(es.ieci.tecdoc.sigem.AdministracionUsuariosPortalWebService.ArrayOfUsuario users) {
        this.users = users;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ListaUsuarios)) return false;
        ListaUsuarios other = (ListaUsuarios) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.users==null && other.getUsers()==null) || 
             (this.users!=null &&
              this.users.equals(other.getUsers())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = super.hashCode();
        if (getUsers() != null) {
            _hashCode += getUsers().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ListaUsuarios.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://server.ws.usuario.sgm.tecdoc.ieci", "ListaUsuarios"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("users");
        elemField.setXmlName(new javax.xml.namespace.QName("http://server.ws.usuario.sgm.tecdoc.ieci", "users"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://server.ws.usuario.sgm.tecdoc.ieci", "ArrayOfUsuario"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
