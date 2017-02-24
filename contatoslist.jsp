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

// Get the keys for master table
String key_m = request.getParameter("key_m");
if (key_m != null && key_m.length() > 0) {
	session.setAttribute("contatos_masterkey", key_m); // Save master key to session

	// Reset start record counter (new master key)
	startRec = 0;
	session.setAttribute("contatos_REC", new Integer(startRec));
} else {
	key_m = (String) session.getAttribute("contatos_masterkey"); // Restore master key from session
}
String masterdatailwhere;
if (key_m != null && key_m.length() > 0) {
	masterdetailwhere = "`idFornecedores` = " + key_m.replaceAll("'",escapeString) + "";
}
%>
<%

// Get search criteria for advanced search
// id_Contatos

String ascrh_x_id_Contatos = request.getParameter("x_id_Contatos");
String z_id_Contatos = request.getParameter("z_id_Contatos");
	if (z_id_Contatos != null && z_id_Contatos.length() > 0 ) {
		String [] arrfieldopr_x_id_Contatos = z_id_Contatos.split(",");
		if (ascrh_x_id_Contatos != null && ascrh_x_id_Contatos.length() > 0) {
			ascrh_x_id_Contatos = ascrh_x_id_Contatos.replaceAll("'",escapeString);
			ascrh_x_id_Contatos = ascrh_x_id_Contatos.replaceAll("\\[","[[]");
			a_search += "`id_Contatos` "; // Add field
			a_search += arrfieldopr_x_id_Contatos[0].trim() + " "; // Add operator
			if (arrfieldopr_x_id_Contatos.length >= 2) {
				a_search += arrfieldopr_x_id_Contatos[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_id_Contatos; // Add input parameter
			if (arrfieldopr_x_id_Contatos.length >= 3) {
				a_search += arrfieldopr_x_id_Contatos[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// idFornecedores
String ascrh_x_idFornecedores = request.getParameter("x_idFornecedores");
String z_idFornecedores = request.getParameter("z_idFornecedores");
	if (z_idFornecedores != null && z_idFornecedores.length() > 0 ) {
		String [] arrfieldopr_x_idFornecedores = z_idFornecedores.split(",");
		if (ascrh_x_idFornecedores != null && ascrh_x_idFornecedores.length() > 0) {
			ascrh_x_idFornecedores = ascrh_x_idFornecedores.replaceAll("'",escapeString);
			ascrh_x_idFornecedores = ascrh_x_idFornecedores.replaceAll("\\[","[[]");
			a_search += "`idFornecedores` "; // Add field
			a_search += arrfieldopr_x_idFornecedores[0].trim() + " "; // Add operator
			if (arrfieldopr_x_idFornecedores.length >= 2) {
				a_search += arrfieldopr_x_idFornecedores[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_idFornecedores; // Add input parameter
			if (arrfieldopr_x_idFornecedores.length >= 3) {
				a_search += arrfieldopr_x_idFornecedores[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Nome_Contato
String ascrh_x_Nome_Contato = request.getParameter("x_Nome_Contato");
String z_Nome_Contato = request.getParameter("z_Nome_Contato");
	if (z_Nome_Contato != null && z_Nome_Contato.length() > 0 ) {
		String [] arrfieldopr_x_Nome_Contato = z_Nome_Contato.split(",");
		if (ascrh_x_Nome_Contato != null && ascrh_x_Nome_Contato.length() > 0) {
			ascrh_x_Nome_Contato = ascrh_x_Nome_Contato.replaceAll("'",escapeString);
			ascrh_x_Nome_Contato = ascrh_x_Nome_Contato.replaceAll("\\[","[[]");
			a_search += "`Nome_Contato` "; // Add field
			a_search += arrfieldopr_x_Nome_Contato[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Nome_Contato.length >= 2) {
				a_search += arrfieldopr_x_Nome_Contato[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Nome_Contato; // Add input parameter
			if (arrfieldopr_x_Nome_Contato.length >= 3) {
				a_search += arrfieldopr_x_Nome_Contato[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Numero_Telefone
String ascrh_x_Numero_Telefone = request.getParameter("x_Numero_Telefone");
String z_Numero_Telefone = request.getParameter("z_Numero_Telefone");
	if (z_Numero_Telefone != null && z_Numero_Telefone.length() > 0 ) {
		String [] arrfieldopr_x_Numero_Telefone = z_Numero_Telefone.split(",");
		if (ascrh_x_Numero_Telefone != null && ascrh_x_Numero_Telefone.length() > 0) {
			ascrh_x_Numero_Telefone = ascrh_x_Numero_Telefone.replaceAll("'",escapeString);
			ascrh_x_Numero_Telefone = ascrh_x_Numero_Telefone.replaceAll("\\[","[[]");
			a_search += "`Numero_Telefone` "; // Add field
			a_search += arrfieldopr_x_Numero_Telefone[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Numero_Telefone.length >= 2) {
				a_search += arrfieldopr_x_Numero_Telefone[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Numero_Telefone; // Add input parameter
			if (arrfieldopr_x_Numero_Telefone.length >= 3) {
				a_search += arrfieldopr_x_Numero_Telefone[2].trim(); // Add search suffix
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
			b_search = b_search + "`Nome_Contato` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Numero_Telefone` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Login` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`Nome_Contato` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Numero_Telefone` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("contatos_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("contatos_REC", new Integer(startRec));
}else{
	if (session.getAttribute("contatos_searchwhere") != null)
		searchwhere = (String) session.getAttribute("contatos_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("contatos_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("contatos_searchwhere", searchwhere);
    	key_m = "";
		session.setAttribute("contatos_masterkey", key_m); // Clear master key
    	masterdetailwhere = "";
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("contatos_REC", new Integer(startRec));
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
String DefaultOrder = "Nome_Contato";
String DefaultOrderType = "ASC";

// No Default Filter
String DefaultFilter = "";

// Check for an Order parameter
String OrderBy = request.getParameter("order");
if (OrderBy != null && OrderBy.length() > 0) {
	if (session.getAttribute("contatos_OB") != null &&
		((String) session.getAttribute("contatos_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("contatos_OT")).equals("ASC")) {
			session.setAttribute("contatos_OT", "DESC");
		}else{
			session.setAttribute("contatos_OT", "ASC");
		}
	}else{
		session.setAttribute("contatos_OT", "ASC");
	}
	session.setAttribute("contatos_OB", OrderBy);
	session.setAttribute("contatos_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("contatos_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("contatos_OB", OrderBy);
		session.setAttribute("contatos_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `contatos`";
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("contatos_OT");
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
	session.setAttribute("contatos_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("contatos_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("contatos_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("contatos_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("contatos_REC") != null)
		startRec = ((Integer) session.getAttribute("contatos_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("contatos_REC", new Integer(startRec));
	}
}
%>
<%
ResultSet rsMas = null;
Statement stmtMas = null;
if (key_m != null && key_m.length() > 0) {
	String strmassql = "SELECT * FROM `fornecedores` WHERE ";
	strmassql = strmassql + "(`idFornecedores` = " + key_m.replaceAll("'",escapeString)  + ")";
	stmtMas = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	rsMas = stmtMas.executeQuery(strmassql);
}
%>
<%@ include file="header.jsp" %>
<%
if (key_m != null && key_m.length() > 0) {
	if (rsMas.next()) { %>
	<p><span class="jspmaker">Registro Mestre: Fornecedores<br><a href="fornecedoreslist.jsp">Voltar a lista</a></span></p>
	<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
		<tr bgcolor="#594FBF">
			<td><span class="jspmaker" style="color: #FFFFFF;">Nome Fornecedor</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">CNPJ</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Telefone</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Home Page</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">e Mail</span>&nbsp;</td>
		</tr>
		<tr bgcolor="#FFFFFF">
<%

    // Load Key for record
    String key = "";
    if (rsMas.getString("idFornecedores") != null){
    	key = rsMas.getString("idFornecedores");
		}else{
			key = "";
		}

		// idFornecedores
		String x_idFornecedores = "";
		x_idFornecedores = String.valueOf(rsMas.getLong("idFornecedores"));

		// Nome_Fornecedor
		String x_Nome_Fornecedor = "";
		if (rsMas.getString("Nome_Fornecedor") != null){
			x_Nome_Fornecedor = rsMas.getString("Nome_Fornecedor");
		}else{
			x_Nome_Fornecedor = "";
		}

		// CNPJ
		String x_CNPJ = "";
		if (rsMas.getString("CNPJ") != null){
			x_CNPJ = rsMas.getString("CNPJ");
		}else{
			x_CNPJ = "";
		}

		// Endereco
		String x_Endereco = "";
			if (rsMas.getClob("Endereco") != null) {
				long length = rsMas.getClob("Endereco").length();
				x_Endereco = rsMas.getClob("Endereco").getSubString((long) 1, (int) length);
			}else{
				x_Endereco = "";
			}

		// Telefone
		String x_Telefone = "";
		if (rsMas.getString("Telefone") != null){
			x_Telefone = rsMas.getString("Telefone");
		}else{
			x_Telefone = "";
		}

		// Home_Page
		String x_Home_Page = "";
		if (rsMas.getString("Home_Page") != null){
			x_Home_Page = rsMas.getString("Home_Page");
		}else{
			x_Home_Page = "";
		}

		// eMail
		String x_eMail = "";
		if (rsMas.getString("eMail") != null){
			x_eMail = rsMas.getString("eMail");
		}else{
			x_eMail = "";
		}

		// Login
		String x_Login = "";
		if (rsMas.getString("Login") != null){
			x_Login = rsMas.getString("Login");
		}else{
			x_Login = "";
		}
%>
			<td><span class="jspmaker"><% out.print(x_Nome_Fornecedor); %></span>&nbsp;</td>
			<td><span class="jspmaker"><% out.print(x_CNPJ); %></span>&nbsp;</td>
			<td><span class="jspmaker"><% out.print(x_Telefone); %></span>&nbsp;</td>
			<td><span class="jspmaker"><% out.print(x_Home_Page); %></span>&nbsp;</td>
			<td><span class="jspmaker"><% out.print(x_eMail); %></span>&nbsp;</td>
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
<p><span class="jspmaker">TABELA: Contatos</span></p>
<form action="contatoslist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Procura rapida (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="OK">
		&nbsp;&nbsp;<a href="contatoslist.jsp?cmd=reset">Mostrar todos</a>
		&nbsp;&nbsp;<a href="contatossrch.jsp">Busca avancada</a>
		</span></td>
	</tr>
	<tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Frase exata&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">Todas as palavras&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Qualquer palavra</span></td></tr>
</table>
</form>
<form method="post">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="contatoslist.jsp?order=<%= java.net.URLEncoder.encode("idFornecedores","UTF-8") %>" style="color: #FFFFFF;">Fornecedor&nbsp;<% if (OrderBy != null && OrderBy.equals("idFornecedores")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("contatos_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("contatos_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="contatoslist.jsp?order=<%= java.net.URLEncoder.encode("Nome_Contato","UTF-8") %>" style="color: #FFFFFF;">Nome do contato&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Nome_Contato")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("contatos_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("contatos_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="contatoslist.jsp?order=<%= java.net.URLEncoder.encode("Numero_Telefone","UTF-8") %>" style="color: #FFFFFF;">Numero do Telefone&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Numero_Telefone")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("contatos_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("contatos_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td>&nbsp;</td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
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
	String x_id_Contatos = "";
	String x_idFornecedores = "";
	String x_Nome_Contato = "";
	String x_Numero_Telefone = "";
	String x_Login = "";

	// Load Key for record
	String key = "";

	// id_Contatos
	x_id_Contatos = String.valueOf(rs.getLong("id_Contatos"));

	// idFornecedores
	x_idFornecedores = String.valueOf(rs.getLong("idFornecedores"));

	// Nome_Contato
	if (rs.getString("Nome_Contato") != null){
		x_Nome_Contato = rs.getString("Nome_Contato");
	}else{
		x_Nome_Contato = "";
	}

	// Numero_Telefone
	if (rs.getString("Numero_Telefone") != null){
		x_Numero_Telefone = rs.getString("Numero_Telefone");
	}else{
		x_Numero_Telefone = "";
	}

	// Login
	if (rs.getString("Login") != null){
		x_Login = rs.getString("Login");
	}else{
		x_Login = "";
	}
%>
	<tr bgcolor="<%= bgcolor %>">
		<td><span class="jspmaker"><%
if (x_idFornecedores!=null && ((String)x_idFornecedores).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_idFornecedores;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`idFornecedores` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `idFornecedores`, `Nome_Fornecedor` FROM `fornecedores`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("Nome_Fornecedor"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
</span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_Nome_Contato); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_Numero_Telefone); %></span>&nbsp;</td>
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Contatos"); 
if (key != null && key.length() > 0) { 
	out.print("contatosview.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Visualizar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Contatos"); 
if (key != null && key.length() > 0) { 
	out.print("contatosedit.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Editar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Contatos"); 
if (key != null && key.length() > 0) { 
	out.print("contatosdelete.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
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
	<td><a href="contatoslist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="contatoslist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="contatoslist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="contatoslist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
	<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<td><a href="contatosadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a></td>
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
<a href="contatosadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
