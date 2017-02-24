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
ew_SecTable[1] = 15;
ew_SecTable[2] = 15;
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
	session.setAttribute("problemas_masterkey", key_m); // Save master key to session

	// Reset start record counter (new master key)
	startRec = 0;
	session.setAttribute("problemas_REC", new Integer(startRec));
} else {
	key_m = (String) session.getAttribute("problemas_masterkey"); // Restore master key from session
}
String masterdatailwhere;
if (key_m != null && key_m.length() > 0) {
	masterdetailwhere = "`id_Movimentacao` = " + key_m.replaceAll("'",escapeString) + "";
}
%>
<%

// Get search criteria for advanced search
// id_Problema

String ascrh_x_id_Problema = request.getParameter("x_id_Problema");
String z_id_Problema = request.getParameter("z_id_Problema");
	if (z_id_Problema != null && z_id_Problema.length() > 0 ) {
		String [] arrfieldopr_x_id_Problema = z_id_Problema.split(",");
		if (ascrh_x_id_Problema != null && ascrh_x_id_Problema.length() > 0) {
			ascrh_x_id_Problema = ascrh_x_id_Problema.replaceAll("'",escapeString);
			ascrh_x_id_Problema = ascrh_x_id_Problema.replaceAll("\\[","[[]");
			a_search += "`id_Problema` "; // Add field
			a_search += arrfieldopr_x_id_Problema[0].trim() + " "; // Add operator
			if (arrfieldopr_x_id_Problema.length >= 2) {
				a_search += arrfieldopr_x_id_Problema[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_id_Problema; // Add input parameter
			if (arrfieldopr_x_id_Problema.length >= 3) {
				a_search += arrfieldopr_x_id_Problema[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

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

// id_Dano
String ascrh_x_id_Dano = request.getParameter("x_id_Dano");
String z_id_Dano = request.getParameter("z_id_Dano");
	if (z_id_Dano != null && z_id_Dano.length() > 0 ) {
		String [] arrfieldopr_x_id_Dano = z_id_Dano.split(",");
		if (ascrh_x_id_Dano != null && ascrh_x_id_Dano.length() > 0) {
			ascrh_x_id_Dano = ascrh_x_id_Dano.replaceAll("'",escapeString);
			ascrh_x_id_Dano = ascrh_x_id_Dano.replaceAll("\\[","[[]");
			a_search += "`id_Dano` "; // Add field
			a_search += arrfieldopr_x_id_Dano[0].trim() + " "; // Add operator
			if (arrfieldopr_x_id_Dano.length >= 2) {
				a_search += arrfieldopr_x_id_Dano[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_id_Dano; // Add input parameter
			if (arrfieldopr_x_id_Dano.length >= 3) {
				a_search += arrfieldopr_x_id_Dano[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Descricao_do_problema
String ascrh_x_Descricao_do_problema = request.getParameter("x_Descricao_do_problema");
String z_Descricao_do_problema = request.getParameter("z_Descricao_do_problema");
	if (z_Descricao_do_problema != null && z_Descricao_do_problema.length() > 0 ) {
		String [] arrfieldopr_x_Descricao_do_problema = z_Descricao_do_problema.split(",");
		if (ascrh_x_Descricao_do_problema != null && ascrh_x_Descricao_do_problema.length() > 0) {
			ascrh_x_Descricao_do_problema = ascrh_x_Descricao_do_problema.replaceAll("'",escapeString);
			ascrh_x_Descricao_do_problema = ascrh_x_Descricao_do_problema.replaceAll("\\[","[[]");
			a_search += "`Descricao_do_problema` "; // Add field
			a_search += arrfieldopr_x_Descricao_do_problema[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Descricao_do_problema.length >= 2) {
				a_search += arrfieldopr_x_Descricao_do_problema[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Descricao_do_problema; // Add input parameter
			if (arrfieldopr_x_Descricao_do_problema.length >= 3) {
				a_search += arrfieldopr_x_Descricao_do_problema[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Imagem
String ascrh_x_Imagem = request.getParameter("x_Imagem");
String z_Imagem = request.getParameter("z_Imagem");
	if (z_Imagem != null && z_Imagem.length() > 0 ) {
		String [] arrfieldopr_x_Imagem = z_Imagem.split(",");
		if (ascrh_x_Imagem != null && ascrh_x_Imagem.length() > 0) {
			ascrh_x_Imagem = ascrh_x_Imagem.replaceAll("'",escapeString);
			ascrh_x_Imagem = ascrh_x_Imagem.replaceAll("\\[","[[]");
			a_search += "`Imagem` "; // Add field
			a_search += arrfieldopr_x_Imagem[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Imagem.length >= 2) {
				a_search += arrfieldopr_x_Imagem[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Imagem; // Add input parameter
			if (arrfieldopr_x_Imagem.length >= 3) {
				a_search += arrfieldopr_x_Imagem[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Video
String ascrh_x_Video = request.getParameter("x_Video");
String z_Video = request.getParameter("z_Video");
	if (z_Video != null && z_Video.length() > 0 ) {
		String [] arrfieldopr_x_Video = z_Video.split(",");
		if (ascrh_x_Video != null && ascrh_x_Video.length() > 0) {
			ascrh_x_Video = ascrh_x_Video.replaceAll("'",escapeString);
			ascrh_x_Video = ascrh_x_Video.replaceAll("\\[","[[]");
			a_search += "`Video` "; // Add field
			a_search += arrfieldopr_x_Video[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Video.length >= 2) {
				a_search += arrfieldopr_x_Video[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Video; // Add input parameter
			if (arrfieldopr_x_Video.length >= 3) {
				a_search += arrfieldopr_x_Video[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Som
String ascrh_x_Som = request.getParameter("x_Som");
String z_Som = request.getParameter("z_Som");
	if (z_Som != null && z_Som.length() > 0 ) {
		String [] arrfieldopr_x_Som = z_Som.split(",");
		if (ascrh_x_Som != null && ascrh_x_Som.length() > 0) {
			ascrh_x_Som = ascrh_x_Som.replaceAll("'",escapeString);
			ascrh_x_Som = ascrh_x_Som.replaceAll("\\[","[[]");
			a_search += "`Som` "; // Add field
			a_search += arrfieldopr_x_Som[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Som.length >= 2) {
				a_search += arrfieldopr_x_Som[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Som; // Add input parameter
			if (arrfieldopr_x_Som.length >= 3) {
				a_search += arrfieldopr_x_Som[2].trim(); // Add search suffix
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
			b_search = b_search + "`Descricao_do_problema` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Imagem` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Video` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Som` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Login` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`Descricao_do_problema` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Imagem` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Video` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Som` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("problemas_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("problemas_REC", new Integer(startRec));
}else{
	if (session.getAttribute("problemas_searchwhere") != null)
		searchwhere = (String) session.getAttribute("problemas_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("problemas_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("problemas_searchwhere", searchwhere);
    	key_m = "";
		session.setAttribute("problemas_masterkey", key_m); // Clear master key
    	masterdetailwhere = "";
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("problemas_REC", new Integer(startRec));
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
	if (session.getAttribute("problemas_OB") != null &&
		((String) session.getAttribute("problemas_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("problemas_OT")).equals("ASC")) {
			session.setAttribute("problemas_OT", "DESC");
		}else{
			session.setAttribute("problemas_OT", "ASC");
		}
	}else{
		session.setAttribute("problemas_OT", "ASC");
	}
	session.setAttribute("problemas_OB", OrderBy);
	session.setAttribute("problemas_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("problemas_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("problemas_OB", OrderBy);
		session.setAttribute("problemas_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `problemas`";
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("problemas_OT");
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
	session.setAttribute("problemas_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("problemas_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("problemas_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("problemas_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("problemas_REC") != null)
		startRec = ((Integer) session.getAttribute("problemas_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("problemas_REC", new Integer(startRec));
	}
}
%>
<%
ResultSet rsMas = null;
Statement stmtMas = null;
if (key_m != null && key_m.length() > 0) {
	String strmassql = "SELECT * FROM `movimentacao` WHERE ";
	strmassql = strmassql + "(`id_Movimentacao` = " + key_m.replaceAll("'",escapeString)  + ")";
	stmtMas = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	rsMas = stmtMas.executeQuery(strmassql);
}
%>
<%@ include file="header.jsp" %>
<%
if (key_m != null && key_m.length() > 0) {
	if (rsMas.next()) { %>
	<p><span class="jspmaker">Registro Mestre: Livro de ocorrencias<br><a href="movimentacaolist.jsp">Voltar a lista</a></span></p>
	<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
		<tr bgcolor="#594FBF">
			<td><span class="jspmaker" style="color: #FFFFFF;">Tombamento</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Siga</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Data da ocorrencia</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Situacao</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Detalhes da ocorrencia</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Garantia</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Lotacao de destino</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Quem movimentou?</span>&nbsp;</td>
		</tr>
		<tr bgcolor="#FFFFFF">
<%

    // Load Key for record
    String key = "";
    if (rsMas.getString("id_Movimentacao") != null){
    	key = rsMas.getString("id_Movimentacao");
		}else{
			key = "";
		}

		// id_Movimentacao
		String x_id_Movimentacao = "";
		x_id_Movimentacao = String.valueOf(rsMas.getLong("id_Movimentacao"));

		// id_Bem
		String x_id_Bem = "";
		x_id_Bem = String.valueOf(rsMas.getLong("id_Bem"));

		// Siga
		String x_Siga = "";
		x_Siga = String.valueOf(rsMas.getLong("Siga"));

		// Data_Entrada
		Timestamp x_Data_Entrada = null;
		if (rsMas.getTimestamp("Data_Entrada") != null){
			x_Data_Entrada = rsMas.getTimestamp("Data_Entrada");
		}else{
			x_Data_Entrada = null;
		}

		// Situacao
		String x_Situacao = "";
		x_Situacao = String.valueOf(rsMas.getLong("Situacao"));

		// Detalhes_da_Movimentacao
		String x_Detalhes_da_Movimentacao = "";
			if (rsMas.getClob("Detalhes_da_Movimentacao") != null) {
				long length = rsMas.getClob("Detalhes_da_Movimentacao").length();
				x_Detalhes_da_Movimentacao = rsMas.getClob("Detalhes_da_Movimentacao").getSubString((long) 1, (int) length);
			}else{
				x_Detalhes_da_Movimentacao = "";
			}

		// Garantia
		String x_Garantia = "";
		x_Garantia = String.valueOf(rsMas.getLong("Garantia"));

		// Lotacao_Destino
		String x_Lotacao_Destino = "";
		x_Lotacao_Destino = String.valueOf(rsMas.getLong("Lotacao_Destino"));

		// Resp_Transporte
		String x_Resp_Transporte = "";
		if (rsMas.getString("Resp_Transporte") != null){
			x_Resp_Transporte = rsMas.getString("Resp_Transporte");
		}else{
			x_Resp_Transporte = "";
		}

		// Login
		String x_Login = "";
		if (rsMas.getString("Login") != null){
			x_Login = rsMas.getString("Login");
		}else{
			x_Login = "";
		}
%>
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
<p><span class="jspmaker">TABELA: Problemas</span></p>
<form action="problemaslist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Procura rapida (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="OK">
		&nbsp;&nbsp;<a href="problemaslist.jsp?cmd=reset">Mostrar todos</a>
		&nbsp;&nbsp;<a href="problemassrch.jsp">Busca avancada</a>
		</span></td>
	</tr>
	<tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Frase exata&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">Todas as palavras&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Qualquer palavra</span></td></tr>
</table>
</form>
<form method="post">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="problemaslist.jsp?order=<%= java.net.URLEncoder.encode("id_Dano","UTF-8") %>" style="color: #FFFFFF;">Dano&nbsp;<% if (OrderBy != null && OrderBy.equals("id_Dano")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("problemas_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("problemas_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Descricao do problema&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Descricao_do_problema")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("problemas_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("problemas_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Imagem&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Imagem")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("problemas_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("problemas_OT")).equals("DESC")) { %>6<% } %></span><% } %>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Audio-visual&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Video")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("problemas_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("problemas_OT")).equals("DESC")) { %>6<% } %></span><% } %>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Audio-visual (cont)&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Som")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("problemas_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("problemas_OT")).equals("DESC")) { %>6<% } %></span><% } %>
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
<td>&nbsp;</td>
<td>&nbsp;</td>
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
	String x_id_Problema = "";
	String x_id_Movimentacao = "";
	String x_id_Dano = "";
	String x_Descricao_do_problema = "";
	String x_Imagem = "";
	String x_Video = "";
	String x_Som = "";
	String x_Login = "";

	// Load Key for record
	String key = "";

	// id_Problema
	x_id_Problema = String.valueOf(rs.getLong("id_Problema"));

	// id_Movimentacao
	x_id_Movimentacao = String.valueOf(rs.getLong("id_Movimentacao"));

	// id_Dano
	x_id_Dano = String.valueOf(rs.getLong("id_Dano"));

	// Descricao_do_problema
	if (rs.getClob("Descricao_do_problema") != null) {
		long length = rs.getClob("Descricao_do_problema").length();
		x_Descricao_do_problema = rs.getClob("Descricao_do_problema").getSubString((long) 1, (int) length);
	}else{
		x_Descricao_do_problema = "";
	}

	// Imagem
	if (rs.getString("Imagem") != null){
		x_Imagem = rs.getString("Imagem");
	}else{
		x_Imagem = "";
	}

	// Video
	if (rs.getString("Video") != null){
		x_Video = rs.getString("Video");
	}else{
		x_Video = "";
	}

	// Som
	if (rs.getString("Som") != null){
		x_Som = rs.getString("Som");
	}else{
		x_Som = "";
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
if (x_id_Dano!=null && ((String)x_id_Dano).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Dano;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Dano` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Dano`, `Descricao_do_dano` FROM `tipos_de_dano`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("Descricao_do_dano"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
</span>&nbsp;</td>
		<td><span class="jspmaker"><% if (x_Descricao_do_problema != null) { out.print(((String)x_Descricao_do_problema).replaceAll("\r\n", "<br>"));} %></span>&nbsp;</td>
		<td><span class="jspmaker"><% if (x_Imagem != null && ((String)x_Imagem).length() > 0) { %>
<a href="uploads/<%= x_Imagem %>" target="blank"><img src="uploads/<%= x_Imagem %>" border="0"></a>
<% } %>
</span>&nbsp;</td>
		<td><span class="jspmaker"><% if (x_Video != null && ((String)x_Video).length() > 0) { %>
<a href="uploads/<%= x_Video %>" target="blank"><%= x_Video %></a>
<% } %>
</span>&nbsp;</td>
		<td><span class="jspmaker"><% if (x_Som != null && ((String)x_Som).length() > 0) { %>
<a href="uploads/<%= x_Som %>" target="blank"><%= x_Som %></a>
<% } %>
</span>&nbsp;</td>
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Problema"); 
if (key != null && key.length() > 0) { 
	out.print("problemasview.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Visualizar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Problema"); 
if (key != null && key.length() > 0) { 
	out.print("problemasedit.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Editar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Problema"); 
if (key != null && key.length() > 0) { 
	out.print("problemasdelete.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Excluir</a></span></td>
<% } %>
<td><span class="jspmaker"><a href="instal_componenteslist.jsp?key_m=<%= x_id_Problema %>">Instalacao de componentes Detalhes</a></span></td>
<td><span class="jspmaker"><a href="retirada_de_componenteslist.jsp?key_m=<%= x_id_Problema %>">Retirada de componentes Detalhes</a></span></td>
<td><span class="jspmaker"><a href="solucoeslist.jsp?key_m=<%= x_id_Problema %>">Solucoes Detalhes</a></span></td>
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
	<td><a href="problemaslist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="problemaslist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="problemaslist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="problemaslist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
	<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<td><a href="problemasadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a></td>
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
<a href="problemasadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
