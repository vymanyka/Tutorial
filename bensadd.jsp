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
if ((ewCurSec & ewAllowAdd) != ewAllowAdd) {
	response.sendRedirect("benslist.jsp"); 
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
Object x_id_Bem = null;
Object x_id_Marca = null;
Object x_id_Categoria = null;
Object x_id_Lotacoes = null;
Object x_Numero_de_serie = null;
Object x_Caracteristicas_do_bem = null;
Object x_Login = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("C")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `bens` WHERE `id_Bem`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()){
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("benslist.jsp");
			response.flushBuffer();
			return;
		}
		rs.first();

			// Get the field contents
	x_id_Bem = String.valueOf(rs.getLong("id_Bem"));
	x_id_Marca = String.valueOf(rs.getLong("id_Marca"));
	x_id_Categoria = String.valueOf(rs.getLong("id_Categoria"));
	x_id_Lotacoes = String.valueOf(rs.getLong("id_Lotacoes"));
	if (rs.getString("Numero_de_serie") != null){
		x_Numero_de_serie = rs.getString("Numero_de_serie");
	}else{
		x_Numero_de_serie = "";
	}
	if (rs.getClob("Caracteristicas_do_bem") != null) {
		long length = rs.getClob("Caracteristicas_do_bem").length();
		x_Caracteristicas_do_bem = rs.getClob("Caracteristicas_do_bem").getSubString((long) 1, (int) length);
	}else{
		x_Caracteristicas_do_bem = "";
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
		if (request.getParameter("x_id_Bem") != null){
			x_id_Bem = (String) request.getParameter("x_id_Bem");
		}else{
			x_id_Bem = "";
		}
		if (request.getParameter("x_id_Marca") != null){
			x_id_Marca = request.getParameter("x_id_Marca");
		}
		if (request.getParameter("x_id_Categoria") != null){
			x_id_Categoria = request.getParameter("x_id_Categoria");
		}
		if (request.getParameter("x_id_Lotacoes") != null){
			x_id_Lotacoes = request.getParameter("x_id_Lotacoes");
		}
		if (request.getParameter("x_Numero_de_serie") != null){
			x_Numero_de_serie = (String) request.getParameter("x_Numero_de_serie");
		}else{
			x_Numero_de_serie = "";
		}
		if (request.getParameter("x_Caracteristicas_do_bem") != null){
			x_Caracteristicas_do_bem = (String) request.getParameter("x_Caracteristicas_do_bem");
		}else{
			x_Caracteristicas_do_bem = "";
		}
		if (request.getParameter("x_Login") != null){
			x_Login = (String) request.getParameter("x_Login");
		}else{
			x_Login = "";
		}

		// Open record
		String strsql = "SELECT * FROM `bens` WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field id_Bem
		tmpfld = ((String) x_id_Bem).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("id_Bem");
		} else {
		String srchfld = tmpfld;
			srchfld = srchfld.replaceAll("'","\\\\'");
			strsql = "SELECT * FROM `bens` WHERE `id_Bem` = " + srchfld;
			Statement stmtchk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rschk = stmtchk.executeQuery(strsql);
			if (rschk.next()) {
				out.print("Duplicar chave para id_Bem, valor = " + tmpfld + "<br>");
				out.print("Pressione [PageUp] para continuar!");
				return;
			}
			rschk.close();
			rschk = null;
			rs.updateInt("id_Bem",Integer.parseInt(tmpfld));
		}

		// Field id_Marca
		tmpfld = ((String) x_id_Marca).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("id_Marca");
		} else {
			rs.updateInt("id_Marca",Integer.parseInt(tmpfld));
		}

		// Field id_Categoria
		tmpfld = ((String) x_id_Categoria).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("id_Categoria");
		} else {
			rs.updateInt("id_Categoria",Integer.parseInt(tmpfld));
		}

		// Field id_Lotacoes
		tmpfld = ((String) x_id_Lotacoes).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("id_Lotacoes");
		} else {
			rs.updateInt("id_Lotacoes",Integer.parseInt(tmpfld));
		}

		// Field Numero_de_serie
		tmpfld = ((String) x_Numero_de_serie);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Numero_de_serie");
		}else{
			rs.updateString("Numero_de_serie", tmpfld);
		}

		// Field Caracteristicas_do_bem
		tmpfld = ((String) x_Caracteristicas_do_bem);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Caracteristicas_do_bem");
		}else{
			rs.updateString("Caracteristicas_do_bem", tmpfld);
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
		response.sendRedirect("benslist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Adicionar TABELA: Bens<br><br><a href="benslist.jsp">Voltar a lista</a></span></p>
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
if (EW_this.x_id_Bem && !EW_hasValue(EW_this.x_id_Bem, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_id_Bem, "TEXT", "Informe o numero do tombamento!"))
                return false; 
        }
if (EW_this.x_id_Bem && !EW_checkinteger(EW_this.x_id_Bem.value)) {
        if (!EW_onError(EW_this, EW_this.x_id_Bem, "TEXT", "Informe o numero do tombamento!"))
            return false; 
        }
if (EW_this.x_id_Marca && !EW_hasValue(EW_this.x_id_Marca, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_id_Marca, "SELECT", "Forneca a marca do bem!"))
                return false; 
        }
