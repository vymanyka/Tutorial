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
ew_SecTable[1] = 15;
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
if ((ewCurSec & ewAllowView) != ewAllowView) {
	response.sendRedirect("problemaslist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
String tmpfld = null;
String escapeString = "\\\\'";
String key = request.getParameter("key");
if (key == null || key.length() == 0) { response.sendRedirect("problemaslist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
String x_id_Problema = "";
String x_id_Movimentacao = "";
String x_id_Dano = "";
String x_Descricao_do_problema = "";
String x_Imagem = "";
String x_Video = "";
String x_Som = "";
String x_Login = "";

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `problemas` WHERE `id_Problema`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("problemaslist.jsp");
		}else{
			rs.first();
		}

		// Get field values
		// id_Problema

		x_id_Problema = String.valueOf(rs.getLong("id_Problema"));

		// id_Movimentacao
		x_id_Movimentacao = String.valueOf(rs.getLong("id_Movimentacao"));

		// id_Dano
		x_id_Dano = String.valueOf(rs.getLong("id_Dano"));

		// Descricao_do_problema
		if (rs.getClob("Descricao_do_problema") != null) {
			long length = rs.getClob("Descricao_do_problema").length();
			x_Descricao_do_problema = rs.getClob("Descricao_do_problema").getSubString((long) 1, (int) length);
		}else{
			x_Descricao_do_problema = "";
		}

		// Imagem
		if (rs.getString("Imagem") != null){
			x_Imagem = rs.getString("Imagem");
		}else{
			x_Imagem = "";
		}

		// Imagem
		if (rs.getString("Imagem") != null){
			x_Imagem = rs.getString("Imagem");
		}else{
			x_Imagem = "";
		}

		// Video
		if (rs.getString("Video") != null){
			x_Video = rs.getString("Video");
		}else{
			x_Video = "";
		}

		// Video
		if (rs.getString("Video") != null){
			x_Video = rs.getString("Video");
		}else{
			x_Video = "";
		}

		// Som
		if (rs.getString("Som") != null){
			x_Som = rs.getString("Som");
		}else{
			x_Som = "";
		}

		// Som
		if (rs.getString("Som") != null){
			x_Som = rs.getString("Som");
		}else{
			x_Som = "";
		}

		// Login
		if (rs.getString("Login") != null){
			x_Login = rs.getString("Login");
		}else{
			x_Login = "";
		}
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Visualizar TABELA: Problemas<br><br><a href="problemaslist.jsp">Voltar a lista</a></span></p>
<p>
<form>
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_id_Problema); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Movimentacao</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
if (x_id_Movimentacao!=null && ((String)x_id_Movimentacao).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Movimentacao;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Movimentacao` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Movimentacao`, `id_Bem` FROM `movimentacao`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("id_Bem"));
		out.print(", " + rswrk.getString("id_Movimentacao"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Dano</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
if (x_id_Dano!=null && ((String)x_id_Dano).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Dano;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Dano` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Dano`, `Descricao_do_dano` FROM `tipos_de_dano`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("Descricao_do_dano"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Descricao do problema</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_Descricao_do_problema != null) { out.print(((String)x_Descricao_do_problema).replaceAll("\r\n", "<br>"));} %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Imagem</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_Imagem != null && ((String)x_Imagem).length() > 0) { %>
<a href="uploads/<%= x_Imagem %>" target="blank"><img src="uploads/<%= x_Imagem %>" border="0"></a>
<% } %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Audio-visual</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_Video != null && ((String)x_Video).length() > 0) { %>
<a href="uploads/<%= x_Video %>" target="blank"><%= x_Video %></a>
<% } %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Audio-visual (cont)</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_Som != null && ((String)x_Som).length() > 0) { %>
<a href="uploads/<%= x_Som %>" target="blank"><%= x_Som %></a>
<% } %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Login</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_Login); %></span>&nbsp;</td>
	</tr>
</table>
</form>
<p>
<%
	rs.close();
	rs = null;
	stmt.close();
	stmt = null;
	conn.close();
	conn = null;
}catch(SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="footer.jsp" %>
