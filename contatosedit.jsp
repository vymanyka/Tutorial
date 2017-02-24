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
if ((ewCurSec & ewAllowEdit) != ewAllowEdit) {
	response.sendRedirect("contatoslist.jsp"); 
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
String key = request.getParameter("key");
if (key == null || key.length() == 0 ) {
	response.sendRedirect("contatoslist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_id_Contatos = null;
Object x_idFornecedores = null;
Object x_Nome_Contato = null;
Object x_Numero_Telefone = null;
Object x_Login = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `contatos` WHERE `id_Contatos`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("contatoslist.jsp");
			response.flushBuffer();
			return;
		}else{
			rs.first();

			// Get the field contents
	x_id_Contatos = String.valueOf(rs.getLong("id_Contatos"));
	x_idFornecedores = String.valueOf(rs.getLong("idFornecedores"));
			if (rs.getString("Nome_Contato") != null){
				x_Nome_Contato = rs.getString("Nome_Contato");
			}else{
				x_Nome_Contato = "";
			}
			if (rs.getString("Numero_Telefone") != null){
				x_Numero_Telefone = rs.getString("Numero_Telefone");
			}else{
				x_Numero_Telefone = "";
			}
			if (rs.getString("Login") != null){
				x_Login = rs.getString("Login");
			}else{
				x_Login = "";
			}
		}
		rs.close();
	}else if (a.equals("U")) {// Update

		// Get fields from form
		if (request.getParameter("x_idFornecedores") != null){
			x_idFornecedores = request.getParameter("x_idFornecedores");
		}
		if (request.getParameter("x_Nome_Contato") != null){
			x_Nome_Contato = (String) request.getParameter("x_Nome_Contato");
		}else{
			x_Nome_Contato = "";
		}
		if (request.getParameter("x_Numero_Telefone") != null){
			x_Numero_Telefone = (String) request.getParameter("x_Numero_Telefone");
		}else{
			x_Numero_Telefone = "";
		}
		if (request.getParameter("x_Login") != null){
			x_Login = (String) request.getParameter("x_Login");
		}else{
			x_Login = "";
		}

		// Open record
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `contatos` WHERE `id_Contatos`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("contatoslist.jsp");
			response.flushBuffer();
			return;
		}

		// Field idFornecedores
		tmpfld = ((String) x_idFornecedores).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("idFornecedores");
		} else {
			rs.updateInt("idFornecedores",Integer.parseInt(tmpfld));
		}

		// Field Nome_Contato
		tmpfld = ((String) x_Nome_Contato);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Nome_Contato");
		}else{
			rs.updateString("Nome_Contato", tmpfld);
		}

		// Field Numero_Telefone
		tmpfld = ((String) x_Numero_Telefone);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Numero_Telefone");
		}else{
			rs.updateString("Numero_Telefone", tmpfld);
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
		rs.updateRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("contatoslist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
		out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Editar TABELA: Contatos<br><br><a href="contatoslist.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_idFornecedores && !EW_hasValue(EW_this.x_idFornecedores, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_idFornecedores, "SELECT", "Escolha o fornecedor para este contato!"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="contatosedit" action="contatosedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">id Contatos</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_id_Contatos); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Fornecedor</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% String tmp_x_idFornecedores = (String) session.getAttribute("contatos_masterkey");
if (tmp_x_idFornecedores != null && tmp_x_idFornecedores.length() > 0) {
x_idFornecedores = tmp_x_idFornecedores; %>
<%
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
<input type="hidden" name="x_idFornecedores" value="<%= HTMLEncode((String)x_idFornecedores) %>">
<% } else { %>
<%
String cbo_x_idFornecedores_js = "";
String x_idFornecedoresList = "<select name=\"x_idFornecedores\"><option value=\"\">Selecione</option>";
String sqlwrk_x_idFornecedores = "SELECT `idFornecedores`, `Nome_Fornecedor` FROM `fornecedores`" + " ORDER BY `Nome_Fornecedor` ASC";
Statement stmtwrk_x_idFornecedores = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_idFornecedores = stmtwrk_x_idFornecedores.executeQuery(sqlwrk_x_idFornecedores);
	int rowcntwrk_x_idFornecedores = 0;
	while (rswrk_x_idFornecedores.next()) {
		x_idFornecedoresList += "<option value=\"" + HTMLEncode(rswrk_x_idFornecedores.getString("idFornecedores")) + "\"";
		if (rswrk_x_idFornecedores.getString("idFornecedores").equals(x_idFornecedores)) {
			x_idFornecedoresList += " selected";
		}
		String tmpValue_x_idFornecedores = "";
		if (rswrk_x_idFornecedores.getString("Nome_Fornecedor")!= null) tmpValue_x_idFornecedores = rswrk_x_idFornecedores.getString("Nome_Fornecedor");
		x_idFornecedoresList += ">" + tmpValue_x_idFornecedores
 + "</option>";
		rowcntwrk_x_idFornecedores++;
	}
rswrk_x_idFornecedores.close();
rswrk_x_idFornecedores = null;
stmtwrk_x_idFornecedores.close();
stmtwrk_x_idFornecedores = null;
x_idFornecedoresList += "</select>";
out.println(x_idFornecedoresList);
%>
<% } %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Nome do contato</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Nome_Contato" size="70" maxlength="50" value="<%= HTMLEncode((String)x_Nome_Contato) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Numero do Telefone</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Numero_Telefone" size="70" maxlength="50" value="<%= HTMLEncode((String)x_Numero_Telefone) %>"></span>&nbsp;</td>
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
<input type="submit" name="Action" value="EDITAR">
</form>
<%@ include file="footer.jsp" %>
