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
	response.sendRedirect("sub_categoria_4list.jsp"); 
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
	response.sendRedirect("sub_categoria_4list.jsp");
	response.flushBuffer();
	return;
}

// Get action
String a = request.getParameter("a");
if (a == null || a.length() == 0) {
	a = "I";	// Display with input box
}

// Get fields from form
Object x_id_Quatro = null;
Object x_Descricao_da_categoria = null;
Object x_Login = null;

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `sub_categoria_4` WHERE `id_Quatro`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("sub_categoria_4list.jsp");
			response.flushBuffer();
			return;
		}else{
			rs.first();

			// Get the field contents
	x_id_Quatro = String.valueOf(rs.getLong("id_Quatro"));
			if (rs.getString("Descricao_da_categoria") != null){
				x_Descricao_da_categoria = rs.getString("Descricao_da_categoria");
			}else{
				x_Descricao_da_categoria = "";
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
		if (request.getParameter("x_Descricao_da_categoria") != null){
			x_Descricao_da_categoria = (String) request.getParameter("x_Descricao_da_categoria");
		}else{
			x_Descricao_da_categoria = "";
		}
		if (request.getParameter("x_Login") != null){
			x_Login = (String) request.getParameter("x_Login");
		}else{
			x_Login = "";
		}

		// Open record
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `sub_categoria_4` WHERE `id_Quatro`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("sub_categoria_4list.jsp");
			response.flushBuffer();
			return;
		}

		// Field Descricao_da_categoria
		tmpfld = ((String) x_Descricao_da_categoria);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("Descricao_da_categoria");
		}else{
			rs.updateString("Descricao_da_categoria", tmpfld);
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
		response.sendRedirect("sub_categoria_4list.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
		out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Editar TABELA: Cat.5<br><br><a href="sub_categoria_4list.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_Descricao_da_categoria && !EW_hasValue(EW_this.x_Descricao_da_categoria, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_Descricao_da_categoria, "TEXT", "Forneca a descricao da categoria!"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="sub_categoria_4edit" action="sub_categoria_4edit.jsp" method="post">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_id_Quatro); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Descricao da categoria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Descricao_da_categoria" size="70" maxlength="50" value="<%= HTMLEncode((String)x_Descricao_da_categoria) %>"></span>&nbsp;</td>
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
