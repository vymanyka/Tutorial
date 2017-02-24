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
	response.sendRedirect("componenteslist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
	String x_id_Componente =  "";
	String x_id_Categoria =  "";
	String x_Descricao_do_componente =  "";
	String x_Qtd_minima =  "";
	String x_Login =  "";
String tmpfld = null;
String escapeString = "\\\\'";

// Get action
String a = request.getParameter("a");
String this_search_criteria = "";
if (a != null && a.equals("S")) { // Get Search Criteria

	// Build search criteria for advanced search, remove blank field
	String search_criteria = "";

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

	// Descricao_do_componente
	if (request.getParameter("x_Descricao_do_componente") != null){
		x_Descricao_do_componente = request.getParameter("x_Descricao_do_componente");
	}
	String z_Descricao_do_componente = "";
	if (request.getParameterValues("z_Descricao_do_componente") != null){
		String [] ary_z_Descricao_do_componente = request.getParameterValues("z_Descricao_do_componente");
		for (int i =0; i < ary_z_Descricao_do_componente.length; i++){
			z_Descricao_do_componente += ary_z_Descricao_do_componente[i] + ",";
		}
		z_Descricao_do_componente = z_Descricao_do_componente.substring(0,z_Descricao_do_componente.length()-1);
	}
	this_search_criteria = "";
	if (x_Descricao_do_componente.length() > 0) {
		String srchFld = x_Descricao_do_componente;
		this_search_criteria = "x_Descricao_do_componente=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Descricao_do_componente=" + URLEncoder.encode(z_Descricao_do_componente,"UTF-8");
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

	// Qtd_minima
	if (request.getParameter("x_Qtd_minima") != null){
		x_Qtd_minima = request.getParameter("x_Qtd_minima");
	}
	String z_Qtd_minima = "";
	if (request.getParameterValues("z_Qtd_minima") != null){
		String [] ary_z_Qtd_minima = request.getParameterValues("z_Qtd_minima");
		for (int i =0; i < ary_z_Qtd_minima.length; i++){
			z_Qtd_minima += ary_z_Qtd_minima[i] + ",";
		}
		z_Qtd_minima = z_Qtd_minima.substring(0,z_Qtd_minima.length()-1);
	}
	this_search_criteria = "";
	if (x_Qtd_minima.length() > 0) {
		String srchFld = x_Qtd_minima;
		this_search_criteria = "x_Qtd_minima=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Qtd_minima=" + URLEncoder.encode(z_Qtd_minima,"UTF-8");
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
		response.sendRedirect("componenteslist.jsp" + "?" + search_criteria);
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
<p><span class="jspmaker">Procurar TABELA: Componentes<br><br><a href="componenteslist.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_id_Componente && !EW_checkinteger(EW_this.x_id_Componente.value)) {
        if (!EW_onError(EW_this, EW_this.x_id_Componente, "TEXT", "Numero inteiro invalido! - Codigo"))
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
<form onSubmit="return EW_checkMyForm(this);"  action="componentessrch.jsp" method="post">
<p>
<input type="hidden" name="a" value="S">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Componente" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_id_Componente" value="<%= HTMLEncode((String)x_id_Componente) %>"></span>&nbsp;</td>
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
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Descricao do componente</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Descricao_do_componente" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Descricao_do_componente" size="50" maxlength="50" value="<%= HTMLEncode((String)x_Descricao_do_componente) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Minima</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Qtd_minima" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Qtd_minima" size="30" value="<%= HTMLEncode((String)x_Qtd_minima) %>"></span>&nbsp;</td>
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
