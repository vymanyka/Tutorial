<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*,java.net.*"%>
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
if ((ewCurSec & ewAllowSearch) != ewAllowSearch) {
	response.sendRedirect("pedido_compralist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
	String x_idPedido_Compra =  "";
	String x_Numero_Pedido =  "";
	String x_Observacao =  "";
	String x_Tipo_de_Compra =  "";
	String x_Login =  "";
String tmpfld = null;
String escapeString = "\\\\'";

// Get action
String a = request.getParameter("a");
String this_search_criteria = "";
if (a != null && a.equals("S")) { // Get Search Criteria

	// Build search criteria for advanced search, remove blank field
	String search_criteria = "";

	// idPedido_Compra
	if (request.getParameter("x_idPedido_Compra") != null){
		x_idPedido_Compra = request.getParameter("x_idPedido_Compra");
	}
	String z_idPedido_Compra = "";
	if (request.getParameterValues("z_idPedido_Compra") != null){
		String [] ary_z_idPedido_Compra = request.getParameterValues("z_idPedido_Compra");
		for (int i =0; i < ary_z_idPedido_Compra.length; i++){
			z_idPedido_Compra += ary_z_idPedido_Compra[i] + ",";
		}
		z_idPedido_Compra = z_idPedido_Compra.substring(0,z_idPedido_Compra.length()-1);
	}
	this_search_criteria = "";
	if (x_idPedido_Compra.length() > 0) {
		String srchFld = x_idPedido_Compra;
		this_search_criteria = "x_idPedido_Compra=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_idPedido_Compra=" + URLEncoder.encode(z_idPedido_Compra,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// Numero_Pedido
	if (request.getParameter("x_Numero_Pedido") != null){
		x_Numero_Pedido = request.getParameter("x_Numero_Pedido");
	}
	String z_Numero_Pedido = "";
	if (request.getParameterValues("z_Numero_Pedido") != null){
		String [] ary_z_Numero_Pedido = request.getParameterValues("z_Numero_Pedido");
		for (int i =0; i < ary_z_Numero_Pedido.length; i++){
			z_Numero_Pedido += ary_z_Numero_Pedido[i] + ",";
		}
		z_Numero_Pedido = z_Numero_Pedido.substring(0,z_Numero_Pedido.length()-1);
	}
	this_search_criteria = "";
	if (x_Numero_Pedido.length() > 0) {
		String srchFld = x_Numero_Pedido;
		this_search_criteria = "x_Numero_Pedido=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Numero_Pedido=" + URLEncoder.encode(z_Numero_Pedido,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// Observacao
	if (request.getParameter("x_Observacao") != null){
		x_Observacao = request.getParameter("x_Observacao");
	}
	String z_Observacao = "";
	if (request.getParameterValues("z_Observacao") != null){
		String [] ary_z_Observacao = request.getParameterValues("z_Observacao");
		for (int i =0; i < ary_z_Observacao.length; i++){
			z_Observacao += ary_z_Observacao[i] + ",";
		}
		z_Observacao = z_Observacao.substring(0,z_Observacao.length()-1);
	}
	this_search_criteria = "";
	if (x_Observacao.length() > 0) {
		String srchFld = x_Observacao;
		this_search_criteria = "x_Observacao=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Observacao=" + URLEncoder.encode(z_Observacao,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// Tipo_de_Compra
	if (request.getParameter("x_Tipo_de_Compra") != null){
		x_Tipo_de_Compra = request.getParameter("x_Tipo_de_Compra");
	}
	String z_Tipo_de_Compra = "";
	if (request.getParameterValues("z_Tipo_de_Compra") != null){
		String [] ary_z_Tipo_de_Compra = request.getParameterValues("z_Tipo_de_Compra");
		for (int i =0; i < ary_z_Tipo_de_Compra.length; i++){
			z_Tipo_de_Compra += ary_z_Tipo_de_Compra[i] + ",";
		}
		z_Tipo_de_Compra = z_Tipo_de_Compra.substring(0,z_Tipo_de_Compra.length()-1);
	}
	this_search_criteria = "";
	if (x_Tipo_de_Compra.length() > 0) {
		String srchFld = x_Tipo_de_Compra;
		this_search_criteria = "x_Tipo_de_Compra=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Tipo_de_Compra=" + URLEncoder.encode(z_Tipo_de_Compra,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}

	// Login
	if (request.getParameter("x_Login") != null){
		x_Login = request.getParameter("x_Login");
	}
	String z_Login = "";
	if (request.getParameterValues("z_Login") != null){
		String [] ary_z_Login = request.getParameterValues("z_Login");
		for (int i =0; i < ary_z_Login.length; i++){
			z_Login += ary_z_Login[i] + ",";
		}
		z_Login = z_Login.substring(0,z_Login.length()-1);
	}
	this_search_criteria = "";
	if (x_Login.length() > 0) {
		String srchFld = x_Login;
		this_search_criteria = "x_Login=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Login=" + URLEncoder.encode(z_Login,"UTF-8");
	}else{
		this_search_criteria = "";
	}
	if (this_search_criteria.length() > 0) {
		if (search_criteria.length() == 0) {
			search_criteria = this_search_criteria;
		}else{
			search_criteria = search_criteria + "&" + this_search_criteria;
		}
	}
	if (search_criteria.length() > 0) {
		out.clear();
		response.sendRedirect("pedido_compralist.jsp" + "?" + search_criteria);
		response.flushBuffer();
		return;
	}
}

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Procurar TABELA: Pedidos de compra<br><br><a href="pedido_compralist.jsp">Voltar a lista</a></span></p>
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
if (EW_this.x_idPedido_Compra && !EW_checkinteger(EW_this.x_idPedido_Compra.value)) {
        if (!EW_onError(EW_this, EW_this.x_idPedido_Compra, "TEXT", "Numero inteiro invalido! - Codigo"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="pedido_comprasrch.jsp" method="post">
<p>
<input type="hidden" name="a" value="S">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_idPedido_Compra" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_idPedido_Compra" value="<%= HTMLEncode((String)x_idPedido_Compra) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Numero do Pedido</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Numero_Pedido" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Numero_Pedido" size="10" maxlength="10" value="<%= HTMLEncode((String)x_Numero_Pedido) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Observacao</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Observacao" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Observacao" cols="80" rows="4"><% if (x_Observacao!=null) out.print(x_Observacao); %></textarea><script language="JavaScript1.2">editor_generate('x_Observacao');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Tipo de Compra</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Tipo_de_Compra" value="=, , ">=
</span>&nbsp;</td>
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
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Login" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Login" size="30" maxlength="10" value="<%= HTMLEncode((String)x_Login) %>"></span>&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="Procurar">
</form>
<%@ include file="footer.jsp" %>
<%
	conn.close();
	conn = null;
}catch(SQLException ex){
	out.println(ex.toString());
}
%>
