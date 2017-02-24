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
	response.sendRedirect("benslist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
	String x_id_Bem =  "";
	String x_id_Marca =  "";
	String x_id_Categoria =  "";
	String x_id_Lotacoes =  "";
	String x_Numero_de_serie =  "";
	String x_Caracteristicas_do_bem =  "";
	String x_Login =  "";
String tmpfld = null;
String escapeString = "\\\\'";

// Get action
String a = request.getParameter("a");
String this_search_criteria = "";
if (a != null && a.equals("S")) { // Get Search Criteria

	// Build search criteria for advanced search, remove blank field
	String search_criteria = "";

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

	// id_Marca
	if (request.getParameter("x_id_Marca") != null){
		x_id_Marca = request.getParameter("x_id_Marca");
	}
	String z_id_Marca = "";
	if (request.getParameterValues("z_id_Marca") != null){
		String [] ary_z_id_Marca = request.getParameterValues("z_id_Marca");
		for (int i =0; i < ary_z_id_Marca.length; i++){
			z_id_Marca += ary_z_id_Marca[i] + ",";
		}
		z_id_Marca = z_id_Marca.substring(0,z_id_Marca.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Marca.length() > 0) {
		String srchFld = x_id_Marca;
		this_search_criteria = "x_id_Marca=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Marca=" + URLEncoder.encode(z_id_Marca,"UTF-8");
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

	// id_Lotacoes
	if (request.getParameter("x_id_Lotacoes") != null){
		x_id_Lotacoes = request.getParameter("x_id_Lotacoes");
	}
	String z_id_Lotacoes = "";
	if (request.getParameterValues("z_id_Lotacoes") != null){
		String [] ary_z_id_Lotacoes = request.getParameterValues("z_id_Lotacoes");
		for (int i =0; i < ary_z_id_Lotacoes.length; i++){
			z_id_Lotacoes += ary_z_id_Lotacoes[i] + ",";
		}
		z_id_Lotacoes = z_id_Lotacoes.substring(0,z_id_Lotacoes.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Lotacoes.length() > 0) {
		String srchFld = x_id_Lotacoes;
		this_search_criteria = "x_id_Lotacoes=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Lotacoes=" + URLEncoder.encode(z_id_Lotacoes,"UTF-8");
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

	// Numero_de_serie
	if (request.getParameter("x_Numero_de_serie") != null){
		x_Numero_de_serie = request.getParameter("x_Numero_de_serie");
	}
	String z_Numero_de_serie = "";
	if (request.getParameterValues("z_Numero_de_serie") != null){
		String [] ary_z_Numero_de_serie = request.getParameterValues("z_Numero_de_serie");
		for (int i =0; i < ary_z_Numero_de_serie.length; i++){
			z_Numero_de_serie += ary_z_Numero_de_serie[i] + ",";
		}
		z_Numero_de_serie = z_Numero_de_serie.substring(0,z_Numero_de_serie.length()-1);
	}
	this_search_criteria = "";
	if (x_Numero_de_serie.length() > 0) {
		String srchFld = x_Numero_de_serie;
		this_search_criteria = "x_Numero_de_serie=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Numero_de_serie=" + URLEncoder.encode(z_Numero_de_serie,"UTF-8");
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

	// Caracteristicas_do_bem
	if (request.getParameter("x_Caracteristicas_do_bem") != null){
		x_Caracteristicas_do_bem = request.getParameter("x_Caracteristicas_do_bem");
	}
	String z_Caracteristicas_do_bem = "";
	if (request.getParameterValues("z_Caracteristicas_do_bem") != null){
		String [] ary_z_Caracteristicas_do_bem = request.getParameterValues("z_Caracteristicas_do_bem");
		for (int i =0; i < ary_z_Caracteristicas_do_bem.length; i++){
			z_Caracteristicas_do_bem += ary_z_Caracteristicas_do_bem[i] + ",";
		}
		z_Caracteristicas_do_bem = z_Caracteristicas_do_bem.substring(0,z_Caracteristicas_do_bem.length()-1);
	}
	this_search_criteria = "";
	if (x_Caracteristicas_do_bem.length() > 0) {
		String srchFld = x_Caracteristicas_do_bem;
		this_search_criteria = "x_Caracteristicas_do_bem=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Caracteristicas_do_bem=" + URLEncoder.encode(z_Caracteristicas_do_bem,"UTF-8");
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
		response.sendRedirect("benslist.jsp" + "?" + search_criteria);
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
<p><span class="jspmaker">Procurar TABELA: Bens<br><br><a href="benslist.jsp">Voltar a lista</a></span></p>
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
if (EW_this.x_id_Bem && !EW_checkinteger(EW_this.x_id_Bem.value)) {
        if (!EW_onError(EW_this, EW_this.x_id_Bem, "TEXT", "Informe o numero do tombamento!"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="benssrch.jsp" method="post">
<p>
<input type="hidden" name="a" value="S">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Tombamento</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Bem" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_id_Bem" size="30" value="<%= HTMLEncode((String)x_id_Bem) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Marca</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Marca" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Marca_js = "";
String x_id_MarcaList = "<select name=\"x_id_Marca\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Marca = "SELECT `id_Marca`, `Marca` FROM `marcas`" + " ORDER BY `Marca` ASC";
Statement stmtwrk_x_id_Marca = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Marca = stmtwrk_x_id_Marca.executeQuery(sqlwrk_x_id_Marca);
	int rowcntwrk_x_id_Marca = 0;
	while (rswrk_x_id_Marca.next()) {
		x_id_MarcaList += "<option value=\"" + HTMLEncode(rswrk_x_id_Marca.getString("id_Marca")) + "\"";
		if (rswrk_x_id_Marca.getString("id_Marca").equals(x_id_Marca)) {
			x_id_MarcaList += " selected";
		}
		String tmpValue_x_id_Marca = "";
		if (rswrk_x_id_Marca.getString("Marca")!= null) tmpValue_x_id_Marca = rswrk_x_id_Marca.getString("Marca");
		x_id_MarcaList += ">" + tmpValue_x_id_Marca
 + "</option>";
		rowcntwrk_x_id_Marca++;
	}
rswrk_x_id_Marca.close();
rswrk_x_id_Marca = null;
stmtwrk_x_id_Marca.close();
stmtwrk_x_id_Marca = null;
x_id_MarcaList += "</select>";
out.println(x_id_MarcaList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Categoria" value="=, , ">=
</span>&nbsp;</td>
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
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Lotacao atual</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Lotacoes" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Lotacoes_js = "";
String x_id_LotacoesList = "<select name=\"x_id_Lotacoes\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Lotacoes = "SELECT `id_Lotacoes`, `Descricao_da_lotacao` FROM `lotacoes`" + " ORDER BY `Descricao_da_lotacao` ASC";
Statement stmtwrk_x_id_Lotacoes = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Lotacoes = stmtwrk_x_id_Lotacoes.executeQuery(sqlwrk_x_id_Lotacoes);
	int rowcntwrk_x_id_Lotacoes = 0;
	while (rswrk_x_id_Lotacoes.next()) {
		x_id_LotacoesList += "<option value=\"" + HTMLEncode(rswrk_x_id_Lotacoes.getString("id_Lotacoes")) + "\"";
		if (rswrk_x_id_Lotacoes.getString("id_Lotacoes").equals(x_id_Lotacoes)) {
			x_id_LotacoesList += " selected";
		}
		String tmpValue_x_id_Lotacoes = "";
		if (rswrk_x_id_Lotacoes.getString("Descricao_da_lotacao")!= null) tmpValue_x_id_Lotacoes = rswrk_x_id_Lotacoes.getString("Descricao_da_lotacao");
		x_id_LotacoesList += ">" + tmpValue_x_id_Lotacoes
 + "</option>";
		rowcntwrk_x_id_Lotacoes++;
	}
rswrk_x_id_Lotacoes.close();
rswrk_x_id_Lotacoes = null;
stmtwrk_x_id_Lotacoes.close();
stmtwrk_x_id_Lotacoes = null;
x_id_LotacoesList += "</select>";
out.println(x_id_LotacoesList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Numero de serie</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Numero_de_serie" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Numero_de_serie" size="50" maxlength="50" value="<%= HTMLEncode((String)x_Numero_de_serie) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Caracteristicas do bem</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Caracteristicas_do_bem" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Caracteristicas_do_bem" cols="80" rows="4"><% if (x_Caracteristicas_do_bem!=null) out.print(x_Caracteristicas_do_bem); %></textarea><script language="JavaScript1.2">editor_generate('x_Caracteristicas_do_bem');</script></span>&nbsp;</td>
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
