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
	response.sendRedirect("categoriaslist.jsp"); 
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
if (key == null || key.length() == 0) { response.sendRedirect("categoriaslist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
String x_id_Categoria = "";
String x_id_Zero = "";
String x_id_Um = "";
String x_id_Dois = "";
String x_id_Tres = "";
String x_id_Quatro = "";
String x_Descricao_da_categoria = "";
String x_Detalhes_da_categoria = "";
String x_Imagem = "";
String x_Guia_do_usuario = "";
String x_Guia_tecnico = "";
String x_Guia_rapido = "";
String x_Login = "";

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `categorias` WHERE `id_Categoria`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("categoriaslist.jsp");
		}else{
			rs.first();
		}

		// Get field values
		// id_Categoria

		x_id_Categoria = String.valueOf(rs.getLong("id_Categoria"));

		// id_Zero
		x_id_Zero = String.valueOf(rs.getLong("id_Zero"));

		// id_Um
		x_id_Um = String.valueOf(rs.getLong("id_Um"));

		// id_Dois
		x_id_Dois = String.valueOf(rs.getLong("id_Dois"));

		// id_Tres
		x_id_Tres = String.valueOf(rs.getLong("id_Tres"));

		// id_Quatro
		x_id_Quatro = String.valueOf(rs.getLong("id_Quatro"));

		// Descricao_da_categoria
		if (rs.getString("Descricao_da_categoria") != null){
			x_Descricao_da_categoria = rs.getString("Descricao_da_categoria");
		}else{
			x_Descricao_da_categoria = "";
		}

		// Detalhes_da_categoria
		if (rs.getClob("Detalhes_da_categoria") != null) {
			long length = rs.getClob("Detalhes_da_categoria").length();
			x_Detalhes_da_categoria = rs.getClob("Detalhes_da_categoria").getSubString((long) 1, (int) length);
		}else{
			x_Detalhes_da_categoria = "";
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

		// Guia_do_usuario
		if (rs.getString("Guia_do_usuario") != null){
			x_Guia_do_usuario = rs.getString("Guia_do_usuario");
		}else{
			x_Guia_do_usuario = "";
		}

		// Guia_do_usuario
		if (rs.getString("Guia_do_usuario") != null){
			x_Guia_do_usuario = rs.getString("Guia_do_usuario");
		}else{
			x_Guia_do_usuario = "";
		}

		// Guia_tecnico
		if (rs.getString("Guia_tecnico") != null){
			x_Guia_tecnico = rs.getString("Guia_tecnico");
		}else{
			x_Guia_tecnico = "";
		}

		// Guia_tecnico
		if (rs.getString("Guia_tecnico") != null){
			x_Guia_tecnico = rs.getString("Guia_tecnico");
		}else{
			x_Guia_tecnico = "";
		}

		// Guia_rapido
		if (rs.getString("Guia_rapido") != null){
			x_Guia_rapido = rs.getString("Guia_rapido");
		}else{
			x_Guia_rapido = "";
		}

		// Guia_rapido
		if (rs.getString("Guia_rapido") != null){
			x_Guia_rapido = rs.getString("Guia_rapido");
		}else{
			x_Guia_rapido = "";
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
<p><span class="jspmaker">Visualizar TABELA: Categorias<br><br><a href="categoriaslist.jsp">Voltar a lista</a></span></p>
<p>
<form>
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria primaria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
if (x_id_Zero!=null && ((String)x_id_Zero).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Zero;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Zero` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Zero`, `Descricao_da_categoria` FROM `sub_categoria_0`";
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
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria secundaria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
if (x_id_Um!=null && ((String)x_id_Um).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Um;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Um` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Um`, `Descricao_da_categoria` FROM `sub_categoria_1`";
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
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria terciaria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
if (x_id_Dois!=null && ((String)x_id_Dois).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Dois;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Dois` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Dois`, `Descricao_da_categoria` FROM `sub_categoria_2`";
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
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria quaternaria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
if (x_id_Tres!=null && ((String)x_id_Tres).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Tres;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Tres` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Tres`, `Descricao_da_categoria` FROM `sub_categoria_3`";
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
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria quinquenaria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
if (x_id_Quatro!=null && ((String)x_id_Quatro).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Quatro;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Quatro` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Quatro`, `Descricao_da_categoria` FROM `sub_categoria_4`";
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
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Descricao da categoria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_Descricao_da_categoria); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Detalhes da categoria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_Detalhes_da_categoria != null) { out.print(((String)x_Detalhes_da_categoria).replaceAll("\r\n", "<br>"));} %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Imagem</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_Imagem != null && ((String)x_Imagem).length() > 0) { %>
<a href="uploads/<%= x_Imagem %>" target="blank"><img src="uploads/<%= x_Imagem %>" border="0"></a>
<% } %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Guia do usuario</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_Guia_do_usuario != null && ((String)x_Guia_do_usuario).length() > 0) { %>
<a href="uploads/<%= x_Guia_do_usuario %>" target="blank"><%= x_Guia_do_usuario %></a>
<% } %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Guia tecnico</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_Guia_tecnico != null && ((String)x_Guia_tecnico).length() > 0) { %>
<a href="uploads/<%= x_Guia_tecnico %>" target="blank"><%= x_Guia_tecnico %></a>
<% } %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Guia rapido</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_Guia_rapido != null && ((String)x_Guia_rapido).length() > 0) { %>
<a href="uploads/<%= x_Guia_rapido %>" target="blank"><%= x_Guia_rapido %></a>
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
