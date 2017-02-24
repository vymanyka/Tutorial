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
	session.setAttribute("retirada_de_componentes_masterkey", key_m); // Save master key to session

	// Reset start record counter (new master key)
	startRec = 0;
	session.setAttribute("retirada_de_componentes_REC", new Integer(startRec));
} else {
	key_m = (String) session.getAttribute("retirada_de_componentes_masterkey"); // Restore master key from session
}
String masterdatailwhere;
if (key_m != null && key_m.length() > 0) {
	masterdetailwhere = "`id_Problema` = " + key_m.replaceAll("'",escapeString) + "";
}
%>
<%

// Get search criteria for advanced search
// id_Retirada_de_Componentes

String ascrh_x_id_Retirada_de_Componentes = request.getParameter("x_id_Retirada_de_Componentes");
String z_id_Retirada_de_Componentes = request.getParameter("z_id_Retirada_de_Componentes");
	if (z_id_Retirada_de_Componentes != null && z_id_Retirada_de_Componentes.length() > 0 ) {
		String [] arrfieldopr_x_id_Retirada_de_Componentes = z_id_Retirada_de_Componentes.split(",");
		if (ascrh_x_id_Retirada_de_Componentes != null && ascrh_x_id_Retirada_de_Componentes.length() > 0) {
			ascrh_x_id_Retirada_de_Componentes = ascrh_x_id_Retirada_de_Componentes.replaceAll("'",escapeString);
			ascrh_x_id_Retirada_de_Componentes = ascrh_x_id_Retirada_de_Componentes.replaceAll("\\[","[[]");
			a_search += "`id_Retirada_de_Componentes` "; // Add field
			a_search += arrfieldopr_x_id_Retirada_de_Componentes[0].trim() + " "; // Add operator
			if (arrfieldopr_x_id_Retirada_de_Componentes.length >= 2) {
				a_search += arrfieldopr_x_id_Retirada_de_Componentes[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_id_Retirada_de_Componentes; // Add input parameter
			if (arrfieldopr_x_id_Retirada_de_Componentes.length >= 3) {
				a_search += arrfieldopr_x_id_Retirada_de_Componentes[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

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

// Qtd_retirada
String ascrh_x_Qtd_retirada = request.getParameter("x_Qtd_retirada");
String z_Qtd_retirada = request.getParameter("z_Qtd_retirada");
	if (z_Qtd_retirada != null && z_Qtd_retirada.length() > 0 ) {
		String [] arrfieldopr_x_Qtd_retirada = z_Qtd_retirada.split(",");
		if (ascrh_x_Qtd_retirada != null && ascrh_x_Qtd_retirada.length() > 0) {
			ascrh_x_Qtd_retirada = ascrh_x_Qtd_retirada.replaceAll("'",escapeString);
			ascrh_x_Qtd_retirada = ascrh_x_Qtd_retirada.replaceAll("\\[","[[]");
			a_search += "`Qtd_retirada` "; // Add field
			a_search += arrfieldopr_x_Qtd_retirada[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Qtd_retirada.length >= 2) {
				a_search += arrfieldopr_x_Qtd_retirada[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Qtd_retirada; // Add input parameter
			if (arrfieldopr_x_Qtd_retirada.length >= 3) {
				a_search += arrfieldopr_x_Qtd_retirada[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Data_retirada
String ascrh_x_Data_retirada = request.getParameter("x_Data_retirada");
String z_Data_retirada = request.getParameter("z_Data_retirada");
	if (z_Data_retirada != null && z_Data_retirada.length() > 0 ) {
		String [] arrfieldopr_x_Data_retirada = z_Data_retirada.split(",");
		if (ascrh_x_Data_retirada != null && ascrh_x_Data_retirada.length() > 0) {
			ascrh_x_Data_retirada = ascrh_x_Data_retirada.replaceAll("'",escapeString);
			ascrh_x_Data_retirada = ascrh_x_Data_retirada.replaceAll("\\[","[[]");
			a_search += "`Data_retirada` "; // Add field
			a_search += arrfieldopr_x_Data_retirada[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Data_retirada.length >= 2) {
				a_search += arrfieldopr_x_Data_retirada[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Data_retirada; // Add input parameter
			if (arrfieldopr_x_Data_retirada.length >= 3) {
				a_search += arrfieldopr_x_Data_retirada[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Destino_do_componente
String ascrh_x_Destino_do_componente = request.getParameter("x_Destino_do_componente");
String z_Destino_do_componente = request.getParameter("z_Destino_do_componente");
	if (z_Destino_do_componente != null && z_Destino_do_componente.length() > 0 ) {
		String [] arrfieldopr_x_Destino_do_componente = z_Destino_do_componente.split(",");
		if (ascrh_x_Destino_do_componente != null && ascrh_x_Destino_do_componente.length() > 0) {
			ascrh_x_Destino_do_componente = ascrh_x_Destino_do_componente.replaceAll("'",escapeString);
			ascrh_x_Destino_do_componente = ascrh_x_Destino_do_componente.replaceAll("\\[","[[]");
			a_search += "`Destino_do_componente` "; // Add field
			a_search += arrfieldopr_x_Destino_do_componente[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Destino_do_componente.length >= 2) {
				a_search += arrfieldopr_x_Destino_do_componente[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Destino_do_componente; // Add input parameter
			if (arrfieldopr_x_Destino_do_componente.length >= 3) {
				a_search += arrfieldopr_x_Destino_do_componente[2].trim(); // Add search suffix
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

// Relacao_confianca
String ascrh_x_Relacao_confianca = request.getParameter("x_Relacao_confianca");
String z_Relacao_confianca = request.getParameter("z_Relacao_confianca");
	if (z_Relacao_confianca != null && z_Relacao_confianca.length() > 0 ) {
		String [] arrfieldopr_x_Relacao_confianca = z_Relacao_confianca.split(",");
		if (ascrh_x_Relacao_confianca != null && ascrh_x_Relacao_confianca.length() > 0) {
			ascrh_x_Relacao_confianca = ascrh_x_Relacao_confianca.replaceAll("'",escapeString);
			ascrh_x_Relacao_confianca = ascrh_x_Relacao_confianca.replaceAll("\\[","[[]");
			a_search += "`Relacao_confianca` "; // Add field
			a_search += arrfieldopr_x_Relacao_confianca[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Relacao_confianca.length >= 2) {
				a_search += arrfieldopr_x_Relacao_confianca[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Relacao_confianca; // Add input parameter
			if (arrfieldopr_x_Relacao_confianca.length >= 3) {
				a_search += arrfieldopr_x_Relacao_confianca[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Com_quem
String ascrh_x_Com_quem = request.getParameter("x_Com_quem");
String z_Com_quem = request.getParameter("z_Com_quem");
	if (z_Com_quem != null && z_Com_quem.length() > 0 ) {
		String [] arrfieldopr_x_Com_quem = z_Com_quem.split(",");
		if (ascrh_x_Com_quem != null && ascrh_x_Com_quem.length() > 0) {
			ascrh_x_Com_quem = ascrh_x_Com_quem.replaceAll("'",escapeString);
			ascrh_x_Com_quem = ascrh_x_Com_quem.replaceAll("\\[","[[]");
			a_search += "`Com_quem` "; // Add field
			a_search += arrfieldopr_x_Com_quem[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Com_quem.length >= 2) {
				a_search += arrfieldopr_x_Com_quem[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Com_quem; // Add input parameter
			if (arrfieldopr_x_Com_quem.length >= 3) {
				a_search += arrfieldopr_x_Com_quem[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Telefone_confianca
String ascrh_x_Telefone_confianca = request.getParameter("x_Telefone_confianca");
String z_Telefone_confianca = request.getParameter("z_Telefone_confianca");
	if (z_Telefone_confianca != null && z_Telefone_confianca.length() > 0 ) {
		String [] arrfieldopr_x_Telefone_confianca = z_Telefone_confianca.split(",");
		if (ascrh_x_Telefone_confianca != null && ascrh_x_Telefone_confianca.length() > 0) {
			ascrh_x_Telefone_confianca = ascrh_x_Telefone_confianca.replaceAll("'",escapeString);
			ascrh_x_Telefone_confianca = ascrh_x_Telefone_confianca.replaceAll("\\[","[[]");
			a_search += "`Telefone_confianca` "; // Add field
			a_search += arrfieldopr_x_Telefone_confianca[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Telefone_confianca.length >= 2) {
				a_search += arrfieldopr_x_Telefone_confianca[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Telefone_confianca; // Add input parameter
			if (arrfieldopr_x_Telefone_confianca.length >= 3) {
				a_search += arrfieldopr_x_Telefone_confianca[2].trim(); // Add search suffix
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
			b_search = b_search + "`Imagem` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Video` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Som` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Com_quem` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Telefone_confianca` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Login` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`Imagem` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Video` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Som` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Com_quem` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Telefone_confianca` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("retirada_de_componentes_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("retirada_de_componentes_REC", new Integer(startRec));
}else{
	if (session.getAttribute("retirada_de_componentes_searchwhere") != null)
		searchwhere = (String) session.getAttribute("retirada_de_componentes_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("retirada_de_componentes_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("retirada_de_componentes_searchwhere", searchwhere);
    	key_m = "";
		session.setAttribute("retirada_de_componentes_masterkey", key_m); // Clear master key
    	masterdetailwhere = "";
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("retirada_de_componentes_REC", new Integer(startRec));
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
	if (session.getAttribute("retirada_de_componentes_OB") != null &&
		((String) session.getAttribute("retirada_de_componentes_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("ASC")) {
			session.setAttribute("retirada_de_componentes_OT", "DESC");
		}else{
			session.setAttribute("retirada_de_componentes_OT", "ASC");
		}
	}else{
		session.setAttribute("retirada_de_componentes_OT", "ASC");
	}
	session.setAttribute("retirada_de_componentes_OB", OrderBy);
	session.setAttribute("retirada_de_componentes_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("retirada_de_componentes_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("retirada_de_componentes_OB", OrderBy);
		session.setAttribute("retirada_de_componentes_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `retirada_de_componentes`";
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("retirada_de_componentes_OT");
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
	session.setAttribute("retirada_de_componentes_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("retirada_de_componentes_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("retirada_de_componentes_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("retirada_de_componentes_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("retirada_de_componentes_REC") != null)
		startRec = ((Integer) session.getAttribute("retirada_de_componentes_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("retirada_de_componentes_REC", new Integer(startRec));
	}
}
%>
<%
ResultSet rsMas = null;
Statement stmtMas = null;
if (key_m != null && key_m.length() > 0) {
	String strmassql = "SELECT * FROM `problemas` WHERE ";
	strmassql = strmassql + "(`id_Problema` = " + key_m.replaceAll("'",escapeString)  + ")";
	stmtMas = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	rsMas = stmtMas.executeQuery(strmassql);
}
%>
<%@ include file="header.jsp" %>
<%
if (key_m != null && key_m.length() > 0) {
	if (rsMas.next()) { %>
	<p><span class="jspmaker">Registro Mestre: Problemas<br><a href="problemaslist.jsp">Voltar a lista</a></span></p>
	<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
		<tr bgcolor="#594FBF">
			<td><span class="jspmaker" style="color: #FFFFFF;">Dano</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Descricao do problema</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Imagem</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Audio-visual</span>&nbsp;</td>
			<td><span class="jspmaker" style="color: #FFFFFF;">Audio-visual (cont)</span>&nbsp;</td>
		</tr>
		<tr bgcolor="#FFFFFF">
<%

    // Load Key for record
    String key = "";
    if (rsMas.getString("id_Problema") != null){
    	key = rsMas.getString("id_Problema");
		}else{
			key = "";
		}

		// id_Problema
		String x_id_Problema = "";
		x_id_Problema = String.valueOf(rsMas.getLong("id_Problema"));

		// id_Movimentacao
		String x_id_Movimentacao = "";
		x_id_Movimentacao = String.valueOf(rsMas.getLong("id_Movimentacao"));

		// id_Dano
		String x_id_Dano = "";
		x_id_Dano = String.valueOf(rsMas.getLong("id_Dano"));

		// Descricao_do_problema
		String x_Descricao_do_problema = "";
			if (rsMas.getClob("Descricao_do_problema") != null) {
				long length = rsMas.getClob("Descricao_do_problema").length();
				x_Descricao_do_problema = rsMas.getClob("Descricao_do_problema").getSubString((long) 1, (int) length);
			}else{
				x_Descricao_do_problema = "";
			}

		// Imagem
		String x_Imagem = "";
		if (rsMas.getString("Imagem") != null){
			x_Imagem = rsMas.getString("Imagem");
		}else{
			x_Imagem = "";
		}

		// Video
		String x_Video = "";
		if (rsMas.getString("Video") != null){
			x_Video = rsMas.getString("Video");
		}else{
			x_Video = "";
		}

		// Som
		String x_Som = "";
		if (rsMas.getString("Som") != null){
			x_Som = rsMas.getString("Som");
		}else{
			x_Som = "";
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
<p><span class="jspmaker">TABELA: Retirada de componentes</span></p>
<form action="retirada_de_componenteslist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Procura rapida (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="OK">
		&nbsp;&nbsp;<a href="retirada_de_componenteslist.jsp?cmd=reset">Mostrar todos</a>
		&nbsp;&nbsp;<a href="retirada_de_componentessrch.jsp">Busca avancada</a>
		</span></td>
	</tr>
	<tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Frase exata&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">Todas as palavras&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Qualquer palavra</span></td></tr>
</table>
</form>
<form method="post">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="retirada_de_componenteslist.jsp?order=<%= java.net.URLEncoder.encode("id_Componente","UTF-8") %>" style="color: #FFFFFF;">Componente&nbsp;<% if (OrderBy != null && OrderBy.equals("id_Componente")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="retirada_de_componenteslist.jsp?order=<%= java.net.URLEncoder.encode("Qtd_retirada","UTF-8") %>" style="color: #FFFFFF;">Qtd retirada&nbsp;<% if (OrderBy != null && OrderBy.equals("Qtd_retirada")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="retirada_de_componenteslist.jsp?order=<%= java.net.URLEncoder.encode("Data_retirada","UTF-8") %>" style="color: #FFFFFF;">Data retirada&nbsp;<% if (OrderBy != null && OrderBy.equals("Data_retirada")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="retirada_de_componenteslist.jsp?order=<%= java.net.URLEncoder.encode("Destino_do_componente","UTF-8") %>" style="color: #FFFFFF;">Estado do componente&nbsp;<% if (OrderBy != null && OrderBy.equals("Destino_do_componente")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Imagem&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Imagem")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("DESC")) { %>6<% } %></span><% } %>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Audio-visual&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Video")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("DESC")) { %>6<% } %></span><% } %>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Audio-visual (cont)&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Som")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("DESC")) { %>6<% } %></span><% } %>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="retirada_de_componenteslist.jsp?order=<%= java.net.URLEncoder.encode("Relacao_confianca","UTF-8") %>" style="color: #FFFFFF;">Tipo de retirada&nbsp;<% if (OrderBy != null && OrderBy.equals("Relacao_confianca")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="retirada_de_componenteslist.jsp?order=<%= java.net.URLEncoder.encode("Com_quem","UTF-8") %>" style="color: #FFFFFF;">Executor externo&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Com_quem")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="retirada_de_componenteslist.jsp?order=<%= java.net.URLEncoder.encode("Telefone_confianca","UTF-8") %>" style="color: #FFFFFF;">Telefone do executor&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Telefone_confianca")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("retirada_de_componentes_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
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
	String x_id_Retirada_de_Componentes = "";
	String x_id_Problema = "";
	String x_id_Componente = "";
	String x_Qtd_retirada = "";
	Object x_Data_retirada = null;
	String x_Destino_do_componente = "";
	String x_Imagem = "";
	String x_Video = "";
	String x_Som = "";
	String x_Relacao_confianca = "";
	String x_Com_quem = "";
	String x_Telefone_confianca = "";
	String x_Login = "";

	// Load Key for record
	String key = "";

	// id_Retirada_de_Componentes
	x_id_Retirada_de_Componentes = String.valueOf(rs.getLong("id_Retirada_de_Componentes"));

	// id_Problema
	x_id_Problema = String.valueOf(rs.getLong("id_Problema"));

	// id_Componente
	x_id_Componente = String.valueOf(rs.getLong("id_Componente"));

	// Qtd_retirada
	x_Qtd_retirada = String.valueOf(rs.getLong("Qtd_retirada"));

	// Data_retirada
	if (rs.getTimestamp("Data_retirada") != null){
		x_Data_retirada = rs.getTimestamp("Data_retirada");
	}else{
		x_Data_retirada = "";
	}

	// Destino_do_componente
	x_Destino_do_componente = String.valueOf(rs.getLong("Destino_do_componente"));

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

	// Relacao_confianca
	x_Relacao_confianca = String.valueOf(rs.getLong("Relacao_confianca"));

	// Com_quem
	if (rs.getString("Com_quem") != null){
		x_Com_quem = rs.getString("Com_quem");
	}else{
		x_Com_quem = "";
	}

	// Telefone_confianca
	if (rs.getString("Telefone_confianca") != null){
		x_Telefone_confianca = rs.getString("Telefone_confianca");
	}else{
		x_Telefone_confianca = "";
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
		<td><span class="jspmaker"><% out.print(x_Qtd_retirada); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(EW_FormatDateTime(x_Data_retirada,7,locale)); %></span>&nbsp;</td>
		<td><span class="jspmaker"><%
String tmpValuex_Destino_do_componente = (String) x_Destino_do_componente;
if (tmpValuex_Destino_do_componente.equals("1")) {
	out.print("Novo");
}
if (tmpValuex_Destino_do_componente.equals("2")) {
	out.print("Seminovo");
}
if (tmpValuex_Destino_do_componente.equals("3")) {
	out.print("Recuperavel");
}
if (tmpValuex_Destino_do_componente.equals("4")) {
	out.print("Irrecuperavel");
}
%>
</span>&nbsp;</td>
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
		<td><span class="jspmaker"><%
String tmpValue_x_Relacao_confianca = (String) x_Relacao_confianca;
if (tmpValue_x_Relacao_confianca.equals("1")) { 
	out.print("Interna");
}
if (tmpValue_x_Relacao_confianca.equals("2")) { 
	out.print("Externa");
}
%>
</span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_Com_quem); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% out.print(x_Telefone_confianca); %></span>&nbsp;</td>
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Retirada_de_Componentes"); 
if (key != null && key.length() > 0) { 
	out.print("retirada_de_componentesview.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Visualizar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Retirada_de_Componentes"); 
if (key != null && key.length() > 0) { 
	out.print("retirada_de_componentesedit.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Editar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Retirada_de_Componentes"); 
if (key != null && key.length() > 0) { 
	out.print("retirada_de_componentesdelete.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
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
	<td><a href="retirada_de_componenteslist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="retirada_de_componenteslist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="retirada_de_componenteslist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="retirada_de_componenteslist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
	<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<td><a href="retirada_de_componentesadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a></td>
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
<a href="retirada_de_componentesadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
