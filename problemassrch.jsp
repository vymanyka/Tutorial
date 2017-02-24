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
ew_SecTable[1] = 15;
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
	response.sendRedirect("problemaslist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
	String x_id_Problema =  "";
	String x_id_Movimentacao =  "";
	String x_id_Dano =  "";
	String x_Descricao_do_problema =  "";
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

	// id_Movimentacao
	if (request.getParameter("x_id_Movimentacao") != null){
		x_id_Movimentacao = request.getParameter("x_id_Movimentacao");
	}
	String z_id_Movimentacao = "";
	if (request.getParameterValues("z_id_Movimentacao") != null){
		String [] ary_z_id_Movimentacao = request.getParameterValues("z_id_Movimentacao");
		for (int i =0; i < ary_z_id_Movimentacao.length; i++){
			z_id_Movimentacao += ary_z_id_Movimentacao[i] + ",";
		}
		z_id_Movimentacao = z_id_Movimentacao.substring(0,z_id_Movimentacao.length()-1);
	}
	this_search_criteria = "";
	if (x_id_Movimentacao.length() > 0) {
		String srchFld = x_id_Movimentacao;
		this_search_criteria = "x_id_Movimentacao=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_id_Movimentacao=" + URLEncoder.encode(z_id_Movimentacao,"UTF-8");
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

	// Descricao_do_problema
	if (request.getParameter("x_Descricao_do_problema") != null){
		x_Descricao_do_problema = request.getParameter("x_Descricao_do_problema");
	}
	String z_Descricao_do_problema = "";
	if (request.getParameterValues("z_Descricao_do_problema") != null){
		String [] ary_z_Descricao_do_problema = request.getParameterValues("z_Descricao_do_problema");
		for (int i =0; i < ary_z_Descricao_do_problema.length; i++){
			z_Descricao_do_problema += ary_z_Descricao_do_problema[i] + ",";
		}
		z_Descricao_do_problema = z_Descricao_do_problema.substring(0,z_Descricao_do_problema.length()-1);
	}
	this_search_criteria = "";
	if (x_Descricao_do_problema.length() > 0) {
		String srchFld = x_Descricao_do_problema;
		this_search_criteria = "x_Descricao_do_problema=" + URLEncoder.encode(srchFld,"UTF-8");
		this_search_criteria = this_search_criteria + "&z_Descricao_do_problema=" + URLEncoder.encode(z_Descricao_do_problema,"UTF-8");
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
		response.sendRedirect("problemaslist.jsp" + "?" + search_criteria);
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
<p><span class="jspmaker">Procurar TABELA: Problemas<br><br><a href="problemaslist.jsp">Voltar a lista</a></span></p>
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
if (EW_this.x_id_Problema && !EW_checkinteger(EW_this.x_id_Problema.value)) {
        if (!EW_onError(EW_this, EW_this.x_id_Problema, "TEXT", "Numero inteiro invalido! - Codigo"))
            return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="problemassrch.jsp" method="post">
<p>
<input type="hidden" name="a" value="S">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Problema" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_id_Problema" value="<%= HTMLEncode((String)x_id_Problema) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Movimentacao</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Movimentacao" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Movimentacao_js = "";
String x_id_MovimentacaoList = "<select name=\"x_id_Movimentacao\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Movimentacao = "SELECT `id_Movimentacao`, `id_Bem` FROM `movimentacao`" + " ORDER BY `id_Bem` ASC";
Statement stmtwrk_x_id_Movimentacao = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Movimentacao = stmtwrk_x_id_Movimentacao.executeQuery(sqlwrk_x_id_Movimentacao);
	int rowcntwrk_x_id_Movimentacao = 0;
	while (rswrk_x_id_Movimentacao.next()) {
		x_id_MovimentacaoList += "<option value=\"" + HTMLEncode(rswrk_x_id_Movimentacao.getString("id_Movimentacao")) + "\"";
		if (rswrk_x_id_Movimentacao.getString("id_Movimentacao").equals(x_id_Movimentacao)) {
			x_id_MovimentacaoList += " selected";
		}
		String tmpValue_x_id_Movimentacao = "";
		if (rswrk_x_id_Movimentacao.getString("id_Bem")!= null) tmpValue_x_id_Movimentacao = rswrk_x_id_Movimentacao.getString("id_Bem");
		x_id_MovimentacaoList += ">" + tmpValue_x_id_Movimentacao
 + ", " + rswrk_x_id_Movimentacao.getString("id_Movimentacao") + "</option>";
		rowcntwrk_x_id_Movimentacao++;
	}
rswrk_x_id_Movimentacao.close();
rswrk_x_id_Movimentacao = null;
stmtwrk_x_id_Movimentacao.close();
stmtwrk_x_id_Movimentacao = null;
x_id_MovimentacaoList += "</select>";
out.println(x_id_MovimentacaoList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Dano</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_id_Dano" value="=, , ">=
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Dano_js = "";
String x_id_DanoList = "<select name=\"x_id_Dano\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Dano = "SELECT `id_Dano`, `Descricao_do_dano` FROM `tipos_de_dano`" + " ORDER BY `Descricao_do_dano` ASC";
Statement stmtwrk_x_id_Dano = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Dano = stmtwrk_x_id_Dano.executeQuery(sqlwrk_x_id_Dano);
	int rowcntwrk_x_id_Dano = 0;
	while (rswrk_x_id_Dano.next()) {
		x_id_DanoList += "<option value=\"" + HTMLEncode(rswrk_x_id_Dano.getString("id_Dano")) + "\"";
		if (rswrk_x_id_Dano.getString("id_Dano").equals(x_id_Dano)) {
			x_id_DanoList += " selected";
		}
		String tmpValue_x_id_Dano = "";
		if (rswrk_x_id_Dano.getString("Descricao_do_dano")!= null) tmpValue_x_id_Dano = rswrk_x_id_Dano.getString("Descricao_do_dano");
		x_id_DanoList += ">" + tmpValue_x_id_Dano
 + "</option>";
		rowcntwrk_x_id_Dano++;
	}
rswrk_x_id_Dano.close();
rswrk_x_id_Dano = null;
stmtwrk_x_id_Dano.close();
stmtwrk_x_id_Dano = null;
x_id_DanoList += "</select>";
out.println(x_id_DanoList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Descricao do problema</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker">
<input type="hidden" name="z_Descricao_do_problema" value="LIKE, '%,%'">IGUAL
</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Descricao_do_problema" cols="80" rows="4"><% if (x_Descricao_do_problema!=null) out.print(x_Descricao_do_problema); %></textarea><script language="JavaScript1.2">editor_generate('x_Descricao_do_problema');</script></span>&nbsp;</td>
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
