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
if ((ewCurSec & ewAllowView) != ewAllowView) {
	response.sendRedirect("benslist.jsp"); 
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
if (key == null || key.length() == 0) { response.sendRedirect("benslist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
String x_id_Bem = "";
String x_id_Marca = "";
String x_id_Categoria = "";
String x_id_Lotacoes = "";
String x_Numero_de_serie = "";
String x_Caracteristicas_do_bem = "";
String x_Login = "";

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `bens` WHERE `id_Bem`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("benslist.jsp");
		}else{
			rs.first();
		}

		// Get field values
		// id_Bem

		x_id_Bem = String.valueOf(rs.getLong("id_Bem"));

		// id_Marca
		x_id_Marca = String.valueOf(rs.getLong("id_Marca"));

		// id_Categoria
		x_id_Categoria = String.valueOf(rs.getLong("id_Categoria"));

		// id_Lotacoes
		x_id_Lotacoes = String.valueOf(rs.getLong("id_Lotacoes"));

		// Numero_de_serie
		if (rs.getString("Numero_de_serie") != null){
			x_Numero_de_serie = rs.getString("Numero_de_serie");
		}else{
			x_Numero_de_serie = "";
		}

		// Caracteristicas_do_bem
		if (rs.getClob("Caracteristicas_do_bem") != null) {
			long length = rs.getClob("Caracteristicas_do_bem").length();
			x_Caracteristicas_do_bem = rs.getClob("Caracteristicas_do_bem").getSubString((long) 1, (int) length);
		}else{
			x_Caracteristicas_do_bem = "";
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
<p><span class="jspmaker">Visualizar TABELA: Bens<br><br><a href="benslist.jsp">Voltar a lista</a></span></p>
<p>
<form>
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Tombamento</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_id_Bem); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Marca</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
if (x_id_Marca!=null && ((String)x_id_Marca).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Marca;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Marca` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Marca`, `Marca` FROM `marcas`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("Marca"));
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
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
if (x_id_Categoria!=null && ((String)x_id_Categoria).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Categoria;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Categoria` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Categoria`, `Descricao_da_categoria` FROM `categorias`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("Descricao_da_categoria"));
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
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Lotacao atual</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
if (x_id_Lotacoes!=null && ((String)x_id_Lotacoes).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Lotacoes;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Lotacoes` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Lotacoes`, `Descricao_da_lotacao` FROM `lotacoes`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("Descricao_da_lotacao"));
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
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Numero de serie</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_Numero_de_serie); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Caracteristicas do bem</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_Caracteristicas_do_bem != null) { out.print(((String)x_Caracteristicas_do_bem).replaceAll("\r\n", "<br>"));} %></span>&nbsp;</td>
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
