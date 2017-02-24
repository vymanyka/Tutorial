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
ew_SecTable[1] = 8;
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
	response.sendRedirect("retirada_de_componenteslist.jsp"); 
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
	response.sendRedirect("retirada_de_componenteslist.jsp");
	response.flushBuffer();
	return;
}
String sqlKey = "`id_Retirada_de_Componentes`=" + "" + key.replaceAll("'",escapeString) + "";

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
		String strsql = "SELECT * FROM `retirada_de_componentes` WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("retirada_de_componenteslist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		String strsql = "DELETE FROM `retirada_de_componentes` WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("retirada_de_componenteslist.jsp");
		response.flushBuffer();
		return;
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Apagar de TABELA: Retirada de componentes<br><br><a href="retirada_de_componenteslist.jsp">Voltar a lista</a></span></p>
<form action="retirada_de_componentesdelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">Componente</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Qtd retirada</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Data retirada</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Estado do componente</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Imagem</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Audio-visual</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Audio-visual (cont)</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Tipo de retirada</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Executor externo</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Telefone do executor</span>&nbsp;</td>
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
	String x_id_Retirada_de_Componentes = "";
	String x_id_Problema = "";
	String x_id_Componente = "";
	String x_Qtd_retirada = "";
	Timestamp x_Data_retirada = null;
	String x_Destino_do_componente = "";
	String x_Imagem = "";
	String x_Video = "";
	String x_Som = "";
	String x_Relacao_confianca = "";
	String x_Com_quem = "";
	String x_Telefone_confianca = "";
	String x_Login = "";

	// id_Retirada_de_Componentes
	x_id_Retirada_de_Componentes = String.valueOf(rs.getLong("id_Retirada_de_Componentes"));

	// id_Problema
	x_id_Problema = String.valueOf(rs.getLong("id_Problema"));

	// id_Componente
	x_id_Componente = String.valueOf(rs.getLong("id_Componente"));

	// Qtd_retirada
	x_Qtd_retirada = String.valueOf(rs.getLong("Qtd_retirada"));

	// Data_retirada
	if (rs.getTimestamp("Data_retirada") != null){
		x_Data_retirada = rs.getTimestamp("Data_retirada");
	}
	else{
		x_Data_retirada = null;
	}

	// Destino_do_componente
	x_Destino_do_componente = String.valueOf(rs.getLong("Destino_do_componente"));

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

	// Relacao_confianca
	x_Relacao_confianca = String.valueOf(rs.getLong("Relacao_confianca"));

	// Com_quem
	if (rs.getString("Com_quem") != null){
		x_Com_quem = rs.getString("Com_quem");
	}
	else{
		x_Com_quem = "";
	}

	// Telefone_confianca
	if (rs.getString("Telefone_confianca") != null){
		x_Telefone_confianca = rs.getString("Telefone_confianca");
	}
	else{
		x_Telefone_confianca = "";
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
		<td class="jspmaker"><% out.print(x_Qtd_retirada); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(EW_FormatDateTime(x_Data_retirada,7,locale)); %>&nbsp;</td>
		<td class="jspmaker"><%
String tmpValuex_Destino_do_componente = (String) x_Destino_do_componente;
if (tmpValuex_Destino_do_componente.equals("1")) {
	out.print("Novo");
}
if (tmpValuex_Destino_do_componente.equals("2")) {
	out.print("Seminovo");
}
if (tmpValuex_Destino_do_componente.equals("3")) {
	out.print("Recuperavel");
}
if (tmpValuex_Destino_do_componente.equals("4")) {
	out.print("Irrecuperavel");
}
%>
&nbsp;</td>
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
		<td class="jspmaker"><%
String tmpValue_x_Relacao_confianca = (String) x_Relacao_confianca;
if (tmpValue_x_Relacao_confianca.equals("1")) { 
	out.print("Interna");
}
if (tmpValue_x_Relacao_confianca.equals("2")) { 
	out.print("Externa");
}
%>
&nbsp;</td>
		<td class="jspmaker"><% out.print(x_Com_quem); %>&nbsp;</td>
		<td class="jspmaker"><% out.print(x_Telefone_confianca); %>&nbsp;</td>
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