if (EW_this.x_id_Categoria && !EW_hasValue(EW_this.x_id_Categoria, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_id_Categoria, "SELECT", "Forneca a categoria!"))
                return false; 
        }
if (EW_this.x_id_Lotacoes && !EW_hasValue(EW_this.x_id_Lotacoes, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_id_Lotacoes, "SELECT", "Forneca a categoria!"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="bensadd.jsp" method="post">
<p>
<input type="hidden" name="a" value="A">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Tombamento</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_id_Bem" size="30" value="<%= HTMLEncode((String)x_id_Bem) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Marca</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Marca_js = "";
String x_id_MarcaList = "<select name=\"x_id_Marca\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Marca = "SELECT `id_Marca`, `Marca` FROM `marcas`" + " ORDER BY `Marca` ASC";
Statement stmtwrk_x_id_Marca = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Marca = stmtwrk_x_id_Marca.executeQuery(sqlwrk_x_id_Marca);
	int rowcntwrk_x_id_Marca = 0;
	while (rswrk_x_id_Marca.next()) {
		x_id_MarcaList += "<option value=\"" + HTMLEncode(rswrk_x_id_Marca.getString("id_Marca")) + "\"";
		if (rswrk_x_id_Marca.getString("id_Marca").equals(x_id_Marca)) {
			x_id_MarcaList += " selected";
		}
		String tmpValue_x_id_Marca = "";
		if (rswrk_x_id_Marca.getString("Marca")!= null) tmpValue_x_id_Marca = rswrk_x_id_Marca.getString("Marca");
		x_id_MarcaList += ">" + tmpValue_x_id_Marca
 + "</option>";
		rowcntwrk_x_id_Marca++;
	}
rswrk_x_id_Marca.close();
rswrk_x_id_Marca = null;
stmtwrk_x_id_Marca.close();
stmtwrk_x_id_Marca = null;
x_id_MarcaList += "</select>";
out.println(x_id_MarcaList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria</span>&nbsp;</td>
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
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Lotacao atual</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Lotacoes_js = "";
String x_id_LotacoesList = "<select name=\"x_id_Lotacoes\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Lotacoes = "SELECT `id_Lotacoes`, `Descricao_da_lotacao` FROM `lotacoes`" + " ORDER BY `Descricao_da_lotacao` ASC";
Statement stmtwrk_x_id_Lotacoes = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Lotacoes = stmtwrk_x_id_Lotacoes.executeQuery(sqlwrk_x_id_Lotacoes);
	int rowcntwrk_x_id_Lotacoes = 0;
	while (rswrk_x_id_Lotacoes.next()) {
		x_id_LotacoesList += "<option value=\"" + HTMLEncode(rswrk_x_id_Lotacoes.getString("id_Lotacoes")) + "\"";
		if (rswrk_x_id_Lotacoes.getString("id_Lotacoes").equals(x_id_Lotacoes)) {
			x_id_LotacoesList += " selected";
		}
		String tmpValue_x_id_Lotacoes = "";
		if (rswrk_x_id_Lotacoes.getString("Descricao_da_lotacao")!= null) tmpValue_x_id_Lotacoes = rswrk_x_id_Lotacoes.getString("Descricao_da_lotacao");
		x_id_LotacoesList += ">" + tmpValue_x_id_Lotacoes
 + "</option>";
		rowcntwrk_x_id_Lotacoes++;
	}
rswrk_x_id_Lotacoes.close();
rswrk_x_id_Lotacoes = null;
stmtwrk_x_id_Lotacoes.close();
stmtwrk_x_id_Lotacoes = null;
x_id_LotacoesList += "</select>";
out.println(x_id_LotacoesList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Numero de serie</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Numero_de_serie" size="50" maxlength="50" value="<%= HTMLEncode((String)x_Numero_de_serie) %>"></span>&nbsp;</td>
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
