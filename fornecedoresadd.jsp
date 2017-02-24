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
if ((ewCurSec & ewAllowAdd) != ewAllowAdd) {
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
request.setCharacterEncoding("UTF-8");

// Get action
String a = request.getParameter("a");
String key = "";
if (a == null || a.length() == 0) {
	key = request.getParameter("key");
	if (key != null && key.length() > 0) {
		a = "C"; // Copy record
	} else {
		a = "I"; // Display blank record
	}
}
Object x_idFornecedores = null;
Object x_Nome_Fornecedor = null;
Object x_CNPJ = null;
Object x_Endereco = null;
Object x_Telefone = null;
Object x_Home_Page = null;
Object x_eMail = null;
Object x_Login = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `fornecedores` WHERE `idFornecedores`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("fornecedoreslist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

			// Get the field contents
	if (rs.getString("Nome_Fornecedor") != null){
		x_Nome_Fornecedor = rs.getString("Nome_Fornecedor");
	}else{
		x_Nome_Fornecedor = "";
	}
	if (rs.getString("CNPJ") != null){
		x_CNPJ = rs.getString("CNPJ");
	}else{
		x_CNPJ = "";
	}
	if (rs.getClob("Endereco") != null) {
		long length = rs.getClob("Endereco").length();
		x_Endereco = rs.getClob("Endereco").getSubString((long) 1, (int) length);
	}else{
		x_Endereco = "";
	}
	if (rs.getString("Telefone") != null){
		x_Telefone = rs.getString("Telefone");
	}else{
		x_Telefone = "";
	}
	if (rs.getString("Home_Page") != null){
		x_Home_Page = rs.getString("Home_Page");
	}else{
		x_Home_Page = "";
	}
	if (rs.getString("eMail") != null){
		x_eMail = rs.getString("eMail");
	}else{
		x_eMail = "";
	}
	if (rs.getString("Login") != null){
		x_Login = rs.getString("Login");
	}else{
		x_Login = "";
	}
		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add

		// Get fields from form
		if (request.getParameter("x_Nome_Fornecedor") != null){
			x_Nome_Fornecedor = (String) request.getParameter("x_Nome_Fornecedor");
		}else{
			x_Nome_Fornecedor = "";
		}
		if (request.getParameter("x_CNPJ") != null){
			x_CNPJ = (String) request.getParameter("x_CNPJ");
		}else{
			x_CNPJ = "";
		}
		if (request.getParameter("x_Endereco") != null){
			x_Endereco = (String) request.getParameter("x_Endereco");
		}else{
			x_Endereco = "";
		}
		if (request.getParameter("x_Telefone") != null){
			x_Telefone = (String) request.getParameter("x_Telefone");
		}else{
			x_Telefone = "";
		}
		if (request.getParameter("x_Home_Page") != null){
			x_Home_Page = (String) request.getParameter("x_Home_Page");
		}else{
			x_Home_Page = "";
		}
		if (request.getParameter("x_eMail") != null){
			x_eMail = (String) request.getParameter("x_eMail");
		}else{
			x_eMail = "";
		}
		if (request.getParameter("x_Login") != null){
			x_Login = (String) request.getParameter("x_Login");
		}else{
			x_Login = "";
		}

		// Open record
		String strsql = "SELECT * FROM `fornecedores` WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field Nome_Fornecedor
		tmpfld = ((String) x_Nome_Fornecedor);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("Nome_Fornecedor");
		}else{
			rs.updateString("Nome_Fornecedor", tmpfld);
		}

		// Field CNPJ
		tmpfld = ((String) x_CNPJ);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("CNPJ");
		}else{
			rs.updateString("CNPJ", tmpfld);
		}

		// Field Endereco
		tmpfld = ((String) x_Endereco);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Endereco");
		}else{
			rs.updateString("Endereco", tmpfld);
		}

		// Field Telefone
		tmpfld = ((String) x_Telefone);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Telefone");
		}else{
			rs.updateString("Telefone", tmpfld);
		}

		// Field Home_Page
		tmpfld = ((String) x_Home_Page);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Home_Page");
		}else{
			rs.updateString("Home_Page", tmpfld);
		}

		// Field eMail
		tmpfld = ((String) x_eMail);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("eMail");
		}else{
			rs.updateString("eMail", tmpfld);
		}

		// Field Login
		tmpfld = ((String) x_Login);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("Login");
		}else{
			rs.updateString("Login", tmpfld);
		}
		rs.insertRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		out.clear();
		response.sendRedirect("fornecedoreslist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Adicionar TABELA: Fornecedores<br><br><a href="fornecedoreslist.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_Nome_Fornecedor && !EW_hasValue(EW_this.x_Nome_Fornecedor, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_Nome_Fornecedor, "TEXT", "Campo invalido! - Nome Fornecedor"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="fornecedoresadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Nome Fornecedor</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Nome_Fornecedor" size="70" maxlength="50" value="<%= HTMLEncode((String)x_Nome_Fornecedor) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">CNPJ</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_CNPJ" size="20" maxlength="14" value="<%= HTMLEncode((String)x_CNPJ) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Endereco</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Endereco" cols="40" rows="4"><% if (x_Endereco!=null) out.print(x_Endereco); %></textarea></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Telefone</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Telefone" size="70" maxlength="50" value="<%= HTMLEncode((String)x_Telefone) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Home Page</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Home_Page" size="100" maxlength="255" value="<%= HTMLEncode((String)x_Home_Page) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">e Mail</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_eMail" size="100" maxlength="255" value="<%= HTMLEncode((String)x_eMail) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Login</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (session.getAttribute("sighs_status_UserLevel") != null && ((Integer) session.getAttribute("sighs_status_UserLevel")).intValue() == -1) { // system admin %>
<input type="text" name="x_Login" size="30" maxlength="10" value="<%= HTMLEncode((String)x_Login) %>">
<%}  else { // not system admin %>
<% 	x_Login = ((String) session.getAttribute("sighs_status_UserID")); %><% out.print(x_Login); %><input type="hidden" name="x_Login" value="<%= HTMLEncode((String)x_Login) %>">
<% 	} %>
</span>&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Cadastrar">
</form>
<%@ include file="footer.jsp" %>
