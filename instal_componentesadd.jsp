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
ew_SecTable[0] = 8;
ew_SecTable[1] = 11;
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
if ((ewCurSec & ewAllowAdd) != ewAllowAdd) {
	response.sendRedirect("instal_componenteslist.jsp"); 
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

// Get action
String a = request.getParameter("a");
String key = "";
if (a == null || a.length() == 0) {
	key = request.getParameter("key");
	if (key != null && key.length() > 0) {
		a = "C"; // Copy record
	} else {
		a = "I"; // Display blank record
	}
}
Object x_id_Instal_Componentes = null;
Object x_id_Componente = null;
Object x_id_Problema = null;
Object x_Origem_Componente = null;
Object x_Data_instalacao = null;
Object x_Qtd_instalacao = null;
Object x_Detalhes_da_instalacao = null;
Object x_Relacao_confianca = null;
Object x_Com_quem = null;
Object x_Telefone_confianca = null;
Object x_Login = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `instal_componentes` WHERE `id_Instal_Componentes`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("instal_componenteslist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

			// Get the field contents
	x_id_Componente = String.valueOf(rs.getLong("id_Componente"));
	x_id_Problema = String.valueOf(rs.getLong("id_Problema"));
	x_Origem_Componente = String.valueOf(rs.getLong("Origem_Componente"));
	if (rs.getTimestamp("Data_instalacao") != null){
		x_Data_instalacao = rs.getTimestamp("Data_instalacao");
	}else{
		x_Data_instalacao = null;
	}
	x_Qtd_instalacao = String.valueOf(rs.getLong("Qtd_instalacao"));
	if (rs.getClob("Detalhes_da_instalacao") != null) {
		long length = rs.getClob("Detalhes_da_instalacao").length();
		x_Detalhes_da_instalacao = rs.getClob("Detalhes_da_instalacao").getSubString((long) 1, (int) length);
	}else{
		x_Detalhes_da_instalacao = "";
	}
	x_Relacao_confianca = String.valueOf(rs.getLong("Relacao_confianca"));
	if (rs.getString("Com_quem") != null){
		x_Com_quem = rs.getString("Com_quem");
	}else{
		x_Com_quem = "";
	}
	if (rs.getString("Telefone_confianca") != null){
		x_Telefone_confianca = rs.getString("Telefone_confianca");
	}else{
		x_Telefone_confianca = "";
	}
	if (rs.getString("Login") != null){
		x_Login = rs.getString("Login");
	}else{
		x_Login = "";
	}
		rs.close();
		rs = null;
	}else if (a.equals("A")) { // Add

		// Get fields from form
		if (request.getParameter("x_id_Componente") != null){
			x_id_Componente = request.getParameter("x_id_Componente");
		}
		if (request.getParameter("x_id_Problema") != null){
			x_id_Problema = (String) request.getParameter("x_id_Problema");
		}else{
			x_id_Problema = "";
		}
		if (request.getParameter("x_Origem_Componente") != null){
			x_Origem_Componente = request.getParameter("x_Origem_Componente");
		}
		if (request.getParameter("x_Data_instalacao") != null){
			x_Data_instalacao = (String) request.getParameter("x_Data_instalacao");
		}else{
			x_Data_instalacao = "";
		}
		if (request.getParameter("x_Qtd_instalacao") != null){
			x_Qtd_instalacao = (String) request.getParameter("x_Qtd_instalacao");
		}else{
			x_Qtd_instalacao = "";
		}
		if (request.getParameter("x_Detalhes_da_instalacao") != null){
			x_Detalhes_da_instalacao = (String) request.getParameter("x_Detalhes_da_instalacao");
		}else{
			x_Detalhes_da_instalacao = "";
		}
		if (request.getParameter("x_Relacao_confianca") != null){
			x_Relacao_confianca = (String) request.getParameter("x_Relacao_confianca");
		}else{
			x_Relacao_confianca = "";
		}
		if (request.getParameter("x_Com_quem") != null){
			x_Com_quem = (String) request.getParameter("x_Com_quem");
		}else{
			x_Com_quem = "";
		}
		if (request.getParameter("x_Telefone_confianca") != null){
			x_Telefone_confianca = (String) request.getParameter("x_Telefone_confianca");
		}else{
			x_Telefone_confianca = "";
		}
		if (request.getParameter("x_Login") != null){
			x_Login = (String) request.getParameter("x_Login");
		}else{
			x_Login = "";
		}

		// Open record
		String strsql = "SELECT * FROM `instal_componentes` WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field id_Componente
		tmpfld = ((String) x_id_Componente).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("id_Componente");
		} else {
			rs.updateInt("id_Componente",Integer.parseInt(tmpfld));
		}

		// Field id_Problema
		tmpfld = ((String) x_id_Problema).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("id_Problema");
		} else {
			rs.updateInt("id_Problema",Integer.parseInt(tmpfld));
		}

		// Field Origem_Componente
		tmpfld = ((String) x_Origem_Componente).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("Origem_Componente");
		} else {
			rs.updateInt("Origem_Componente",Integer.parseInt(tmpfld));
		}

		// Field Data_instalacao
		if (IsDate((String) x_Data_instalacao,"EURODATE", locale)) {
			rs.updateTimestamp("Data_instalacao", EW_UnFormatDateTime((String)x_Data_instalacao,"EURODATE", locale));
		}else{
			rs.updateNull("Data_instalacao");
		}

		// Field Qtd_instalacao
		tmpfld = ((String) x_Qtd_instalacao).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("Qtd_instalacao");
		} else {
			rs.updateInt("Qtd_instalacao",Integer.parseInt(tmpfld));
		}

		// Field Detalhes_da_instalacao
		tmpfld = ((String) x_Detalhes_da_instalacao);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Detalhes_da_instalacao");
		}else{
			rs.updateString("Detalhes_da_instalacao", tmpfld);
		}

		// Field Relacao_confianca
		tmpfld = ((String) x_Relacao_confianca).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("Relacao_confianca");
		} else {
			rs.updateInt("Relacao_confianca",Integer.parseInt(tmpfld));
		}

		// Field Com_quem
		tmpfld = ((String) x_Com_quem);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Com_quem");
		}else{
			rs.updateString("Com_quem", tmpfld);
		}

		// Field Telefone_confianca
		tmpfld = ((String) x_Telefone_confianca);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Telefone_confianca");
		}else{
			rs.updateString("Telefone_confianca", tmpfld);
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
		rs.insertRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		out.clear();
		response.sendRedirect("instal_componenteslist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Adicionar TABELA: Instalacao de componentes<br><br><a href="instal_componenteslist.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>
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
if (EW_this.x_id_Componente && !EW_hasValue(EW_this.x_id_Componente, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_id_Componente, "SELECT", "Informe o componente instalado!"))
                return false; 
        }
if (EW_this.x_id_Problema && !EW_hasValue(EW_this.x_id_Problema, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_id_Problema, "TEXT", "Numero inteiro invalido! - Problema #"))
                return false; 
        }
