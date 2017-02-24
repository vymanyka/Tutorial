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
	session.setAttribute("movimentacao_masterkey", key_m); // Save master key to session

	// Reset start record counter (new master key)
	startRec = 0;
	session.setAttribute("movimentacao_REC", new Integer(startRec));
} else {
	key_m = (String) session.getAttribute("movimentacao_masterkey"); // Restore master key from session
}
String masterdatailwhere;
if (key_m != null && key_m.length() > 0) {
	masterdetailwhere = "`id_Bem` = " + key_m.replaceAll("'",escapeString) + "";
}
%>
<%

// Get search criteria for advanced search
// id_Movimentacao

String ascrh_x_id_Movimentacao = request.getParameter("x_id_Movimentacao");
String z_id_Movimentacao = request.getParameter("z_id_Movimentacao");
	if (z_id_Movimentacao != null && z_id_Movimentacao.length() > 0 ) {
		String [] arrfieldopr_x_id_Movimentacao = z_id_Movimentacao.split(",");
		if (ascrh_x_id_Movimentacao != null && ascrh_x_id_Movimentacao.length() > 0) {
			ascrh_x_id_Movimentacao = ascrh_x_id_Movimentacao.replaceAll("'",escapeString);
			ascrh_x_id_Movimentacao = ascrh_x_id_Movimentacao.replaceAll("\\[","[[]");
			a_search += "`id_Movimentacao` "; // Add field
			a_search += arrfieldopr_x_id_Movimentacao[0].trim() + " "; // Add operator
			if (arrfieldopr_x_id_Movimentacao.length >= 2) {
				a_search += arrfieldopr_x_id_Movimentacao[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_id_Movimentacao; // Add input parameter
			if (arrfieldopr_x_id_Movimentacao.length >= 3) {
				a_search += arrfieldopr_x_id_Movimentacao[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// id_Bem
String ascrh_x_id_Bem = request.getParameter("x_id_Bem");
String z_id_Bem = request.getParameter("z_id_Bem");
	if (z_id_Bem != null && z_id_Bem.length() > 0 ) {
		String [] arrfieldopr_x_id_Bem = z_id_Bem.split(",");
		if (ascrh_x_id_Bem != null && ascrh_x_id_Bem.length() > 0) {
			ascrh_x_id_Bem = ascrh_x_id_Bem.replaceAll("'",escapeString);
			ascrh_x_id_Bem = ascrh_x_id_Bem.replaceAll("\\[","[[]");
			a_search += "`id_Bem` "; // Add field
			a_search += arrfieldopr_x_id_Bem[0].trim() + " "; // Add operator
			if (arrfieldopr_x_id_Bem.length >= 2) {
				a_search += arrfieldopr_x_id_Bem[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_id_Bem; // Add input parameter
			if (arrfieldopr_x_id_Bem.length >= 3) {
				a_search += arrfieldopr_x_id_Bem[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Siga
String ascrh_x_Siga = request.getParameter("x_Siga");
String z_Siga = request.getParameter("z_Siga");
	if (z_Siga != null && z_Siga.length() > 0 ) {
		String [] arrfieldopr_x_Siga = z_Siga.split(",");
		if (ascrh_x_Siga != null && ascrh_x_Siga.length() > 0) {
			ascrh_x_Siga = ascrh_x_Siga.replaceAll("'",escapeString);
			ascrh_x_Siga = ascrh_x_Siga.replaceAll("\\[","[[]");
			a_search += "`Siga` "; // Add field
			a_search += arrfieldopr_x_Siga[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Siga.length >= 2) {
				a_search += arrfieldopr_x_Siga[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Siga; // Add input parameter
			if (arrfieldopr_x_Siga.length >= 3) {
				a_search += arrfieldopr_x_Siga[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Data_Entrada
String ascrh_x_Data_Entrada = request.getParameter("x_Data_Entrada");
String z_Data_Entrada = request.getParameter("z_Data_Entrada");
	if (z_Data_Entrada != null && z_Data_Entrada.length() > 0 ) {
		String [] arrfieldopr_x_Data_Entrada = z_Data_Entrada.split(",");
		if (ascrh_x_Data_Entrada != null && ascrh_x_Data_Entrada.length() > 0) {
			ascrh_x_Data_Entrada = ascrh_x_Data_Entrada.replaceAll("'",escapeString);
			ascrh_x_Data_Entrada = ascrh_x_Data_Entrada.replaceAll("\\[","[[]");
			a_search += "`Data_Entrada` "; // Add field
			a_search += arrfieldopr_x_Data_Entrada[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Data_Entrada.length >= 2) {
				a_search += arrfieldopr_x_Data_Entrada[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Data_Entrada; // Add input parameter
			if (arrfieldopr_x_Data_Entrada.length >= 3) {
				a_search += arrfieldopr_x_Data_Entrada[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Situacao
String ascrh_x_Situacao = request.getParameter("x_Situacao");
String z_Situacao = request.getParameter("z_Situacao");
	if (z_Situacao != null && z_Situacao.length() > 0 ) {
		String [] arrfieldopr_x_Situacao = z_Situacao.split(",");
		if (ascrh_x_Situacao != null && ascrh_x_Situacao.length() > 0) {
			ascrh_x_Situacao = ascrh_x_Situacao.replaceAll("'",escapeString);
			ascrh_x_Situacao = ascrh_x_Situacao.replaceAll("\\[","[[]");
			a_search += "`Situacao` "; // Add field
			a_search += arrfieldopr_x_Situacao[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Situacao.length >= 2) {
				a_search += arrfieldopr_x_Situacao[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Situacao; // Add input parameter
			if (arrfieldopr_x_Situacao.length >= 3) {
				a_search += arrfieldopr_x_Situacao[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Detalhes_da_Movimentacao
String ascrh_x_Detalhes_da_Movimentacao = request.getParameter("x_Detalhes_da_Movimentacao");
String z_Detalhes_da_Movimentacao = request.getParameter("z_Detalhes_da_Movimentacao");
	if (z_Detalhes_da_Movimentacao != null && z_Detalhes_da_Movimentacao.length() > 0 ) {
		String [] arrfieldopr_x_Detalhes_da_Movimentacao = z_Detalhes_da_Movimentacao.split(",");
		if (ascrh_x_Detalhes_da_Movimentacao != null && ascrh_x_Detalhes_da_Movimentacao.length() > 0) {
			ascrh_x_Detalhes_da_Movimentacao = ascrh_x_Detalhes_da_Movimentacao.replaceAll("'",escapeString);
			ascrh_x_Detalhes_da_Movimentacao = ascrh_x_Detalhes_da_Movimentacao.replaceAll("\\[","[[]");
			a_search += "`Detalhes_da_Movimentacao` "; // Add field
			a_search += arrfieldopr_x_Detalhes_da_Movimentacao[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Detalhes_da_Movimentacao.length >= 2) {
				a_search += arrfieldopr_x_Detalhes_da_Movimentacao[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Detalhes_da_Movimentacao; // Add input parameter
			if (arrfieldopr_x_Detalhes_da_Movimentacao.length >= 3) {
				a_search += arrfieldopr_x_Detalhes_da_Movimentacao[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Garantia
String ascrh_x_Garantia = request.getParameter("x_Garantia");
String z_Garantia = request.getParameter("z_Garantia");
	if (z_Garantia != null && z_Garantia.length() > 0 ) {
		String [] arrfieldopr_x_Garantia = z_Garantia.split(",");
		if (ascrh_x_Garantia != null && ascrh_x_Garantia.length() > 0) {
			ascrh_x_Garantia = ascrh_x_Garantia.replaceAll("'",escapeString);
			ascrh_x_Garantia = ascrh_x_Garantia.replaceAll("\\[","[[]");
			a_search += "`Garantia` "; // Add field
			a_search += arrfieldopr_x_Garantia[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Garantia.length >= 2) {
				a_search += arrfieldopr_x_Garantia[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Garantia; // Add input parameter
			if (arrfieldopr_x_Garantia.length >= 3) {
				a_search += arrfieldopr_x_Garantia[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Lotacao_Destino
String ascrh_x_Lotacao_Destino = request.getParameter("x_Lotacao_Destino");
String z_Lotacao_Destino = request.getParameter("z_Lotacao_Destino");
	if (z_Lotacao_Destino != null && z_Lotacao_Destino.length() > 0 ) {
		String [] arrfieldopr_x_Lotacao_Destino = z_Lotacao_Destino.split(",");
		if (ascrh_x_Lotacao_Destino != null && ascrh_x_Lotacao_Destino.length() > 0) {
			ascrh_x_Lotacao_Destino = ascrh_x_Lotacao_Destino.replaceAll("'",escapeString);
			ascrh_x_Lotacao_Destino = ascrh_x_Lotacao_Destino.replaceAll("\\[","[[]");
			a_search += "`Lotacao_Destino` "; // Add field
			a_search += arrfieldopr_x_Lotacao_Destino[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Lotacao_Destino.length >= 2) {
				a_search += arrfieldopr_x_Lotacao_Destino[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Lotacao_Destino; // Add input parameter
			if (arrfieldopr_x_Lotacao_Destino.length >= 3) {
				a_search += arrfieldopr_x_Lotacao_Destino[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Resp_Transporte
String ascrh_x_Resp_Transporte = request.getParameter("x_Resp_Transporte");
String z_Resp_Transporte = request.getParameter("z_Resp_Transporte");
	if (z_Resp_Transporte != null && z_Resp_Transporte.length() > 0 ) {
		String [] arrfieldopr_x_Resp_Transporte = z_Resp_Transporte.split(",");
		if (ascrh_x_Resp_Transporte != null && ascrh_x_Resp_Transporte.length() > 0) {
			ascrh_x_Resp_Transporte = ascrh_x_Resp_Transporte.replaceAll("'",escapeString);
			ascrh_x_Resp_Transporte = ascrh_x_Resp_Transporte.replaceAll("\\[","[[]");
			a_search += "`Resp_Transporte` "; // Add field
			a_search += arrfieldopr_x_Resp_Transporte[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Resp_Transporte.length >= 2) {
				a_search += arrfieldopr_x_Resp_Transporte[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Resp_Transporte; // Add input parameter
			if (arrfieldopr_x_Resp_Transporte.length >= 3) {
				a_search += arrfieldopr_x_Resp_Transporte[2].trim(); // Add search suffix
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
			b_search = b_search + "`Detalhes_da_Movimentacao` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Resp_Transporte` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Login` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`Detalhes_da_Movimentacao` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Resp_Transporte` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("movimentacao_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("movimentacao_REC", new Integer(startRec));
}else{
	if (session.getAttribute("movimentacao_searchwhere") != null)
		searchwhere = (String) session.getAttribute("movimentacao_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("movimentacao_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("movimentacao_searchwhere", searchwhere);
    	key_m = "";
		session.setAttribute("movimentacao_masterkey", key_m); // Clear master key
    	masterdetailwhere = "";
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("movimentacao_REC", new Integer(startRec));
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
String DefaultOrder = "Data_Entrada";
String DefaultOrderType = "DESC";

// No Default Filter
String DefaultFilter = "";

// Check for an Order parameter
String OrderBy = request.getParameter("order");
if (OrderBy != null && OrderBy.length() > 0) {
	if (session.getAttribute("movimentacao_OB") != null &&
		((String) session.getAttribute("movimentacao_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("movimentacao_OT")).equals("ASC")) {
			session.setAttribute("movimentacao_OT", "DESC");
		}else{
			session.setAttribute("movimentacao_OT", "ASC");
		}
	}else{
		session.setAttribute("movimentacao_OT", "ASC");
	}
	session.setAttribute("movimentacao_OB", OrderBy);
	session.setAttribute("movimentacao_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("movimentacao_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("movimentacao_OB", OrderBy);
		session.setAttribute("movimentacao_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `movimentacao`";
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("movimentacao_OT");
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
	session.setAttribute("movimentacao_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("movimentacao_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("movimentacao_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("movimentacao_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("movimentacao_REC") != null)
		startRec = ((Integer) session.getAttribute("movimentacao_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("movimentacao_REC", new Integer(startRec));
	}
}
%>
<%
ResultSet rsMas = null;
Statement stmtMas = null;
if (key_m != null && key_m.length() > 0) {
	String strmassql = "SELECT * FROM `bens` WHERE ";
	strmassql = strmassql + "(`id_Bem` = " + key_m.replaceAll("'",escapeString)  + ")";
	stmtMas = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	rsMas = stmtMas.executeQuery(strmassql);
}
%>
<%@ include file="header.jsp" %>
<%
if (key_m != null && key_m.length() > 0) {
	if (rsMas.next()) { %>
	<p><span class="jspmaker">Registro Mestre: Bens<br><a href="benslist.jsp">Voltar a lista</a></span></p>
	<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
		<tr bgcolor="#594FBF">
			<td><span class="jspmaker" style="color: #FFFFFF;">Tombamento</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Marca</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Categoria</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Lotacao atual</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Numero de serie</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Caracteristicas do bem</span>&nbsp;</td>
		</tr>
		<tr bgcolor="#FFFFFF">
<%

    // Load Key for record
    String key = "";
    if (rsMas.getString("id_Bem") != null){
    	key = rsMas.getString("id_Bem");
		}else{
			key = "";
		}

		// id_Bem
		String x_id_Bem = "";
		x_id_Bem = String.valueOf(rsMas.getLong("id_Bem"));

		// id_Marca
		String x_id_Marca = "";
		x_id_Marca = String.valueOf(rsMas.getLong("id_Marca"));

		// id_Categoria
		String x_id_Categoria = "";
		x_id_Categoria = String.valueOf(rsMas.getLong("id_Categoria"));

		// id_Lotacoes
		String x_id_Lotacoes = "";
		x_id_Lotacoes = String.valueOf(rsMas.getLong("id_Lotacoes"));

		// Numero_de_serie
		String x_Numero_de_serie = "";
		if (rsMas.getString("Numero_de_serie") != null){
			x_Numero_de_serie = rsMas.getString("Numero_de_serie");
		}else{
			x_Numero_de_serie = "";
		}

		// Caracteristicas_do_bem
		String x_Caracteristicas_do_bem = "";
			if (rsMas.getClob("Caracteristicas_do_bem") != null) {
				long length = rsMas.getClob("Caracteristicas_do_bem").length();
				x_Caracteristicas_do_bem = rsMas.getClob("Caracteristicas_do_bem").getSubString((long) 1, (int) length);
			}else{
				x_Caracteristicas_do_bem = "";
			}

		// Login
		String x_Login = "";
		if (rsMas.getString("Login") != null){
			x_Login = rsMas.getString("Login");
		}else{
			x_Login = "";
		}
%>
			<td><span class="jspmaker"><% out.print(x_id_Bem); %></span>&nbsp;</td>
			<td><span class="jspmaker"><%
if (x_id_Marca!=null && ((String)x_id_Marca).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Marca;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Marca` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Marca`, `Marca` FROM `marcas`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("Marca"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
</span>&nbsp;</td>
			<td><span class="jspmaker"><%
if (x_id_Categoria!=null && ((String)x_id_Categoria).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Categoria;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Categoria` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Categoria`, `Descricao_da_categoria` FROM `categorias`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("Descricao_da_categoria"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
</span>&nbsp;</td>
			<td><span class="jspmaker"><%
if (x_id_Lotacoes!=null && ((String)x_id_Lotacoes).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Lotacoes;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Lotacoes` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Lotacoes`, `Descricao_da_lotacao` FROM `lotacoes`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("Descricao_da_lotacao"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
</span>&nbsp;</td>
			<td><span class="jspmaker"><% out.print(x_Numero_de_serie); %></span>&nbsp;</td>
			<td><span class="jspmaker"><% if (x_Caracteristicas_do_bem != null) { out.print(((String)x_Caracteristicas_do_bem).replaceAll("\r\n", "<br>"));} %></span>&nbsp;</td>
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
<p><span class="jspmaker">TABELA: Livro de ocorrencias</span></p>
<form action="movimentacaolist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Procura rapida (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="OK">
		&nbsp;&nbsp;<a href="movimentacaolist.jsp?cmd=reset">Mostrar todos</a>
		&nbsp;&nbsp;<a href="movimentacaosrch.jsp">Busca avancada</a>
		</span></td>
	</tr>
	<tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Frase exata&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">Todas as palavras&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Qualquer palavra</span></td></tr>
</table>
</form>
<form method="post">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="movimentacaolist.jsp?order=<%= java.net.URLEncoder.encode("id_Bem","UTF-8") %>" style="color: #FFFFFF;">Tombamento&nbsp;<% if (OrderBy != null && OrderBy.equals("id_Bem")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("movimentacao_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("movimentacao_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="movimentacaolist.jsp?order=<%= java.net.URLEncoder.encode("Siga","UTF-8") %>" style="color: #FFFFFF;">Siga&nbsp;<% if (OrderBy != null && OrderBy.equals("Siga")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("movimentacao_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("movimentacao_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="movimentacaolist.jsp?order=<%= java.net.URLEncoder.encode("Data_Entrada","UTF-8") %>" style="color: #FFFFFF;">Data da ocorrencia&nbsp;<% if (OrderBy != null && OrderBy.equals("Data_Entrada")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("movimentacao_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("movimentacao_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="movimentacaolist.jsp?order=<%= java.net.URLEncoder.encode("Situacao","UTF-8") %>" style="color: #FFFFFF;">Situacao&nbsp;<% if (OrderBy != null && OrderBy.equals("Situacao")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("movimentacao_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("movimentacao_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Detalhes da ocorrencia&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Detalhes_da_Movimentacao")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("movimentacao_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("movimentacao_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="movimentacaolist.jsp?order=<%= java.net.URLEncoder.encode("Garantia","UTF-8") %>" style="color: #FFFFFF;">Garantia&nbsp;<% if (OrderBy != null && OrderBy.equals("Garantia")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("movimentacao_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("movimentacao_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="movimentacaolist.jsp?order=<%= java.net.URLEncoder.encode("Lotacao_Destino","UTF-8") %>" style="color: #FFFFFF;">Lotacao de destino&nbsp;<% if (OrderBy != null && OrderBy.equals("Lotacao_Destino")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("movimentacao_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("movimentacao_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="movimentacaolist.jsp?order=<%= java.net.URLEncoder.encode("Resp_Transporte","UTF-8") %>" style="color: #FFFFFF;">Quem movimentou?&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Resp_Transporte")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("movimentacao_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("movimentacao_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
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
	String x_id_Movimentacao = "";
	String x_id_Bem = "";
	String x_Siga = "";
	Object x_Data_Entrada = null;
	String x_Situacao = "";
	String x_Detalhes_da_Movimentacao = "";
	String x_Garantia = "";
	String x_Lotacao_Destino = "";
	String x_Resp_Transporte = "";
	String x_Login = "";

	// Load Key for record
	String key = "";

	// id_Movimentacao
	x_id_Movimentacao = String.valueOf(rs.getLong("id_Movimentacao"));

	// id_Bem
	x_id_Bem = String.valueOf(rs.getLong("id_Bem"));

	// Siga
	x_Siga = String.valueOf(rs.getLong("Siga"));

	// Data_Entrada
	if (rs.getTimestamp("Data_Entrada") != null){
		x_Data_Entrada = rs.getTimestamp("Data_Entrada");
	}else{
		x_Data_Entrada = "";
	}

	// Situacao
	x_Situacao = String.valueOf(rs.getLong("Situacao"));

	// Detalhes_da_Movimentacao
	if (rs.getClob("Detalhes_da_Movimentacao") != null) {
		long length = rs.getClob("Detalhes_da_Movimentacao").length();
		x_Detalhes_da_Movimentacao = rs.getClob("Detalhes_da_Movimentacao").getSubString((long) 1, (int) length);
	}else{
		x_Detalhes_da_Movimentacao = "";
	}

	// Garantia
	x_Garantia = String.valueOf(rs.getLong("Garantia"));

	// Lotacao_Destino
	x_Lotacao_Destino = String.valueOf(rs.getLong("Lotacao_Destino"));

	// Resp_Transporte
	if (rs.getString("Resp_Transporte") != null){
		x_Resp_Transporte = rs.getString("Resp_Transporte");
	}else{
		x_Resp_Transporte = "";
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
</span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_Siga); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(EW_FormatDateTime(x_Data_Entrada,7,locale)); %></span>&nbsp;</td>
		<td><span class="jspmaker"><%
String tmpValue_x_Situacao = (String) x_Situacao;
if (tmpValue_x_Situacao.equals("1")) { 
	out.print("Bom");
}
if (tmpValue_x_Situacao.equals("2")) { 
	out.print("Danificado");
}
if (tmpValue_x_Situacao.equals("3")) { 
	out.print("Anti-economico");
}
%>
</span>&nbsp;</td>
		<td><span class="jspmaker"><% if (x_Detalhes_da_Movimentacao != null) { out.print(((String)x_Detalhes_da_Movimentacao).replaceAll("\r\n", "<br>"));} %></span>&nbsp;</td>
		<td><span class="jspmaker"><%
String tmpValue_x_Garantia = (String) x_Garantia;
if (tmpValue_x_Garantia.equals("1")) { 
	out.print("Na garantia");
}
if (tmpValue_x_Garantia.equals("2")) { 
	out.print("Fora da garantia");
}
%>
</span>&nbsp;</td>
		<td><span class="jspmaker"><%
if (x_Lotacao_Destino!=null && ((String)x_Lotacao_Destino).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_Lotacao_Destino;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Lotacoes` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Lotacoes`, `Descricao_da_lotacao` FROM `lotacoes`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("Descricao_da_lotacao"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
</span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_Resp_Transporte); %></span>&nbsp;</td>
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Movimentacao"); 
if (key != null && key.length() > 0) { 
	out.print("movimentacaoview.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Visualizar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Movimentacao"); 
if (key != null && key.length() > 0) { 
	out.print("movimentacaoedit.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Editar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Movimentacao"); 
if (key != null && key.length() > 0) { 
	out.print("movimentacaoadd.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Copiar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Movimentacao"); 
if (key != null && key.length() > 0) { 
	out.print("movimentacaodelete.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Excluir</a></span></td>
<% } %>
<td><span class="jspmaker"><a href="problemaslist.jsp?key_m=<%= x_id_Movimentacao %>">Problemas Detalhes</a></span></td>
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
	<td><a href="movimentacaolist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="movimentacaolist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="movimentacaolist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="movimentacaolist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
	<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<td><a href="movimentacaoadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a></td>
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
<a href="movimentacaoadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
