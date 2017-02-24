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
ew_SecTable[0] = 11;
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
	response.sendRedirect("compra_componenteslist.jsp"); 
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
Object x_id_Compra_Componentes = null;
Object x_id_Componente = null;
Object x_idFornecedores = null;
Object x_idPedido_Compra = null;
Object x_Qtd_comprada = null;
Object x_Estado_do_componente = null;
Object x_Data_compra = null;
Object x_Valor_total_compra = null;
Object x_Login = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `compra_componentes` WHERE `id_Compra_Componentes`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("compra_componenteslist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

			// Get the field contents
	x_id_Componente = String.valueOf(rs.getLong("id_Componente"));
	x_idFornecedores = String.valueOf(rs.getLong("idFornecedores"));
	x_idPedido_Compra = String.valueOf(rs.getLong("idPedido_Compra"));
	x_Qtd_comprada = String.valueOf(rs.getLong("Qtd_comprada"));
	x_Estado_do_componente = String.valueOf(rs.getLong("Estado_do_componente"));
	if (rs.getTimestamp("Data_compra") != null){
		x_Data_compra = rs.getTimestamp("Data_compra");
	}else{
		x_Data_compra = null;
	}
	x_Valor_total_compra = String.valueOf(rs.getDouble("Valor_total_compra"));
	if (rs.getString("Login") != null){
		x_Login = rs.getString("Login");
	}else{
		x_Login = "";
	}
		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add

		// Get fields from form
		if (request.getParameter("x_id_Componente") != null){
			x_id_Componente = request.getParameter("x_id_Componente");
		}
		if (request.getParameter("x_idFornecedores") != null){
			x_idFornecedores = request.getParameter("x_idFornecedores");
		}
		if (request.getParameter("x_idPedido_Compra") != null){
			x_idPedido_Compra = request.getParameter("x_idPedido_Compra");
		}
		if (request.getParameter("x_Qtd_comprada") != null){
			x_Qtd_comprada = (String) request.getParameter("x_Qtd_comprada");
		}else{
			x_Qtd_comprada = "";
		}
		if (request.getParameter("x_Estado_do_componente") != null){
			x_Estado_do_componente = request.getParameter("x_Estado_do_componente");
		}
		if (request.getParameter("x_Data_compra") != null){
			x_Data_compra = (String) request.getParameter("x_Data_compra");
		}else{
			x_Data_compra = "";
		}
		if (request.getParameter("x_Valor_total_compra") != null){
			x_Valor_total_compra = (String) request.getParameter("x_Valor_total_compra");
		}else{
			x_Valor_total_compra = "";
		}
		if (request.getParameter("x_Login") != null){
			x_Login = (String) request.getParameter("x_Login");
		}else{
			x_Login = "";
		}

		// Open record
		String strsql = "SELECT * FROM `compra_componentes` WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field id_Componente
		tmpfld = ((String) x_id_Componente).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("id_Componente");
		} else {
			rs.updateInt("id_Componente",Integer.parseInt(tmpfld));
		}

		// Field idFornecedores
		tmpfld = ((String) x_idFornecedores).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("idFornecedores");
		} else {
			rs.updateInt("idFornecedores",Integer.parseInt(tmpfld));
		}

		// Field idPedido_Compra
		tmpfld = ((String) x_idPedido_Compra).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("idPedido_Compra");
		} else {
			rs.updateInt("idPedido_Compra",Integer.parseInt(tmpfld));
		}

		// Field Qtd_comprada
		tmpfld = ((String) x_Qtd_comprada).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("Qtd_comprada");
		} else {
			rs.updateInt("Qtd_comprada",Integer.parseInt(tmpfld));
		}

		// Field Estado_do_componente
		tmpfld = ((String) x_Estado_do_componente).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("Estado_do_componente");
		} else {
			rs.updateInt("Estado_do_componente",Integer.parseInt(tmpfld));
		}

		// Field Data_compra
		if (IsDate((String) x_Data_compra,"EURODATE", locale)) {
			rs.updateTimestamp("Data_compra", EW_UnFormatDateTime((String)x_Data_compra,"EURODATE", locale));
		}else{
			rs.updateNull("Data_compra");
		}

		// Field Valor_total_compra
		tmpfld = ((String) x_Valor_total_compra).trim();
		if (!IsNumeric(tmpfld)) {tmpfld = "0";}
		if (tmpfld != null) {
			rs.updateDouble("Valor_total_compra", Double.parseDouble(tmpfld));
		} else {
			rs.updateNull("Valor_total_compra");
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
		response.sendRedirect("compra_componenteslist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Adicionar TABELA: Compra de componentes<br><br><a href="compra_componenteslist.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_id_Componente && !EW_hasValue(EW_this.x_id_Componente, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_id_Componente, "SELECT", "Identifique o componente!"))
                return false; 
        }
