package com.ieci.tecdoc.common.invesicres;

import java.io.Serializable;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

/** 
 *        @hibernate.class
 *         table="SCR_REPORTARCH"
 *     
*/
public class ScrReportarch implements Serializable {

    /** identifier field */
    private Integer id;

    /** persistent field */
    private int idReport;

    /** persistent field */
    private int idArch;

    /** full constructor */
    public ScrReportarch(Integer id, int idReport, int idArch) {
        this.id = id;
        this.idReport = idReport;
        this.idArch = idArch;
    }

    /** default constructor */
    public ScrReportarch() {
    }

    /** 
     *            @hibernate.id
     *             generator-class="assigned"
     *             type="java.lang.Integer"
     *             column="ID"
     *         
     */
    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    /** 
     *            @hibernate.property
     *             column="ID_REPORT"
     *             length="10"
     *             not-null="true"
     *         
     */
    public int getIdReport() {
        return this.idReport;
    }

    public void setIdReport(int idReport) {
        this.idReport = idReport;
    }

    /** 
     *            @hibernate.property
     *             column="ID_ARCH"
     *             length="10"
     *             not-null="true"
     *         
     */
    public int getIdArch() {
        return this.idArch;
    }

    public void setIdArch(int idArch) {
        this.idArch = idArch;
    }

    public String toString() {
        return new ToStringBuilder(this)
            .append("id", getId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( !(other instanceof ScrReportarch) ) return false;
        ScrReportarch castOther = (ScrReportarch) other;
        return new EqualsBuilder()
            .append(this.getId(), castOther.getId())
            .isEquals();
    }

    
         
                                       
//************************************
// Incluido pos ISicres-Common Oracle 9i


public String toXML() {
       String className = getClass().getName();
       className = className.substring(className.lastIndexOf(".") + 1, className.length()).toUpperCase();
       StringBuffer buffer = new StringBuffer();
       buffer.append("<");
       buffer.append(className);
       buffer.append(">");
       try {
           java.lang.reflect.Field[] fields = getClass().getDeclaredFields();
           java.lang.reflect.Field field = null;
           String name = null;
           int size = fields.length;
           for (int i = 0; i < size; i++) {
               field = fields[i];
               name = field.getName();
               buffer.append("<");
               buffer.append(name.toUpperCase());
               buffer.append(">");
               if (field.get(this) != null) {
                   buffer.append(field.get(this));
               }
               buffer.append("</");
               buffer.append(name.toUpperCase());
               buffer.append(">");
           }
       } catch (Exception e) {
           e.printStackTrace(System.err);
       }
       buffer.append("</");
       buffer.append(className);
       buffer.append(">");
       return buffer.toString();
}
                               
//************************************  
                                                                                                                                                                   
public int hashCode() {
      
        return new HashCodeBuilder()
            .append(getId())
            .toHashCode();
    }

}
