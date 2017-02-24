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
ew_SecTable[0] = 15;
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
if ((ewCurSec & ewAllowDelete) != ewAllowDelete) {
	response.sendRedirect("fornecedoreslist.jsp"); 
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
	response.sendRedirect("fornecedoreslist.jsp");
	response.flushBuffer();
	return;
}
String sqlKey = "`idFornecedores`=" + "" + key.replaceAll("'",escapeString) + "";

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
		String strsql = "SELECT * FROM `fornecedores` WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("fornecedoreslist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		String strsql = "DELETE FROM `fornecedores` WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("fornecedoreslist.jsp");
		response.flushBuffer();
		return;
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Apagar de TABELA: Fornecedores<br><br><a href="fornecedoreslist.jsp">Voltar a lista</a></span></p>
<form action="fornecedoresdelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">Nome Fornecedor</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">CNPJ</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Telefone</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Home Page</span>&nbsp;</td>
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
	String x_idFornecedores = "";
	String x_Nome_Fornecedor = "";
	String x_CNPJ = "";
	String x_Endereco = "";
	String x_Telefone = "";
	String x_Home_Page = "";
	String x_eMail = "";
	String x_Login = "";

	// idFornecedores
	x_idFornecedores = String.valueOf(rs.getLong("idFornecedores"));

	// Nome_Fornecedor
	if (rs.getString("Nome_Fornecedor") != null){
		x_Nome_Fornecedor = rs.getString("Nome_Fornecedor");
	}
	else{
		x_Nome_Fornecedor = "";
	}

	// CNPJ
	if (rs.getString("CNPJ") != null){
		x_CNPJ = rs.getString("CNPJ");
	}
	else{
		x_CNPJ = "";
	}

	// Endereco
	if (rs.getClob("Endereco") != null) {
		long length = rs.getClob("Endereco").length();
		x_Endereco = rs.getClob("Endereco").getSubString((long) 1, (int) length);
	}else{
		x_Endereco = "";
	}

	// Telefone
	if (rs.getString("Telefone") != null){
		x_Telefone = rs.getString("Telefone");
	}
	else{
		x_Telefone = "";
	}

	// Home_Page
	if (rs.getString("Home_Page") != null){
		x_Home_Page = rs.getString("Home_Page");
	}
	else{
		x_Home_Page = "";
	}

	// eMail
	if (rs.getString("eMail") != null){
		x_eMail = rs.getString("eMail");
	}
	else{
		x_eMail = "";
	}

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
		<td class="jspmaker"><% out.print(x_Nome_Fornecedor); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_CNPJ); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_Telefone); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_Home_Page); %>&nbsp;</td>
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
