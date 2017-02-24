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
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
int displayRecs = 20;
int recRange = 10;
%>
<%
String tmpfld = null;
String escapeString = "\\\\'";
String dbwhere = "";
String masterdetailwhere = "";
String searchwhere = "";
String a_search = "";
String b_search = "";
String whereClause = "";
int startRec = 0, stopRec = 0, totalRecs = 0, recCount = 0;
%>
<%

// Get search criteria for advanced search
// idPedido_Compra

String ascrh_x_idPedido_Compra = request.getParameter("x_idPedido_Compra");
String z_idPedido_Compra = request.getParameter("z_idPedido_Compra");
	if (z_idPedido_Compra != null && z_idPedido_Compra.length() > 0 ) {
		String [] arrfieldopr_x_idPedido_Compra = z_idPedido_Compra.split(",");
		if (ascrh_x_idPedido_Compra != null && ascrh_x_idPedido_Compra.length() > 0) {
			ascrh_x_idPedido_Compra = ascrh_x_idPedido_Compra.replaceAll("'",escapeString);
			ascrh_x_idPedido_Compra = ascrh_x_idPedido_Compra.replaceAll("\\[","[[]");
			a_search += "`idPedido_Compra` "; // Add field
			a_search += arrfieldopr_x_idPedido_Compra[0].trim() + " "; // Add operator
			if (arrfieldopr_x_idPedido_Compra.length >= 2) {
				a_search += arrfieldopr_x_idPedido_Compra[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_idPedido_Compra; // Add input parameter
			if (arrfieldopr_x_idPedido_Compra.length >= 3) {
				a_search += arrfieldopr_x_idPedido_Compra[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Numero_Pedido
String ascrh_x_Numero_Pedido = request.getParameter("x_Numero_Pedido");
String z_Numero_Pedido = request.getParameter("z_Numero_Pedido");
	if (z_Numero_Pedido != null && z_Numero_Pedido.length() > 0 ) {
		String [] arrfieldopr_x_Numero_Pedido = z_Numero_Pedido.split(",");
		if (ascrh_x_Numero_Pedido != null && ascrh_x_Numero_Pedido.length() > 0) {
			ascrh_x_Numero_Pedido = ascrh_x_Numero_Pedido.replaceAll("'",escapeString);
			ascrh_x_Numero_Pedido = ascrh_x_Numero_Pedido.replaceAll("\\[","[[]");
			a_search += "`Numero_Pedido` "; // Add field
			a_search += arrfieldopr_x_Numero_Pedido[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Numero_Pedido.length >= 2) {
				a_search += arrfieldopr_x_Numero_Pedido[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Numero_Pedido; // Add input parameter
			if (arrfieldopr_x_Numero_Pedido.length >= 3) {
				a_search += arrfieldopr_x_Numero_Pedido[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Observacao
String ascrh_x_Observacao = request.getParameter("x_Observacao");
String z_Observacao = request.getParameter("z_Observacao");
	if (z_Observacao != null && z_Observacao.length() > 0 ) {
		String [] arrfieldopr_x_Observacao = z_Observacao.split(",");
		if (ascrh_x_Observacao != null && ascrh_x_Observacao.length() > 0) {
			ascrh_x_Observacao = ascrh_x_Observacao.replaceAll("'",escapeString);
			ascrh_x_Observacao = ascrh_x_Observacao.replaceAll("\\[","[[]");
			a_search += "`Observacao` "; // Add field
			a_search += arrfieldopr_x_Observacao[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Observacao.length >= 2) {
				a_search += arrfieldopr_x_Observacao[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Observacao; // Add input parameter
			if (arrfieldopr_x_Observacao.length >= 3) {
				a_search += arrfieldopr_x_Observacao[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Tipo_de_Compra
String ascrh_x_Tipo_de_Compra = request.getParameter("x_Tipo_de_Compra");
String z_Tipo_de_Compra = request.getParameter("z_Tipo_de_Compra");
	if (z_Tipo_de_Compra != null && z_Tipo_de_Compra.length() > 0 ) {
		String [] arrfieldopr_x_Tipo_de_Compra = z_Tipo_de_Compra.split(",");
		if (ascrh_x_Tipo_de_Compra != null && ascrh_x_Tipo_de_Compra.length() > 0) {
			ascrh_x_Tipo_de_Compra = ascrh_x_Tipo_de_Compra.replaceAll("'",escapeString);
			ascrh_x_Tipo_de_Compra = ascrh_x_Tipo_de_Compra.replaceAll("\\[","[[]");
			a_search += "`Tipo_de_Compra` "; // Add field
			a_search += arrfieldopr_x_Tipo_de_Compra[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Tipo_de_Compra.length >= 2) {
				a_search += arrfieldopr_x_Tipo_de_Compra[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Tipo_de_Compra; // Add input parameter
			if (arrfieldopr_x_Tipo_de_Compra.length >= 3) {
				a_search += arrfieldopr_x_Tipo_de_Compra[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Login
String ascrh_x_Login = request.getParameter("x_Login");
String z_Login = request.getParameter("z_Login");
	if (z_Login != null && z_Login.length() > 0 ) {
		String [] arrfieldopr_x_Login = z_Login.split(",");
		if (ascrh_x_Login != null && ascrh_x_Login.length() > 0) {
			ascrh_x_Login = ascrh_x_Login.replaceAll("'",escapeString);
			ascrh_x_Login = ascrh_x_Login.replaceAll("\\[","[[]");
			a_search += "`Login` "; // Add field
			a_search += arrfieldopr_x_Login[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Login.length >= 2) {
				a_search += arrfieldopr_x_Login[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Login; // Add input parameter
			if (arrfieldopr_x_Login.length >= 3) {
				a_search += arrfieldopr_x_Login[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}
	if (a_search.length() > 4) {
		a_search = a_search.substring(0, a_search.length()-4);
	}
%>
<%

// Get search criteria for basic search
String pSearch = request.getParameter("psearch");
String pSearchType = request.getParameter("psearchtype");
if (pSearch != null && pSearch.length() > 0) {
	pSearch = pSearch.replaceAll("'",escapeString);
	if (pSearchType != null && pSearchType.length() > 0) {
		while (pSearch.indexOf("  ") > 0) {
			pSearch = pSearch.replaceAll("  ", " ");
		}
		String [] arpSearch = pSearch.trim().split(" ");
		for (int i = 0; i < arpSearch.length; i++){
			String kw = arpSearch[i].trim();
			b_search = b_search + "(";
			b_search = b_search + "`Numero_Pedido` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Observacao` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Login` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`Numero_Pedido` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Observacao` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Login` LIKE '%" + pSearch + "%' OR ";
	}
}
if (b_search.length() > 4 && b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) {b_search = b_search.substring(0, b_search.length()-4);}
if (b_search.length() > 5 && b_search.substring(b_search.length()-5,b_search.length()).equals(" AND ")) {b_search = b_search.substring(0, b_search.length()-5);}
%>
<%

// Build search criteria
if (a_search != null && a_search.length() > 0) {
	searchwhere = a_search; // Advanced search
}else if (b_search != null && b_search.length() > 0) {
	searchwhere = b_search; // Basic search
}

// Save search criteria
if (searchwhere != null && searchwhere.length() > 0) {
	session.setAttribute("pedido_compra_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("pedido_compra_REC", new Integer(startRec));
}else{
	if (session.getAttribute("pedido_compra_searchwhere") != null)
		searchwhere = (String) session.getAttribute("pedido_compra_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("pedido_compra_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("pedido_compra_searchwhere", searchwhere);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("pedido_compra_REC", new Integer(startRec));
}

// Build dbwhere
if (masterdetailwhere != null && masterdetailwhere.length() > 0) {
	dbwhere = dbwhere + "(" + masterdetailwhere + ") AND ";
}
if (searchwhere != null && searchwhere.length() > 0) {
	dbwhere = dbwhere + "(" + searchwhere + ") AND ";
}
if (dbwhere != null && dbwhere.length() > 5) {
	dbwhere = dbwhere.substring(0, dbwhere.length()-5); // Trim rightmost AND
}
%>
<%

// Load Default Order
String DefaultOrder = "";
String DefaultOrderType = "";

// No Default Filter
String DefaultFilter = "";

// Check for an Order parameter
String OrderBy = request.getParameter("order");
if (OrderBy != null && OrderBy.length() > 0) {
	if (session.getAttribute("pedido_compra_OB") != null &&
		((String) session.getAttribute("pedido_compra_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("pedido_compra_OT")).equals("ASC")) {
			session.setAttribute("pedido_compra_OT", "DESC");
		}else{
			session.setAttribute("pedido_compra_OT", "ASC");
		}
	}else{
		session.setAttribute("pedido_compra_OT", "ASC");
	}
	session.setAttribute("pedido_compra_OB", OrderBy);
	session.setAttribute("pedido_compra_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("pedido_compra_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("pedido_compra_OB", OrderBy);
		session.setAttribute("pedido_compra_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `pedido_compra`";
whereClause = "";
if (DefaultFilter.length() > 0) {
	whereClause = whereClause + "(" + DefaultFilter + ") AND ";
}
if (dbwhere.length() > 0) {
	whereClause = whereClause + "(" + dbwhere + ") AND ";
}
if ((ewCurSec & ewAllowList) != ewAllowList) {
	whereClause = whereClause + "(0=1) AND ";
}
if (whereClause.length() > 5 && whereClause.substring(whereClause.length()-5, whereClause.length()).equals(" AND ")) {
	whereClause = whereClause.substring(0, whereClause.length()-5);
}
if (whereClause.length() > 0) {
	strsql = strsql + " WHERE " + whereClause;
}
if (OrderBy != null && OrderBy.length() > 0) {
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("pedido_compra_OT");
}

//out.println(strsql);
rs = stmt.executeQuery(strsql);
rs.last();
totalRecs = rs.getRow();
rs.beforeFirst();
startRec = 0;
int pageno = 0;

// Check for a START parameter
if (request.getParameter("start") != null && Integer.parseInt(request.getParameter("start")) > 0) {
	startRec = Integer.parseInt(request.getParameter("start"));
	session.setAttribute("pedido_compra_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("pedido_compra_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("pedido_compra_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("pedido_compra_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("pedido_compra_REC") != null)
		startRec = ((Integer) session.getAttribute("pedido_compra_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("pedido_compra_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">TABELA: Pedidos de compra</span></p>
<form action="pedido_compralist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Procura rapida (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="OK">
		&nbsp;&nbsp;<a href="pedido_compralist.jsp?cmd=reset">Mostrar todos</a>
		&nbsp;&nbsp;<a href="pedido_comprasrch.jsp">Busca avancada</a>
		</span></td>
	</tr>
	<tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Frase exata&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">Todas as palavras&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Qualquer palavra</span></td></tr>
</table>
</form>
<form method="post">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="pedido_compralist.jsp?order=<%= java.net.URLEncoder.encode("Numero_Pedido","UTF-8") %>" style="color: #FFFFFF;">Numero do Pedido&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Numero_Pedido")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("pedido_compra_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("pedido_compra_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Observacao&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Observacao")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("pedido_compra_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("pedido_compra_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="pedido_compralist.jsp?order=<%= java.net.URLEncoder.encode("Tipo_de_Compra","UTF-8") %>" style="color: #FFFFFF;">Tipo de Compra&nbsp;<% if (OrderBy != null && OrderBy.equals("Tipo_de_Compra")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("pedido_compra_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("pedido_compra_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td>&nbsp;</td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td>&nbsp;</td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td>&nbsp;</td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td>&nbsp;</td>
<% } %>
<td>&nbsp;</td>
</tr>
<%

// Avoid starting record > total records
if (startRec > totalRecs) {
	startRec = totalRecs;
}

// Set the last record to display
stopRec = startRec + displayRecs - 1;

// Move to first record directly for performance reason
recCount = startRec - 1;
if (rs.next()) {
	rs.first();
	rs.relative(startRec - 1);
}
long recActual = 0;
if (startRec == 1)
   rs.beforeFirst();
else
   rs.previous();
while (rs.next() && recCount < stopRec) {
	recCount++;
	if (recCount >= startRec) {
		recActual++;
%>
<%
	String bgcolor = "#FFFFFF"; // Set row color
%>
<%
	if (recCount%2 != 0) { // Display alternate color for rows
		bgcolor = "#F5F5F5";
	}
%>
<%
	String x_idPedido_Compra = "";
	String x_Numero_Pedido = "";
	String x_Observacao = "";
	String x_Tipo_de_Compra = "";
	String x_Login = "";

	// Load Key for record
	String key = "";

	// idPedido_Compra
	x_idPedido_Compra = String.valueOf(rs.getLong("idPedido_Compra"));

	// Numero_Pedido
	if (rs.getString("Numero_Pedido") != null){
		x_Numero_Pedido = rs.getString("Numero_Pedido");
	}else{
		x_Numero_Pedido = "";
	}

	// Observacao
	if (rs.getClob("Observacao") != null) {
		long length = rs.getClob("Observacao").length();
		x_Observacao = rs.getClob("Observacao").getSubString((long) 1, (int) length);
	}else{
		x_Observacao = "";
	}

	// Tipo_de_Compra
	x_Tipo_de_Compra = String.valueOf(rs.getLong("Tipo_de_Compra"));

	// Login
	if (rs.getString("Login") != null){
		x_Login = rs.getString("Login");
	}else{
		x_Login = "";
	}
%>
	<tr bgcolor="<%= bgcolor %>">
		<td><span class="jspmaker"><% out.print(x_Numero_Pedido); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% if (x_Observacao != null) { out.print(((String)x_Observacao).replaceAll("\r\n", "<br>"));} %></span>&nbsp;</td>
		<td><span class="jspmaker"><%
String tmpValuex_Tipo_de_Compra = (String) x_Tipo_de_Compra;
if (tmpValuex_Tipo_de_Compra.equals("1")) {
	out.print("Compra direta");
}
if (tmpValuex_Tipo_de_Compra.equals("2")) {
	out.print("Licitacao");
}
if (tmpValuex_Tipo_de_Compra.equals("3")) {
	out.print("Registro de precos");
}
if (tmpValuex_Tipo_de_Compra.equals("4")) {
	out.print("Pregao eletronico");
}
%>
</span>&nbsp;</td>
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("idPedido_Compra"); 
if (key != null && key.length() > 0) { 
	out.print("pedido_compraview.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Visualizar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("idPedido_Compra"); 
if (key != null && key.length() > 0) { 
	out.print("pedido_compraedit.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Editar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("idPedido_Compra"); 
if (key != null && key.length() > 0) { 
	out.print("pedido_compraadd.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Copiar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("idPedido_Compra"); 
if (key != null && key.length() > 0) { 
	out.print("pedido_compradelete.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Excluir</a></span></td>
<% } %>
<td><span class="jspmaker"><a href="compra_componenteslist.jsp?key_m=<%= x_idPedido_Compra %>">Compra de componentes Detalhes</a></span></td>
	</tr>
<%

//	}
}
}
%>
</table>
</form>
<%

// Close recordset and connection
rs.close();
rs = null;
stmt.close();
stmt = null;
conn.close();
conn = null;
}catch(SQLException ex){
	out.println(ex.toString());
}
%>
<table border="0" cellspacing="0" cellpadding="10"><tr><td>
<%
boolean rsEof = false;
if (totalRecs > 0) {
	rsEof = (totalRecs < (startRec + displayRecs));
	int PrevStart = startRec - displayRecs;
	if (PrevStart < 1) { PrevStart = 1;}
	int NextStart = startRec + displayRecs;
	if (NextStart > totalRecs) { NextStart = startRec;}
	int LastStart = ((totalRecs-1)/displayRecs)*displayRecs+1;
	%>
<form>
	<table border="0" cellspacing="0" cellpadding="0"><tr><td><span class="jspmaker">Pagina</span>&nbsp;</td>
<!--first page button-->
	<% if (startRec==1) { %>
	<td><img src="images/firstdisab.gif" alt="First" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="pedido_compralist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="pedido_compralist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="pedido_compralist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="pedido_compralist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
	<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<td><a href="pedido_compraadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a></td>
<% } %>
	<td><span class="jspmaker">&nbsp;de <%=(totalRecs-1)/displayRecs+1%></span></td>
	</td></tr></table>
</form>
	<% if (startRec > totalRecs) { startRec = totalRecs;}
	stopRec = startRec + displayRecs - 1;
	recCount = totalRecs - 1;
	if (rsEof) { recCount = totalRecs;}
	if (stopRec > recCount) { stopRec = recCount;} %>
	<span class="jspmaker">Registros <%= startRec %> para <%= stopRec %> de <%= totalRecs %></span>
<% }else{ %>
	<% if ((ewCurSec & ewAllowList) == ewAllowList) { %>
	<span class="jspmaker">Sem registros</span>
	<% }else{ %>
	<span class="jspmaker">Sem permissao</span>
	<% } %>
<p>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
<a href="pedido_compraadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
