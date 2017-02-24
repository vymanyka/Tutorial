<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"%>
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
if ((ewCurSec & ewAllowEdit) != ewAllowEdit) {
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
String tmpfld = null;
String escapeString = "\\\\'";
request.setCharacterEncoding("UTF-8");
String key = request.getParameter("key");
if (key == null || key.length() == 0 ) {
	response.sendRedirect("loginlist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_Login = null;
Object x_Senha = null;
Object x_Nivel = null;
Object x_eMail = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `login` WHERE `Login`=" + tkey;
		if (session.getAttribute("sighs_status_UserLevel")!= null && ((Integer) session.getAttribute("sighs_status_UserLevel")).intValue() != -1) { // Non system admin
			strsql = strsql + " AND (`Login` = '" + (String) session.getAttribute("sighs_status_UserID") + "')";
		}
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("loginlist.jsp");
			response.flushBuffer();
			return;
		}else{
			rs.first();

			// Get the field contents
			if (rs.getString("Login") != null){
				x_Login = rs.getString("Login");
			}else{
				x_Login = "";
			}
			if (rs.getString("Senha") != null){
				x_Senha = rs.getString("Senha");
			}else{
				x_Senha = "";
			}
	x_Nivel = String.valueOf(rs.getLong("Nivel"));
			if (rs.getString("eMail") != null){
				x_eMail = rs.getString("eMail");
			}else{
				x_eMail = "";
			}
		}
		rs.close();
	}else if (a.equals("U")) {// Update

		// Get fields from form
		if (request.getParameter("x_Login") != null){
			x_Login = (String) request.getParameter("x_Login");
		}else{
			x_Login = "";
		}
		if (request.getParameter("x_Senha") != null){
			x_Senha = (String) request.getParameter("x_Senha");
		}else{
			x_Senha = "";
		}
		if (request.getParameter("x_Nivel") != null){
			x_Nivel = request.getParameter("x_Nivel");
		}
		if (request.getParameter("x_eMail") != null){
			x_eMail = (String) request.getParameter("x_eMail");
		}else{
			x_eMail = "";
		}

		// Open record
		String tkey = "'" + key.replaceAll("'",escapeString) + "'";
		String strsql = "SELECT * FROM `login` WHERE `Login`=" + tkey;
		Integer userLevel = (Integer) session.getAttribute("sighs_status_UserLevel");
    	if (userLevel != null && userLevel.intValue() != -1) { // Non system admin
			strsql += " AND (`Login` = '" + (String) session.getAttribute("sighs_status_UserID") + "')";
		}
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("loginlist.jsp");
			response.flushBuffer();
			return;
		}

		// Field Login
		tmpfld = ((String) x_Login);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("Login");
		}else{
			rs.updateString("Login", tmpfld);
		}

		// Field Senha
		tmpfld = ((String) x_Senha);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("Senha");
		}else{
			rs.updateString("Senha", tmpfld);
		}
		if ((ewCurSec & ewAllowAdmin) == ewAllowAdmin) { // System admin

		// Field Nivel
		tmpfld = ((String) x_Nivel).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("Nivel");
		} else {
			rs.updateInt("Nivel",Integer.parseInt(tmpfld));
		}
		}

		// Field eMail
		tmpfld = ((String) x_eMail);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("eMail");
		}else{
			rs.updateString("eMail", tmpfld);
		}
		rs.updateRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("loginlist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
		out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Editar TABELA: Login<br><br><a href="loginlist.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_Login && !EW_hasValue(EW_this.x_Login, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_Login, "TEXT", "Forneca o login (ate dez caracteres)!"))
                return false; 
        }
if (EW_this.x_Senha && !EW_hasValue(EW_this.x_Senha, "PASSWORD" )) {
            if (!EW_onError(EW_this, EW_this.x_Senha, "PASSWORD", "Forneca sua senha (ate dez caracteres)!"))
                return false; 
        }
if (EW_this.x_Nivel && !EW_hasValue(EW_this.x_Nivel, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_Nivel, "SELECT", "Forneca o nivel de acesso!"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="loginedit" action="loginedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Login</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (session.getAttribute("sighs_status_UserLevel") != null && ((Integer) session.getAttribute("sighs_status_UserLevel")).intValue() == -1) { // system admin %>
<input type="text" name="x_Login" size="10" maxlength="10" value="<%= HTMLEncode((String)x_Login) %>">
<%}  else { // not system admin %>
<% 	x_Login = ((String) session.getAttribute("sighs_status_UserID")); %><% out.print(x_Login); %><input type="hidden" name="x_Login" value="<%= HTMLEncode((String)x_Login) %>">
<% 	} %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Senha</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="password" name="x_Senha" value="<%= x_Senha %>" size=30 maxlength=10></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Nivel</span>&nbsp;</td>
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
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_eMail" size="100" maxlength="255" value="<%= HTMLEncode((String)x_eMail) %>"></span>&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="EDITAR">
</form>
<%@ include file="footer.jsp" %>
