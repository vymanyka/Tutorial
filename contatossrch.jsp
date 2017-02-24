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
	response.sendRedirect("contatoslist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
	String x_id_Contatos =  "";
	String x_idFornecedores =  "";
	String x_Nome_Contato =  "";
	String x_Numero_Telefone =  "";
	String x_Login =  "";
String tmpfld = null;
String escapeString = "\\\\'";

// Get action
String a = request.getParameter("a");
String this_search_criteria = "";
if (a != null && a.equals("S")) { // Get Search Criteria

	// Build search criteria for advanced search, remove blank field
	String search_criteria = "";

	// id_Contatos
	if (request.getParameter("x_id_Contatos") != null){
		x_id_Contatos = request.getParameter("x_id_Contatos");
	}
	String z_id_Contatos = "";
	if (request.getParameterValues("z_id_Contatos") != null){
		String [] ary_z_id_Contatos = request.getParameterValues("z_id_Contatos");
		for (int i =0; i < ary_z_id_Contatos.length; i++){
			z_id_Contatos += ary_z_id_Contatos[i] + ",";
		}
		z_id_Contatos = z_id_Contatos.substring(0,z_id_Contatos.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Contatos.length() > 0) {
		String srchFld = x_id_Contatos;
		this_search_criteria = "x_id_Contatos=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Contatos=" + URLEncoder.encode(z_id_Contatos,"UTF-8");
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

	// Nome_Contato
	if (request.getParameter("x_Nome_Contato") != null){
		x_Nome_Contato = request.getParameter("x_Nome_Contato");
	}
	String z_Nome_Contato = "";
	if (request.getParameterValues("z_Nome_Contato") != null){
		String [] ary_z_Nome_Contato = request.getParameterValues("z_Nome_Contato");
		for (int i =0; i < ary_z_Nome_Contato.length; i++){
			z_Nome_Contato += ary_z_Nome_Contato[i] + ",";
		}
		z_Nome_Contato = z_Nome_Contato.substring(0,z_Nome_Contato.length()-1);
	}
	this_search_criteria = "";
	if (x_Nome_Contato.length() > 0) {
		String srchFld = x_Nome_Contato;
		this_search_criteria = "x_Nome_Contato=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Nome_Contato=" + URLEncoder.encode(z_Nome_Contato,"UTF-8");
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

	// Numero_Telefone
	if (request.getParameter("x_Numero_Telefone") != null){
		x_Numero_Telefone = request.getParameter("x_Numero_Telefone");
	}
	String z_Numero_Telefone = "";
	if (request.getParameterValues("z_Numero_Telefone") != null){
		String [] ary_z_Numero_Telefone = request.getParameterValues("z_Numero_Telefone");
		for (int i =0; i < ary_z_Numero_Telefone.length; i++){
			z_Numero_Telefone += ary_z_Numero_Telefone[i] + ",";
		}
		z_Numero_Telefone = z_Numero_Telefone.substring(0,z_Numero_Telefone.length()-1);
	}
	this_search_criteria = "";
	if (x_Numero_Telefone.length() > 0) {
		String srchFld = x_Numero_Telefone;
		this_search_criteria = "x_Numero_Telefone=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Numero_Telefone=" + URLEncoder.encode(z_Numero_Telefone,"UTF-8");
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
		response.sendRedirect("contatoslist.jsp" + "?" + search_criteria);
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
<p><span class="jspmaker">Procurar TABELA: Contatos<br><br><a href="contatoslist.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_id_Contatos && !EW_checkinteger(EW_this.x_id_Contatos.value)) {
        if (!EW_onError(EW_this, EW_this.x_id_Contatos, "TEXT", "Numero inteiro invalido! - id Contatos"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="contatossrch.jsp" method="post">
<p>
<input type="hidden" name="a" value="S">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">id Contatos</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Contatos" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_id_Contatos" value="<%= HTMLEncode((String)x_id_Contatos) %>"></span>&nbsp;</td>
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
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Nome do contato</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Nome_Contato" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Nome_Contato" size="70" maxlength="50" value="<%= HTMLEncode((String)x_Nome_Contato) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Numero do Telefone</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Numero_Telefone" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Numero_Telefone" size="70" maxlength="50" value="<%= HTMLEncode((String)x_Numero_Telefone) %>"></span>&nbsp;</td>
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
