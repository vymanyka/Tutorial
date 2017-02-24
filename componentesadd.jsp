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
	response.sendRedirect("componenteslist.jsp"); 
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
Object x_id_Componente = null;
Object x_id_Categoria = null;
Object x_Descricao_do_componente = null;
Object x_Qtd_minima = null;
Object x_Login = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `componentes` WHERE `id_Componente`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("componenteslist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

			// Get the field contents
	x_id_Categoria = String.valueOf(rs.getLong("id_Categoria"));
	if (rs.getString("Descricao_do_componente") != null){
		x_Descricao_do_componente = rs.getString("Descricao_do_componente");
	}else{
		x_Descricao_do_componente = "";
	}
	x_Qtd_minima = String.valueOf(rs.getLong("Qtd_minima"));
	if (rs.getString("Login") != null){
		x_Login = rs.getString("Login");
	}else{
		x_Login = "";
	}
		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add

		// Get fields from form
		if (request.getParameter("x_id_Categoria") != null){
			x_id_Categoria = request.getParameter("x_id_Categoria");
		}
		if (request.getParameter("x_Descricao_do_componente") != null){
			x_Descricao_do_componente = (String) request.getParameter("x_Descricao_do_componente");
		}else{
			x_Descricao_do_componente = "";
		}
		if (request.getParameter("x_Qtd_minima") != null){
			x_Qtd_minima = (String) request.getParameter("x_Qtd_minima");
		}else{
			x_Qtd_minima = "";
		}
		if (request.getParameter("x_Login") != null){
			x_Login = (String) request.getParameter("x_Login");
		}else{
			x_Login = "";
		}

		// Open record
		String strsql = "SELECT * FROM `componentes` WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field id_Categoria
		tmpfld = ((String) x_id_Categoria).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("id_Categoria");
		} else {
			rs.updateInt("id_Categoria",Integer.parseInt(tmpfld));
		}

		// Field Descricao_do_componente
		tmpfld = ((String) x_Descricao_do_componente);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("Descricao_do_componente");
		}else{
			rs.updateString("Descricao_do_componente", tmpfld);
		}

		// Field Qtd_minima
		tmpfld = ((String) x_Qtd_minima).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("Qtd_minima");
		} else {
			rs.updateInt("Qtd_minima",Integer.parseInt(tmpfld));
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
		response.sendRedirect("componenteslist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Adicionar TABELA: Componentes<br><br><a href="componenteslist.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_id_Categoria && !EW_hasValue(EW_this.x_id_Categoria, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_id_Categoria, "SELECT", "Informe a categoria do componente!"))
                return false; 
        }
if (EW_this.x_Descricao_do_componente && !EW_hasValue(EW_this.x_Descricao_do_componente, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_Descricao_do_componente, "TEXT", "Descreva o componente!"))
                return false; 
        }
if (EW_this.x_Qtd_minima && !EW_hasValue(EW_this.x_Qtd_minima, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_Qtd_minima, "TEXT", "Informe a quantidade minima que o estoque deve possuir!"))
                return false; 
        }
if (EW_this.x_Qtd_minima && !EW_checkinteger(EW_this.x_Qtd_minima.value)) {
        if (!EW_onError(EW_this, EW_this.x_Qtd_minima, "TEXT", "Informe a quantidade minima que o estoque deve possuir!"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="componentesadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Categoria_js = "";
String x_id_CategoriaList = "<select name=\"x_id_Categoria\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Categoria = "SELECT `id_Categoria`, `Descricao_da_categoria` FROM `categorias`" + " ORDER BY `Descricao_da_categoria` ASC";
Statement stmtwrk_x_id_Categoria = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Categoria = stmtwrk_x_id_Categoria.executeQuery(sqlwrk_x_id_Categoria);
	int rowcntwrk_x_id_Categoria = 0;
	while (rswrk_x_id_Categoria.next()) {
		x_id_CategoriaList += "<option value=\"" + HTMLEncode(rswrk_x_id_Categoria.getString("id_Categoria")) + "\"";
		if (rswrk_x_id_Categoria.getString("id_Categoria").equals(x_id_Categoria)) {
			x_id_CategoriaList += " selected";
		}
		String tmpValue_x_id_Categoria = "";
		if (rswrk_x_id_Categoria.getString("Descricao_da_categoria")!= null) tmpValue_x_id_Categoria = rswrk_x_id_Categoria.getString("Descricao_da_categoria");
		x_id_CategoriaList += ">" + tmpValue_x_id_Categoria
 + "</option>";
		rowcntwrk_x_id_Categoria++;
	}
rswrk_x_id_Categoria.close();
rswrk_x_id_Categoria = null;
stmtwrk_x_id_Categoria.close();
stmtwrk_x_id_Categoria = null;
x_id_CategoriaList += "</select>";
out.println(x_id_CategoriaList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Descricao do componente</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Descricao_do_componente" size="50" maxlength="50" value="<%= HTMLEncode((String)x_Descricao_do_componente) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Minima</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Qtd_minima" size="30" value="<%= HTMLEncode((String)x_Qtd_minima) %>"></span>&nbsp;</td>
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
