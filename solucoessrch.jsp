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
	response.sendRedirect("solucoeslist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
	String x_id_Solucao =  "";
	String x_id_Problema =  "";
	String x_Detalhes =  "";
	String x_Imagem =  "";
	String x_Video =  "";
	String x_Som =  "";
	String x_Login =  "";
String tmpfld = null;
String escapeString = "\\\\'";

// Get action
String a = request.getParameter("a");
String this_search_criteria = "";
if (a != null && a.equals("S")) { // Get Search Criteria

	// Build search criteria for advanced search, remove blank field
	String search_criteria = "";

	// id_Solucao
	if (request.getParameter("x_id_Solucao") != null){
		x_id_Solucao = request.getParameter("x_id_Solucao");
	}
	String z_id_Solucao = "";
	if (request.getParameterValues("z_id_Solucao") != null){
		String [] ary_z_id_Solucao = request.getParameterValues("z_id_Solucao");
		for (int i =0; i < ary_z_id_Solucao.length; i++){
			z_id_Solucao += ary_z_id_Solucao[i] + ",";
		}
		z_id_Solucao = z_id_Solucao.substring(0,z_id_Solucao.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Solucao.length() > 0) {
		String srchFld = x_id_Solucao;
		this_search_criteria = "x_id_Solucao=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Solucao=" + URLEncoder.encode(z_id_Solucao,"UTF-8");
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

	// Detalhes
	if (request.getParameter("x_Detalhes") != null){
		x_Detalhes = request.getParameter("x_Detalhes");
	}
	String z_Detalhes = "";
	if (request.getParameterValues("z_Detalhes") != null){
		String [] ary_z_Detalhes = request.getParameterValues("z_Detalhes");
		for (int i =0; i < ary_z_Detalhes.length; i++){
			z_Detalhes += ary_z_Detalhes[i] + ",";
		}
		z_Detalhes = z_Detalhes.substring(0,z_Detalhes.length()-1);
	}
	this_search_criteria = "";
	if (x_Detalhes.length() > 0) {
		String srchFld = x_Detalhes;
		this_search_criteria = "x_Detalhes=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Detalhes=" + URLEncoder.encode(z_Detalhes,"UTF-8");
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
		response.sendRedirect("solucoeslist.jsp" + "?" + search_criteria);
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
<p><span class="jspmaker">Procurar TABELA: Solucoes<br><br><a href="solucoeslist.jsp">Voltar a lista</a></span></p>
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
if (EW_this.x_id_Solucao && !EW_checkinteger(EW_this.x_id_Solucao.value)) {
        if (!EW_onError(EW_this, EW_this.x_id_Solucao, "TEXT", "Numero inteiro invalido! - Codigo"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="solucoessrch.jsp" method="post">
<p>
<input type="hidden" name="a" value="S">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Solucao" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_id_Solucao" value="<%= HTMLEncode((String)x_id_Solucao) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Problema</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Problema" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Problema_js = "";
String x_id_ProblemaList = "<select name=\"x_id_Problema\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Problema = "SELECT `id_Problema` FROM `problemas`" + " ORDER BY `id_Problema` DESC";
Statement stmtwrk_x_id_Problema = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Problema = stmtwrk_x_id_Problema.executeQuery(sqlwrk_x_id_Problema);
	int rowcntwrk_x_id_Problema = 0;
	while (rswrk_x_id_Problema.next()) {
		x_id_ProblemaList += "<option value=\"" + HTMLEncode(rswrk_x_id_Problema.getString("id_Problema")) + "\"";
		if (rswrk_x_id_Problema.getString("id_Problema").equals(x_id_Problema)) {
			x_id_ProblemaList += " selected";
		}
		String tmpValue_x_id_Problema = "";
		if (rswrk_x_id_Problema.getString("id_Problema")!= null) tmpValue_x_id_Problema = rswrk_x_id_Problema.getString("id_Problema");
		x_id_ProblemaList += ">" + tmpValue_x_id_Problema
 + "</option>";
		rowcntwrk_x_id_Problema++;
	}
rswrk_x_id_Problema.close();
rswrk_x_id_Problema = null;
stmtwrk_x_id_Problema.close();
stmtwrk_x_id_Problema = null;
x_id_ProblemaList += "</select>";
out.println(x_id_ProblemaList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Detalhes</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Detalhes" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Detalhes" cols="80" rows="4"><% if (x_Detalhes!=null) out.print(x_Detalhes); %></textarea><script language="JavaScript1.2">editor_generate('x_Detalhes');</script></span>&nbsp;</td>
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
