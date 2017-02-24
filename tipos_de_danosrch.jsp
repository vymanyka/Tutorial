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
	response.sendRedirect("tipos_de_danolist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
	String x_id_Dano =  "";
	String x_Descricao_do_dano =  "";
	String x_Login =  "";
String tmpfld = null;
String escapeString = "\\\\'";

// Get action
String a = request.getParameter("a");
String this_search_criteria = "";
if (a != null && a.equals("S")) { // Get Search Criteria

	// Build search criteria for advanced search, remove blank field
	String search_criteria = "";

	// id_Dano
	if (request.getParameter("x_id_Dano") != null){
		x_id_Dano = request.getParameter("x_id_Dano");
	}
	String z_id_Dano = "";
	if (request.getParameterValues("z_id_Dano") != null){
		String [] ary_z_id_Dano = request.getParameterValues("z_id_Dano");
		for (int i =0; i < ary_z_id_Dano.length; i++){
			z_id_Dano += ary_z_id_Dano[i] + ",";
		}
		z_id_Dano = z_id_Dano.substring(0,z_id_Dano.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Dano.length() > 0) {
		String srchFld = x_id_Dano;
		this_search_criteria = "x_id_Dano=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Dano=" + URLEncoder.encode(z_id_Dano,"UTF-8");
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

	// Descricao_do_dano
	if (request.getParameter("x_Descricao_do_dano") != null){
		x_Descricao_do_dano = request.getParameter("x_Descricao_do_dano");
	}
	String z_Descricao_do_dano = "";
	if (request.getParameterValues("z_Descricao_do_dano") != null){
		String [] ary_z_Descricao_do_dano = request.getParameterValues("z_Descricao_do_dano");
		for (int i =0; i < ary_z_Descricao_do_dano.length; i++){
			z_Descricao_do_dano += ary_z_Descricao_do_dano[i] + ",";
		}
		z_Descricao_do_dano = z_Descricao_do_dano.substring(0,z_Descricao_do_dano.length()-1);
	}
	this_search_criteria = "";
	if (x_Descricao_do_dano.length() > 0) {
		String srchFld = x_Descricao_do_dano;
		this_search_criteria = "x_Descricao_do_dano=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Descricao_do_dano=" + URLEncoder.encode(z_Descricao_do_dano,"UTF-8");
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
		response.sendRedirect("tipos_de_danolist.jsp" + "?" + search_criteria);
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
<p><span class="jspmaker">Procurar TABELA: Danos<br><br><a href="tipos_de_danolist.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_id_Dano && !EW_checkinteger(EW_this.x_id_Dano.value)) {
        if (!EW_onError(EW_this, EW_this.x_id_Dano, "TEXT", "Numero inteiro invalido! - Codigo"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="tipos_de_danosrch.jsp" method="post">
<p>
<input type="hidden" name="a" value="S">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Dano" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_id_Dano" value="<%= HTMLEncode((String)x_id_Dano) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Descricao do dano</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Descricao_do_dano" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Descricao_do_dano" size="70" maxlength="50" value="<%= HTMLEncode((String)x_Descricao_do_dano) %>"></span>&nbsp;</td>
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
