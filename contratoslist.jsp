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
// id_Contrato

String ascrh_x_id_Contrato = request.getParameter("x_id_Contrato");
String z_id_Contrato = request.getParameter("z_id_Contrato");
	if (z_id_Contrato != null && z_id_Contrato.length() > 0 ) {
		String [] arrfieldopr_x_id_Contrato = z_id_Contrato.split(",");
		if (ascrh_x_id_Contrato != null && ascrh_x_id_Contrato.length() > 0) {
			ascrh_x_id_Contrato = ascrh_x_id_Contrato.replaceAll("'",escapeString);
			ascrh_x_id_Contrato = ascrh_x_id_Contrato.replaceAll("\\[","[[]");
			a_search += "`id_Contrato` "; // Add field
			a_search += arrfieldopr_x_id_Contrato[0].trim() + " "; // Add operator
			if (arrfieldopr_x_id_Contrato.length >= 2) {
				a_search += arrfieldopr_x_id_Contrato[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_id_Contrato; // Add input parameter
			if (arrfieldopr_x_id_Contrato.length >= 3) {
				a_search += arrfieldopr_x_id_Contrato[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Contrato
String ascrh_x_Contrato = request.getParameter("x_Contrato");
String z_Contrato = request.getParameter("z_Contrato");
	if (z_Contrato != null && z_Contrato.length() > 0 ) {
		String [] arrfieldopr_x_Contrato = z_Contrato.split(",");
		if (ascrh_x_Contrato != null && ascrh_x_Contrato.length() > 0) {
			ascrh_x_Contrato = ascrh_x_Contrato.replaceAll("'",escapeString);
			ascrh_x_Contrato = ascrh_x_Contrato.replaceAll("\\[","[[]");
			a_search += "`Contrato` "; // Add field
			a_search += arrfieldopr_x_Contrato[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Contrato.length >= 2) {
				a_search += arrfieldopr_x_Contrato[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Contrato; // Add input parameter
			if (arrfieldopr_x_Contrato.length >= 3) {
				a_search += arrfieldopr_x_Contrato[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Empresa
String ascrh_x_Empresa = request.getParameter("x_Empresa");
String z_Empresa = request.getParameter("z_Empresa");
	if (z_Empresa != null && z_Empresa.length() > 0 ) {
		String [] arrfieldopr_x_Empresa = z_Empresa.split(",");
		if (ascrh_x_Empresa != null && ascrh_x_Empresa.length() > 0) {
			ascrh_x_Empresa = ascrh_x_Empresa.replaceAll("'",escapeString);
			ascrh_x_Empresa = ascrh_x_Empresa.replaceAll("\\[","[[]");
			a_search += "`Empresa` "; // Add field
			a_search += arrfieldopr_x_Empresa[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Empresa.length >= 2) {
				a_search += arrfieldopr_x_Empresa[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Empresa; // Add input parameter
			if (arrfieldopr_x_Empresa.length >= 3) {
				a_search += arrfieldopr_x_Empresa[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Vigencia
String ascrh_x_Vigencia = request.getParameter("x_Vigencia");
String z_Vigencia = request.getParameter("z_Vigencia");
	if (z_Vigencia != null && z_Vigencia.length() > 0 ) {
		String [] arrfieldopr_x_Vigencia = z_Vigencia.split(",");
		if (ascrh_x_Vigencia != null && ascrh_x_Vigencia.length() > 0) {
			ascrh_x_Vigencia = ascrh_x_Vigencia.replaceAll("'",escapeString);
			ascrh_x_Vigencia = ascrh_x_Vigencia.replaceAll("\\[","[[]");
			a_search += "`Vigencia` "; // Add field
			a_search += arrfieldopr_x_Vigencia[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Vigencia.length >= 2) {
				a_search += arrfieldopr_x_Vigencia[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Vigencia; // Add input parameter
			if (arrfieldopr_x_Vigencia.length >= 3) {
				a_search += arrfieldopr_x_Vigencia[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Horario_atend
String ascrh_x_Horario_atend = request.getParameter("x_Horario_atend");
String z_Horario_atend = request.getParameter("z_Horario_atend");
	if (z_Horario_atend != null && z_Horario_atend.length() > 0 ) {
		String [] arrfieldopr_x_Horario_atend = z_Horario_atend.split(",");
		if (ascrh_x_Horario_atend != null && ascrh_x_Horario_atend.length() > 0) {
			ascrh_x_Horario_atend = ascrh_x_Horario_atend.replaceAll("'",escapeString);
			ascrh_x_Horario_atend = ascrh_x_Horario_atend.replaceAll("\\[","[[]");
			a_search += "`Horario_atend` "; // Add field
			a_search += arrfieldopr_x_Horario_atend[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Horario_atend.length >= 2) {
				a_search += arrfieldopr_x_Horario_atend[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Horario_atend; // Add input parameter
			if (arrfieldopr_x_Horario_atend.length >= 3) {
				a_search += arrfieldopr_x_Horario_atend[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Primeiro_atend
String ascrh_x_Primeiro_atend = request.getParameter("x_Primeiro_atend");
String z_Primeiro_atend = request.getParameter("z_Primeiro_atend");
	if (z_Primeiro_atend != null && z_Primeiro_atend.length() > 0 ) {
		String [] arrfieldopr_x_Primeiro_atend = z_Primeiro_atend.split(",");
		if (ascrh_x_Primeiro_atend != null && ascrh_x_Primeiro_atend.length() > 0) {
			ascrh_x_Primeiro_atend = ascrh_x_Primeiro_atend.replaceAll("'",escapeString);
			ascrh_x_Primeiro_atend = ascrh_x_Primeiro_atend.replaceAll("\\[","[[]");
			a_search += "`Primeiro_atend` "; // Add field
			a_search += arrfieldopr_x_Primeiro_atend[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Primeiro_atend.length >= 2) {
				a_search += arrfieldopr_x_Primeiro_atend[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Primeiro_atend; // Add input parameter
			if (arrfieldopr_x_Primeiro_atend.length >= 3) {
				a_search += arrfieldopr_x_Primeiro_atend[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Solucao
String ascrh_x_Solucao = request.getParameter("x_Solucao");
String z_Solucao = request.getParameter("z_Solucao");
	if (z_Solucao != null && z_Solucao.length() > 0 ) {
		String [] arrfieldopr_x_Solucao = z_Solucao.split(",");
		if (ascrh_x_Solucao != null && ascrh_x_Solucao.length() > 0) {
			ascrh_x_Solucao = ascrh_x_Solucao.replaceAll("'",escapeString);
			ascrh_x_Solucao = ascrh_x_Solucao.replaceAll("\\[","[[]");
			a_search += "`Solucao` "; // Add field
			a_search += arrfieldopr_x_Solucao[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Solucao.length >= 2) {
				a_search += arrfieldopr_x_Solucao[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Solucao; // Add input parameter
			if (arrfieldopr_x_Solucao.length >= 3) {
				a_search += arrfieldopr_x_Solucao[2].trim(); // Add search suffix
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
			b_search = b_search + "`Contrato` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Empresa` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Vigencia` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Horario_atend` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Primeiro_atend` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Solucao` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Login` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`Contrato` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Empresa` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Vigencia` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Horario_atend` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Primeiro_atend` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Solucao` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("contratos_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("contratos_REC", new Integer(startRec));
}else{
	if (session.getAttribute("contratos_searchwhere") != null)
		searchwhere = (String) session.getAttribute("contratos_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("contratos_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("contratos_searchwhere", searchwhere);
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("contratos_REC", new Integer(startRec));
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
	if (session.getAttribute("contratos_OB") != null &&
		((String) session.getAttribute("contratos_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("contratos_OT")).equals("ASC")) {
			session.setAttribute("contratos_OT", "DESC");
		}else{
			session.setAttribute("contratos_OT", "ASC");
		}
	}else{
		session.setAttribute("contratos_OT", "ASC");
	}
	session.setAttribute("contratos_OB", OrderBy);
	session.setAttribute("contratos_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("contratos_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("contratos_OB", OrderBy);
		session.setAttribute("contratos_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `contratos`";
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("contratos_OT");
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
	session.setAttribute("contratos_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("contratos_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("contratos_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("contratos_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("contratos_REC") != null)
		startRec = ((Integer) session.getAttribute("contratos_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("contratos_REC", new Integer(startRec));
	}
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">TABELA: Contratos</span></p>
<form action="contratoslist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Procura rapida (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="OK">
		&nbsp;&nbsp;<a href="contratoslist.jsp?cmd=reset">Mostrar todos</a>
		&nbsp;&nbsp;<a href="contratossrch.jsp">Busca avancada</a>
		</span></td>
	</tr>
	<tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Frase exata&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">Todas as palavras&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Qualquer palavra</span></td></tr>
</table>
</form>
<form method="post">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">
Contrato&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Contrato")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("contratos_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("contratos_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Empresa&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Empresa")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("contratos_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("contratos_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Vigencia&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Vigencia")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("contratos_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("contratos_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Horario atendimento&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Horario_atend")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("contratos_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("contratos_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Primeiro atendimento&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Primeiro_atend")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("contratos_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("contratos_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Solucao&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Solucao")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("contratos_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("contratos_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
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
	String x_id_Contrato = "";
	String x_Contrato = "";
	String x_Empresa = "";
	String x_Vigencia = "";
	String x_Horario_atend = "";
	String x_Primeiro_atend = "";
	String x_Solucao = "";
	String x_Login = "";

	// Load Key for record
	String key = "";

	// id_Contrato
	x_id_Contrato = String.valueOf(rs.getLong("id_Contrato"));

	// Contrato
	if (rs.getClob("Contrato") != null) {
		long length = rs.getClob("Contrato").length();
		x_Contrato = rs.getClob("Contrato").getSubString((long) 1, (int) length);
	}else{
		x_Contrato = "";
	}

	// Empresa
	if (rs.getClob("Empresa") != null) {
		long length = rs.getClob("Empresa").length();
		x_Empresa = rs.getClob("Empresa").getSubString((long) 1, (int) length);
	}else{
		x_Empresa = "";
	}

	// Vigencia
	if (rs.getClob("Vigencia") != null) {
		long length = rs.getClob("Vigencia").length();
		x_Vigencia = rs.getClob("Vigencia").getSubString((long) 1, (int) length);
	}else{
		x_Vigencia = "";
	}

	// Horario_atend
	if (rs.getClob("Horario_atend") != null) {
		long length = rs.getClob("Horario_atend").length();
		x_Horario_atend = rs.getClob("Horario_atend").getSubString((long) 1, (int) length);
	}else{
		x_Horario_atend = "";
	}

	// Primeiro_atend
	if (rs.getClob("Primeiro_atend") != null) {
		long length = rs.getClob("Primeiro_atend").length();
		x_Primeiro_atend = rs.getClob("Primeiro_atend").getSubString((long) 1, (int) length);
	}else{
		x_Primeiro_atend = "";
	}

	// Solucao
	if (rs.getClob("Solucao") != null) {
		long length = rs.getClob("Solucao").length();
		x_Solucao = rs.getClob("Solucao").getSubString((long) 1, (int) length);
	}else{
		x_Solucao = "";
	}

	// Login
	if (rs.getString("Login") != null){
		x_Login = rs.getString("Login");
	}else{
		x_Login = "";
	}
%>
	<tr bgcolor="<%= bgcolor %>">
		<td><span class="jspmaker"><% if (x_Contrato != null) { out.print(((String)x_Contrato).replaceAll("\r\n", "<br>"));} %></span>&nbsp;</td>
		<td><span class="jspmaker"><% if (x_Empresa != null) { out.print(((String)x_Empresa).replaceAll("\r\n", "<br>"));} %></span>&nbsp;</td>
		<td><span class="jspmaker"><% if (x_Vigencia != null) { out.print(((String)x_Vigencia).replaceAll("\r\n", "<br>"));} %></span>&nbsp;</td>
		<td><span class="jspmaker"><% if (x_Horario_atend != null) { out.print(((String)x_Horario_atend).replaceAll("\r\n", "<br>"));} %></span>&nbsp;</td>
		<td><span class="jspmaker"><% if (x_Primeiro_atend != null) { out.print(((String)x_Primeiro_atend).replaceAll("\r\n", "<br>"));} %></span>&nbsp;</td>
		<td><span class="jspmaker"><% if (x_Solucao != null) { out.print(((String)x_Solucao).replaceAll("\r\n", "<br>"));} %></span>&nbsp;</td>
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Contrato"); 
if (key != null && key.length() > 0) { 
	out.print("contratosview.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Visualizar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Contrato"); 
if (key != null && key.length() > 0) { 
	out.print("contratosedit.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Editar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Contrato"); 
if (key != null && key.length() > 0) { 
	out.print("contratosadd.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Copiar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Contrato"); 
if (key != null && key.length() > 0) { 
	out.print("contratosdelete.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Excluir</a></span></td>
<% } %>
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
	<td><a href="contratoslist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="contratoslist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="contratoslist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="contratoslist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
	<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<td><a href="contratosadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a></td>
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
<a href="contratosadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
