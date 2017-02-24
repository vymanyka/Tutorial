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
	response.sendRedirect("fornecedoreslist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
	String x_idFornecedores =  "";
	String x_Nome_Fornecedor =  "";
	String x_CNPJ =  "";
	String x_Endereco =  "";
	String x_Telefone =  "";
	String x_Home_Page =  "";
	String x_eMail =  "";
	String x_Login =  "";
String tmpfld = null;
String escapeString = "\\\\'";

// Get action
String a = request.getParameter("a");
String this_search_criteria = "";
if (a != null && a.equals("S")) { // Get Search Criteria

	// Build search criteria for advanced search, remove blank field
	String search_criteria = "";

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

	// Nome_Fornecedor
	if (request.getParameter("x_Nome_Fornecedor") != null){
		x_Nome_Fornecedor = request.getParameter("x_Nome_Fornecedor");
	}
	String z_Nome_Fornecedor = "";
	if (request.getParameterValues("z_Nome_Fornecedor") != null){
		String [] ary_z_Nome_Fornecedor = request.getParameterValues("z_Nome_Fornecedor");
		for (int i =0; i < ary_z_Nome_Fornecedor.length; i++){
			z_Nome_Fornecedor += ary_z_Nome_Fornecedor[i] + ",";
		}
		z_Nome_Fornecedor = z_Nome_Fornecedor.substring(0,z_Nome_Fornecedor.length()-1);
	}
	this_search_criteria = "";
	if (x_Nome_Fornecedor.length() > 0) {
		String srchFld = x_Nome_Fornecedor;
		this_search_criteria = "x_Nome_Fornecedor=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Nome_Fornecedor=" + URLEncoder.encode(z_Nome_Fornecedor,"UTF-8");
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

	// CNPJ
	if (request.getParameter("x_CNPJ") != null){
		x_CNPJ = request.getParameter("x_CNPJ");
	}
	String z_CNPJ = "";
	if (request.getParameterValues("z_CNPJ") != null){
		String [] ary_z_CNPJ = request.getParameterValues("z_CNPJ");
		for (int i =0; i < ary_z_CNPJ.length; i++){
			z_CNPJ += ary_z_CNPJ[i] + ",";
		}
		z_CNPJ = z_CNPJ.substring(0,z_CNPJ.length()-1);
	}
	this_search_criteria = "";
	if (x_CNPJ.length() > 0) {
		String srchFld = x_CNPJ;
		this_search_criteria = "x_CNPJ=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_CNPJ=" + URLEncoder.encode(z_CNPJ,"UTF-8");
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

	// Endereco
	if (request.getParameter("x_Endereco") != null){
		x_Endereco = request.getParameter("x_Endereco");
	}
	String z_Endereco = "";
	if (request.getParameterValues("z_Endereco") != null){
		String [] ary_z_Endereco = request.getParameterValues("z_Endereco");
		for (int i =0; i < ary_z_Endereco.length; i++){
			z_Endereco += ary_z_Endereco[i] + ",";
		}
		z_Endereco = z_Endereco.substring(0,z_Endereco.length()-1);
	}
	this_search_criteria = "";
	if (x_Endereco.length() > 0) {
		String srchFld = x_Endereco;
		this_search_criteria = "x_Endereco=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Endereco=" + URLEncoder.encode(z_Endereco,"UTF-8");
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

	// Telefone
	if (request.getParameter("x_Telefone") != null){
		x_Telefone = request.getParameter("x_Telefone");
	}
	String z_Telefone = "";
	if (request.getParameterValues("z_Telefone") != null){
		String [] ary_z_Telefone = request.getParameterValues("z_Telefone");
		for (int i =0; i < ary_z_Telefone.length; i++){
			z_Telefone += ary_z_Telefone[i] + ",";
		}
		z_Telefone = z_Telefone.substring(0,z_Telefone.length()-1);
	}
	this_search_criteria = "";
	if (x_Telefone.length() > 0) {
		String srchFld = x_Telefone;
		this_search_criteria = "x_Telefone=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Telefone=" + URLEncoder.encode(z_Telefone,"UTF-8");
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

	// Home_Page
	if (request.getParameter("x_Home_Page") != null){
		x_Home_Page = request.getParameter("x_Home_Page");
	}
	String z_Home_Page = "";
	if (request.getParameterValues("z_Home_Page") != null){
		String [] ary_z_Home_Page = request.getParameterValues("z_Home_Page");
		for (int i =0; i < ary_z_Home_Page.length; i++){
			z_Home_Page += ary_z_Home_Page[i] + ",";
		}
		z_Home_Page = z_Home_Page.substring(0,z_Home_Page.length()-1);
	}
	this_search_criteria = "";
	if (x_Home_Page.length() > 0) {
		String srchFld = x_Home_Page;
		this_search_criteria = "x_Home_Page=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Home_Page=" + URLEncoder.encode(z_Home_Page,"UTF-8");
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

	// eMail
	if (request.getParameter("x_eMail") != null){
		x_eMail = request.getParameter("x_eMail");
	}
	String z_eMail = "";
	if (request.getParameterValues("z_eMail") != null){
		String [] ary_z_eMail = request.getParameterValues("z_eMail");
		for (int i =0; i < ary_z_eMail.length; i++){
			z_eMail += ary_z_eMail[i] + ",";
		}
		z_eMail = z_eMail.substring(0,z_eMail.length()-1);
	}
	this_search_criteria = "";
	if (x_eMail.length() > 0) {
		String srchFld = x_eMail;
		this_search_criteria = "x_eMail=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_eMail=" + URLEncoder.encode(z_eMail,"UTF-8");
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
		response.sendRedirect("fornecedoreslist.jsp" + "?" + search_criteria);
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
<p><span class="jspmaker">Procurar TABELA: Fornecedores<br><br><a href="fornecedoreslist.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_idFornecedores && !EW_checkinteger(EW_this.x_idFornecedores.value)) {
        if (!EW_onError(EW_this, EW_this.x_idFornecedores, "TEXT", "Numero inteiro invalido! - Fornecedor"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="fornecedoressrch.jsp" method="post">
<p>
<input type="hidden" name="a" value="S">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Fornecedor</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_idFornecedores" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_idFornecedores" value="<%= HTMLEncode((String)x_idFornecedores) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Nome Fornecedor</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Nome_Fornecedor" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Nome_Fornecedor" size="70" maxlength="50" value="<%= HTMLEncode((String)x_Nome_Fornecedor) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">CNPJ</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_CNPJ" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_CNPJ" size="20" maxlength="14" value="<%= HTMLEncode((String)x_CNPJ) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Endereco</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Endereco" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Endereco" cols="40" rows="4"><% if (x_Endereco!=null) out.print(x_Endereco); %></textarea></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Telefone</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Telefone" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Telefone" size="70" maxlength="50" value="<%= HTMLEncode((String)x_Telefone) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Home Page</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Home_Page" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Home_Page" size="100" maxlength="255" value="<%= HTMLEncode((String)x_Home_Page) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">e Mail</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_eMail" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_eMail" size="100" maxlength="255" value="<%= HTMLEncode((String)x_eMail) %>"></span>&nbsp;</td>
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
