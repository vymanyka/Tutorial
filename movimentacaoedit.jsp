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
ew_SecTable[0] = 10;
ew_SecTable[1] = 9;
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
	response.sendRedirect("movimentacaolist.jsp"); 
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
	response.sendRedirect("movimentacaolist.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_id_Movimentacao = null;
Object x_id_Bem = null;
Object x_Siga = null;
Object x_Data_Entrada = null;
Object x_Situacao = null;
Object x_Detalhes_da_Movimentacao = null;
Object x_Garantia = null;
Object x_Lotacao_Destino = null;
Object x_Resp_Transporte = null;
Object x_Login = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `movimentacao` WHERE `id_Movimentacao`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("movimentacaolist.jsp");
			response.flushBuffer();
			return;
		}else{
			rs.first();

			// Get the field contents
	x_id_Movimentacao = String.valueOf(rs.getLong("id_Movimentacao"));
	x_id_Bem = String.valueOf(rs.getLong("id_Bem"));
	x_Siga = String.valueOf(rs.getLong("Siga"));
			if (rs.getTimestamp("Data_Entrada") != null){
				x_Data_Entrada = rs.getTimestamp("Data_Entrada");
			}else{
				x_Data_Entrada = null;
			}
	x_Situacao = String.valueOf(rs.getLong("Situacao"));
			if (rs.getClob("Detalhes_da_Movimentacao") != null) {
				long length = rs.getClob("Detalhes_da_Movimentacao").length();
				x_Detalhes_da_Movimentacao = rs.getClob("Detalhes_da_Movimentacao").getSubString((long) 1, (int) length);
			}else{
				x_Detalhes_da_Movimentacao = "";
			}
	x_Garantia = String.valueOf(rs.getLong("Garantia"));
	x_Lotacao_Destino = String.valueOf(rs.getLong("Lotacao_Destino"));
			if (rs.getString("Resp_Transporte") != null){
				x_Resp_Transporte = rs.getString("Resp_Transporte");
			}else{
				x_Resp_Transporte = "";
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
		if (request.getParameter("x_id_Bem") != null){
			x_id_Bem = request.getParameter("x_id_Bem");
		}
		if (request.getParameter("x_Siga") != null){
			x_Siga = (String) request.getParameter("x_Siga");
		}else{
			x_Siga = "";
		}
		if (request.getParameter("x_Data_Entrada") != null){
			x_Data_Entrada = (String) request.getParameter("x_Data_Entrada");
		}else{
			x_Data_Entrada = "";
		}
		if (request.getParameter("x_Situacao") != null){
			x_Situacao = (String) request.getParameter("x_Situacao");
		}else{
			x_Situacao = "";
		}
		if (request.getParameter("x_Detalhes_da_Movimentacao") != null){
			x_Detalhes_da_Movimentacao = (String) request.getParameter("x_Detalhes_da_Movimentacao");
		}else{
			x_Detalhes_da_Movimentacao = "";
		}
		if (request.getParameter("x_Garantia") != null){
			x_Garantia = (String) request.getParameter("x_Garantia");
		}else{
			x_Garantia = "";
		}
		if (request.getParameter("x_Lotacao_Destino") != null){
			x_Lotacao_Destino = request.getParameter("x_Lotacao_Destino");
		}
		if (request.getParameter("x_Resp_Transporte") != null){
			x_Resp_Transporte = (String) request.getParameter("x_Resp_Transporte");
		}else{
			x_Resp_Transporte = "";
		}
		if (request.getParameter("x_Login") != null){
			x_Login = (String) request.getParameter("x_Login");
		}else{
			x_Login = "";
		}

		// Open record
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `movimentacao` WHERE `id_Movimentacao`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("movimentacaolist.jsp");
			response.flushBuffer();
			return;
		}

		// Field id_Bem
		tmpfld = ((String) x_id_Bem).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("id_Bem");
		} else {
			rs.updateInt("id_Bem",Integer.parseInt(tmpfld));
		}

		// Field Siga
		tmpfld = ((String) x_Siga).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("Siga");
		} else {
			rs.updateInt("Siga",Integer.parseInt(tmpfld));
		}

		// Field Data_Entrada
		if (IsDate((String) x_Data_Entrada,"EURODATE", locale)) {
			rs.updateTimestamp("Data_Entrada", EW_UnFormatDateTime((String)x_Data_Entrada,"EURODATE", locale));
		}else{
			rs.updateNull("Data_Entrada");
		}

		// Field Situacao
		tmpfld = ((String) x_Situacao).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("Situacao");
		} else {
			rs.updateInt("Situacao",Integer.parseInt(tmpfld));
		}

		// Field Detalhes_da_Movimentacao
		tmpfld = ((String) x_Detalhes_da_Movimentacao);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Detalhes_da_Movimentacao");
		}else{
			rs.updateString("Detalhes_da_Movimentacao", tmpfld);
		}

		// Field Garantia
		tmpfld = ((String) x_Garantia).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("Garantia");
		} else {
			rs.updateInt("Garantia",Integer.parseInt(tmpfld));
		}

		// Field Lotacao_Destino
		tmpfld = ((String) x_Lotacao_Destino).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("Lotacao_Destino");
		} else {
			rs.updateInt("Lotacao_Destino",Integer.parseInt(tmpfld));
		}

		// Field Resp_Transporte
		tmpfld = ((String) x_Resp_Transporte);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Resp_Transporte");
		}else{
			rs.updateString("Resp_Transporte", tmpfld);
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
		response.sendRedirect("movimentacaolist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
		out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Editar TABELA: Livro de ocorrencias<br><br><a href="movimentacaolist.jsp">Voltar a lista</a></span></p>
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
if (EW_this.x_id_Bem && !EW_hasValue(EW_this.x_id_Bem, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_id_Bem, "SELECT", "Escolha o bem movimentado!"))
                return false; 
        }
if (EW_this.x_Siga && !EW_hasValue(EW_this.x_Siga, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_Siga, "TEXT", "Forneça o número SIGA!"))
                return false; 
        }