if (EW_this.x_idFornecedores && !EW_hasValue(EW_this.x_idFornecedores, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_idFornecedores, "SELECT", "Informe o fornecedor!"))
                return false; 
        }
if (EW_this.x_idPedido_Compra && !EW_hasValue(EW_this.x_idPedido_Compra, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_idPedido_Compra, "SELECT", "Informe qual o pedido de compra!"))
                return false; 
        }
if (EW_this.x_Qtd_comprada && !EW_hasValue(EW_this.x_Qtd_comprada, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_Qtd_comprada, "TEXT", "Informe a quantidade comprada!"))
                return false; 
        }
if (EW_this.x_Qtd_comprada && !EW_checkinteger(EW_this.x_Qtd_comprada.value)) {
        if (!EW_onError(EW_this, EW_this.x_Qtd_comprada, "TEXT", "Informe a quantidade comprada!"))
            return false; 
        }
if (EW_this.x_Estado_do_componente && !EW_hasValue(EW_this.x_Estado_do_componente, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_Estado_do_componente, "SELECT", "Informe o estado do componente adquirido!"))
                return false; 
        }
if (EW_this.x_Data_compra && !EW_hasValue(EW_this.x_Data_compra, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_Data_compra, "TEXT", "Informe a data da compra!"))
                return false; 
        }
if (EW_this.x_Data_compra && !EW_checkeurodate(EW_this.x_Data_compra.value)) {
        if (!EW_onError(EW_this, EW_this.x_Data_compra, "TEXT", "Informe a data da compra!"))
            return false; 
        }
if (EW_this.x_Valor_total_compra && !EW_hasValue(EW_this.x_Valor_total_compra, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_Valor_total_compra, "TEXT", "Informe o valor total da compra (NAO use virgula! USE PONTO)!"))
                return false; 
        }
