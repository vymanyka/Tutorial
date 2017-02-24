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
ew_SecTable[0] = 8;
ew_SecTable[1] = 11;
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
	response.sendRedirect("instal_componenteslist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
	String x_id_Instal_Componentes =  "";
	String x_id_Componente =  "";
	String x_id_Problema =  "";
	String x_Origem_Componente =  "";
	String x_Data_instalacao =  "";
	String x_Qtd_instalacao =  "";
	String x_Detalhes_da_instalacao =  "";
	String x_Relacao_confianca =  "";
	String x_Com_quem =  "";
	String x_Telefone_confianca =  "";
	String x_Login =  "";
String tmpfld = null;
String escapeString = "\\\\'";

// Get action
String a = request.getParameter("a");
String this_search_criteria = "";
if (a != null && a.equals("S")) { // Get Search Criteria

	// Build search criteria for advanced search, remove blank field
	String search_criteria = "";

	// id_Instal_Componentes
	if (request.getParameter("x_id_Instal_Componentes") != null){
		x_id_Instal_Componentes = request.getParameter("x_id_Instal_Componentes");
	}
	String z_id_Instal_Componentes = "";
	if (request.getParameterValues("z_id_Instal_Componentes") != null){
		String [] ary_z_id_Instal_Componentes = request.getParameterValues("z_id_Instal_Componentes");
		for (int i =0; i < ary_z_id_Instal_Componentes.length; i++){
			z_id_Instal_Componentes += ary_z_id_Instal_Componentes[i] + ",";
		}
		z_id_Instal_Componentes = z_id_Instal_Componentes.substring(0,z_id_Instal_Componentes.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Instal_Componentes.length() > 0) {
		String srchFld = x_id_Instal_Componentes;
		this_search_criteria = "x_id_Instal_Componentes=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Instal_Componentes=" + URLEncoder.encode(z_id_Instal_Componentes,"UTF-8");
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

	// id_Problema
	if (request.getParameter("x_id_Problema") != null){
		x_id_Problema = request.getParameter("x_id_Problema");
	}
	String z_id_Problema = "";
	if (request.getParameterValues("z_id_Problema") != null){
		String [] ary_z_id_Problema = request.getParameterValues("z_id_Problema");
		for (int i =0; i < ary_z_id_Problema.length; i++){
			z_id_Problema += ary_z_id_Problema[i] + ",";
		}
		z_id_Problema = z_id_Problema.substring(0,z_id_Problema.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Problema.length() > 0) {
		String srchFld = x_id_Problema;
		this_search_criteria = "x_id_Problema=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Problema=" + URLEncoder.encode(z_id_Problema,"UTF-8");
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

	// Origem_Componente
	if (request.getParameter("x_Origem_Componente") != null){
		x_Origem_Componente = request.getParameter("x_Origem_Componente");
	}
	String z_Origem_Componente = "";
	if (request.getParameterValues("z_Origem_Componente") != null){
		String [] ary_z_Origem_Componente = request.getParameterValues("z_Origem_Componente");
		for (int i =0; i < ary_z_Origem_Componente.length; i++){
			z_Origem_Componente += ary_z_Origem_Componente[i] + ",";
		}
		z_Origem_Componente = z_Origem_Componente.substring(0,z_Origem_Componente.length()-1);
	}
	this_search_criteria = "";
	if (x_Origem_Componente.length() > 0) {
		String srchFld = x_Origem_Componente;
		this_search_criteria = "x_Origem_Componente=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Origem_Componente=" + URLEncoder.encode(z_Origem_Componente,"UTF-8");
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

	// Data_instalacao
	if (request.getParameter("x_Data_instalacao") != null){
		x_Data_instalacao = request.getParameter("x_Data_instalacao");
	}
	String z_Data_instalacao = "";
	if (request.getParameterValues("z_Data_instalacao") != null){
		String [] ary_z_Data_instalacao = request.getParameterValues("z_Data_instalacao");
		for (int i =0; i < ary_z_Data_instalacao.length; i++){
			z_Data_instalacao += ary_z_Data_instalacao[i] + ",";
		}
		z_Data_instalacao = z_Data_instalacao.substring(0,z_Data_instalacao.length()-1);
	}
	this_search_criteria = "";
	if (x_Data_instalacao.length() > 0) {
		String srchFld = x_Data_instalacao;

		//srchFld = EW_UnFormatDateTime(srchFld,"EURODATE", locale).toString();
		this_search_criteria = "x_Data_instalacao=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Data_instalacao=" + URLEncoder.encode(z_Data_instalacao,"UTF-8");
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

	// Qtd_instalacao
	if (request.getParameter("x_Qtd_instalacao") != null){
		x_Qtd_instalacao = request.getParameter("x_Qtd_instalacao");
	}
	String z_Qtd_instalacao = "";
	if (request.getParameterValues("z_Qtd_instalacao") != null){
		String [] ary_z_Qtd_instalacao = request.getParameterValues("z_Qtd_instalacao");
		for (int i =0; i < ary_z_Qtd_instalacao.length; i++){
			z_Qtd_instalacao += ary_z_Qtd_instalacao[i] + ",";
		}
		z_Qtd_instalacao = z_Qtd_instalacao.substring(0,z_Qtd_instalacao.length()-1);
	}
	this_search_criteria = "";
	if (x_Qtd_instalacao.length() > 0) {
		String srchFld = x_Qtd_instalacao;
		this_search_criteria = "x_Qtd_instalacao=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Qtd_instalacao=" + URLEncoder.encode(z_Qtd_instalacao,"UTF-8");
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

	// Detalhes_da_instalacao
	if (request.getParameter("x_Detalhes_da_instalacao") != null){
		x_Detalhes_da_instalacao = request.getParameter("x_Detalhes_da_instalacao");
	}
	String z_Detalhes_da_instalacao = "";
	if (request.getParameterValues("z_Detalhes_da_instalacao") != null){
		String [] ary_z_Detalhes_da_instalacao = request.getParameterValues("z_Detalhes_da_instalacao");
		for (int i =0; i < ary_z_Detalhes_da_instalacao.length; i++){
			z_Detalhes_da_instalacao += ary_z_Detalhes_da_instalacao[i] + ",";
		}
		z_Detalhes_da_instalacao = z_Detalhes_da_instalacao.substring(0,z_Detalhes_da_instalacao.length()-1);
	}
	this_search_criteria = "";
	if (x_Detalhes_da_instalacao.length() > 0) {
		String srchFld = x_Detalhes_da_instalacao;
		this_search_criteria = "x_Detalhes_da_instalacao=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Detalhes_da_instalacao=" + URLEncoder.encode(z_Detalhes_da_instalacao,"UTF-8");
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

	// Relacao_confianca
	if (request.getParameter("x_Relacao_confianca") != null){
		x_Relacao_confianca = request.getParameter("x_Relacao_confianca");
	}
	String z_Relacao_confianca = "";
	if (request.getParameterValues("z_Relacao_confianca") != null){
		String [] ary_z_Relacao_confianca = request.getParameterValues("z_Relacao_confianca");
		for (int i =0; i < ary_z_Relacao_confianca.length; i++){
			z_Relacao_confianca += ary_z_Relacao_confianca[i] + ",";
		}
		z_Relacao_confianca = z_Relacao_confianca.substring(0,z_Relacao_confianca.length()-1);
	}
	this_search_criteria = "";
	if (x_Relacao_confianca.length() > 0) {
		String srchFld = x_Relacao_confianca;
		this_search_criteria = "x_Relacao_confianca=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Relacao_confianca=" + URLEncoder.encode(z_Relacao_confianca,"UTF-8");
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

	// Com_quem
	if (request.getParameter("x_Com_quem") != null){
		x_Com_quem = request.getParameter("x_Com_quem");
	}
	String z_Com_quem = "";
	if (request.getParameterValues("z_Com_quem") != null){
		String [] ary_z_Com_quem = request.getParameterValues("z_Com_quem");
		for (int i =0; i < ary_z_Com_quem.length; i++){
			z_Com_quem += ary_z_Com_quem[i] + ",";
		}
		z_Com_quem = z_Com_quem.substring(0,z_Com_quem.length()-1);
	}
	this_search_criteria = "";
	if (x_Com_quem.length() > 0) {
		String srchFld = x_Com_quem;
		this_search_criteria = "x_Com_quem=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Com_quem=" + URLEncoder.encode(z_Com_quem,"UTF-8");
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

	// Telefone_confianca
	if (request.getParameter("x_Telefone_confianca") != null){
		x_Telefone_confianca = request.getParameter("x_Telefone_confianca");
	}
	String z_Telefone_confianca = "";
	if (request.getParameterValues("z_Telefone_confianca") != null){
		String [] ary_z_Telefone_confianca = request.getParameterValues("z_Telefone_confianca");
		for (int i =0; i < ary_z_Telefone_confianca.length; i++){
			z_Telefone_confianca += ary_z_Telefone_confianca[i] + ",";
		}
		z_Telefone_confianca = z_Telefone_confianca.substring(0,z_Telefone_confianca.length()-1);
	}
	this_search_criteria = "";
	if (x_Telefone_confianca.length() > 0) {
		String srchFld = x_Telefone_confianca;
		this_search_criteria = "x_Telefone_confianca=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Telefone_confianca=" + URLEncoder.encode(z_Telefone_confianca,"UTF-8");
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
		response.sendRedirect("instal_componenteslist.jsp" + "?" + search_criteria);
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
<p><span class="jspmaker">Procurar TABELA: Instalacao de componentes<br><br><a href="instal_componenteslist.jsp">Voltar a lista</a></span></p>
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
if (EW_this.x_id_Instal_Componentes && !EW_checkinteger(EW_this.x_id_Instal_Componentes.value)) {
        if (!EW_onError(EW_this, EW_this.x_id_Instal_Componentes, "TEXT", "Numero inteiro invalido! - Codigo"))
            return false; 
        }
if (EW_this.x_id_Problema && !EW_checkinteger(EW_this.x_id_Problema.value)) {
        if (!EW_onError(EW_this, EW_this.x_id_Problema, "TEXT", "Numero inteiro invalido! - Problema #"))
            return false; 
        }
if (EW_this.x_Data_instalacao && !EW_checkeurodate(EW_this.x_Data_instalacao.value)) {
        if (!EW_onError(EW_this, EW_this.x_Data_instalacao, "TEXT", "Informe a data de instalacao!"))
            return false; 
        }
if (EW_this.x_Qtd_instalacao && !EW_checkinteger(EW_this.x_Qtd_instalacao.value)) {
        if (!EW_onError(EW_this, EW_this.x_Qtd_instalacao, "TEXT", "Informe a quantidade instalada!"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="instal_componentessrch.jsp" method="post">
<p>
<input type="hidden" name="a" value="S">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Instal_Componentes" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_id_Instal_Componentes" value="<%= HTMLEncode((String)x_id_Instal_Componentes) %>"></span>&nbsp;</td>
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
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Problema #</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Problema" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_id_Problema" size="30" value="<%= HTMLEncode((String)x_id_Problema) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Origem do Componente</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Origem_Componente" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_Origem_Componente_js = "";
String x_Origem_ComponenteList = "<select name=\"x_Origem_Componente\"><option value=\"\">Selecione</option>";
x_Origem_ComponenteList += "<option value=\"" + HTMLEncode("1") + "\"";
if (x_Origem_Componente != null && x_Origem_Componente.equals("1")) {
	x_Origem_ComponenteList += " selected";
}
x_Origem_ComponenteList += ">" + "Novo" + "</option>";
x_Origem_ComponenteList += "<option value=\"" + HTMLEncode("2") + "\"";
if (x_Origem_Componente != null && x_Origem_Componente.equals("2")) {
	x_Origem_ComponenteList += " selected";
}
x_Origem_ComponenteList += ">" + "Seminovo" + "</option>";
x_Origem_ComponenteList += "<option value=\"" + HTMLEncode("3") + "\"";
if (x_Origem_Componente != null && x_Origem_Componente.equals("3")) {
	x_Origem_ComponenteList += " selected";
}
x_Origem_ComponenteList += ">" + "Recuperavel" + "</option>";
x_Origem_ComponenteList += "<option value=\"" + HTMLEncode("4") + "\"";
if (x_Origem_Componente != null && x_Origem_Componente.equals("4")) {
	x_Origem_ComponenteList += " selected";
}
x_Origem_ComponenteList += ">" + "Irrecuperavel" + "</option>";
x_Origem_ComponenteList += "</select>";
out.print(x_Origem_ComponenteList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Data de instalacao</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Data_instalacao" value="=, ','">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Data_instalacao" value="<%= EW_FormatDateTime(x_Data_instalacao,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Pick a Date" onClick="popUpCalendar(this, this.form.x_Data_instalacao,'dd/mm/yyyy');return false;"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Qtd instalada</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Qtd_instalacao" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Qtd_instalacao" size="30" value="<%= HTMLEncode((String)x_Qtd_instalacao) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Detalhes da instalacao</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Detalhes_da_instalacao" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Detalhes_da_instalacao" cols="80" rows="4"><% if (x_Detalhes_da_instalacao!=null) out.print(x_Detalhes_da_instalacao); %></textarea><script language="JavaScript1.2">editor_generate('x_Detalhes_da_instalacao');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Tipo de instalacao</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Relacao_confianca" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="radio" name="x_Relacao_confianca" value="<%= HTMLEncode("1") %>"><%= "Interna" %>
<input type="radio" name="x_Relacao_confianca" value="<%= HTMLEncode("2") %>"><%= "Externa" %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Executor externo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Com_quem" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Com_quem" size="50" maxlength="50" value="<%= HTMLEncode((String)x_Com_quem) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Telefone do executor</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Telefone_confianca" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Telefone_confianca" size="30" maxlength="50" value="<%= HTMLEncode((String)x_Telefone_confianca) %>"></span>&nbsp;</td>
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