if (EW_this.x_Siga && !EW_checkinteger(EW_this.x_Siga.value)) {
        if (!EW_onError(EW_this, EW_this.x_Siga, "TEXT", "Forneça o número SIGA!"))
            return false; 
        }
if (EW_this.x_Data_Entrada && !EW_hasValue(EW_this.x_Data_Entrada, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_Data_Entrada, "TEXT", "Forneca a data da movimentacao!"))
                return false; 
        }
if (EW_this.x_Data_Entrada && !EW_checkeurodate(EW_this.x_Data_Entrada.value)) {
        if (!EW_onError(EW_this, EW_this.x_Data_Entrada, "TEXT", "Forneca a data da movimentacao!"))
            return false; 
        }
if (EW_this.x_Situacao && !EW_hasValue(EW_this.x_Situacao, "RADIO" )) {
            if (!EW_onError(EW_this, EW_this.x_Situacao, "RADIO", "Forneca a situacao do equipamento no momento da movimentacao!"))
                return false; 
        }
if (EW_this.x_Garantia && !EW_hasValue(EW_this.x_Garantia, "RADIO" )) {
            if (!EW_onError(EW_this, EW_this.x_Garantia, "RADIO", "Informe a situacao da garantia no momento da movimentacao do bem!"))
                return false; 
        }
