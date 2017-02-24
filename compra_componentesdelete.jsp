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
ew_SecTable[0] = 11;
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
	response.sendRedirect("compra_componenteslist.jsp"); 
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
	response.sendRedirect("compra_componenteslist.jsp");
	response.flushBuffer();
	return;
}
String sqlKey = "`id_Compra_Componentes`=" + "" + key.replaceAll("'",escapeString) + "";

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
		String strsql = "SELECT * FROM `compra_componentes` WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("compra_componenteslist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		String strsql = "DELETE FROM `compra_componentes` WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("compra_componenteslist.jsp");
		response.flushBuffer();
		return;
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Apagar de TABELA: Compra de componentes<br><br><a href="compra_componenteslist.jsp">Voltar a lista</a></span></p>
<form action="compra_componentesdelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">Componente</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Fornecedor</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Pedido de Compra</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Qtd comprada</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Estado do componente</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Data compra</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Valor total da compra</span>&nbsp;</td>
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
	String x_id_Compra_Componentes = "";
	String x_id_Componente = "";
	String x_idFornecedores = "";
	String x_idPedido_Compra = "";
	String x_Qtd_comprada = "";
	String x_Estado_do_componente = "";
	Timestamp x_Data_compra = null;
	String x_Valor_total_compra = "";
	String x_Login = "";

	// id_Compra_Componentes
	x_id_Compra_Componentes = String.valueOf(rs.getLong("id_Compra_Componentes"));

	// id_Componente
	x_id_Componente = String.valueOf(rs.getLong("id_Componente"));

	// idFornecedores
	x_idFornecedores = String.valueOf(rs.getLong("idFornecedores"));

	// idPedido_Compra
	x_idPedido_Compra = String.valueOf(rs.getLong("idPedido_Compra"));

	// Qtd_comprada
	x_Qtd_comprada = String.valueOf(rs.getLong("Qtd_comprada"));

	// Estado_do_componente
	x_Estado_do_componente = String.valueOf(rs.getLong("Estado_do_componente"));

	// Data_compra
	if (rs.getTimestamp("Data_compra") != null){
		x_Data_compra = rs.getTimestamp("Data_compra");
	}
	else{
		x_Data_compra = null;
	}

	// Valor_total_compra
	x_Valor_total_compra = String.valueOf(rs.getDouble("Valor_total_compra"));

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
		<td class="jspmaker"><%
if (x_id_Componente!=null && ((String)x_id_Componente).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Componente;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Componente` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Componente`, `Descricao_do_componente` FROM `componentes`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("Descricao_do_componente"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
&nbsp;</td>
		<td class="jspmaker"><%
if (x_idFornecedores!=null && ((String)x_idFornecedores).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_idFornecedores;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`idFornecedores` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `idFornecedores`, `Nome_Fornecedor` FROM `fornecedores`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("Nome_Fornecedor"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
&nbsp;</td>
		<td class="jspmaker"><%
if (x_idPedido_Compra!=null && ((String)x_idPedido_Compra).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_idPedido_Compra;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`idPedido_Compra` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `idPedido_Compra`, `Numero_Pedido` FROM `pedido_compra`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("Numero_Pedido"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
&nbsp;</td>
		<td class="jspmaker"><% out.print(x_Qtd_comprada); %>&nbsp;</td>
		<td class="jspmaker"><%
String tmpValuex_Estado_do_componente = (String) x_Estado_do_componente;
if (tmpValuex_Estado_do_componente.equals("1")) {
	out.print("Novo");
}
if (tmpValuex_Estado_do_componente.equals("2")) {
	out.print("Seminovo");
}
if (tmpValuex_Estado_do_componente.equals("3")) {
	out.print("Recuperavel");
}
if (tmpValuex_Estado_do_componente.equals("4")) {
	out.print("Irrecuperavel");
}
%>
&nbsp;</td>
		<td class="jspmaker"><% out.print(EW_FormatDateTime(x_Data_compra,7,locale)); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_Valor_total_compra); %>&nbsp;</td>
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
