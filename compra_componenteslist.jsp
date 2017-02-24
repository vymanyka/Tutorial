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
ew_SecTable[0] = 11;
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
	session.setAttribute("compra_componentes_masterkey", key_m); // Save master key to session

	// Reset start record counter (new master key)
	startRec = 0;
	session.setAttribute("compra_componentes_REC", new Integer(startRec));
} else {
	key_m = (String) session.getAttribute("compra_componentes_masterkey"); // Restore master key from session
}
String masterdatailwhere;
if (key_m != null && key_m.length() > 0) {
	masterdetailwhere = "`idPedido_Compra` = " + key_m.replaceAll("'",escapeString) + "";
}
%>
<%

// Get search criteria for advanced search
// id_Compra_Componentes

String ascrh_x_id_Compra_Componentes = request.getParameter("x_id_Compra_Componentes");
String z_id_Compra_Componentes = request.getParameter("z_id_Compra_Componentes");
	if (z_id_Compra_Componentes != null && z_id_Compra_Componentes.length() > 0 ) {
		String [] arrfieldopr_x_id_Compra_Componentes = z_id_Compra_Componentes.split(",");
		if (ascrh_x_id_Compra_Componentes != null && ascrh_x_id_Compra_Componentes.length() > 0) {
			ascrh_x_id_Compra_Componentes = ascrh_x_id_Compra_Componentes.replaceAll("'",escapeString);
			ascrh_x_id_Compra_Componentes = ascrh_x_id_Compra_Componentes.replaceAll("\\[","[[]");
			a_search += "`id_Compra_Componentes` "; // Add field
			a_search += arrfieldopr_x_id_Compra_Componentes[0].trim() + " "; // Add operator
			if (arrfieldopr_x_id_Compra_Componentes.length >= 2) {
				a_search += arrfieldopr_x_id_Compra_Componentes[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_id_Compra_Componentes; // Add input parameter
			if (arrfieldopr_x_id_Compra_Componentes.length >= 3) {
				a_search += arrfieldopr_x_id_Compra_Componentes[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

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

// Qtd_comprada
String ascrh_x_Qtd_comprada = request.getParameter("x_Qtd_comprada");
String z_Qtd_comprada = request.getParameter("z_Qtd_comprada");
	if (z_Qtd_comprada != null && z_Qtd_comprada.length() > 0 ) {
		String [] arrfieldopr_x_Qtd_comprada = z_Qtd_comprada.split(",");
		if (ascrh_x_Qtd_comprada != null && ascrh_x_Qtd_comprada.length() > 0) {
			ascrh_x_Qtd_comprada = ascrh_x_Qtd_comprada.replaceAll("'",escapeString);
			ascrh_x_Qtd_comprada = ascrh_x_Qtd_comprada.replaceAll("\\[","[[]");
			a_search += "`Qtd_comprada` "; // Add field
			a_search += arrfieldopr_x_Qtd_comprada[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Qtd_comprada.length >= 2) {
				a_search += arrfieldopr_x_Qtd_comprada[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Qtd_comprada; // Add input parameter
			if (arrfieldopr_x_Qtd_comprada.length >= 3) {
				a_search += arrfieldopr_x_Qtd_comprada[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Estado_do_componente
String ascrh_x_Estado_do_componente = request.getParameter("x_Estado_do_componente");
String z_Estado_do_componente = request.getParameter("z_Estado_do_componente");
	if (z_Estado_do_componente != null && z_Estado_do_componente.length() > 0 ) {
		String [] arrfieldopr_x_Estado_do_componente = z_Estado_do_componente.split(",");
		if (ascrh_x_Estado_do_componente != null && ascrh_x_Estado_do_componente.length() > 0) {
			ascrh_x_Estado_do_componente = ascrh_x_Estado_do_componente.replaceAll("'",escapeString);
			ascrh_x_Estado_do_componente = ascrh_x_Estado_do_componente.replaceAll("\\[","[[]");
			a_search += "`Estado_do_componente` "; // Add field
			a_search += arrfieldopr_x_Estado_do_componente[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Estado_do_componente.length >= 2) {
				a_search += arrfieldopr_x_Estado_do_componente[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Estado_do_componente; // Add input parameter
			if (arrfieldopr_x_Estado_do_componente.length >= 3) {
				a_search += arrfieldopr_x_Estado_do_componente[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Data_compra
String ascrh_x_Data_compra = request.getParameter("x_Data_compra");
String z_Data_compra = request.getParameter("z_Data_compra");
	if (z_Data_compra != null && z_Data_compra.length() > 0 ) {
		String [] arrfieldopr_x_Data_compra = z_Data_compra.split(",");
		if (ascrh_x_Data_compra != null && ascrh_x_Data_compra.length() > 0) {
			ascrh_x_Data_compra = ascrh_x_Data_compra.replaceAll("'",escapeString);
			ascrh_x_Data_compra = ascrh_x_Data_compra.replaceAll("\\[","[[]");
			a_search += "`Data_compra` "; // Add field
			a_search += arrfieldopr_x_Data_compra[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Data_compra.length >= 2) {
				a_search += arrfieldopr_x_Data_compra[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Data_compra; // Add input parameter
			if (arrfieldopr_x_Data_compra.length >= 3) {
				a_search += arrfieldopr_x_Data_compra[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Valor_total_compra
String ascrh_x_Valor_total_compra = request.getParameter("x_Valor_total_compra");
String z_Valor_total_compra = request.getParameter("z_Valor_total_compra");
	if (z_Valor_total_compra != null && z_Valor_total_compra.length() > 0 ) {
		String [] arrfieldopr_x_Valor_total_compra = z_Valor_total_compra.split(",");
		if (ascrh_x_Valor_total_compra != null && ascrh_x_Valor_total_compra.length() > 0) {
			ascrh_x_Valor_total_compra = ascrh_x_Valor_total_compra.replaceAll("'",escapeString);
			ascrh_x_Valor_total_compra = ascrh_x_Valor_total_compra.replaceAll("\\[","[[]");
			a_search += "`Valor_total_compra` "; // Add field
			a_search += arrfieldopr_x_Valor_total_compra[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Valor_total_compra.length >= 2) {
				a_search += arrfieldopr_x_Valor_total_compra[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Valor_total_compra; // Add input parameter
			if (arrfieldopr_x_Valor_total_compra.length >= 3) {
				a_search += arrfieldopr_x_Valor_total_compra[2].trim(); // Add search suffix
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
			b_search = b_search + "`Login` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
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
	session.setAttribute("compra_componentes_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("compra_componentes_REC", new Integer(startRec));
}else{
	if (session.getAttribute("compra_componentes_searchwhere") != null)
		searchwhere = (String) session.getAttribute("compra_componentes_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("compra_componentes_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("compra_componentes_searchwhere", searchwhere);
    	key_m = "";
		session.setAttribute("compra_componentes_masterkey", key_m); // Clear master key
    	masterdetailwhere = "";
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("compra_componentes_REC", new Integer(startRec));
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
	if (session.getAttribute("compra_componentes_OB") != null &&
		((String) session.getAttribute("compra_componentes_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("compra_componentes_OT")).equals("ASC")) {
			session.setAttribute("compra_componentes_OT", "DESC");
		}else{
			session.setAttribute("compra_componentes_OT", "ASC");
		}
	}else{
		session.setAttribute("compra_componentes_OT", "ASC");
	}
	session.setAttribute("compra_componentes_OB", OrderBy);
	session.setAttribute("compra_componentes_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("compra_componentes_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("compra_componentes_OB", OrderBy);
		session.setAttribute("compra_componentes_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `compra_componentes`";
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("compra_componentes_OT");
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
	session.setAttribute("compra_componentes_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("compra_componentes_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("compra_componentes_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("compra_componentes_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("compra_componentes_REC") != null)
		startRec = ((Integer) session.getAttribute("compra_componentes_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("compra_componentes_REC", new Integer(startRec));
	}
}
%>
<%
ResultSet rsMas = null;
Statement stmtMas = null;
if (key_m != null && key_m.length() > 0) {
	String strmassql = "SELECT * FROM `pedido_compra` WHERE ";
	strmassql = strmassql + "(`idPedido_Compra` = " + key_m.replaceAll("'",escapeString)  + ")";
	stmtMas = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	rsMas = stmtMas.executeQuery(strmassql);
}
%>
<%@ include file="header.jsp" %>
<%
if (key_m != null && key_m.length() > 0) {
	if (rsMas.next()) { %>
	<p><span class="jspmaker">Registro Mestre: Pedidos de compra<br><a href="pedido_compralist.jsp">Voltar a lista</a></span></p>
	<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
		<tr bgcolor="#594FBF">
			<td><span class="jspmaker" style="color: #FFFFFF;">Numero do Pedido</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Observacao</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Tipo de Compra</span>&nbsp;</td>
		</tr>
		<tr bgcolor="#FFFFFF">
<%

    // Load Key for record
    String key = "";
    if (rsMas.getString("idPedido_Compra") != null){
    	key = rsMas.getString("idPedido_Compra");
		}else{
			key = "";
		}

		// idPedido_Compra
		String x_idPedido_Compra = "";
		x_idPedido_Compra = String.valueOf(rsMas.getLong("idPedido_Compra"));

		// Numero_Pedido
		String x_Numero_Pedido = "";
		if (rsMas.getString("Numero_Pedido") != null){
			x_Numero_Pedido = rsMas.getString("Numero_Pedido");
		}else{
			x_Numero_Pedido = "";
		}

		// Observacao
		String x_Observacao = "";
			if (rsMas.getClob("Observacao") != null) {
				long length = rsMas.getClob("Observacao").length();
				x_Observacao = rsMas.getClob("Observacao").getSubString((long) 1, (int) length);
			}else{
				x_Observacao = "";
			}

		// Tipo_de_Compra
		String x_Tipo_de_Compra = "";
		x_Tipo_de_Compra = String.valueOf(rsMas.getLong("Tipo_de_Compra"));

		// Login
		String x_Login = "";
		if (rsMas.getString("Login") != null){
			x_Login = rsMas.getString("Login");
		}else{
			x_Login = "";
		}
%>
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
<p><span class="jspmaker">TABELA: Compra de componentes</span></p>
<form action="compra_componenteslist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Procura rapida (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="OK">
		&nbsp;&nbsp;<a href="compra_componenteslist.jsp?cmd=reset">Mostrar todos</a>
		&nbsp;&nbsp;<a href="compra_componentessrch.jsp">Busca avancada</a>
		</span></td>
	</tr>
	<tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Frase exata&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">Todas as palavras&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Qualquer palavra</span></td></tr>
</table>
</form>
<form method="post">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="compra_componenteslist.jsp?order=<%= java.net.URLEncoder.encode("id_Componente","UTF-8") %>" style="color: #FFFFFF;">Componente&nbsp;<% if (OrderBy != null && OrderBy.equals("id_Componente")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("compra_componentes_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("compra_componentes_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="compra_componenteslist.jsp?order=<%= java.net.URLEncoder.encode("idFornecedores","UTF-8") %>" style="color: #FFFFFF;">Fornecedor&nbsp;<% if (OrderBy != null && OrderBy.equals("idFornecedores")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("compra_componentes_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("compra_componentes_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="compra_componenteslist.jsp?order=<%= java.net.URLEncoder.encode("idPedido_Compra","UTF-8") %>" style="color: #FFFFFF;">Pedido de Compra&nbsp;<% if (OrderBy != null && OrderBy.equals("idPedido_Compra")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("compra_componentes_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("compra_componentes_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="compra_componenteslist.jsp?order=<%= java.net.URLEncoder.encode("Qtd_comprada","UTF-8") %>" style="color: #FFFFFF;">Qtd comprada&nbsp;<% if (OrderBy != null && OrderBy.equals("Qtd_comprada")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("compra_componentes_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("compra_componentes_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="compra_componenteslist.jsp?order=<%= java.net.URLEncoder.encode("Estado_do_componente","UTF-8") %>" style="color: #FFFFFF;">Estado do componente&nbsp;<% if (OrderBy != null && OrderBy.equals("Estado_do_componente")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("compra_componentes_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("compra_componentes_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="compra_componenteslist.jsp?order=<%= java.net.URLEncoder.encode("Data_compra","UTF-8") %>" style="color: #FFFFFF;">Data compra&nbsp;<% if (OrderBy != null && OrderBy.equals("Data_compra")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("compra_componentes_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("compra_componentes_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="compra_componenteslist.jsp?order=<%= java.net.URLEncoder.encode("Valor_total_compra","UTF-8") %>" style="color: #FFFFFF;">Valor total da compra&nbsp;<% if (OrderBy != null && OrderBy.equals("Valor_total_compra")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("compra_componentes_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("compra_componentes_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
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
	String x_id_Compra_Componentes = "";
	String x_id_Componente = "";
	String x_idFornecedores = "";
	String x_idPedido_Compra = "";
	String x_Qtd_comprada = "";
	String x_Estado_do_componente = "";
	Object x_Data_compra = null;
	String x_Valor_total_compra = "";
	String x_Login = "";

	// Load Key for record
	String key = "";

	// id_Compra_Componentes
	x_id_Compra_Componentes = String.valueOf(rs.getLong("id_Compra_Componentes"));

	// id_Componente
	x_id_Componente = String.valueOf(rs.getLong("id_Componente"));

	// idFornecedores
	x_idFornecedores = String.valueOf(rs.getLong("idFornecedores"));

	// idPedido_Compra
	x_idPedido_Compra = String.valueOf(rs.getLong("idPedido_Compra"));

	// Qtd_comprada
	x_Qtd_comprada = String.valueOf(rs.getLong("Qtd_comprada"));

	// Estado_do_componente
	x_Estado_do_componente = String.valueOf(rs.getLong("Estado_do_componente"));

	// Data_compra
	if (rs.getTimestamp("Data_compra") != null){
		x_Data_compra = rs.getTimestamp("Data_compra");
	}else{
		x_Data_compra = "";
	}

	// Valor_total_compra
	x_Valor_total_compra = String.valueOf(rs.getDouble("Valor_total_compra"));

	// Login
	if (rs.getString("Login") != null){
		x_Login = rs.getString("Login");
	}else{
		x_Login = "";
	}
%>
	<tr bgcolor="<%= bgcolor %>">
		<td><span class="jspmaker"><%
if (x_id_Componente!=null && ((String)x_id_Componente).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Componente;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Componente` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Componente`, `Descricao_do_componente` FROM `componentes`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("Descricao_do_componente"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
</span>&nbsp;</td>
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
		<td><span class="jspmaker"><%
if (x_idPedido_Compra!=null && ((String)x_idPedido_Compra).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_idPedido_Compra;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`idPedido_Compra` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `idPedido_Compra`, `Numero_Pedido` FROM `pedido_compra`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("Numero_Pedido"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
</span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_Qtd_comprada); %></span>&nbsp;</td>
		<td><span class="jspmaker"><%
String tmpValuex_Estado_do_componente = (String) x_Estado_do_componente;
if (tmpValuex_Estado_do_componente.equals("1")) {
	out.print("Novo");
}
if (tmpValuex_Estado_do_componente.equals("2")) {
	out.print("Seminovo");
}
if (tmpValuex_Estado_do_componente.equals("3")) {
	out.print("Recuperavel");
}
if (tmpValuex_Estado_do_componente.equals("4")) {
	out.print("Irrecuperavel");
}
%>
</span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(EW_FormatDateTime(x_Data_compra,7,locale)); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_Valor_total_compra); %></span>&nbsp;</td>
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Compra_Componentes"); 
if (key != null && key.length() > 0) { 
	out.print("compra_componentesview.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Visualizar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Compra_Componentes"); 
if (key != null && key.length() > 0) { 
	out.print("compra_componentesedit.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Editar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Compra_Componentes"); 
if (key != null && key.length() > 0) { 
	out.print("compra_componentesadd.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Copiar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Compra_Componentes"); 
if (key != null && key.length() > 0) { 
	out.print("compra_componentesdelete.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
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
	<td><a href="compra_componenteslist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="compra_componenteslist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="compra_componenteslist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="compra_componenteslist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
	<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<td><a href="compra_componentesadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a></td>
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
<a href="compra_componentesadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
