<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*"%>
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
if ((ewCurSec & ewAllowEdit) != ewAllowEdit) {
	response.sendRedirect("contratoslist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
String tmpfld = null;
String escapeString = "\\\\'";
request.setCharacterEncoding("UTF-8");
String key = request.getParameter("key");
if (key == null || key.length() == 0 ) {
	response.sendRedirect("contratoslist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_id_Contrato = null;
Object x_Contrato = null;
Object x_Empresa = null;
Object x_Vigencia = null;
Object x_Horario_atend = null;
Object x_Primeiro_atend = null;
Object x_Solucao = null;
Object x_Login = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `contratos` WHERE `id_Contrato`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("contratoslist.jsp");
			response.flushBuffer();
			return;
		}else{
			rs.first();

			// Get the field contents
	x_id_Contrato = String.valueOf(rs.getLong("id_Contrato"));
			if (rs.getClob("Contrato") != null) {
				long length = rs.getClob("Contrato").length();
				x_Contrato = rs.getClob("Contrato").getSubString((long) 1, (int) length);
			}else{
				x_Contrato = "";
			}
			if (rs.getClob("Empresa") != null) {
				long length = rs.getClob("Empresa").length();
				x_Empresa = rs.getClob("Empresa").getSubString((long) 1, (int) length);
			}else{
				x_Empresa = "";
			}
			if (rs.getClob("Vigencia") != null) {
				long length = rs.getClob("Vigencia").length();
				x_Vigencia = rs.getClob("Vigencia").getSubString((long) 1, (int) length);
			}else{
				x_Vigencia = "";
			}
			if (rs.getClob("Horario_atend") != null) {
				long length = rs.getClob("Horario_atend").length();
				x_Horario_atend = rs.getClob("Horario_atend").getSubString((long) 1, (int) length);
			}else{
				x_Horario_atend = "";
			}
			if (rs.getClob("Primeiro_atend") != null) {
				long length = rs.getClob("Primeiro_atend").length();
				x_Primeiro_atend = rs.getClob("Primeiro_atend").getSubString((long) 1, (int) length);
			}else{
				x_Primeiro_atend = "";
			}
			if (rs.getClob("Solucao") != null) {
				long length = rs.getClob("Solucao").length();
				x_Solucao = rs.getClob("Solucao").getSubString((long) 1, (int) length);
			}else{
				x_Solucao = "";
			}
			if (rs.getString("Login") != null){
				x_Login = rs.getString("Login");
			}else{
				x_Login = "";
			}
		}
		rs.close();
	}else if (a.equals("U")) {// Update

		// Get fields from form
		if (request.getParameter("x_Contrato") != null){
			x_Contrato = (String) request.getParameter("x_Contrato");
		}else{
			x_Contrato = "";
		}
		if (request.getParameter("x_Empresa") != null){
			x_Empresa = (String) request.getParameter("x_Empresa");
		}else{
			x_Empresa = "";
		}
		if (request.getParameter("x_Vigencia") != null){
			x_Vigencia = (String) request.getParameter("x_Vigencia");
		}else{
			x_Vigencia = "";
		}
		if (request.getParameter("x_Horario_atend") != null){
			x_Horario_atend = (String) request.getParameter("x_Horario_atend");
		}else{
			x_Horario_atend = "";
		}
		if (request.getParameter("x_Primeiro_atend") != null){
			x_Primeiro_atend = (String) request.getParameter("x_Primeiro_atend");
		}else{
			x_Primeiro_atend = "";
		}
		if (request.getParameter("x_Solucao") != null){
			x_Solucao = (String) request.getParameter("x_Solucao");
		}else{
			x_Solucao = "";
		}
		if (request.getParameter("x_Login") != null){
			x_Login = (String) request.getParameter("x_Login");
		}else{
			x_Login = "";
		}

		// Open record
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `contratos` WHERE `id_Contrato`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("contratoslist.jsp");
			response.flushBuffer();
			return;
		}

		// Field Contrato
		tmpfld = ((String) x_Contrato);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Contrato");
		}else{
			rs.updateString("Contrato", tmpfld);
		}

		// Field Empresa
		tmpfld = ((String) x_Empresa);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Empresa");
		}else{
			rs.updateString("Empresa", tmpfld);
		}

		// Field Vigencia
		tmpfld = ((String) x_Vigencia);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Vigencia");
		}else{
			rs.updateString("Vigencia", tmpfld);
		}

		// Field Horario_atend
		tmpfld = ((String) x_Horario_atend);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Horario_atend");
		}else{
			rs.updateString("Horario_atend", tmpfld);
		}

		// Field Primeiro_atend
		tmpfld = ((String) x_Primeiro_atend);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Primeiro_atend");
		}else{
			rs.updateString("Primeiro_atend", tmpfld);
		}

		// Field Solucao
		tmpfld = ((String) x_Solucao);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Solucao");
		}else{
			rs.updateString("Solucao", tmpfld);
		}

		// Field Login
		tmpfld = ((String) x_Login);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("Login");
		}else{
			rs.updateString("Login", tmpfld);
		}
		rs.updateRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		response.sendRedirect("contratoslist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
		out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Editar TABELA: Contratos<br><br><a href="contratoslist.jsp">Voltar a lista</a></span></p>
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
if (EW_this.x_Contrato && !EW_hasValue(EW_this.x_Contrato, "TEXTAREA" )) {
            if (!EW_onError(EW_this, EW_this.x_Contrato, "TEXTAREA", "Informe o contrato!"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="contratosedit" action="contratosedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_id_Contrato); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Contrato</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Contrato" cols="100" rows="4"><% if (x_Contrato!=null) out.print(x_Contrato); %></textarea><script language="JavaScript1.2">editor_generate('x_Contrato');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Empresa</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Empresa" cols="100" rows="4"><% if (x_Empresa!=null) out.print(x_Empresa); %></textarea><script language="JavaScript1.2">editor_generate('x_Empresa');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Vigencia</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Vigencia" cols="100" rows="4"><% if (x_Vigencia!=null) out.print(x_Vigencia); %></textarea><script language="JavaScript1.2">editor_generate('x_Vigencia');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Horario atendimento</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Horario_atend" cols="100" rows="4"><% if (x_Horario_atend!=null) out.print(x_Horario_atend); %></textarea><script language="JavaScript1.2">editor_generate('x_Horario_atend');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Primeiro atendimento</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Primeiro_atend" cols="100" rows="4"><% if (x_Primeiro_atend!=null) out.print(x_Primeiro_atend); %></textarea><script language="JavaScript1.2">editor_generate('x_Primeiro_atend');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Solucao</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Solucao" cols="100" rows="4"><% if (x_Solucao!=null) out.print(x_Solucao); %></textarea><script language="JavaScript1.2">editor_generate('x_Solucao');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Login</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (session.getAttribute("sighs_status_UserLevel") != null && ((Integer) session.getAttribute("sighs_status_UserLevel")).intValue() == -1) { // system admin %>
<input type="text" name="x_Login" size="30" maxlength="10" value="<%= HTMLEncode((String)x_Login) %>">
<%}  else { // not system admin %>
<% 	x_Login = ((String) session.getAttribute("sighs_status_UserID")); %><% out.print(x_Login); %><input type="hidden" name="x_Login" value="<%= HTMLEncode((String)x_Login) %>">
<% 	} %>
</span>&nbsp;</td>
	</tr>
</table>
<p>
<input type="submit" name="Action" value="EDITAR">
</form>
<%@ include file="footer.jsp" %>
