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
	response.sendRedirect("pedido_compralist.jsp"); 
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
	response.sendRedirect("pedido_compralist.jsp");
	response.flushBuffer();
	return;
}
String sqlKey = "`idPedido_Compra`=" + "" + key.replaceAll("'",escapeString) + "";

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
		String strsql = "SELECT * FROM `pedido_compra` WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("pedido_compralist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		String strsql = "DELETE FROM `pedido_compra` WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("pedido_compralist.jsp");
		response.flushBuffer();
		return;
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Apagar de TABELA: Pedidos de compra<br><br><a href="pedido_compralist.jsp">Voltar a lista</a></span></p>
<form action="pedido_compradelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">Numero do Pedido</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Observacao</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Tipo de Compra</span>&nbsp;</td>
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
	String x_idPedido_Compra = "";
	String x_Numero_Pedido = "";
	String x_Observacao = "";
	String x_Tipo_de_Compra = "";
	String x_Login = "";

	// idPedido_Compra
	x_idPedido_Compra = String.valueOf(rs.getLong("idPedido_Compra"));

	// Numero_Pedido
	if (rs.getString("Numero_Pedido") != null){
		x_Numero_Pedido = rs.getString("Numero_Pedido");
	}
	else{
		x_Numero_Pedido = "";
	}

	// Observacao
	if (rs.getClob("Observacao") != null) {
		long length = rs.getClob("Observacao").length();
		x_Observacao = rs.getClob("Observacao").getSubString((long) 1, (int) length);
	}else{
		x_Observacao = "";
	}

	// Tipo_de_Compra
	x_Tipo_de_Compra = String.valueOf(rs.getLong("Tipo_de_Compra"));

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
		<td class="jspmaker"><% out.print(x_Numero_Pedido); %>&nbsp;</td>
		<td class="jspmaker"><% if (x_Observacao != null) { out.print(((String)x_Observacao).replaceAll("\r\n", "<br>"));} %>&nbsp;</td>
		<td class="jspmaker"><%
String tmpValuex_Tipo_de_Compra = (String) x_Tipo_de_Compra;
if (tmpValuex_Tipo_de_Compra.equals("1")) {
	out.print("Compra direta");
}
if (tmpValuex_Tipo_de_Compra.equals("2")) {
	out.print("Licitacao");
}
if (tmpValuex_Tipo_de_Compra.equals("3")) {
	out.print("Registro de precos");
}
if (tmpValuex_Tipo_de_Compra.equals("4")) {
	out.print("Pregao eletronico");
}
%>
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
