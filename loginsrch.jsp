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
ew_SecTable[0] = 12;
ew_SecTable[1] = 12;
ew_SecTable[2] = 12;
ew_SecTable[3] = 12;
ew_SecTable[4] = 12;

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
	response.sendRedirect("loginlist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<% String userid = (String) session.getAttribute("sighs_status_UserID"); 
Integer userlevel = (Integer) session.getAttribute("sighs_status_UserLevel"); 
if (userid == null && userlevel != null && (userlevel.intValue() != -1) ) {	response.sendRedirect("login.jsp");
	response.flushBuffer(); 
	return; 
}%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
	String x_Login =  "";
	String x_Senha =  "";
	String x_Nivel =  "";
	String x_eMail =  "";
String tmpfld = null;
String escapeString = "\\\\'";

// Get action
String a = request.getParameter("a");
String this_search_criteria = "";
if (a != null && a.equals("S")) { // Get Search Criteria

	// Build search criteria for advanced search, remove blank field
	String search_criteria = "";

	// Login
	if (request.getParameter("x_Login") != null){
		x_Login = request.getParameter("x_Login");
	}
	String z_Login = "";
	if (request.getParameterValues("z_Login") != null){
		String [] ary_z_Login = request.getParameterValues("z_Login");
		for (int i =0; i < ary_z_Login.length; i++){
			z_Login += ary_z_Login[i] + ",";
		}
		z_Login = z_Login.substring(0,z_Login.length()-1);
	}
	this_search_criteria = "";
	if (x_Login.length() > 0) {
		String srchFld = x_Login;
		this_search_criteria = "x_Login=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Login=" + URLEncoder.encode(z_Login,"UTF-8");
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

	// Senha
	if (request.getParameter("x_Senha") != null){
		x_Senha = request.getParameter("x_Senha");
	}
	String z_Senha = "";
	if (request.getParameterValues("z_Senha") != null){
		String [] ary_z_Senha = request.getParameterValues("z_Senha");
		for (int i =0; i < ary_z_Senha.length; i++){
			z_Senha += ary_z_Senha[i] + ",";
		}
		z_Senha = z_Senha.substring(0,z_Senha.length()-1);
	}
	this_search_criteria = "";
	if (x_Senha.length() > 0) {
		String srchFld = x_Senha;
		this_search_criteria = "x_Senha=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Senha=" + URLEncoder.encode(z_Senha,"UTF-8");
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

	// Nivel
	if (request.getParameter("x_Nivel") != null){
		x_Nivel = request.getParameter("x_Nivel");
	}
	String z_Nivel = "";
	if (request.getParameterValues("z_Nivel") != null){
		String [] ary_z_Nivel = request.getParameterValues("z_Nivel");
		for (int i =0; i < ary_z_Nivel.length; i++){
			z_Nivel += ary_z_Nivel[i] + ",";
		}
		z_Nivel = z_Nivel.substring(0,z_Nivel.length()-1);
	}
	this_search_criteria = "";
	if (x_Nivel.length() > 0) {
		String srchFld = x_Nivel;
		this_search_criteria = "x_Nivel=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Nivel=" + URLEncoder.encode(z_Nivel,"UTF-8");
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

	// eMail
	if (request.getParameter("x_eMail") != null){
		x_eMail = request.getParameter("x_eMail");
	}
	String z_eMail = "";
	if (request.getParameterValues("z_eMail") != null){
		String [] ary_z_eMail = request.getParameterValues("z_eMail");
		for (int i =0; i < ary_z_eMail.length; i++){
			z_eMail += ary_z_eMail[i] + ",";
		}
		z_eMail = z_eMail.substring(0,z_eMail.length()-1);
	}
	this_search_criteria = "";
	if (x_eMail.length() > 0) {
		String srchFld = x_eMail;
		this_search_criteria = "x_eMail=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_eMail=" + URLEncoder.encode(z_eMail,"UTF-8");
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
		response.sendRedirect("loginlist.jsp" + "?" + search_criteria);
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
<p><span class="jspmaker">Procurar TABELA: Login<br><br><a href="loginlist.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="loginsrch.jsp" method="post">
<p>
<input type="hidden" name="a" value="S">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Login</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Login" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Login" size="10" maxlength="10" value="<%= HTMLEncode((String)x_Login) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Senha</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Senha" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="password" name="x_Senha" value="<%= x_Senha %>" size=30 maxlength=10></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Nivel</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Nivel" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if ((ewCurSec & ewAllowAdmin) == ewAllowAdmin) { // system admin %>
<%
String cbo_x_Nivel_js = "";
String x_NivelList = "<select name=\"x_Nivel\"><option value=\"\">Selecione</option>";
x_NivelList += "<option value=\"" + HTMLEncode("1") + "\"";
if (x_Nivel != null && x_Nivel.equals("1")) {
	x_NivelList += " selected";
}
x_NivelList += ">" + "Administrador" + "</option>";
x_NivelList += "<option value=\"" + HTMLEncode("2") + "\"";
if (x_Nivel != null && x_Nivel.equals("2")) {
	x_NivelList += " selected";
}
x_NivelList += ">" + "Chefia" + "</option>";
x_NivelList += "<option value=\"" + HTMLEncode("3") + "\"";
if (x_Nivel != null && x_Nivel.equals("3")) {
	x_NivelList += " selected";
}
x_NivelList += ">" + "Tecnico" + "</option>";
x_NivelList += "<option value=\"" + HTMLEncode("4") + "\"";
if (x_Nivel != null && x_Nivel.equals("4")) {
	x_NivelList += " selected";
}
x_NivelList += ">" + "Gerencia" + "</option>";
x_NivelList += "<option value=\"" + HTMLEncode("5") + "\"";
if (x_Nivel != null && x_Nivel.equals("5")) {
	x_NivelList += " selected";
}
x_NivelList += ">" + "SuperUsu" + "</option>";
x_NivelList += "</select>";
out.print(x_NivelList);
%>
<% } else { %>
********
<% } %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">e Mail</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_eMail" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_eMail" size="100" maxlength="255" value="<%= HTMLEncode((String)x_eMail) %>"></span>&nbsp;</td>
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
