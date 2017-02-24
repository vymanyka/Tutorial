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
if ((ewCurSec & ewAllowDelete) != ewAllowDelete) {
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

// Single delete record
String key = request.getParameter("key");
if (key == null || key.length() == 0 ) {
	response.sendRedirect("loginlist.jsp");
	response.flushBuffer();
	return;
}
String sqlKey = "`Login`=" + "'" + key.replaceAll("'",escapeString) + "'";

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Display
		String strsql = "SELECT * FROM `login` WHERE " + sqlKey;
		if (((Integer) session.getAttribute("sighs_status_UserLevel")).intValue() != -1 ) { // Non system admin
				strsql = strsql + " AND (`Login` = '" + (String) session.getAttribute("sighs_status_UserID") + "')";
		}
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("loginlist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		String strsql = "DELETE FROM `login` WHERE " + sqlKey;
		if (session.getAttribute("sighs_status_UserLevel") != null && ((Integer) session.getAttribute("sighs_status_UserLevel")).intValue() != -1 ) { // Non system admin
				strsql = strsql + " AND (`Login` = '" + (String) session.getAttribute("sighs_status_UserID") + "')";
		}
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("loginlist.jsp");
		response.flushBuffer();
		return;
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Apagar de TABELA: Login<br><br><a href="loginlist.jsp">Voltar a lista</a></span></p>
<form action="logindelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">Login</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Senha</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Nivel</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">e Mail</span>&nbsp;</td>
	</tr>
<%
int recCount = 0;
while (rs.next()){
	recCount ++;
	String bgcolor = "#FFFFFF"; // Set row color
%>
<%
	if (recCount%2 != 0 ) { // Display alternate color for rows
		bgcolor = "#F5F5F5";
	}
%>
<%
	String x_Login = "";
	String x_Senha = "";
	String x_Nivel = "";
	String x_eMail = "";

	// Login
	if (rs.getString("Login") != null){
		x_Login = rs.getString("Login");
	}
	else{
		x_Login = "";
	}

	// Senha
	if (rs.getString("Senha") != null){
		x_Senha = rs.getString("Senha");
	}
	else{
		x_Senha = "";
	}

	// Nivel
	x_Nivel = String.valueOf(rs.getLong("Nivel"));

	// eMail
	if (rs.getString("eMail") != null){
		x_eMail = rs.getString("eMail");
	}
	else{
		x_eMail = "";
	}
%>
	<tr bgcolor="<%= bgcolor %>">
	<input type="hidden" name="key" value="<%= HTMLEncode(key) %>">
		<td class="jspmaker"><% out.print(x_Login); %>&nbsp;</td>
		<td class="jspmaker">********&nbsp;</td>
		<td class="jspmaker"><% if ((ewCurSec & ewAllowAdmin) == ewAllowAdmin) { %>
<%
String tmpValuex_Nivel = (String) x_Nivel;
if (tmpValuex_Nivel.equals("1")) {
	out.print("Administrador");
}
if (tmpValuex_Nivel.equals("2")) {
	out.print("Chefia");
}
if (tmpValuex_Nivel.equals("3")) {
	out.print("Tecnico");
}
if (tmpValuex_Nivel.equals("4")) {
	out.print("Gerencia");
}
if (tmpValuex_Nivel.equals("5")) {
	out.print("SuperUsu");
}
%>
<% } else { %>
********
<% } %>
&nbsp;</td>
		<td class="jspmaker"><% out.print(x_eMail); %>&nbsp;</td>
  </tr>
<%
}
rs.close();
rs = null;
stmt.close();
stmt = null;
conn.close();
conn = null;
}catch (SQLException ex){
	out.println(ex.toString());
}
%>
</table>
<p>
<input type="submit" name="Action" value="CONFIRME EXCLUSAO">
</form>
<%@ include file="footer.jsp" %>
