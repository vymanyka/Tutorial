<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*,java.net.*"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
response.setDateHeader("Expires", 0); // date in the past
response.addHeader("Cache-Control", "no-store, no-cache, must-revalidate"); // HTTP/1.1 
response.addHeader("Cache-Control", "post-check=0, pre-check=0"); 
response.addHeader("Pragma", "no-cache"); // HTTP/1.0 
%>
<% Locale locale = Locale.getDefault();
response.setLocale(locale);%>
<% session.setMaxInactiveInterval(30*60); %>
<% 
String login = (String) session.getAttribute("sighs_status");
if (login == null || !login.equals("login")) {
response.sendRedirect("login.jsp");
response.flushBuffer(); 
return; 
}%>
<% 

// user levels
final int ewAllowAdd = 1;
final int ewAllowDelete = 2;
final int ewAllowEdit = 4;
final int ewAllowView = 8;
final int ewAllowList = 8;
final int ewAllowSearch = 8;
final int ewAllowAdmin = 16;
int [] ew_SecTable = new int[4+1];
ew_SecTable[0] = 8;
ew_SecTable[1] = 8;
ew_SecTable[2] = 8;
ew_SecTable[3] = 8;
ew_SecTable[4] = 15;

// get current table security
int ewCurSec = 0; // initialise
if (session.getAttribute("sighs_status_UserLevel") != null) {
	int ewCurIdx = ((Integer) session.getAttribute("sighs_status_UserLevel")).intValue();
	if (ewCurIdx == -1) { // system administrator
		ewCurSec = 31;
	} else if (ewCurIdx > 0 && ewCurIdx <= 5) { 
		ewCurSec = ew_SecTable[ewCurIdx-1];
	}
}
if ((ewCurSec & ewAllowSearch) != ewAllowSearch) {
	response.sendRedirect("estoquelist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
	String x_id_Componente =  "";
	String x_Qtd_novo =  "";
	String x_Qtd_seminovo =  "";
	String x_Qtd_recuperavel =  "";
	String x_Qtd_irrecuperavel =  "";
String tmpfld = null;
String escapeString = "\\\\'";

// Get action
String a = request.getParameter("a");
String this_search_criteria = "";
if (a != null && a.equals("S")) { // Get Search Criteria

	// Build search criteria for advanced search, remove blank field
	String search_criteria = "";

	// id_Componente
	if (request.getParameter("x_id_Componente") != null){
		x_id_Componente = request.getParameter("x_id_Componente");
	}
	String z_id_Componente = "";
	if (request.getParameterValues("z_id_Componente") != null){
		String [] ary_z_id_Componente = request.getParameterValues("z_id_Componente");
		for (int i =0; i < ary_z_id_Componente.length; i++){
			z_id_Componente += ary_z_id_Componente[i] + ",";
		}
		z_id_Componente = z_id_Componente.substring(0,z_id_Componente.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Componente.length() > 0) {
		String srchFld = x_id_Componente;
		this_search_criteria = "x_id_Componente=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Componente=" + URLEncoder.encode(z_id_Componente,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// Qtd_novo
	if (request.getParameter("x_Qtd_novo") != null){
		x_Qtd_novo = request.getParameter("x_Qtd_novo");
	}
	String z_Qtd_novo = "";
	if (request.getParameterValues("z_Qtd_novo") != null){
		String [] ary_z_Qtd_novo = request.getParameterValues("z_Qtd_novo");
		for (int i =0; i < ary_z_Qtd_novo.length; i++){
			z_Qtd_novo += ary_z_Qtd_novo[i] + ",";
		}
		z_Qtd_novo = z_Qtd_novo.substring(0,z_Qtd_novo.length()-1);
	}
	this_search_criteria = "";
	if (x_Qtd_novo.length() > 0) {
		String srchFld = x_Qtd_novo;
		this_search_criteria = "x_Qtd_novo=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Qtd_novo=" + URLEncoder.encode(z_Qtd_novo,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// Qtd_seminovo
	if (request.getParameter("x_Qtd_seminovo") != null){
		x_Qtd_seminovo = request.getParameter("x_Qtd_seminovo");
	}
	String z_Qtd_seminovo = "";
	if (request.getParameterValues("z_Qtd_seminovo") != null){
		String [] ary_z_Qtd_seminovo = request.getParameterValues("z_Qtd_seminovo");
		for (int i =0; i < ary_z_Qtd_seminovo.length; i++){
			z_Qtd_seminovo += ary_z_Qtd_seminovo[i] + ",";
		}
		z_Qtd_seminovo = z_Qtd_seminovo.substring(0,z_Qtd_seminovo.length()-1);
	}
	this_search_criteria = "";
	if (x_Qtd_seminovo.length() > 0) {
		String srchFld = x_Qtd_seminovo;
		this_search_criteria = "x_Qtd_seminovo=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Qtd_seminovo=" + URLEncoder.encode(z_Qtd_seminovo,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// Qtd_recuperavel
	if (request.getParameter("x_Qtd_recuperavel") != null){
		x_Qtd_recuperavel = request.getParameter("x_Qtd_recuperavel");
	}
	String z_Qtd_recuperavel = "";
	if (request.getParameterValues("z_Qtd_recuperavel") != null){
		String [] ary_z_Qtd_recuperavel = request.getParameterValues("z_Qtd_recuperavel");
		for (int i =0; i < ary_z_Qtd_recuperavel.length; i++){
			z_Qtd_recuperavel += ary_z_Qtd_recuperavel[i] + ",";
		}
		z_Qtd_recuperavel = z_Qtd_recuperavel.substring(0,z_Qtd_recuperavel.length()-1);
	}
	this_search_criteria = "";
	if (x_Qtd_recuperavel.length() > 0) {
		String srchFld = x_Qtd_recuperavel;
		this_search_criteria = "x_Qtd_recuperavel=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Qtd_recuperavel=" + URLEncoder.encode(z_Qtd_recuperavel,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// Qtd_irrecuperavel
	if (request.getParameter("x_Qtd_irrecuperavel") != null){
		x_Qtd_irrecuperavel = request.getParameter("x_Qtd_irrecuperavel");
	}
	String z_Qtd_irrecuperavel = "";
	if (request.getParameterValues("z_Qtd_irrecuperavel") != null){
		String [] ary_z_Qtd_irrecuperavel = request.getParameterValues("z_Qtd_irrecuperavel");
		for (int i =0; i < ary_z_Qtd_irrecuperavel.length; i++){
			z_Qtd_irrecuperavel += ary_z_Qtd_irrecuperavel[i] + ",";
		}
		z_Qtd_irrecuperavel = z_Qtd_irrecuperavel.substring(0,z_Qtd_irrecuperavel.length()-1);
	}
	this_search_criteria = "";
	if (x_Qtd_irrecuperavel.length() > 0) {
		String srchFld = x_Qtd_irrecuperavel;
		this_search_criteria = "x_Qtd_irrecuperavel=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Qtd_irrecuperavel=" + URLEncoder.encode(z_Qtd_irrecuperavel,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}
	if (search_criteria.length() > 0) {
		out.clear();
		response.sendRedirect("estoquelist.jsp" + "?" + search_criteria);
		response.flushBuffer();
		return;
	}
}

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Procurar TABELA: Estoque<br><br><a href="estoquelist.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_id_Componente && !EW_checkinteger(EW_this.x_id_Componente.value)) {
        if (!EW_onError(EW_this, EW_this.x_id_Componente, "TEXT", "Numero inteiro invalido! - id Componente"))
            return false; 
        }
if (EW_this.x_Qtd_novo && !EW_checkinteger(EW_this.x_Qtd_novo.value)) {
        if (!EW_onError(EW_this, EW_this.x_Qtd_novo, "TEXT", "Numero inteiro invalido! - Novo"))
            return false; 
        }
if (EW_this.x_Qtd_seminovo && !EW_checkinteger(EW_this.x_Qtd_seminovo.value)) {
        if (!EW_onError(EW_this, EW_this.x_Qtd_seminovo, "TEXT", "Numero inteiro invalido! - Seminovo"))
            return false; 
        }
if (EW_this.x_Qtd_recuperavel && !EW_checkinteger(EW_this.x_Qtd_recuperavel.value)) {
        if (!EW_onError(EW_this, EW_this.x_Qtd_recuperavel, "TEXT", "Numero inteiro invalido! - Recuperavel"))
            return false; 
        }
if (EW_this.x_Qtd_irrecuperavel && !EW_checkinteger(EW_this.x_Qtd_irrecuperavel.value)) {
        if (!EW_onError(EW_this, EW_this.x_Qtd_irrecuperavel, "TEXT", "Numero inteiro invalido! - Irrecuperavel"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="estoquesrch.jsp" method="post">
<p>
<input type="hidden" name="a" value="S">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">id Componente</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Componente" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_id_Componente" size="30" value="<%= HTMLEncode((String)x_id_Componente) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Novo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Qtd_novo" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Qtd_novo" size="30" value="<%= HTMLEncode((String)x_Qtd_novo) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Seminovo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Qtd_seminovo" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Qtd_seminovo" size="30" value="<%= HTMLEncode((String)x_Qtd_seminovo) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Recuperavel</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Qtd_recuperavel" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Qtd_recuperavel" size="30" value="<%= HTMLEncode((String)x_Qtd_recuperavel) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Irrecuperavel</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Qtd_irrecuperavel" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Qtd_irrecuperavel" size="30" value="<%= HTMLEncode((String)x_Qtd_irrecuperavel) %>"></span>&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Procurar">
</form>
<%@ include file="footer.jsp" %>
<%
	conn.close();
	conn = null;
}catch(SQLException ex){
	out.println(ex.toString());
}
%>
