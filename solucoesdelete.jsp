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
ew_SecTable[0] = 8;
ew_SecTable[1] = 11;
ew_SecTable[2] = 15;
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
if ((ewCurSec & ewAllowDelete) != ewAllowDelete) {
	response.sendRedirect("solucoeslist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
String tmpfld = null;
String escapeString = "\\\\'";

// Single delete record
String key = request.getParameter("key");
if (key == null || key.length() == 0 ) {
	response.sendRedirect("solucoeslist.jsp");
	response.flushBuffer();
	return;
}
String sqlKey = "`id_Solucao`=" + "" + key.replaceAll("'",escapeString) + "";

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
		String strsql = "SELECT * FROM `solucoes` WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("solucoeslist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		String strsql = "DELETE FROM `solucoes` WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("solucoeslist.jsp");
		response.flushBuffer();
		return;
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Apagar de TABELA: Solucoes<br><br><a href="solucoeslist.jsp">Voltar a lista</a></span></p>
<form action="solucoesdelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">Detalhes</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Imagem</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Audio-visual</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Audio-visual (cont)</span>&nbsp;</td>
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
	String x_id_Solucao = "";
	String x_id_Problema = "";
	String x_Detalhes = "";
	String x_Imagem = "";
	String x_Video = "";
	String x_Som = "";
	String x_Login = "";

	// id_Solucao
	x_id_Solucao = String.valueOf(rs.getLong("id_Solucao"));

	// id_Problema
	x_id_Problema = String.valueOf(rs.getLong("id_Problema"));

	// Detalhes
	if (rs.getClob("Detalhes") != null) {
		long length = rs.getClob("Detalhes").length();
		x_Detalhes = rs.getClob("Detalhes").getSubString((long) 1, (int) length);
	}else{
		x_Detalhes = "";
	}

	// Imagem
	if (rs.getString("Imagem") != null){
		x_Imagem = rs.getString("Imagem");
	}
	else{
		x_Imagem = "";
	}

	// Get BLOB field width & height
	x_Imagem = rs.getString("Imagem");

	// Video
	if (rs.getString("Video") != null){
		x_Video = rs.getString("Video");
	}
	else{
		x_Video = "";
	}

	// Get BLOB field width & height
	x_Video = rs.getString("Video");

	// Som
	if (rs.getString("Som") != null){
		x_Som = rs.getString("Som");
	}
	else{
		x_Som = "";
	}

	// Get BLOB field width & height
	x_Som = rs.getString("Som");

	// Login
	if (rs.getString("Login") != null){
		x_Login = rs.getString("Login");
	}
	else{
		x_Login = "";
	}
%>
	<tr bgcolor="<%= bgcolor %>">
	<input type="hidden" name="key" value="<%= HTMLEncode(key) %>">
		<td class="jspmaker"><% if (x_Detalhes != null) { out.print(((String)x_Detalhes).replaceAll("\r\n", "<br>"));} %>&nbsp;</td>
		<td class="jspmaker"><% if (x_Imagem != null && ((String)x_Imagem).length() > 0) { %>
<a href="uploads/<%= x_Imagem %>" target="blank"><img src="uploads/<%= x_Imagem %>" border="0"></a>
<% } %>
&nbsp;</td>
		<td class="jspmaker"><% if (x_Video != null && ((String)x_Video).length() > 0) { %>
<a href="uploads/<%= x_Video %>" target="blank"><%= x_Video %></a>
<% } %>
&nbsp;</td>
		<td class="jspmaker"><% if (x_Som != null && ((String)x_Som).length() > 0) { %>
<a href="uploads/<%= x_Som %>" target="blank"><%= x_Som %></a>
<% } %>
&nbsp;</td>
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
