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

// Single delete record
String key = request.getParameter("key");
if (key == null || key.length() == 0 ) {
	response.sendRedirect("categoriaslist.jsp");
	response.flushBuffer();
	return;
}
String sqlKey = "`id_Categoria`=" + "" + key.replaceAll("'",escapeString) + "";

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
		String strsql = "SELECT * FROM `categorias` WHERE " + sqlKey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			response.sendRedirect("categoriaslist.jsp");
		}else{
			rs.beforeFirst();
		}
	}else if (a.equals("D")){ // Delete
		String strsql = "DELETE FROM `categorias` WHERE " + sqlKey;
		stmt.executeUpdate(strsql);
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("categoriaslist.jsp");
		response.flushBuffer();
		return;
	}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Apagar de TABELA: Categorias<br><br><a href="categoriaslist.jsp">Voltar a lista</a></span></p>
<form action="categoriasdelete.jsp" method="post">
<p>
<input type="hidden" name="a" value="D">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">Descricao da categoria</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Detalhes da categoria</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Imagem</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Guia do usuario</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Guia tecnico</span>&nbsp;</td>
		<td><span class="jspmaker" style="color: #FFFFFF;">Guia rapido</span>&nbsp;</td>
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
	}
	else{
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
	}
	else{
		x_Imagem = "";
	}

	// Get BLOB field width & height
	x_Imagem = rs.getString("Imagem");

	// Guia_do_usuario
	if (rs.getString("Guia_do_usuario") != null){
		x_Guia_do_usuario = rs.getString("Guia_do_usuario");
	}
	else{
		x_Guia_do_usuario = "";
	}

	// Get BLOB field width & height
	x_Guia_do_usuario = rs.getString("Guia_do_usuario");

	// Guia_tecnico
	if (rs.getString("Guia_tecnico") != null){
		x_Guia_tecnico = rs.getString("Guia_tecnico");
	}
	else{
		x_Guia_tecnico = "";
	}

	// Get BLOB field width & height
	x_Guia_tecnico = rs.getString("Guia_tecnico");

	// Guia_rapido
	if (rs.getString("Guia_rapido") != null){
		x_Guia_rapido = rs.getString("Guia_rapido");
	}
	else{
		x_Guia_rapido = "";
	}

	// Get BLOB field width & height
	x_Guia_rapido = rs.getString("Guia_rapido");

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
		<td class="jspmaker"><% out.print(x_Descricao_da_categoria); %>&nbsp;</td>
		<td class="jspmaker"><% if (x_Detalhes_da_categoria != null) { out.print(((String)x_Detalhes_da_categoria).replaceAll("\r\n", "<br>"));} %>&nbsp;</td>
		<td class="jspmaker"><% if (x_Imagem != null && ((String)x_Imagem).length() > 0) { %>
<a href="uploads/<%= x_Imagem %>" target="blank"><img src="uploads/<%= x_Imagem %>" border="0"></a>
<% } %>
&nbsp;</td>
		<td class="jspmaker"><% if (x_Guia_do_usuario != null && ((String)x_Guia_do_usuario).length() > 0) { %>
<a href="uploads/<%= x_Guia_do_usuario %>" target="blank"><%= x_Guia_do_usuario %></a>
<% } %>
&nbsp;</td>
		<td class="jspmaker"><% if (x_Guia_tecnico != null && ((String)x_Guia_tecnico).length() > 0) { %>
<a href="uploads/<%= x_Guia_tecnico %>" target="blank"><%= x_Guia_tecnico %></a>
<% } %>
&nbsp;</td>
		<td class="jspmaker"><% if (x_Guia_rapido != null && ((String)x_Guia_rapido).length() > 0) { %>
<a href="uploads/<%= x_Guia_rapido %>" target="blank"><%= x_Guia_rapido %></a>
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
