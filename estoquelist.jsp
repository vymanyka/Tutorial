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

// Get the keys for master table
String key_m = request.getParameter("key_m");
if (key_m != null && key_m.length() > 0) {
	session.setAttribute("estoque_masterkey", key_m); // Save master key to session

	// Reset start record counter (new master key)
	startRec = 0;
	session.setAttribute("estoque_REC", new Integer(startRec));
} else {
	key_m = (String) session.getAttribute("estoque_masterkey"); // Restore master key from session
}
String masterdatailwhere;
if (key_m != null && key_m.length() > 0) {
	masterdetailwhere = "`id_Componente` = " + key_m.replaceAll("'",escapeString) + "";
}
%>
<%

// Get search criteria for advanced search
// id_Componente

String ascrh_x_id_Componente = request.getParameter("x_id_Componente");
String z_id_Componente = request.getParameter("z_id_Componente");
	if (z_id_Componente != null && z_id_Componente.length() > 0 ) {
		String [] arrfieldopr_x_id_Componente = z_id_Componente.split(",");
		if (ascrh_x_id_Componente != null && ascrh_x_id_Componente.length() > 0) {
			ascrh_x_id_Componente = ascrh_x_id_Componente.replaceAll("'",escapeString);
			ascrh_x_id_Componente = ascrh_x_id_Componente.replaceAll("\\[","[[]");
			a_search += "`id_Componente` "; // Add field
			a_search += arrfieldopr_x_id_Componente[0].trim() + " "; // Add operator
			if (arrfieldopr_x_id_Componente.length >= 2) {
				a_search += arrfieldopr_x_id_Componente[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_id_Componente; // Add input parameter
			if (arrfieldopr_x_id_Componente.length >= 3) {
				a_search += arrfieldopr_x_id_Componente[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Qtd_novo
String ascrh_x_Qtd_novo = request.getParameter("x_Qtd_novo");
String z_Qtd_novo = request.getParameter("z_Qtd_novo");
	if (z_Qtd_novo != null && z_Qtd_novo.length() > 0 ) {
		String [] arrfieldopr_x_Qtd_novo = z_Qtd_novo.split(",");
		if (ascrh_x_Qtd_novo != null && ascrh_x_Qtd_novo.length() > 0) {
			ascrh_x_Qtd_novo = ascrh_x_Qtd_novo.replaceAll("'",escapeString);
			ascrh_x_Qtd_novo = ascrh_x_Qtd_novo.replaceAll("\\[","[[]");
			a_search += "`Qtd_novo` "; // Add field
			a_search += arrfieldopr_x_Qtd_novo[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Qtd_novo.length >= 2) {
				a_search += arrfieldopr_x_Qtd_novo[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Qtd_novo; // Add input parameter
			if (arrfieldopr_x_Qtd_novo.length >= 3) {
				a_search += arrfieldopr_x_Qtd_novo[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Qtd_seminovo
String ascrh_x_Qtd_seminovo = request.getParameter("x_Qtd_seminovo");
String z_Qtd_seminovo = request.getParameter("z_Qtd_seminovo");
	if (z_Qtd_seminovo != null && z_Qtd_seminovo.length() > 0 ) {
		String [] arrfieldopr_x_Qtd_seminovo = z_Qtd_seminovo.split(",");
		if (ascrh_x_Qtd_seminovo != null && ascrh_x_Qtd_seminovo.length() > 0) {
			ascrh_x_Qtd_seminovo = ascrh_x_Qtd_seminovo.replaceAll("'",escapeString);
			ascrh_x_Qtd_seminovo = ascrh_x_Qtd_seminovo.replaceAll("\\[","[[]");
			a_search += "`Qtd_seminovo` "; // Add field
			a_search += arrfieldopr_x_Qtd_seminovo[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Qtd_seminovo.length >= 2) {
				a_search += arrfieldopr_x_Qtd_seminovo[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Qtd_seminovo; // Add input parameter
			if (arrfieldopr_x_Qtd_seminovo.length >= 3) {
				a_search += arrfieldopr_x_Qtd_seminovo[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Qtd_recuperavel
String ascrh_x_Qtd_recuperavel = request.getParameter("x_Qtd_recuperavel");
String z_Qtd_recuperavel = request.getParameter("z_Qtd_recuperavel");
	if (z_Qtd_recuperavel != null && z_Qtd_recuperavel.length() > 0 ) {
		String [] arrfieldopr_x_Qtd_recuperavel = z_Qtd_recuperavel.split(",");
		if (ascrh_x_Qtd_recuperavel != null && ascrh_x_Qtd_recuperavel.length() > 0) {
			ascrh_x_Qtd_recuperavel = ascrh_x_Qtd_recuperavel.replaceAll("'",escapeString);
			ascrh_x_Qtd_recuperavel = ascrh_x_Qtd_recuperavel.replaceAll("\\[","[[]");
			a_search += "`Qtd_recuperavel` "; // Add field
			a_search += arrfieldopr_x_Qtd_recuperavel[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Qtd_recuperavel.length >= 2) {
				a_search += arrfieldopr_x_Qtd_recuperavel[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Qtd_recuperavel; // Add input parameter
			if (arrfieldopr_x_Qtd_recuperavel.length >= 3) {
				a_search += arrfieldopr_x_Qtd_recuperavel[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Qtd_irrecuperavel
String ascrh_x_Qtd_irrecuperavel = request.getParameter("x_Qtd_irrecuperavel");
String z_Qtd_irrecuperavel = request.getParameter("z_Qtd_irrecuperavel");
	if (z_Qtd_irrecuperavel != null && z_Qtd_irrecuperavel.length() > 0 ) {
		String [] arrfieldopr_x_Qtd_irrecuperavel = z_Qtd_irrecuperavel.split(",");
		if (ascrh_x_Qtd_irrecuperavel != null && ascrh_x_Qtd_irrecuperavel.length() > 0) {
			ascrh_x_Qtd_irrecuperavel = ascrh_x_Qtd_irrecuperavel.replaceAll("'",escapeString);
			ascrh_x_Qtd_irrecuperavel = ascrh_x_Qtd_irrecuperavel.replaceAll("\\[","[[]");
			a_search += "`Qtd_irrecuperavel` "; // Add field
			a_search += arrfieldopr_x_Qtd_irrecuperavel[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Qtd_irrecuperavel.length >= 2) {
				a_search += arrfieldopr_x_Qtd_irrecuperavel[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Qtd_irrecuperavel; // Add input parameter
			if (arrfieldopr_x_Qtd_irrecuperavel.length >= 3) {
				a_search += arrfieldopr_x_Qtd_irrecuperavel[2].trim(); // Add search suffix
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
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
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
	session.setAttribute("estoque_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("estoque_REC", new Integer(startRec));
}else{
	if (session.getAttribute("estoque_searchwhere") != null)
		searchwhere = (String) session.getAttribute("estoque_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("estoque_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("estoque_searchwhere", searchwhere);
    	key_m = "";
		session.setAttribute("estoque_masterkey", key_m); // Clear master key
    	masterdetailwhere = "";
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("estoque_REC", new Integer(startRec));
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
	if (session.getAttribute("estoque_OB") != null &&
		((String) session.getAttribute("estoque_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("estoque_OT")).equals("ASC")) {
			session.setAttribute("estoque_OT", "DESC");
		}else{
			session.setAttribute("estoque_OT", "ASC");
		}
	}else{
		session.setAttribute("estoque_OT", "ASC");
	}
	session.setAttribute("estoque_OB", OrderBy);
	session.setAttribute("estoque_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("estoque_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("estoque_OB", OrderBy);
		session.setAttribute("estoque_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `estoque`";
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("estoque_OT");
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
	session.setAttribute("estoque_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("estoque_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("estoque_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("estoque_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("estoque_REC") != null)
		startRec = ((Integer) session.getAttribute("estoque_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("estoque_REC", new Integer(startRec));
	}
}
%>
<%
ResultSet rsMas = null;
Statement stmtMas = null;
if (key_m != null && key_m.length() > 0) {
	String strmassql = "SELECT * FROM `componentes` WHERE ";
	strmassql = strmassql + "(`id_Componente` = " + key_m.replaceAll("'",escapeString)  + ")";
	stmtMas = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	rsMas = stmtMas.executeQuery(strmassql);
}
%>
<%@ include file="header.jsp" %>
<%
if (key_m != null && key_m.length() > 0) {
	if (rsMas.next()) { %>
	<p><span class="jspmaker">Registro Mestre: Componentes<br><a href="componenteslist.jsp">Voltar a lista</a></span></p>
	<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
		<tr bgcolor="#594FBF">
			<td><span class="jspmaker" style="color: #FFFFFF;">Descricao do componente</span>&nbsp;</td>
		</tr>
		<tr bgcolor="#FFFFFF">
<%

		// id_Componente
		String x_id_Componente = "";
		x_id_Componente = String.valueOf(rsMas.getLong("id_Componente"));

		// id_Categoria
		String x_id_Categoria = "";
		x_id_Categoria = String.valueOf(rsMas.getLong("id_Categoria"));

		// Descricao_do_componente
		String x_Descricao_do_componente = "";
		if (rsMas.getString("Descricao_do_componente") != null){
			x_Descricao_do_componente = rsMas.getString("Descricao_do_componente");
		}else{
			x_Descricao_do_componente = "";
		}

		// Qtd_minima
		String x_Qtd_minima = "";
		x_Qtd_minima = String.valueOf(rsMas.getLong("Qtd_minima"));

		// Login
		String x_Login = "";
		if (rsMas.getString("Login") != null){
			x_Login = rsMas.getString("Login");
		}else{
			x_Login = "";
		}
%>
			<td><span class="jspmaker"><% out.print(x_Descricao_do_componente); %></span>&nbsp;</td>
		</tr>
	</table>
	<br>
<%
	}
} %>
<%
if (key_m != null && key_m.length() > 0) {
	rsMas.close();
	rsMas = null;
	stmtMas.close();
	stmtMas = null;
}
%>
<p><span class="jspmaker">TABELA: Estoque</span></p>
<form action="estoquelist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Procura rapida (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="OK">
		&nbsp;&nbsp;<a href="estoquelist.jsp?cmd=reset">Mostrar todos</a>
		&nbsp;&nbsp;<a href="estoquesrch.jsp">Busca avancada</a>
		</span></td>
	</tr>
	<tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Frase exata&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">Todas as palavras&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Qualquer palavra</span></td></tr>
</table>
</form>
<form method="post">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="estoquelist.jsp?order=<%= java.net.URLEncoder.encode("Qtd_novo","UTF-8") %>" style="color: #FFFFFF;">Novo&nbsp;<% if (OrderBy != null && OrderBy.equals("Qtd_novo")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("estoque_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("estoque_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="estoquelist.jsp?order=<%= java.net.URLEncoder.encode("Qtd_seminovo","UTF-8") %>" style="color: #FFFFFF;">Seminovo&nbsp;<% if (OrderBy != null && OrderBy.equals("Qtd_seminovo")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("estoque_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("estoque_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="estoquelist.jsp?order=<%= java.net.URLEncoder.encode("Qtd_recuperavel","UTF-8") %>" style="color: #FFFFFF;">Recuperavel&nbsp;<% if (OrderBy != null && OrderBy.equals("Qtd_recuperavel")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("estoque_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("estoque_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="estoquelist.jsp?order=<%= java.net.URLEncoder.encode("Qtd_irrecuperavel","UTF-8") %>" style="color: #FFFFFF;">Irrecuperavel&nbsp;<% if (OrderBy != null && OrderBy.equals("Qtd_irrecuperavel")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("estoque_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("estoque_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
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
	String x_id_Componente = "";
	String x_Qtd_novo = "";
	String x_Qtd_seminovo = "";
	String x_Qtd_recuperavel = "";
	String x_Qtd_irrecuperavel = "";

	// id_Componente
	x_id_Componente = String.valueOf(rs.getLong("id_Componente"));

	// Qtd_novo
	x_Qtd_novo = String.valueOf(rs.getLong("Qtd_novo"));

	// Qtd_seminovo
	x_Qtd_seminovo = String.valueOf(rs.getLong("Qtd_seminovo"));

	// Qtd_recuperavel
	x_Qtd_recuperavel = String.valueOf(rs.getLong("Qtd_recuperavel"));

	// Qtd_irrecuperavel
	x_Qtd_irrecuperavel = String.valueOf(rs.getLong("Qtd_irrecuperavel"));
%>
	<tr bgcolor="<%= bgcolor %>">
		<td><span class="jspmaker"><% out.print(x_Qtd_novo); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_Qtd_seminovo); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_Qtd_recuperavel); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_Qtd_irrecuperavel); %></span>&nbsp;</td>
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
	<td><a href="estoquelist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="estoquelist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="estoquelist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="estoquelist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
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
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