if (EW_this.x_Lotacao_Destino && !EW_hasValue(EW_this.x_Lotacao_Destino, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_Lotacao_Destino, "SELECT", "Informe a lotacao de origem do bem!"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="movimentacaoedit" action="movimentacaoedit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_id_Movimentacao); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Tombamento</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% String tmp_x_id_Bem = (String) session.getAttribute("movimentacao_masterkey");
if (tmp_x_id_Bem != null && tmp_x_id_Bem.length() > 0) {
x_id_Bem = tmp_x_id_Bem; %>
<%
if (x_id_Bem!=null && ((String)x_id_Bem).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Bem;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Bem` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Bem` FROM `bens`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("id_Bem"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
<input type="hidden" name="x_id_Bem" value="<%= HTMLEncode((String)x_id_Bem) %>">
<% } else { %>
<%
String cbo_x_id_Bem_js = "";
String x_id_BemList = "<select name=\"x_id_Bem\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Bem = "SELECT `id_Bem` FROM `bens`" + " ORDER BY `id_Bem` ASC";
Statement stmtwrk_x_id_Bem = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Bem = stmtwrk_x_id_Bem.executeQuery(sqlwrk_x_id_Bem);
	int rowcntwrk_x_id_Bem = 0;
	while (rswrk_x_id_Bem.next()) {
		x_id_BemList += "<option value=\"" + HTMLEncode(rswrk_x_id_Bem.getString("id_Bem")) + "\"";
		if (rswrk_x_id_Bem.getString("id_Bem").equals(x_id_Bem)) {
			x_id_BemList += " selected";
		}
		String tmpValue_x_id_Bem = "";
		if (rswrk_x_id_Bem.getString("id_Bem")!= null) tmpValue_x_id_Bem = rswrk_x_id_Bem.getString("id_Bem");
		x_id_BemList += ">" + tmpValue_x_id_Bem
 + "</option>";
		rowcntwrk_x_id_Bem++;
	}
rswrk_x_id_Bem.close();
rswrk_x_id_Bem = null;
stmtwrk_x_id_Bem.close();
stmtwrk_x_id_Bem = null;
x_id_BemList += "</select>";
out.println(x_id_BemList);
%>
<% } %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Siga</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Siga" size="30" value="<%= HTMLEncode((String)x_Siga) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Data da ocorrencia</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Data_Entrada" value="<%= EW_FormatDateTime(x_Data_Entrada,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Pick a Date" onClick="popUpCalendar(this, this.form.x_Data_Entrada,'dd/mm/yyyy');return false;"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Situacao</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="radio" name="x_Situacao"<% if (x_Situacao != null && ((String)x_Situacao).equals("1")) { out.print(" checked"); } %> value="<%= HTMLEncode("1") %>"><%= "Bom" %>
<input type="radio" name="x_Situacao"<% if (x_Situacao != null && ((String)x_Situacao).equals("2")) { out.print(" checked"); } %> value="<%= HTMLEncode("2") %>"><%= "Danificado" %>
<input type="radio" name="x_Situacao"<% if (x_Situacao != null && ((String)x_Situacao).equals("3")) { out.print(" checked"); } %> value="<%= HTMLEncode("3") %>"><%= "Anti-economico" %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Detalhes da ocorrencia</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Detalhes_da_Movimentacao" cols="80" rows="4"><% if (x_Detalhes_da_Movimentacao!=null) out.print(x_Detalhes_da_Movimentacao); %></textarea><script language="JavaScript1.2">editor_generate('x_Detalhes_da_Movimentacao');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Garantia</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="radio" name="x_Garantia"<% if (x_Garantia != null && ((String)x_Garantia).equals("1")) { out.print(" checked"); } %> value="<%= HTMLEncode("1") %>"><%= "Na garantia" %>
<input type="radio" name="x_Garantia"<% if (x_Garantia != null && ((String)x_Garantia).equals("2")) { out.print(" checked"); } %> value="<%= HTMLEncode("2") %>"><%= "Fora da garantia" %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Lotacao de destino</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_Lotacao_Destino_js = "";
String x_Lotacao_DestinoList = "<select name=\"x_Lotacao_Destino\"><option value=\"\">Selecione</option>";
String sqlwrk_x_Lotacao_Destino = "SELECT `id_Lotacoes`, `Descricao_da_lotacao` FROM `lotacoes`" + " ORDER BY `Descricao_da_lotacao` ASC";
Statement stmtwrk_x_Lotacao_Destino = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_Lotacao_Destino = stmtwrk_x_Lotacao_Destino.executeQuery(sqlwrk_x_Lotacao_Destino);
	int rowcntwrk_x_Lotacao_Destino = 0;
	while (rswrk_x_Lotacao_Destino.next()) {
		x_Lotacao_DestinoList += "<option value=\"" + HTMLEncode(rswrk_x_Lotacao_Destino.getString("id_Lotacoes")) + "\"";
		if (rswrk_x_Lotacao_Destino.getString("id_Lotacoes").equals(x_Lotacao_Destino)) {
			x_Lotacao_DestinoList += " selected";
		}
		String tmpValue_x_Lotacao_Destino = "";
		if (rswrk_x_Lotacao_Destino.getString("Descricao_da_lotacao")!= null) tmpValue_x_Lotacao_Destino = rswrk_x_Lotacao_Destino.getString("Descricao_da_lotacao");
		x_Lotacao_DestinoList += ">" + tmpValue_x_Lotacao_Destino
 + "</option>";
		rowcntwrk_x_Lotacao_Destino++;
	}
rswrk_x_Lotacao_Destino.close();
rswrk_x_Lotacao_Destino = null;
stmtwrk_x_Lotacao_Destino.close();
stmtwrk_x_Lotacao_Destino = null;
x_Lotacao_DestinoList += "</select>";
out.println(x_Lotacao_DestinoList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Quem movimentou?</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Resp_Transporte" size="40" maxlength="20" value="<%= HTMLEncode((String)x_Resp_Transporte) %>"></span>&nbsp;</td>
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
