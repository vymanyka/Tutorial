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
	response.sendRedirect("categoriaslist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
	String x_id_Categoria =  "";
	String x_id_Zero =  "";
	String x_id_Um =  "";
	String x_id_Dois =  "";
	String x_id_Tres =  "";
	String x_id_Quatro =  "";
	String x_Descricao_da_categoria =  "";
	String x_Detalhes_da_categoria =  "";
	String x_Imagem =  "";
	String x_Guia_do_usuario =  "";
	String x_Guia_tecnico =  "";
	String x_Guia_rapido =  "";
	String x_Login =  "";
String tmpfld = null;
String escapeString = "\\\\'";

// Get action
String a = request.getParameter("a");
String this_search_criteria = "";
if (a != null && a.equals("S")) { // Get Search Criteria

	// Build search criteria for advanced search, remove blank field
	String search_criteria = "";

	// id_Categoria
	if (request.getParameter("x_id_Categoria") != null){
		x_id_Categoria = request.getParameter("x_id_Categoria");
	}
	String z_id_Categoria = "";
	if (request.getParameterValues("z_id_Categoria") != null){
		String [] ary_z_id_Categoria = request.getParameterValues("z_id_Categoria");
		for (int i =0; i < ary_z_id_Categoria.length; i++){
			z_id_Categoria += ary_z_id_Categoria[i] + ",";
		}
		z_id_Categoria = z_id_Categoria.substring(0,z_id_Categoria.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Categoria.length() > 0) {
		String srchFld = x_id_Categoria;
		this_search_criteria = "x_id_Categoria=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Categoria=" + URLEncoder.encode(z_id_Categoria,"UTF-8");
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

	// id_Zero
	if (request.getParameter("x_id_Zero") != null){
		x_id_Zero = request.getParameter("x_id_Zero");
	}
	String z_id_Zero = "";
	if (request.getParameterValues("z_id_Zero") != null){
		String [] ary_z_id_Zero = request.getParameterValues("z_id_Zero");
		for (int i =0; i < ary_z_id_Zero.length; i++){
			z_id_Zero += ary_z_id_Zero[i] + ",";
		}
		z_id_Zero = z_id_Zero.substring(0,z_id_Zero.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Zero.length() > 0) {
		String srchFld = x_id_Zero;
		this_search_criteria = "x_id_Zero=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Zero=" + URLEncoder.encode(z_id_Zero,"UTF-8");
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

	// id_Um
	if (request.getParameter("x_id_Um") != null){
		x_id_Um = request.getParameter("x_id_Um");
	}
	String z_id_Um = "";
	if (request.getParameterValues("z_id_Um") != null){
		String [] ary_z_id_Um = request.getParameterValues("z_id_Um");
		for (int i =0; i < ary_z_id_Um.length; i++){
			z_id_Um += ary_z_id_Um[i] + ",";
		}
		z_id_Um = z_id_Um.substring(0,z_id_Um.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Um.length() > 0) {
		String srchFld = x_id_Um;
		this_search_criteria = "x_id_Um=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Um=" + URLEncoder.encode(z_id_Um,"UTF-8");
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

	// id_Dois
	if (request.getParameter("x_id_Dois") != null){
		x_id_Dois = request.getParameter("x_id_Dois");
	}
	String z_id_Dois = "";
	if (request.getParameterValues("z_id_Dois") != null){
		String [] ary_z_id_Dois = request.getParameterValues("z_id_Dois");
		for (int i =0; i < ary_z_id_Dois.length; i++){
			z_id_Dois += ary_z_id_Dois[i] + ",";
		}
		z_id_Dois = z_id_Dois.substring(0,z_id_Dois.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Dois.length() > 0) {
		String srchFld = x_id_Dois;
		this_search_criteria = "x_id_Dois=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Dois=" + URLEncoder.encode(z_id_Dois,"UTF-8");
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

	// id_Tres
	if (request.getParameter("x_id_Tres") != null){
		x_id_Tres = request.getParameter("x_id_Tres");
	}
	String z_id_Tres = "";
	if (request.getParameterValues("z_id_Tres") != null){
		String [] ary_z_id_Tres = request.getParameterValues("z_id_Tres");
		for (int i =0; i < ary_z_id_Tres.length; i++){
			z_id_Tres += ary_z_id_Tres[i] + ",";
		}
		z_id_Tres = z_id_Tres.substring(0,z_id_Tres.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Tres.length() > 0) {
		String srchFld = x_id_Tres;
		this_search_criteria = "x_id_Tres=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Tres=" + URLEncoder.encode(z_id_Tres,"UTF-8");
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

	// id_Quatro
	if (request.getParameter("x_id_Quatro") != null){
		x_id_Quatro = request.getParameter("x_id_Quatro");
	}
	String z_id_Quatro = "";
	if (request.getParameterValues("z_id_Quatro") != null){
		String [] ary_z_id_Quatro = request.getParameterValues("z_id_Quatro");
		for (int i =0; i < ary_z_id_Quatro.length; i++){
			z_id_Quatro += ary_z_id_Quatro[i] + ",";
		}
		z_id_Quatro = z_id_Quatro.substring(0,z_id_Quatro.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Quatro.length() > 0) {
		String srchFld = x_id_Quatro;
		this_search_criteria = "x_id_Quatro=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Quatro=" + URLEncoder.encode(z_id_Quatro,"UTF-8");
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

	// Descricao_da_categoria
	if (request.getParameter("x_Descricao_da_categoria") != null){
		x_Descricao_da_categoria = request.getParameter("x_Descricao_da_categoria");
	}
	String z_Descricao_da_categoria = "";
	if (request.getParameterValues("z_Descricao_da_categoria") != null){
		String [] ary_z_Descricao_da_categoria = request.getParameterValues("z_Descricao_da_categoria");
		for (int i =0; i < ary_z_Descricao_da_categoria.length; i++){
			z_Descricao_da_categoria += ary_z_Descricao_da_categoria[i] + ",";
		}
		z_Descricao_da_categoria = z_Descricao_da_categoria.substring(0,z_Descricao_da_categoria.length()-1);
	}
	this_search_criteria = "";
	if (x_Descricao_da_categoria.length() > 0) {
		String srchFld = x_Descricao_da_categoria;
		this_search_criteria = "x_Descricao_da_categoria=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Descricao_da_categoria=" + URLEncoder.encode(z_Descricao_da_categoria,"UTF-8");
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

	// Detalhes_da_categoria
	if (request.getParameter("x_Detalhes_da_categoria") != null){
		x_Detalhes_da_categoria = request.getParameter("x_Detalhes_da_categoria");
	}
	String z_Detalhes_da_categoria = "";
	if (request.getParameterValues("z_Detalhes_da_categoria") != null){
		String [] ary_z_Detalhes_da_categoria = request.getParameterValues("z_Detalhes_da_categoria");
		for (int i =0; i < ary_z_Detalhes_da_categoria.length; i++){
			z_Detalhes_da_categoria += ary_z_Detalhes_da_categoria[i] + ",";
		}
		z_Detalhes_da_categoria = z_Detalhes_da_categoria.substring(0,z_Detalhes_da_categoria.length()-1);
	}
	this_search_criteria = "";
	if (x_Detalhes_da_categoria.length() > 0) {
		String srchFld = x_Detalhes_da_categoria;
		this_search_criteria = "x_Detalhes_da_categoria=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Detalhes_da_categoria=" + URLEncoder.encode(z_Detalhes_da_categoria,"UTF-8");
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

	// Guia_do_usuario
	if (request.getParameter("x_Guia_do_usuario") != null){
		x_Guia_do_usuario = request.getParameter("x_Guia_do_usuario");
	}
	String z_Guia_do_usuario = "";
	if (request.getParameterValues("z_Guia_do_usuario") != null){
		String [] ary_z_Guia_do_usuario = request.getParameterValues("z_Guia_do_usuario");
		for (int i =0; i < ary_z_Guia_do_usuario.length; i++){
			z_Guia_do_usuario += ary_z_Guia_do_usuario[i] + ",";
		}
		z_Guia_do_usuario = z_Guia_do_usuario.substring(0,z_Guia_do_usuario.length()-1);
	}
	this_search_criteria = "";
	if (x_Guia_do_usuario.length() > 0) {
		String srchFld = x_Guia_do_usuario;
		this_search_criteria = "x_Guia_do_usuario=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Guia_do_usuario=" + URLEncoder.encode(z_Guia_do_usuario,"UTF-8");
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

	// Guia_tecnico
	if (request.getParameter("x_Guia_tecnico") != null){
		x_Guia_tecnico = request.getParameter("x_Guia_tecnico");
	}
	String z_Guia_tecnico = "";
	if (request.getParameterValues("z_Guia_tecnico") != null){
		String [] ary_z_Guia_tecnico = request.getParameterValues("z_Guia_tecnico");
		for (int i =0; i < ary_z_Guia_tecnico.length; i++){
			z_Guia_tecnico += ary_z_Guia_tecnico[i] + ",";
		}
		z_Guia_tecnico = z_Guia_tecnico.substring(0,z_Guia_tecnico.length()-1);
	}
	this_search_criteria = "";
	if (x_Guia_tecnico.length() > 0) {
		String srchFld = x_Guia_tecnico;
		this_search_criteria = "x_Guia_tecnico=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Guia_tecnico=" + URLEncoder.encode(z_Guia_tecnico,"UTF-8");
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

	// Guia_rapido
	if (request.getParameter("x_Guia_rapido") != null){
		x_Guia_rapido = request.getParameter("x_Guia_rapido");
	}
	String z_Guia_rapido = "";
	if (request.getParameterValues("z_Guia_rapido") != null){
		String [] ary_z_Guia_rapido = request.getParameterValues("z_Guia_rapido");
		for (int i =0; i < ary_z_Guia_rapido.length; i++){
			z_Guia_rapido += ary_z_Guia_rapido[i] + ",";
		}
		z_Guia_rapido = z_Guia_rapido.substring(0,z_Guia_rapido.length()-1);
	}
	this_search_criteria = "";
	if (x_Guia_rapido.length() > 0) {
		String srchFld = x_Guia_rapido;
		this_search_criteria = "x_Guia_rapido=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Guia_rapido=" + URLEncoder.encode(z_Guia_rapido,"UTF-8");
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
		response.sendRedirect("categoriaslist.jsp" + "?" + search_criteria);
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
<p><span class="jspmaker">Procurar TABELA: Categorias<br><br><a href="categoriaslist.jsp">Voltar a lista</a></span></p>
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
if (EW_this.x_id_Categoria && !EW_checkinteger(EW_this.x_id_Categoria.value)) {
        if (!EW_onError(EW_this, EW_this.x_id_Categoria, "TEXT", "Numero inteiro invalido! - Codigo"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="categoriassrch.jsp" method="post">
<p>
<input type="hidden" name="a" value="S">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Categoria" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_id_Categoria" value="<%= HTMLEncode((String)x_id_Categoria) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria primaria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Zero" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Zero_js = "";
String x_id_ZeroList = "<select name=\"x_id_Zero\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Zero = "SELECT `id_Zero`, `Descricao_da_categoria` FROM `sub_categoria_0`" + " ORDER BY `Descricao_da_categoria` ASC";
Statement stmtwrk_x_id_Zero = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Zero = stmtwrk_x_id_Zero.executeQuery(sqlwrk_x_id_Zero);
	int rowcntwrk_x_id_Zero = 0;
	while (rswrk_x_id_Zero.next()) {
		x_id_ZeroList += "<option value=\"" + HTMLEncode(rswrk_x_id_Zero.getString("id_Zero")) + "\"";
		if (rswrk_x_id_Zero.getString("id_Zero").equals(x_id_Zero)) {
			x_id_ZeroList += " selected";
		}
		String tmpValue_x_id_Zero = "";
		if (rswrk_x_id_Zero.getString("Descricao_da_categoria")!= null) tmpValue_x_id_Zero = rswrk_x_id_Zero.getString("Descricao_da_categoria");
		x_id_ZeroList += ">" + tmpValue_x_id_Zero
 + "</option>";
		rowcntwrk_x_id_Zero++;
	}
rswrk_x_id_Zero.close();
rswrk_x_id_Zero = null;
stmtwrk_x_id_Zero.close();
stmtwrk_x_id_Zero = null;
x_id_ZeroList += "</select>";
out.println(x_id_ZeroList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria secundaria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Um" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Um_js = "";
String x_id_UmList = "<select name=\"x_id_Um\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Um = "SELECT `id_Um`, `Descricao_da_categoria` FROM `sub_categoria_1`" + " ORDER BY `Descricao_da_categoria` ASC";
Statement stmtwrk_x_id_Um = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Um = stmtwrk_x_id_Um.executeQuery(sqlwrk_x_id_Um);
	int rowcntwrk_x_id_Um = 0;
	while (rswrk_x_id_Um.next()) {
		x_id_UmList += "<option value=\"" + HTMLEncode(rswrk_x_id_Um.getString("id_Um")) + "\"";
		if (rswrk_x_id_Um.getString("id_Um").equals(x_id_Um)) {
			x_id_UmList += " selected";
		}
		String tmpValue_x_id_Um = "";
		if (rswrk_x_id_Um.getString("Descricao_da_categoria")!= null) tmpValue_x_id_Um = rswrk_x_id_Um.getString("Descricao_da_categoria");
		x_id_UmList += ">" + tmpValue_x_id_Um
 + "</option>";
		rowcntwrk_x_id_Um++;
	}
rswrk_x_id_Um.close();
rswrk_x_id_Um = null;
stmtwrk_x_id_Um.close();
stmtwrk_x_id_Um = null;
x_id_UmList += "</select>";
out.println(x_id_UmList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria terciaria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Dois" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Dois_js = "";
String x_id_DoisList = "<select name=\"x_id_Dois\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Dois = "SELECT `id_Dois`, `Descricao_da_categoria` FROM `sub_categoria_2`" + " ORDER BY `Descricao_da_categoria` ASC";
Statement stmtwrk_x_id_Dois = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Dois = stmtwrk_x_id_Dois.executeQuery(sqlwrk_x_id_Dois);
	int rowcntwrk_x_id_Dois = 0;
	while (rswrk_x_id_Dois.next()) {
		x_id_DoisList += "<option value=\"" + HTMLEncode(rswrk_x_id_Dois.getString("id_Dois")) + "\"";
		if (rswrk_x_id_Dois.getString("id_Dois").equals(x_id_Dois)) {
			x_id_DoisList += " selected";
		}
		String tmpValue_x_id_Dois = "";
		if (rswrk_x_id_Dois.getString("Descricao_da_categoria")!= null) tmpValue_x_id_Dois = rswrk_x_id_Dois.getString("Descricao_da_categoria");
		x_id_DoisList += ">" + tmpValue_x_id_Dois
 + "</option>";
		rowcntwrk_x_id_Dois++;
	}
rswrk_x_id_Dois.close();
rswrk_x_id_Dois = null;
stmtwrk_x_id_Dois.close();
stmtwrk_x_id_Dois = null;
x_id_DoisList += "</select>";
out.println(x_id_DoisList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria quaternaria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Tres" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Tres_js = "";
String x_id_TresList = "<select name=\"x_id_Tres\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Tres = "SELECT `id_Tres`, `Descricao_da_categoria` FROM `sub_categoria_3`" + " ORDER BY `Descricao_da_categoria` ASC";
Statement stmtwrk_x_id_Tres = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Tres = stmtwrk_x_id_Tres.executeQuery(sqlwrk_x_id_Tres);
	int rowcntwrk_x_id_Tres = 0;
	while (rswrk_x_id_Tres.next()) {
		x_id_TresList += "<option value=\"" + HTMLEncode(rswrk_x_id_Tres.getString("id_Tres")) + "\"";
		if (rswrk_x_id_Tres.getString("id_Tres").equals(x_id_Tres)) {
			x_id_TresList += " selected";
		}
		String tmpValue_x_id_Tres = "";
		if (rswrk_x_id_Tres.getString("Descricao_da_categoria")!= null) tmpValue_x_id_Tres = rswrk_x_id_Tres.getString("Descricao_da_categoria");
		x_id_TresList += ">" + tmpValue_x_id_Tres
 + "</option>";
		rowcntwrk_x_id_Tres++;
	}
rswrk_x_id_Tres.close();
rswrk_x_id_Tres = null;
stmtwrk_x_id_Tres.close();
stmtwrk_x_id_Tres = null;
x_id_TresList += "</select>";
out.println(x_id_TresList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria quinquenaria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Quatro" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Quatro_js = "";
String x_id_QuatroList = "<select name=\"x_id_Quatro\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Quatro = "SELECT `id_Quatro`, `Descricao_da_categoria` FROM `sub_categoria_4`" + " ORDER BY `Descricao_da_categoria` ASC";
Statement stmtwrk_x_id_Quatro = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Quatro = stmtwrk_x_id_Quatro.executeQuery(sqlwrk_x_id_Quatro);
	int rowcntwrk_x_id_Quatro = 0;
	while (rswrk_x_id_Quatro.next()) {
		x_id_QuatroList += "<option value=\"" + HTMLEncode(rswrk_x_id_Quatro.getString("id_Quatro")) + "\"";
		if (rswrk_x_id_Quatro.getString("id_Quatro").equals(x_id_Quatro)) {
			x_id_QuatroList += " selected";
		}
		String tmpValue_x_id_Quatro = "";
		if (rswrk_x_id_Quatro.getString("Descricao_da_categoria")!= null) tmpValue_x_id_Quatro = rswrk_x_id_Quatro.getString("Descricao_da_categoria");
		x_id_QuatroList += ">" + tmpValue_x_id_Quatro
 + "</option>";
		rowcntwrk_x_id_Quatro++;
	}
rswrk_x_id_Quatro.close();
rswrk_x_id_Quatro = null;
stmtwrk_x_id_Quatro.close();
stmtwrk_x_id_Quatro = null;
x_id_QuatroList += "</select>";
out.println(x_id_QuatroList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Descricao da categoria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Descricao_da_categoria" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Descricao_da_categoria" size="70" maxlength="50" value="<%= HTMLEncode((String)x_Descricao_da_categoria) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Detalhes da categoria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Detalhes_da_categoria" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Detalhes_da_categoria" cols="80" rows="4"><% if (x_Detalhes_da_categoria!=null) out.print(x_Detalhes_da_categoria); %></textarea><script language="JavaScript1.2">editor_generate('x_Detalhes_da_categoria');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Imagem</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Imagem" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="file" name="x_Imagem"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Guia do usuario</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Guia_do_usuario" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="file" name="x_Guia_do_usuario"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Guia tecnico</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Guia_tecnico" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="file" name="x_Guia_tecnico"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Guia rapido</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Guia_rapido" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="file" name="x_Guia_rapido"></span>&nbsp;</td>
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
