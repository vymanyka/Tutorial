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
ew_SecTable[0] = 10;
ew_SecTable[1] = 9;
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
	response.sendRedirect("movimentacaolist.jsp"); 
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
if (key == null || key.length() == 0) { response.sendRedirect("movimentacaolist.jsp");}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}
String x_id_Movimentacao = "";
String x_id_Bem = "";
String x_Siga = "";
Object x_Data_Entrada = null;
String x_Situacao = "";
String x_Detalhes_da_Movimentacao = "";
String x_Garantia = "";
String x_Lotacao_Destino = "";
String x_Resp_Transporte = "";
String x_Login = "";

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")) {// Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `movimentacao` WHERE `id_Movimentacao`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("movimentacaolist.jsp");
		}else{
			rs.first();
		}

		// Get field values
		// id_Movimentacao

		x_id_Movimentacao = String.valueOf(rs.getLong("id_Movimentacao"));

		// id_Bem
		x_id_Bem = String.valueOf(rs.getLong("id_Bem"));

		// Siga
		x_Siga = String.valueOf(rs.getLong("Siga"));

		// Data_Entrada
		if (rs.getTimestamp("Data_Entrada") != null){
			x_Data_Entrada = rs.getTimestamp("Data_Entrada");
		}else{
			x_Data_Entrada = "";
		}

		// Situacao
		x_Situacao = String.valueOf(rs.getLong("Situacao"));

		// Detalhes_da_Movimentacao
		if (rs.getClob("Detalhes_da_Movimentacao") != null) {
			long length = rs.getClob("Detalhes_da_Movimentacao").length();
			x_Detalhes_da_Movimentacao = rs.getClob("Detalhes_da_Movimentacao").getSubString((long) 1, (int) length);
		}else{
			x_Detalhes_da_Movimentacao = "";
		}

		// Garantia
		x_Garantia = String.valueOf(rs.getLong("Garantia"));

		// Lotacao_Destino
		x_Lotacao_Destino = String.valueOf(rs.getLong("Lotacao_Destino"));

		// Resp_Transporte
		if (rs.getString("Resp_Transporte") != null){
			x_Resp_Transporte = rs.getString("Resp_Transporte");
		}else{
			x_Resp_Transporte = "";
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
<p><span class="jspmaker">Visualizar TABELA: Livro de ocorrencias<br><br><a href="movimentacaolist.jsp">Voltar a lista</a></span></p>
<p>
<form>
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_id_Movimentacao); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Tombamento</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
if (x_id_Bem!=null && ((String)x_id_Bem).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Bem;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Bem` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Bem` FROM `bens`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("id_Bem"));
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
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Siga</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_Siga); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Data da ocorrencia</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(EW_FormatDateTime(x_Data_Entrada,7,locale)); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Situacao</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String tmpValue_x_Situacao = (String) x_Situacao;
if (tmpValue_x_Situacao.equals("1")) { 
	out.print("Bom");
}
if (tmpValue_x_Situacao.equals("2")) { 
	out.print("Danificado");
}
if (tmpValue_x_Situacao.equals("3")) { 
	out.print("Anti-economico");
}
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Detalhes da ocorrencia</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_Detalhes_da_Movimentacao != null) { out.print(((String)x_Detalhes_da_Movimentacao).replaceAll("\r\n", "<br>"));} %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Garantia</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String tmpValue_x_Garantia = (String) x_Garantia;
if (tmpValue_x_Garantia.equals("1")) { 
	out.print("Na garantia");
}
if (tmpValue_x_Garantia.equals("2")) { 
	out.print("Fora da garantia");
}
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Lotacao de destino</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
if (x_Lotacao_Destino!=null && ((String)x_Lotacao_Destino).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_Lotacao_Destino;
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
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Quem movimentou?</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_Resp_Transporte); %></span>&nbsp;</td>
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