if (EW_this.x_id_Problema && !EW_checkinteger(EW_this.x_id_Problema.value)) {
        if (!EW_onError(EW_this, EW_this.x_id_Problema, "TEXT", "Numero inteiro invalido! - Problema #"))
            return false; 
        }
if (EW_this.x_Origem_Componente && !EW_hasValue(EW_this.x_Origem_Componente, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_Origem_Componente, "SELECT", "Informe o estado do componente instalado!"))
                return false; 
        }
if (EW_this.x_Data_instalacao && !EW_hasValue(EW_this.x_Data_instalacao, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_Data_instalacao, "TEXT", "Informe a data de instalacao!"))
                return false; 
        }
if (EW_this.x_Data_instalacao && !EW_checkeurodate(EW_this.x_Data_instalacao.value)) {
        if (!EW_onError(EW_this, EW_this.x_Data_instalacao, "TEXT", "Informe a data de instalacao!"))
            return false; 
        }
if (EW_this.x_Qtd_instalacao && !EW_hasValue(EW_this.x_Qtd_instalacao, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_Qtd_instalacao, "TEXT", "Informe a quantidade instalada!"))
                return false; 
        }
if (EW_this.x_Qtd_instalacao && !EW_checkinteger(EW_this.x_Qtd_instalacao.value)) {
        if (!EW_onError(EW_this, EW_this.x_Qtd_instalacao, "TEXT", "Informe a quantidade instalada!"))
            return false; 
        }
if (EW_this.x_Detalhes_da_instalacao && !EW_hasValue(EW_this.x_Detalhes_da_instalacao, "TEXTAREA" )) {
            if (!EW_onError(EW_this, EW_this.x_Detalhes_da_instalacao, "TEXTAREA", "Informacoes sobre esta operacao sao essenciais!"))
                return false; 
        }