if (EW_this.x_Valor_total_compra && !EW_checknumber(EW_this.x_Valor_total_compra.value)) {
        if (!EW_onError(EW_this, EW_this.x_Valor_total_compra, "TEXT", "Informe o valor total da compra (NAO use virgula! USE PONTO)!"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="compra_componentesadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Componente</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Componente_js = "";
String x_id_ComponenteList = "<select name=\"x_id_Componente\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Componente = "SELECT `id_Componente`, `Descricao_do_componente` FROM `componentes`" + " ORDER BY `Descricao_do_componente` ASC";
Statement stmtwrk_x_id_Componente = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Componente = stmtwrk_x_id_Componente.executeQuery(sqlwrk_x_id_Componente);
	int rowcntwrk_x_id_Componente = 0;
	while (rswrk_x_id_Componente.next()) {
		x_id_ComponenteList += "<option value=\"" + HTMLEncode(rswrk_x_id_Componente.getString("id_Componente")) + "\"";
		if (rswrk_x_id_Componente.getString("id_Componente").equals(x_id_Componente)) {
			x_id_ComponenteList += " selected";
		}
		String tmpValue_x_id_Componente = "";
		if (rswrk_x_id_Componente.getString("Descricao_do_componente")!= null) tmpValue_x_id_Componente = rswrk_x_id_Componente.getString("Descricao_do_componente");
		x_id_ComponenteList += ">" + tmpValue_x_id_Componente
 + "</option>";
		rowcntwrk_x_id_Componente++;
	}
rswrk_x_id_Componente.close();
rswrk_x_id_Componente = null;
stmtwrk_x_id_Componente.close();
stmtwrk_x_id_Componente = null;
x_id_ComponenteList += "</select>";
out.println(x_id_ComponenteList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Fornecedor</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
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
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Pedido de Compra</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% String tmp_x_idPedido_Compra = (String) session.getAttribute("compra_componentes_masterkey");
if (tmp_x_idPedido_Compra != null && tmp_x_idPedido_Compra.length() > 0) {
x_idPedido_Compra = tmp_x_idPedido_Compra; %>
<%
if (x_idPedido_Compra!=null && ((String)x_idPedido_Compra).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_idPedido_Compra;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`idPedido_Compra` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `idPedido_Compra`, `Numero_Pedido` FROM `pedido_compra`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("Numero_Pedido"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
<input type="hidden" name="x_idPedido_Compra" value="<%= HTMLEncode((String)x_idPedido_Compra) %>">
<% } else { %>
<%
String cbo_x_idPedido_Compra_js = "";
String x_idPedido_CompraList = "<select name=\"x_idPedido_Compra\"><option value=\"\">Selecione</option>";
String sqlwrk_x_idPedido_Compra = "SELECT `idPedido_Compra`, `Numero_Pedido` FROM `pedido_compra`" + " ORDER BY `Numero_Pedido` ASC";
Statement stmtwrk_x_idPedido_Compra = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_idPedido_Compra = stmtwrk_x_idPedido_Compra.executeQuery(sqlwrk_x_idPedido_Compra);
	int rowcntwrk_x_idPedido_Compra = 0;
	while (rswrk_x_idPedido_Compra.next()) {
		x_idPedido_CompraList += "<option value=\"" + HTMLEncode(rswrk_x_idPedido_Compra.getString("idPedido_Compra")) + "\"";
		if (rswrk_x_idPedido_Compra.getString("idPedido_Compra").equals(x_idPedido_Compra)) {
			x_idPedido_CompraList += " selected";
		}
		String tmpValue_x_idPedido_Compra = "";
		if (rswrk_x_idPedido_Compra.getString("Numero_Pedido")!= null) tmpValue_x_idPedido_Compra = rswrk_x_idPedido_Compra.getString("Numero_Pedido");
		x_idPedido_CompraList += ">" + tmpValue_x_idPedido_Compra
 + "</option>";
		rowcntwrk_x_idPedido_Compra++;
	}
rswrk_x_idPedido_Compra.close();
rswrk_x_idPedido_Compra = null;
stmtwrk_x_idPedido_Compra.close();
stmtwrk_x_idPedido_Compra = null;
x_idPedido_CompraList += "</select>";
out.println(x_idPedido_CompraList);
%>
<% } %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Qtd comprada</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Qtd_comprada" size="30" value="<%= HTMLEncode((String)x_Qtd_comprada) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Estado do componente</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_Estado_do_componente_js = "";
String x_Estado_do_componenteList = "<select name=\"x_Estado_do_componente\"><option value=\"\">Selecione</option>";
x_Estado_do_componenteList += "<option value=\"" + HTMLEncode("1") + "\"";
if (x_Estado_do_componente != null && x_Estado_do_componente.equals("1")) {
	x_Estado_do_componenteList += " selected";
}
x_Estado_do_componenteList += ">" + "Novo" + "</option>";
x_Estado_do_componenteList += "<option value=\"" + HTMLEncode("2") + "\"";
if (x_Estado_do_componente != null && x_Estado_do_componente.equals("2")) {
	x_Estado_do_componenteList += " selected";
}
x_Estado_do_componenteList += ">" + "Seminovo" + "</option>";
x_Estado_do_componenteList += "<option value=\"" + HTMLEncode("3") + "\"";
if (x_Estado_do_componente != null && x_Estado_do_componente.equals("3")) {
	x_Estado_do_componenteList += " selected";
}
x_Estado_do_componenteList += ">" + "Recuperavel" + "</option>";
x_Estado_do_componenteList += "<option value=\"" + HTMLEncode("4") + "\"";
if (x_Estado_do_componente != null && x_Estado_do_componente.equals("4")) {
	x_Estado_do_componenteList += " selected";
}
x_Estado_do_componenteList += ">" + "Irrecuperavel" + "</option>";
x_Estado_do_componenteList += "</select>";
out.print(x_Estado_do_componenteList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Data compra</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Data_compra" value="<%= EW_FormatDateTime(x_Data_compra,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Pick a Date" onClick="popUpCalendar(this, this.form.x_Data_compra,'dd/mm/yyyy');return false;"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Valor total da compra</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Valor_total_compra" size="30" value="<%= HTMLEncode((String)x_Valor_total_compra) %>"></span>&nbsp;</td>
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
