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
	response.sendRedirect("pedido_compralist.jsp"); 
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
	response.sendRedirect("pedido_compralist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_idPedido_Compra = null;
Object x_Numero_Pedido = null;
Object x_Observacao = null;
Object x_Tipo_de_Compra = null;
Object x_Login = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `pedido_compra` WHERE `idPedido_Compra`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("pedido_compralist.jsp");
			response.flushBuffer();
			return;
		}else{
			rs.first();

			// Get the field contents
	x_idPedido_Compra = String.valueOf(rs.getLong("idPedido_Compra"));
			if (rs.getString("Numero_Pedido") != null){
				x_Numero_Pedido = rs.getString("Numero_Pedido");
			}else{
				x_Numero_Pedido = "";
			}
			if (rs.getClob("Observacao") != null) {
				long length = rs.getClob("Observacao").length();
				x_Observacao = rs.getClob("Observacao").getSubString((long) 1, (int) length);
			}else{
				x_Observacao = "";
			}
	x_Tipo_de_Compra = String.valueOf(rs.getLong("Tipo_de_Compra"));
			if (rs.getString("Login") != null){
				x_Login = rs.getString("Login");
			}else{
				x_Login = "";
			}
		}
		rs.close();
	}else if (a.equals("U")) {// Update

		// Get fields from form
		if (request.getParameter("x_Numero_Pedido") != null){
			x_Numero_Pedido = (String) request.getParameter("x_Numero_Pedido");
		}else{
			x_Numero_Pedido = "";
		}
		if (request.getParameter("x_Observacao") != null){
			x_Observacao = (String) request.getParameter("x_Observacao");
		}else{
			x_Observacao = "";
		}
		if (request.getParameter("x_Tipo_de_Compra") != null){
			x_Tipo_de_Compra = request.getParameter("x_Tipo_de_Compra");
		}
		if (request.getParameter("x_Login") != null){
			x_Login = (String) request.getParameter("x_Login");
		}else{
			x_Login = "";
		}

		// Open record
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `pedido_compra` WHERE `idPedido_Compra`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("pedido_compralist.jsp");
			response.flushBuffer();
			return;
		}

		// Field Numero_Pedido
		tmpfld = ((String) x_Numero_Pedido);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("Numero_Pedido");
		}else{
			rs.updateString("Numero_Pedido", tmpfld);
		}

		// Field Observacao
		tmpfld = ((String) x_Observacao);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Observacao");
		}else{
			rs.updateString("Observacao", tmpfld);
		}

		// Field Tipo_de_Compra
		tmpfld = ((String) x_Tipo_de_Compra).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("Tipo_de_Compra");
		} else {
			rs.updateInt("Tipo_de_Compra",Integer.parseInt(tmpfld));
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
		response.sendRedirect("pedido_compralist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
		out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Editar TABELA: Pedidos de compra<br><br><a href="pedido_compralist.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
_editor_url = "";                     // URL to htmlarea files
var win_ie_ver = parseFloat(navigator.appVersion.split("MSIE")[1]);
if (navigator.userAgent.indexOf('Mac')        >= 0) { win_ie_ver = 0; }
if (navigator.userAgent.indexOf('Windows CE') >= 0) { win_ie_ver = 0; }
if (navigator.userAgent.indexOf('Opera')      >= 0) { win_ie_ver = 0; }
if (win_ie_ver >= 5.5) {
  document.write('<scr' + 'ipt src="' +_editor_url+ 'editor.js" language="Javascript"></scr' + 'ipt>');
} else { document.write('<scr'+'ipt>function editor_generate() { return false; }</scr'+'ipt>'); }

// end JavaScript -->
</script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_Numero_Pedido && !EW_hasValue(EW_this.x_Numero_Pedido, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_Numero_Pedido, "TEXT", "Forneca o numero do pedido no formato NNNN/ANO!"))
                return false; 
        }
if (EW_this.x_Observacao && !EW_hasValue(EW_this.x_Observacao, "TEXTAREA" )) {
            if (!EW_onError(EW_this, EW_this.x_Observacao, "TEXTAREA", "Informacoes sobre esta operacao sao essenciais!"))
                return false; 
        }
if (EW_this.x_Tipo_de_Compra && !EW_hasValue(EW_this.x_Tipo_de_Compra, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_Tipo_de_Compra, "SELECT", "Escolha uma forma de compra !"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="pedido_compraedit" action="pedido_compraedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_idPedido_Compra); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Numero do Pedido</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Numero_Pedido" size="10" maxlength="10" value="<%= HTMLEncode((String)x_Numero_Pedido) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Observacao</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Observacao" cols="80" rows="4"><% if (x_Observacao!=null) out.print(x_Observacao); %></textarea><script language="JavaScript1.2">editor_generate('x_Observacao');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Tipo de Compra</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_Tipo_de_Compra_js = "";
String x_Tipo_de_CompraList = "<select name=\"x_Tipo_de_Compra\"><option value=\"\">Selecione</option>";
x_Tipo_de_CompraList += "<option value=\"" + HTMLEncode("1") + "\"";
if (x_Tipo_de_Compra != null && x_Tipo_de_Compra.equals("1")) {
	x_Tipo_de_CompraList += " selected";
}
x_Tipo_de_CompraList += ">" + "Compra direta" + "</option>";
x_Tipo_de_CompraList += "<option value=\"" + HTMLEncode("2") + "\"";
if (x_Tipo_de_Compra != null && x_Tipo_de_Compra.equals("2")) {
	x_Tipo_de_CompraList += " selected";
}
x_Tipo_de_CompraList += ">" + "Licitacao" + "</option>";
x_Tipo_de_CompraList += "<option value=\"" + HTMLEncode("3") + "\"";
if (x_Tipo_de_Compra != null && x_Tipo_de_Compra.equals("3")) {
	x_Tipo_de_CompraList += " selected";
}
x_Tipo_de_CompraList += ">" + "Registro de precos" + "</option>";
x_Tipo_de_CompraList += "<option value=\"" + HTMLEncode("4") + "\"";
if (x_Tipo_de_Compra != null && x_Tipo_de_Compra.equals("4")) {
	x_Tipo_de_CompraList += " selected";
}
x_Tipo_de_CompraList += ">" + "Pregao eletronico" + "</option>";
x_Tipo_de_CompraList += "</select>";
out.print(x_Tipo_de_CompraList);
%>
</span>&nbsp;</td>
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
