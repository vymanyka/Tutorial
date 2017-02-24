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
ew_SecTable[1] = 8;
ew_SecTable[2] = 15;
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
	response.sendRedirect("retirada_de_componenteslist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
	String x_id_Retirada_de_Componentes =  "";
	String x_id_Problema =  "";
	String x_id_Componente =  "";
	String x_Qtd_retirada =  "";
	String x_Data_retirada =  "";
	String x_Destino_do_componente =  "";
	String x_Imagem =  "";
	String x_Video =  "";
	String x_Som =  "";
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

	// id_Retirada_de_Componentes
	if (request.getParameter("x_id_Retirada_de_Componentes") != null){
		x_id_Retirada_de_Componentes = request.getParameter("x_id_Retirada_de_Componentes");
	}
	String z_id_Retirada_de_Componentes = "";
	if (request.getParameterValues("z_id_Retirada_de_Componentes") != null){
		String [] ary_z_id_Retirada_de_Componentes = request.getParameterValues("z_id_Retirada_de_Componentes");
		for (int i =0; i < ary_z_id_Retirada_de_Componentes.length; i++){
			z_id_Retirada_de_Componentes += ary_z_id_Retirada_de_Componentes[i] + ",";
		}
		z_id_Retirada_de_Componentes = z_id_Retirada_de_Componentes.substring(0,z_id_Retirada_de_Componentes.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Retirada_de_Componentes.length() > 0) {
		String srchFld = x_id_Retirada_de_Componentes;
		this_search_criteria = "x_id_Retirada_de_Componentes=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Retirada_de_Componentes=" + URLEncoder.encode(z_id_Retirada_de_Componentes,"UTF-8");
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

	// Qtd_retirada
	if (request.getParameter("x_Qtd_retirada") != null){
		x_Qtd_retirada = request.getParameter("x_Qtd_retirada");
	}
	String z_Qtd_retirada = "";
	if (request.getParameterValues("z_Qtd_retirada") != null){
		String [] ary_z_Qtd_retirada = request.getParameterValues("z_Qtd_retirada");
		for (int i =0; i < ary_z_Qtd_retirada.length; i++){
			z_Qtd_retirada += ary_z_Qtd_retirada[i] + ",";
		}
		z_Qtd_retirada = z_Qtd_retirada.substring(0,z_Qtd_retirada.length()-1);
	}
	this_search_criteria = "";
	if (x_Qtd_retirada.length() > 0) {
		String srchFld = x_Qtd_retirada;
		this_search_criteria = "x_Qtd_retirada=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Qtd_retirada=" + URLEncoder.encode(z_Qtd_retirada,"UTF-8");
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

	// Data_retirada
	if (request.getParameter("x_Data_retirada") != null){
		x_Data_retirada = request.getParameter("x_Data_retirada");
	}
	String z_Data_retirada = "";
	if (request.getParameterValues("z_Data_retirada") != null){
		String [] ary_z_Data_retirada = request.getParameterValues("z_Data_retirada");
		for (int i =0; i < ary_z_Data_retirada.length; i++){
			z_Data_retirada += ary_z_Data_retirada[i] + ",";
		}
		z_Data_retirada = z_Data_retirada.substring(0,z_Data_retirada.length()-1);
	}
	this_search_criteria = "";
	if (x_Data_retirada.length() > 0) {
		String srchFld = x_Data_retirada;

		//srchFld = EW_UnFormatDateTime(srchFld,"EURODATE", locale).toString();
		this_search_criteria = "x_Data_retirada=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Data_retirada=" + URLEncoder.encode(z_Data_retirada,"UTF-8");
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

	// Destino_do_componente
	if (request.getParameter("x_Destino_do_componente") != null){
		x_Destino_do_componente = request.getParameter("x_Destino_do_componente");
	}
	String z_Destino_do_componente = "";
	if (request.getParameterValues("z_Destino_do_componente") != null){
		String [] ary_z_Destino_do_componente = request.getParameterValues("z_Destino_do_componente");
		for (int i =0; i < ary_z_Destino_do_componente.length; i++){
			z_Destino_do_componente += ary_z_Destino_do_componente[i] + ",";
		}
		z_Destino_do_componente = z_Destino_do_componente.substring(0,z_Destino_do_componente.length()-1);
	}
	this_search_criteria = "";
	if (x_Destino_do_componente.length() > 0) {
		String srchFld = x_Destino_do_componente;
		this_search_criteria = "x_Destino_do_componente=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Destino_do_componente=" + URLEncoder.encode(z_Destino_do_componente,"UTF-8");
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

	// Imagem
	if (request.getParameter("x_Imagem") != null){
		x_Imagem = request.getParameter("x_Imagem");
	}
	String z_Imagem = "";
	if (request.getParameterValues("z_Imagem") != null){
		String [] ary_z_Imagem = request.getParameterValues("z_Imagem");
		for (int i =0; i < ary_z_Imagem.length; i++){
			z_Imagem += ary_z_Imagem[i] + ",";
		}
		z_Imagem = z_Imagem.substring(0,z_Imagem.length()-1);
	}
	this_search_criteria = "";
	if (x_Imagem.length() > 0) {
		String srchFld = x_Imagem;
		this_search_criteria = "x_Imagem=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Imagem=" + URLEncoder.encode(z_Imagem,"UTF-8");
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

	// Video
	if (request.getParameter("x_Video") != null){
		x_Video = request.getParameter("x_Video");
	}
	String z_Video = "";
	if (request.getParameterValues("z_Video") != null){
		String [] ary_z_Video = request.getParameterValues("z_Video");
		for (int i =0; i < ary_z_Video.length; i++){
			z_Video += ary_z_Video[i] + ",";
		}
		z_Video = z_Video.substring(0,z_Video.length()-1);
	}
	this_search_criteria = "";
	if (x_Video.length() > 0) {
		String srchFld = x_Video;
		this_search_criteria = "x_Video=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Video=" + URLEncoder.encode(z_Video,"UTF-8");
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

	// Som
	if (request.getParameter("x_Som") != null){
		x_Som = request.getParameter("x_Som");
	}
	String z_Som = "";
	if (request.getParameterValues("z_Som") != null){
		String [] ary_z_Som = request.getParameterValues("z_Som");
		for (int i =0; i < ary_z_Som.length; i++){
			z_Som += ary_z_Som[i] + ",";
		}
		z_Som = z_Som.substring(0,z_Som.length()-1);
	}
	this_search_criteria = "";
	if (x_Som.length() > 0) {
		String srchFld = x_Som;
		this_search_criteria = "x_Som=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Som=" + URLEncoder.encode(z_Som,"UTF-8");
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
		response.sendRedirect("retirada_de_componenteslist.jsp" + "?" + search_criteria);
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
<p><span class="jspmaker">Procurar TABELA: Retirada de componentes<br><br><a href="retirada_de_componenteslist.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_id_Retirada_de_Componentes && !EW_checkinteger(EW_this.x_id_Retirada_de_Componentes.value)) {
        if (!EW_onError(EW_this, EW_this.x_id_Retirada_de_Componentes, "TEXT", "Numero inteiro invalido! - Codigo"))
            return false; 
        }
if (EW_this.x_id_Problema && !EW_checkinteger(EW_this.x_id_Problema.value)) {
        if (!EW_onError(EW_this, EW_this.x_id_Problema, "TEXT", "Numero inteiro invalido! - Problema"))
            return false; 
        }
if (EW_this.x_Qtd_retirada && !EW_checkinteger(EW_this.x_Qtd_retirada.value)) {
        if (!EW_onError(EW_this, EW_this.x_Qtd_retirada, "TEXT", "Informe a quantidade retirada!"))
            return false; 
        }
if (EW_this.x_Data_retirada && !EW_checkeurodate(EW_this.x_Data_retirada.value)) {
        if (!EW_onError(EW_this, EW_this.x_Data_retirada, "TEXT", "Informe a data da retirada!"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="retirada_de_componentessrch.jsp" method="post">
<p>
<input type="hidden" name="a" value="S">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Retirada_de_Componentes" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_id_Retirada_de_Componentes" value="<%= HTMLEncode((String)x_id_Retirada_de_Componentes) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Problema</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Problema" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_id_Problema" size="30" value="<%= HTMLEncode((String)x_id_Problema) %>"></span>&nbsp;</td>
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
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Qtd retirada</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Qtd_retirada" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Qtd_retirada" size="30" value="<%= HTMLEncode((String)x_Qtd_retirada) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Data retirada</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Data_retirada" value="=, ','">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Data_retirada" value="<%= EW_FormatDateTime(x_Data_retirada,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Pick a Date" onClick="popUpCalendar(this, this.form.x_Data_retirada,'dd/mm/yyyy');return false;"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Estado do componente</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Destino_do_componente" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_Destino_do_componente_js = "";
String x_Destino_do_componenteList = "<select name=\"x_Destino_do_componente\"><option value=\"\">Selecione</option>";
x_Destino_do_componenteList += "<option value=\"" + HTMLEncode("1") + "\"";
if (x_Destino_do_componente != null && x_Destino_do_componente.equals("1")) {
	x_Destino_do_componenteList += " selected";
}
x_Destino_do_componenteList += ">" + "Novo" + "</option>";
x_Destino_do_componenteList += "<option value=\"" + HTMLEncode("2") + "\"";
if (x_Destino_do_componente != null && x_Destino_do_componente.equals("2")) {
	x_Destino_do_componenteList += " selected";
}
x_Destino_do_componenteList += ">" + "Seminovo" + "</option>";
x_Destino_do_componenteList += "<option value=\"" + HTMLEncode("3") + "\"";
if (x_Destino_do_componente != null && x_Destino_do_componente.equals("3")) {
	x_Destino_do_componenteList += " selected";
}
x_Destino_do_componenteList += ">" + "Recuperavel" + "</option>";
x_Destino_do_componenteList += "<option value=\"" + HTMLEncode("4") + "\"";
if (x_Destino_do_componente != null && x_Destino_do_componente.equals("4")) {
	x_Destino_do_componenteList += " selected";
}
x_Destino_do_componenteList += ">" + "Irrecuperavel" + "</option>";
x_Destino_do_componenteList += "</select>";
out.print(x_Destino_do_componenteList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Imagem</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Imagem" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="file" name="x_Imagem"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Audio-visual</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Video" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="file" name="x_Video"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Audio-visual (cont)</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Som" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="file" name="x_Som"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Tipo de retirada</span>&nbsp;</td>
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
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Com_quem" size="70" maxlength="50" value="<%= HTMLEncode((String)x_Com_quem) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Telefone do executor</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Telefone_confianca" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Telefone_confianca" size="70" maxlength="50" value="<%= HTMLEncode((String)x_Telefone_confianca) %>"></span>&nbsp;</td>
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
