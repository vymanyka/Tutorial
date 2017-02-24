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
if ((ewCurSec & ewAllowSearch) != ewAllowSearch) {
	response.sendRedirect("compra_componenteslist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
	String x_id_Compra_Componentes =  "";
	String x_id_Componente =  "";
	String x_idFornecedores =  "";
	String x_idPedido_Compra =  "";
	String x_Qtd_comprada =  "";
	String x_Estado_do_componente =  "";
	String x_Data_compra =  "";
	String x_Valor_total_compra =  "";
	String x_Login =  "";
String tmpfld = null;
String escapeString = "\\\\'";

// Get action
String a = request.getParameter("a");
String this_search_criteria = "";
if (a != null && a.equals("S")) { // Get Search Criteria

	// Build search criteria for advanced search, remove blank field
	String search_criteria = "";

	// id_Compra_Componentes
	if (request.getParameter("x_id_Compra_Componentes") != null){
		x_id_Compra_Componentes = request.getParameter("x_id_Compra_Componentes");
	}
	String z_id_Compra_Componentes = "";
	if (request.getParameterValues("z_id_Compra_Componentes") != null){
		String [] ary_z_id_Compra_Componentes = request.getParameterValues("z_id_Compra_Componentes");
		for (int i =0; i < ary_z_id_Compra_Componentes.length; i++){
			z_id_Compra_Componentes += ary_z_id_Compra_Componentes[i] + ",";
		}
		z_id_Compra_Componentes = z_id_Compra_Componentes.substring(0,z_id_Compra_Componentes.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Compra_Componentes.length() > 0) {
		String srchFld = x_id_Compra_Componentes;
		this_search_criteria = "x_id_Compra_Componentes=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Compra_Componentes=" + URLEncoder.encode(z_id_Compra_Componentes,"UTF-8");
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

	// id_Componente
	if (request.getParameter("x_id_Componente") != null){
		x_id_Componente = request.getParameter("x_id_Componente");
	}
	String z_id_Componente = "";
	if (request.getParameterValues("z_id_Componente") != null){
		String [] ary_z_id_Componente = request.getParameterValues("z_id_Componente");
		for (int i =0; i < ary_z_id_Componente.length; i++){
			z_id_Componente += ary_z_id_Componente[i] + ",";
		}
		z_id_Componente = z_id_Componente.substring(0,z_id_Componente.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Componente.length() > 0) {
		String srchFld = x_id_Componente;
		this_search_criteria = "x_id_Componente=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Componente=" + URLEncoder.encode(z_id_Componente,"UTF-8");
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

	// idFornecedores
	if (request.getParameter("x_idFornecedores") != null){
		x_idFornecedores = request.getParameter("x_idFornecedores");
	}
	String z_idFornecedores = "";
	if (request.getParameterValues("z_idFornecedores") != null){
		String [] ary_z_idFornecedores = request.getParameterValues("z_idFornecedores");
		for (int i =0; i < ary_z_idFornecedores.length; i++){
			z_idFornecedores += ary_z_idFornecedores[i] + ",";
		}
		z_idFornecedores = z_idFornecedores.substring(0,z_idFornecedores.length()-1);
	}
	this_search_criteria = "";
	if (x_idFornecedores.length() > 0) {
		String srchFld = x_idFornecedores;
		this_search_criteria = "x_idFornecedores=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_idFornecedores=" + URLEncoder.encode(z_idFornecedores,"UTF-8");
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

	// Qtd_comprada
	if (request.getParameter("x_Qtd_comprada") != null){
		x_Qtd_comprada = request.getParameter("x_Qtd_comprada");
	}
	String z_Qtd_comprada = "";
	if (request.getParameterValues("z_Qtd_comprada") != null){
		String [] ary_z_Qtd_comprada = request.getParameterValues("z_Qtd_comprada");
		for (int i =0; i < ary_z_Qtd_comprada.length; i++){
			z_Qtd_comprada += ary_z_Qtd_comprada[i] + ",";
		}
		z_Qtd_comprada = z_Qtd_comprada.substring(0,z_Qtd_comprada.length()-1);
	}
	this_search_criteria = "";
	if (x_Qtd_comprada.length() > 0) {
		String srchFld = x_Qtd_comprada;
		this_search_criteria = "x_Qtd_comprada=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Qtd_comprada=" + URLEncoder.encode(z_Qtd_comprada,"UTF-8");
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

	// Estado_do_componente
	if (request.getParameter("x_Estado_do_componente") != null){
		x_Estado_do_componente = request.getParameter("x_Estado_do_componente");
	}
	String z_Estado_do_componente = "";
	if (request.getParameterValues("z_Estado_do_componente") != null){
		String [] ary_z_Estado_do_componente = request.getParameterValues("z_Estado_do_componente");
		for (int i =0; i < ary_z_Estado_do_componente.length; i++){
			z_Estado_do_componente += ary_z_Estado_do_componente[i] + ",";
		}
		z_Estado_do_componente = z_Estado_do_componente.substring(0,z_Estado_do_componente.length()-1);
	}
	this_search_criteria = "";
	if (x_Estado_do_componente.length() > 0) {
		String srchFld = x_Estado_do_componente;
		this_search_criteria = "x_Estado_do_componente=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Estado_do_componente=" + URLEncoder.encode(z_Estado_do_componente,"UTF-8");
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

	// Data_compra
	if (request.getParameter("x_Data_compra") != null){
		x_Data_compra = request.getParameter("x_Data_compra");
	}
	String z_Data_compra = "";
	if (request.getParameterValues("z_Data_compra") != null){
		String [] ary_z_Data_compra = request.getParameterValues("z_Data_compra");
		for (int i =0; i < ary_z_Data_compra.length; i++){
			z_Data_compra += ary_z_Data_compra[i] + ",";
		}
		z_Data_compra = z_Data_compra.substring(0,z_Data_compra.length()-1);
	}
	this_search_criteria = "";
	if (x_Data_compra.length() > 0) {
		String srchFld = x_Data_compra;

		//srchFld = EW_UnFormatDateTime(srchFld,"EURODATE", locale).toString();
		this_search_criteria = "x_Data_compra=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Data_compra=" + URLEncoder.encode(z_Data_compra,"UTF-8");
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

	// Valor_total_compra
	if (request.getParameter("x_Valor_total_compra") != null){
		x_Valor_total_compra = request.getParameter("x_Valor_total_compra");
	}
	String z_Valor_total_compra = "";
	if (request.getParameterValues("z_Valor_total_compra") != null){
		String [] ary_z_Valor_total_compra = request.getParameterValues("z_Valor_total_compra");
		for (int i =0; i < ary_z_Valor_total_compra.length; i++){
			z_Valor_total_compra += ary_z_Valor_total_compra[i] + ",";
		}
		z_Valor_total_compra = z_Valor_total_compra.substring(0,z_Valor_total_compra.length()-1);
	}
	this_search_criteria = "";
	if (x_Valor_total_compra.length() > 0) {
		String srchFld = x_Valor_total_compra;
		this_search_criteria = "x_Valor_total_compra=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Valor_total_compra=" + URLEncoder.encode(z_Valor_total_compra,"UTF-8");
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
		response.sendRedirect("compra_componenteslist.jsp" + "?" + search_criteria);
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
<p><span class="jspmaker">Procurar TABELA: Compra de componentes<br><br><a href="compra_componenteslist.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_id_Compra_Componentes && !EW_checkinteger(EW_this.x_id_Compra_Componentes.value)) {
        if (!EW_onError(EW_this, EW_this.x_id_Compra_Componentes, "TEXT", "Numero inteiro invalido! - Codigo"))
            return false; 
        }
if (EW_this.x_Qtd_comprada && !EW_checkinteger(EW_this.x_Qtd_comprada.value)) {
        if (!EW_onError(EW_this, EW_this.x_Qtd_comprada, "TEXT", "Informe a quantidade comprada!"))
            return false; 
        }
if (EW_this.x_Data_compra && !EW_checkeurodate(EW_this.x_Data_compra.value)) {
        if (!EW_onError(EW_this, EW_this.x_Data_compra, "TEXT", "Informe a data da compra!"))
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
<form onSubmit="return EW_checkMyForm(this);"  action="compra_componentessrch.jsp" method="post">
<p>
<input type="hidden" name="a" value="S">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Compra_Componentes" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_id_Compra_Componentes" value="<%= HTMLEncode((String)x_id_Compra_Componentes) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Componente</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Componente" value="=, , ">=
</span>&nbsp;</td>
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
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_idFornecedores" value="=, , ">=
</span>&nbsp;</td>
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
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_idPedido_Compra" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
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
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Qtd comprada</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Qtd_comprada" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Qtd_comprada" size="30" value="<%= HTMLEncode((String)x_Qtd_comprada) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Estado do componente</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Estado_do_componente" value="=, , ">=
</span>&nbsp;</td>
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
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Data_compra" value="=, ','">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Data_compra" value="<%= EW_FormatDateTime(x_Data_compra,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Pick a Date" onClick="popUpCalendar(this, this.form.x_Data_compra,'dd/mm/yyyy');return false;"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Valor total da compra</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Valor_total_compra" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Valor_total_compra" size="30" value="<%= HTMLEncode((String)x_Valor_total_compra) %>"></span>&nbsp;</td>
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