if (EW_this.x_Relacao_confianca && !EW_hasValue(EW_this.x_Relacao_confianca, "RADIO" )) {
            if (!EW_onError(EW_this, EW_this.x_Relacao_confianca, "RADIO", "Informe o tipo de instalacao!"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="instal_componentesadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Componente</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Componente_js = "";
String x_id_ComponenteList = "<select name=\"x_id_Componente\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Componente = "SELECT `id_Componente`, `Descricao_do_componente` FROM `componentes`" + " ORDER BY `Descricao_do_componente` ASC";
Statement stmtwrk_x_id_Componente = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Componente = stmtwrk_x_id_Componente.executeQuery(sqlwrk_x_id_Componente);
	int rowcntwrk_x_id_Componente = 0;
	while (rswrk_x_id_Componente.next()) {
		x_id_ComponenteList += "<option value=\"" + HTMLEncode(rswrk_x_id_Componente.getString("id_Componente")) + "\"";
		if (rswrk_x_id_Componente.getString("id_Componente").equals(x_id_Componente)) {
			x_id_ComponenteList += " selected";
		}
		String tmpValue_x_id_Componente = "";
		if (rswrk_x_id_Componente.getString("Descricao_do_componente")!= null) tmpValue_x_id_Componente = rswrk_x_id_Componente.getString("Descricao_do_componente");
		x_id_ComponenteList += ">" + tmpValue_x_id_Componente
 + "</option>";
		rowcntwrk_x_id_Componente++;
	}
rswrk_x_id_Componente.close();
rswrk_x_id_Componente = null;
stmtwrk_x_id_Componente.close();
stmtwrk_x_id_Componente = null;
x_id_ComponenteList += "</select>";
out.println(x_id_ComponenteList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Problema #</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% String tmp_x_id_Problema = (String) session.getAttribute("instal_componentes_masterkey");
if (tmp_x_id_Problema != null && tmp_x_id_Problema.length() > 0) {
x_id_Problema = tmp_x_id_Problema; %>
<% out.print(x_id_Problema); %><input type="hidden" name="x_id_Problema" value="<%= HTMLEncode((String)x_id_Problema) %>">
<% } else { %>
<input type="text" name="x_id_Problema" size="30" value="<%= HTMLEncode((String)x_id_Problema) %>">
<% } %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Origem do Componente</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_Origem_Componente_js = "";
String x_Origem_ComponenteList = "<select name=\"x_Origem_Componente\"><option value=\"\">Selecione</option>";
x_Origem_ComponenteList += "<option value=\"" + HTMLEncode("1") + "\"";
if (x_Origem_Componente != null && x_Origem_Componente.equals("1")) {
	x_Origem_ComponenteList += " selected";
}
x_Origem_ComponenteList += ">" + "Novo" + "</option>";
x_Origem_ComponenteList += "<option value=\"" + HTMLEncode("2") + "\"";
if (x_Origem_Componente != null && x_Origem_Componente.equals("2")) {
	x_Origem_ComponenteList += " selected";
}
x_Origem_ComponenteList += ">" + "Seminovo" + "</option>";
x_Origem_ComponenteList += "<option value=\"" + HTMLEncode("3") + "\"";
if (x_Origem_Componente != null && x_Origem_Componente.equals("3")) {
	x_Origem_ComponenteList += " selected";
}
x_Origem_ComponenteList += ">" + "Recuperavel" + "</option>";
x_Origem_ComponenteList += "<option value=\"" + HTMLEncode("4") + "\"";
if (x_Origem_Componente != null && x_Origem_Componente.equals("4")) {
	x_Origem_ComponenteList += " selected";
}
x_Origem_ComponenteList += ">" + "Irrecuperavel" + "</option>";
x_Origem_ComponenteList += "</select>";
out.print(x_Origem_ComponenteList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Data de instalacao</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Data_instalacao" value="<%= EW_FormatDateTime(x_Data_instalacao,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Pick a Date" onClick="popUpCalendar(this, this.form.x_Data_instalacao,'dd/mm/yyyy');return false;"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Qtd instalada</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Qtd_instalacao" size="30" value="<%= HTMLEncode((String)x_Qtd_instalacao) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Detalhes da instalacao</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Detalhes_da_instalacao" cols="80" rows="4"><% if (x_Detalhes_da_instalacao!=null) out.print(x_Detalhes_da_instalacao); %></textarea><script language="JavaScript1.2">editor_generate('x_Detalhes_da_instalacao');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Tipo de instalacao</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="radio" name="x_Relacao_confianca"<% if (x_Relacao_confianca != null && ((String)x_Relacao_confianca).equals("1")) { out.print(" checked"); } %> value="<%= HTMLEncode("1") %>"><%= "Interna" %>
<input type="radio" name="x_Relacao_confianca"<% if (x_Relacao_confianca != null && ((String)x_Relacao_confianca).equals("2")) { out.print(" checked"); } %> value="<%= HTMLEncode("2") %>"><%= "Externa" %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Executor externo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Com_quem" size="50" maxlength="50" value="<%= HTMLEncode((String)x_Com_quem) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Telefone do executor</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Telefone_confianca" size="30" maxlength="50" value="<%= HTMLEncode((String)x_Telefone_confianca) %>"></span>&nbsp;</td>
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
<input type="submit" name="Action" value="Cadastrar">
</form>
<%@ include file="footer.jsp" %>
