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
if ((ewCurSec & ewAllowSearch) != ewAllowSearch) {
	response.sendRedirect("movimentacaolist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
	String x_id_Movimentacao =  "";
	String x_id_Bem =  "";
	String x_Siga =  "";
	String x_Data_Entrada =  "";
	String x_Situacao =  "";
	String x_Detalhes_da_Movimentacao =  "";
	String x_Garantia =  "";
	String x_Lotacao_Destino =  "";
	String x_Resp_Transporte =  "";
	String x_Login =  "";
String tmpfld = null;
String escapeString = "\\\\'";

// Get action
String a = request.getParameter("a");
String this_search_criteria = "";
if (a != null && a.equals("S")) { // Get Search Criteria

	// Build search criteria for advanced search, remove blank field
	String search_criteria = "";

	// id_Movimentacao
	if (request.getParameter("x_id_Movimentacao") != null){
		x_id_Movimentacao = request.getParameter("x_id_Movimentacao");
	}
	String z_id_Movimentacao = "";
	if (request.getParameterValues("z_id_Movimentacao") != null){
		String [] ary_z_id_Movimentacao = request.getParameterValues("z_id_Movimentacao");
		for (int i =0; i < ary_z_id_Movimentacao.length; i++){
			z_id_Movimentacao += ary_z_id_Movimentacao[i] + ",";
		}
		z_id_Movimentacao = z_id_Movimentacao.substring(0,z_id_Movimentacao.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Movimentacao.length() > 0) {
		String srchFld = x_id_Movimentacao;
		this_search_criteria = "x_id_Movimentacao=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Movimentacao=" + URLEncoder.encode(z_id_Movimentacao,"UTF-8");
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

	// id_Bem
	if (request.getParameter("x_id_Bem") != null){
		x_id_Bem = request.getParameter("x_id_Bem");
	}
	String z_id_Bem = "";
	if (request.getParameterValues("z_id_Bem") != null){
		String [] ary_z_id_Bem = request.getParameterValues("z_id_Bem");
		for (int i =0; i < ary_z_id_Bem.length; i++){
			z_id_Bem += ary_z_id_Bem[i] + ",";
		}
		z_id_Bem = z_id_Bem.substring(0,z_id_Bem.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Bem.length() > 0) {
		String srchFld = x_id_Bem;
		this_search_criteria = "x_id_Bem=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Bem=" + URLEncoder.encode(z_id_Bem,"UTF-8");
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

	// Siga
	if (request.getParameter("x_Siga") != null){
		x_Siga = request.getParameter("x_Siga");
	}
	String z_Siga = "";
	if (request.getParameterValues("z_Siga") != null){
		String [] ary_z_Siga = request.getParameterValues("z_Siga");
		for (int i =0; i < ary_z_Siga.length; i++){
			z_Siga += ary_z_Siga[i] + ",";
		}
		z_Siga = z_Siga.substring(0,z_Siga.length()-1);
	}
	this_search_criteria = "";
	if (x_Siga.length() > 0) {
		String srchFld = x_Siga;
		this_search_criteria = "x_Siga=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Siga=" + URLEncoder.encode(z_Siga,"UTF-8");
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

	// Data_Entrada
	if (request.getParameter("x_Data_Entrada") != null){
		x_Data_Entrada = request.getParameter("x_Data_Entrada");
	}
	String z_Data_Entrada = "";
	if (request.getParameterValues("z_Data_Entrada") != null){
		String [] ary_z_Data_Entrada = request.getParameterValues("z_Data_Entrada");
		for (int i =0; i < ary_z_Data_Entrada.length; i++){
			z_Data_Entrada += ary_z_Data_Entrada[i] + ",";
		}
		z_Data_Entrada = z_Data_Entrada.substring(0,z_Data_Entrada.length()-1);
	}
	this_search_criteria = "";
	if (x_Data_Entrada.length() > 0) {
		String srchFld = x_Data_Entrada;

		//srchFld = EW_UnFormatDateTime(srchFld,"EURODATE", locale).toString();
		this_search_criteria = "x_Data_Entrada=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Data_Entrada=" + URLEncoder.encode(z_Data_Entrada,"UTF-8");
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

	// Situacao
	if (request.getParameter("x_Situacao") != null){
		x_Situacao = request.getParameter("x_Situacao");
	}
	String z_Situacao = "";
	if (request.getParameterValues("z_Situacao") != null){
		String [] ary_z_Situacao = request.getParameterValues("z_Situacao");
		for (int i =0; i < ary_z_Situacao.length; i++){
			z_Situacao += ary_z_Situacao[i] + ",";
		}
		z_Situacao = z_Situacao.substring(0,z_Situacao.length()-1);
	}
	this_search_criteria = "";
	if (x_Situacao.length() > 0) {
		String srchFld = x_Situacao;
		this_search_criteria = "x_Situacao=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Situacao=" + URLEncoder.encode(z_Situacao,"UTF-8");
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

	// Detalhes_da_Movimentacao
	if (request.getParameter("x_Detalhes_da_Movimentacao") != null){
		x_Detalhes_da_Movimentacao = request.getParameter("x_Detalhes_da_Movimentacao");
	}
	String z_Detalhes_da_Movimentacao = "";
	if (request.getParameterValues("z_Detalhes_da_Movimentacao") != null){
		String [] ary_z_Detalhes_da_Movimentacao = request.getParameterValues("z_Detalhes_da_Movimentacao");
		for (int i =0; i < ary_z_Detalhes_da_Movimentacao.length; i++){
			z_Detalhes_da_Movimentacao += ary_z_Detalhes_da_Movimentacao[i] + ",";
		}
		z_Detalhes_da_Movimentacao = z_Detalhes_da_Movimentacao.substring(0,z_Detalhes_da_Movimentacao.length()-1);
	}
	this_search_criteria = "";
	if (x_Detalhes_da_Movimentacao.length() > 0) {
		String srchFld = x_Detalhes_da_Movimentacao;
		this_search_criteria = "x_Detalhes_da_Movimentacao=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Detalhes_da_Movimentacao=" + URLEncoder.encode(z_Detalhes_da_Movimentacao,"UTF-8");
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

	// Garantia
	if (request.getParameter("x_Garantia") != null){
		x_Garantia = request.getParameter("x_Garantia");
	}
	String z_Garantia = "";
	if (request.getParameterValues("z_Garantia") != null){
		String [] ary_z_Garantia = request.getParameterValues("z_Garantia");
		for (int i =0; i < ary_z_Garantia.length; i++){
			z_Garantia += ary_z_Garantia[i] + ",";
		}
		z_Garantia = z_Garantia.substring(0,z_Garantia.length()-1);
	}
	this_search_criteria = "";
	if (x_Garantia.length() > 0) {
		String srchFld = x_Garantia;
		this_search_criteria = "x_Garantia=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Garantia=" + URLEncoder.encode(z_Garantia,"UTF-8");
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

	// Lotacao_Destino
	if (request.getParameter("x_Lotacao_Destino") != null){
		x_Lotacao_Destino = request.getParameter("x_Lotacao_Destino");
	}
	String z_Lotacao_Destino = "";
	if (request.getParameterValues("z_Lotacao_Destino") != null){
		String [] ary_z_Lotacao_Destino = request.getParameterValues("z_Lotacao_Destino");
		for (int i =0; i < ary_z_Lotacao_Destino.length; i++){
			z_Lotacao_Destino += ary_z_Lotacao_Destino[i] + ",";
		}
		z_Lotacao_Destino = z_Lotacao_Destino.substring(0,z_Lotacao_Destino.length()-1);
	}
	this_search_criteria = "";
	if (x_Lotacao_Destino.length() > 0) {
		String srchFld = x_Lotacao_Destino;
		this_search_criteria = "x_Lotacao_Destino=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Lotacao_Destino=" + URLEncoder.encode(z_Lotacao_Destino,"UTF-8");
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

	// Resp_Transporte
	if (request.getParameter("x_Resp_Transporte") != null){
		x_Resp_Transporte = request.getParameter("x_Resp_Transporte");
	}
	String z_Resp_Transporte = "";
	if (request.getParameterValues("z_Resp_Transporte") != null){
		String [] ary_z_Resp_Transporte = request.getParameterValues("z_Resp_Transporte");
		for (int i =0; i < ary_z_Resp_Transporte.length; i++){
			z_Resp_Transporte += ary_z_Resp_Transporte[i] + ",";
		}
		z_Resp_Transporte = z_Resp_Transporte.substring(0,z_Resp_Transporte.length()-1);
	}
	this_search_criteria = "";
	if (x_Resp_Transporte.length() > 0) {
		String srchFld = x_Resp_Transporte;
		this_search_criteria = "x_Resp_Transporte=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Resp_Transporte=" + URLEncoder.encode(z_Resp_Transporte,"UTF-8");
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
		response.sendRedirect("movimentacaolist.jsp" + "?" + search_criteria);
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
<p><span class="jspmaker">Procurar TABELA: Livro de ocorrencias<br><br><a href="movimentacaolist.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>
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
if (EW_this.x_id_Movimentacao && !EW_checkinteger(EW_this.x_id_Movimentacao.value)) {
        if (!EW_onError(EW_this, EW_this.x_id_Movimentacao, "TEXT", "Numero inteiro invalido! - Codigo"))
            return false; 
        }
if (EW_this.x_Siga && !EW_checkinteger(EW_this.x_Siga.value)) {
        if (!EW_onError(EW_this, EW_this.x_Siga, "TEXT", "Forneça o número SIGA!"))
            return false; 
        }
if (EW_this.x_Data_Entrada && !EW_checkeurodate(EW_this.x_Data_Entrada.value)) {
        if (!EW_onError(EW_this, EW_this.x_Data_Entrada, "TEXT", "Forneca a data da movimentacao!"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="movimentacaosrch.jsp" method="post">
<p>
<input type="hidden" name="a" value="S">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Movimentacao" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_id_Movimentacao" value="<%= HTMLEncode((String)x_id_Movimentacao) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Tombamento</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Bem" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Bem_js = "";
String x_id_BemList = "<select name=\"x_id_Bem\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Bem = "SELECT `id_Bem` FROM `bens`" + " ORDER BY `id_Bem` ASC";
Statement stmtwrk_x_id_Bem = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Bem = stmtwrk_x_id_Bem.executeQuery(sqlwrk_x_id_Bem);
	int rowcntwrk_x_id_Bem = 0;
	while (rswrk_x_id_Bem.next()) {
		x_id_BemList += "<option value=\"" + HTMLEncode(rswrk_x_id_Bem.getString("id_Bem")) + "\"";
		if (rswrk_x_id_Bem.getString("id_Bem").equals(x_id_Bem)) {
			x_id_BemList += " selected";
		}
		String tmpValue_x_id_Bem = "";
		if (rswrk_x_id_Bem.getString("id_Bem")!= null) tmpValue_x_id_Bem = rswrk_x_id_Bem.getString("id_Bem");
		x_id_BemList += ">" + tmpValue_x_id_Bem
 + "</option>";
		rowcntwrk_x_id_Bem++;
	}
rswrk_x_id_Bem.close();
rswrk_x_id_Bem = null;
stmtwrk_x_id_Bem.close();
stmtwrk_x_id_Bem = null;
x_id_BemList += "</select>";
out.println(x_id_BemList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Siga</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Siga" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Siga" size="30" value="<%= HTMLEncode((String)x_Siga) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Data da ocorrencia</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Data_Entrada" value="=, ','">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Data_Entrada" value="<%= EW_FormatDateTime(x_Data_Entrada,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Pick a Date" onClick="popUpCalendar(this, this.form.x_Data_Entrada,'dd/mm/yyyy');return false;"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Situacao</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Situacao" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="radio" name="x_Situacao" value="<%= HTMLEncode("1") %>"><%= "Bom" %>
<input type="radio" name="x_Situacao" value="<%= HTMLEncode("2") %>"><%= "Danificado" %>
<input type="radio" name="x_Situacao" value="<%= HTMLEncode("3") %>"><%= "Anti-economico" %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Detalhes da ocorrencia</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Detalhes_da_Movimentacao" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Detalhes_da_Movimentacao" cols="80" rows="4"><% if (x_Detalhes_da_Movimentacao!=null) out.print(x_Detalhes_da_Movimentacao); %></textarea><script language="JavaScript1.2">editor_generate('x_Detalhes_da_Movimentacao');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Garantia</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Garantia" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="radio" name="x_Garantia" value="<%= HTMLEncode("1") %>"><%= "Na garantia" %>
<input type="radio" name="x_Garantia" value="<%= HTMLEncode("2") %>"><%= "Fora da garantia" %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Lotacao de destino</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Lotacao_Destino" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_Lotacao_Destino_js = "";
String x_Lotacao_DestinoList = "<select name=\"x_Lotacao_Destino\"><option value=\"\">Selecione</option>";
String sqlwrk_x_Lotacao_Destino = "SELECT `id_Lotacoes`, `Descricao_da_lotacao` FROM `lotacoes`" + " ORDER BY `Descricao_da_lotacao` ASC";
Statement stmtwrk_x_Lotacao_Destino = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_Lotacao_Destino = stmtwrk_x_Lotacao_Destino.executeQuery(sqlwrk_x_Lotacao_Destino);
	int rowcntwrk_x_Lotacao_Destino = 0;
	while (rswrk_x_Lotacao_Destino.next()) {
		x_Lotacao_DestinoList += "<option value=\"" + HTMLEncode(rswrk_x_Lotacao_Destino.getString("id_Lotacoes")) + "\"";
		if (rswrk_x_Lotacao_Destino.getString("id_Lotacoes").equals(x_Lotacao_Destino)) {
			x_Lotacao_DestinoList += " selected";
		}
		String tmpValue_x_Lotacao_Destino = "";
		if (rswrk_x_Lotacao_Destino.getString("Descricao_da_lotacao")!= null) tmpValue_x_Lotacao_Destino = rswrk_x_Lotacao_Destino.getString("Descricao_da_lotacao");
		x_Lotacao_DestinoList += ">" + tmpValue_x_Lotacao_Destino
 + "</option>";
		rowcntwrk_x_Lotacao_Destino++;
	}
rswrk_x_Lotacao_Destino.close();
rswrk_x_Lotacao_Destino = null;
stmtwrk_x_Lotacao_Destino.close();
stmtwrk_x_Lotacao_Destino = null;
x_Lotacao_DestinoList += "</select>";
out.println(x_Lotacao_DestinoList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Quem movimentou?</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Resp_Transporte" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Resp_Transporte" size="40" maxlength="20" value="<%= HTMLEncode((String)x_Resp_Transporte) %>"></span>&nbsp;</td>
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
