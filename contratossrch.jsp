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
	response.sendRedirect("contratoslist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
	String x_id_Contrato =  "";
	String x_Contrato =  "";
	String x_Empresa =  "";
	String x_Vigencia =  "";
	String x_Horario_atend =  "";
	String x_Primeiro_atend =  "";
	String x_Solucao =  "";
	String x_Login =  "";
String tmpfld = null;
String escapeString = "\\\\'";

// Get action
String a = request.getParameter("a");
String this_search_criteria = "";
if (a != null && a.equals("S")) { // Get Search Criteria

	// Build search criteria for advanced search, remove blank field
	String search_criteria = "";

	// id_Contrato
	if (request.getParameter("x_id_Contrato") != null){
		x_id_Contrato = request.getParameter("x_id_Contrato");
	}
	String z_id_Contrato = "";
	if (request.getParameterValues("z_id_Contrato") != null){
		String [] ary_z_id_Contrato = request.getParameterValues("z_id_Contrato");
		for (int i =0; i < ary_z_id_Contrato.length; i++){
			z_id_Contrato += ary_z_id_Contrato[i] + ",";
		}
		z_id_Contrato = z_id_Contrato.substring(0,z_id_Contrato.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Contrato.length() > 0) {
		String srchFld = x_id_Contrato;
		this_search_criteria = "x_id_Contrato=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Contrato=" + URLEncoder.encode(z_id_Contrato,"UTF-8");
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

	// Contrato
	if (request.getParameter("x_Contrato") != null){
		x_Contrato = request.getParameter("x_Contrato");
	}
	String z_Contrato = "";
	if (request.getParameterValues("z_Contrato") != null){
		String [] ary_z_Contrato = request.getParameterValues("z_Contrato");
		for (int i =0; i < ary_z_Contrato.length; i++){
			z_Contrato += ary_z_Contrato[i] + ",";
		}
		z_Contrato = z_Contrato.substring(0,z_Contrato.length()-1);
	}
	this_search_criteria = "";
	if (x_Contrato.length() > 0) {
		String srchFld = x_Contrato;
		this_search_criteria = "x_Contrato=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Contrato=" + URLEncoder.encode(z_Contrato,"UTF-8");
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

	// Empresa
	if (request.getParameter("x_Empresa") != null){
		x_Empresa = request.getParameter("x_Empresa");
	}
	String z_Empresa = "";
	if (request.getParameterValues("z_Empresa") != null){
		String [] ary_z_Empresa = request.getParameterValues("z_Empresa");
		for (int i =0; i < ary_z_Empresa.length; i++){
			z_Empresa += ary_z_Empresa[i] + ",";
		}
		z_Empresa = z_Empresa.substring(0,z_Empresa.length()-1);
	}
	this_search_criteria = "";
	if (x_Empresa.length() > 0) {
		String srchFld = x_Empresa;
		this_search_criteria = "x_Empresa=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Empresa=" + URLEncoder.encode(z_Empresa,"UTF-8");
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

	// Vigencia
	if (request.getParameter("x_Vigencia") != null){
		x_Vigencia = request.getParameter("x_Vigencia");
	}
	String z_Vigencia = "";
	if (request.getParameterValues("z_Vigencia") != null){
		String [] ary_z_Vigencia = request.getParameterValues("z_Vigencia");
		for (int i =0; i < ary_z_Vigencia.length; i++){
			z_Vigencia += ary_z_Vigencia[i] + ",";
		}
		z_Vigencia = z_Vigencia.substring(0,z_Vigencia.length()-1);
	}
	this_search_criteria = "";
	if (x_Vigencia.length() > 0) {
		String srchFld = x_Vigencia;
		this_search_criteria = "x_Vigencia=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Vigencia=" + URLEncoder.encode(z_Vigencia,"UTF-8");
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

	// Horario_atend
	if (request.getParameter("x_Horario_atend") != null){
		x_Horario_atend = request.getParameter("x_Horario_atend");
	}
	String z_Horario_atend = "";
	if (request.getParameterValues("z_Horario_atend") != null){
		String [] ary_z_Horario_atend = request.getParameterValues("z_Horario_atend");
		for (int i =0; i < ary_z_Horario_atend.length; i++){
			z_Horario_atend += ary_z_Horario_atend[i] + ",";
		}
		z_Horario_atend = z_Horario_atend.substring(0,z_Horario_atend.length()-1);
	}
	this_search_criteria = "";
	if (x_Horario_atend.length() > 0) {
		String srchFld = x_Horario_atend;
		this_search_criteria = "x_Horario_atend=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Horario_atend=" + URLEncoder.encode(z_Horario_atend,"UTF-8");
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

	// Primeiro_atend
	if (request.getParameter("x_Primeiro_atend") != null){
		x_Primeiro_atend = request.getParameter("x_Primeiro_atend");
	}
	String z_Primeiro_atend = "";
	if (request.getParameterValues("z_Primeiro_atend") != null){
		String [] ary_z_Primeiro_atend = request.getParameterValues("z_Primeiro_atend");
		for (int i =0; i < ary_z_Primeiro_atend.length; i++){
			z_Primeiro_atend += ary_z_Primeiro_atend[i] + ",";
		}
		z_Primeiro_atend = z_Primeiro_atend.substring(0,z_Primeiro_atend.length()-1);
	}
	this_search_criteria = "";
	if (x_Primeiro_atend.length() > 0) {
		String srchFld = x_Primeiro_atend;
		this_search_criteria = "x_Primeiro_atend=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Primeiro_atend=" + URLEncoder.encode(z_Primeiro_atend,"UTF-8");
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

	// Solucao
	if (request.getParameter("x_Solucao") != null){
		x_Solucao = request.getParameter("x_Solucao");
	}
	String z_Solucao = "";
	if (request.getParameterValues("z_Solucao") != null){
		String [] ary_z_Solucao = request.getParameterValues("z_Solucao");
		for (int i =0; i < ary_z_Solucao.length; i++){
			z_Solucao += ary_z_Solucao[i] + ",";
		}
		z_Solucao = z_Solucao.substring(0,z_Solucao.length()-1);
	}
	this_search_criteria = "";
	if (x_Solucao.length() > 0) {
		String srchFld = x_Solucao;
		this_search_criteria = "x_Solucao=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Solucao=" + URLEncoder.encode(z_Solucao,"UTF-8");
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
		response.sendRedirect("contratoslist.jsp" + "?" + search_criteria);
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
<p><span class="jspmaker">Procurar TABELA: Contratos<br><br><a href="contratoslist.jsp">Voltar a lista</a></span></p>
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
if (EW_this.x_id_Contrato && !EW_checkinteger(EW_this.x_id_Contrato.value)) {
        if (!EW_onError(EW_this, EW_this.x_id_Contrato, "TEXT", "Numero inteiro invalido! - Codigo"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="contratossrch.jsp" method="post">
<p>
<input type="hidden" name="a" value="S">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Contrato" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_id_Contrato" value="<%= HTMLEncode((String)x_id_Contrato) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Contrato</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Contrato" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Contrato" cols="100" rows="4"><% if (x_Contrato!=null) out.print(x_Contrato); %></textarea><script language="JavaScript1.2">editor_generate('x_Contrato');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Empresa</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Empresa" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Empresa" cols="100" rows="4"><% if (x_Empresa!=null) out.print(x_Empresa); %></textarea><script language="JavaScript1.2">editor_generate('x_Empresa');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Vigencia</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Vigencia" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Vigencia" cols="100" rows="4"><% if (x_Vigencia!=null) out.print(x_Vigencia); %></textarea><script language="JavaScript1.2">editor_generate('x_Vigencia');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Horario atendimento</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Horario_atend" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Horario_atend" cols="100" rows="4"><% if (x_Horario_atend!=null) out.print(x_Horario_atend); %></textarea><script language="JavaScript1.2">editor_generate('x_Horario_atend');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Primeiro atendimento</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Primeiro_atend" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Primeiro_atend" cols="100" rows="4"><% if (x_Primeiro_atend!=null) out.print(x_Primeiro_atend); %></textarea><script language="JavaScript1.2">editor_generate('x_Primeiro_atend');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Solucao</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Solucao" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Solucao" cols="100" rows="4"><% if (x_Solucao!=null) out.print(x_Solucao); %></textarea><script language="JavaScript1.2">editor_generate('x_Solucao');</script></span>&nbsp;</td>
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
