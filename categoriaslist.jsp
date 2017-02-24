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
	session.setAttribute("categorias_masterkey", key_m); // Save master key to session

	// Reset start record counter (new master key)
	startRec = 0;
	session.setAttribute("categorias_REC", new Integer(startRec));
} else {
	key_m = (String) session.getAttribute("categorias_masterkey"); // Restore master key from session
}
String masterdatailwhere;
if (key_m != null && key_m.length() > 0) {
	masterdetailwhere = "`id_Categoria` = " + key_m.replaceAll("'",escapeString) + "";
}
%>
<%

// Get search criteria for advanced search
// id_Categoria

String ascrh_x_id_Categoria = request.getParameter("x_id_Categoria");
String z_id_Categoria = request.getParameter("z_id_Categoria");
	if (z_id_Categoria != null && z_id_Categoria.length() > 0 ) {
		String [] arrfieldopr_x_id_Categoria = z_id_Categoria.split(",");
		if (ascrh_x_id_Categoria != null && ascrh_x_id_Categoria.length() > 0) {
			ascrh_x_id_Categoria = ascrh_x_id_Categoria.replaceAll("'",escapeString);
			ascrh_x_id_Categoria = ascrh_x_id_Categoria.replaceAll("\\[","[[]");
			a_search += "`id_Categoria` "; // Add field
			a_search += arrfieldopr_x_id_Categoria[0].trim() + " "; // Add operator
			if (arrfieldopr_x_id_Categoria.length >= 2) {
				a_search += arrfieldopr_x_id_Categoria[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_id_Categoria; // Add input parameter
			if (arrfieldopr_x_id_Categoria.length >= 3) {
				a_search += arrfieldopr_x_id_Categoria[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// id_Zero
String ascrh_x_id_Zero = request.getParameter("x_id_Zero");
String z_id_Zero = request.getParameter("z_id_Zero");
	if (z_id_Zero != null && z_id_Zero.length() > 0 ) {
		String [] arrfieldopr_x_id_Zero = z_id_Zero.split(",");
		if (ascrh_x_id_Zero != null && ascrh_x_id_Zero.length() > 0) {
			ascrh_x_id_Zero = ascrh_x_id_Zero.replaceAll("'",escapeString);
			ascrh_x_id_Zero = ascrh_x_id_Zero.replaceAll("\\[","[[]");
			a_search += "`id_Zero` "; // Add field
			a_search += arrfieldopr_x_id_Zero[0].trim() + " "; // Add operator
			if (arrfieldopr_x_id_Zero.length >= 2) {
				a_search += arrfieldopr_x_id_Zero[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_id_Zero; // Add input parameter
			if (arrfieldopr_x_id_Zero.length >= 3) {
				a_search += arrfieldopr_x_id_Zero[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// id_Um
String ascrh_x_id_Um = request.getParameter("x_id_Um");
String z_id_Um = request.getParameter("z_id_Um");
	if (z_id_Um != null && z_id_Um.length() > 0 ) {
		String [] arrfieldopr_x_id_Um = z_id_Um.split(",");
		if (ascrh_x_id_Um != null && ascrh_x_id_Um.length() > 0) {
			ascrh_x_id_Um = ascrh_x_id_Um.replaceAll("'",escapeString);
			ascrh_x_id_Um = ascrh_x_id_Um.replaceAll("\\[","[[]");
			a_search += "`id_Um` "; // Add field
			a_search += arrfieldopr_x_id_Um[0].trim() + " "; // Add operator
			if (arrfieldopr_x_id_Um.length >= 2) {
				a_search += arrfieldopr_x_id_Um[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_id_Um; // Add input parameter
			if (arrfieldopr_x_id_Um.length >= 3) {
				a_search += arrfieldopr_x_id_Um[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// id_Dois
String ascrh_x_id_Dois = request.getParameter("x_id_Dois");
String z_id_Dois = request.getParameter("z_id_Dois");
	if (z_id_Dois != null && z_id_Dois.length() > 0 ) {
		String [] arrfieldopr_x_id_Dois = z_id_Dois.split(",");
		if (ascrh_x_id_Dois != null && ascrh_x_id_Dois.length() > 0) {
			ascrh_x_id_Dois = ascrh_x_id_Dois.replaceAll("'",escapeString);
			ascrh_x_id_Dois = ascrh_x_id_Dois.replaceAll("\\[","[[]");
			a_search += "`id_Dois` "; // Add field
			a_search += arrfieldopr_x_id_Dois[0].trim() + " "; // Add operator
			if (arrfieldopr_x_id_Dois.length >= 2) {
				a_search += arrfieldopr_x_id_Dois[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_id_Dois; // Add input parameter
			if (arrfieldopr_x_id_Dois.length >= 3) {
				a_search += arrfieldopr_x_id_Dois[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// id_Tres
String ascrh_x_id_Tres = request.getParameter("x_id_Tres");
String z_id_Tres = request.getParameter("z_id_Tres");
	if (z_id_Tres != null && z_id_Tres.length() > 0 ) {
		String [] arrfieldopr_x_id_Tres = z_id_Tres.split(",");
		if (ascrh_x_id_Tres != null && ascrh_x_id_Tres.length() > 0) {
			ascrh_x_id_Tres = ascrh_x_id_Tres.replaceAll("'",escapeString);
			ascrh_x_id_Tres = ascrh_x_id_Tres.replaceAll("\\[","[[]");
			a_search += "`id_Tres` "; // Add field
			a_search += arrfieldopr_x_id_Tres[0].trim() + " "; // Add operator
			if (arrfieldopr_x_id_Tres.length >= 2) {
				a_search += arrfieldopr_x_id_Tres[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_id_Tres; // Add input parameter
			if (arrfieldopr_x_id_Tres.length >= 3) {
				a_search += arrfieldopr_x_id_Tres[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// id_Quatro
String ascrh_x_id_Quatro = request.getParameter("x_id_Quatro");
String z_id_Quatro = request.getParameter("z_id_Quatro");
	if (z_id_Quatro != null && z_id_Quatro.length() > 0 ) {
		String [] arrfieldopr_x_id_Quatro = z_id_Quatro.split(",");
		if (ascrh_x_id_Quatro != null && ascrh_x_id_Quatro.length() > 0) {
			ascrh_x_id_Quatro = ascrh_x_id_Quatro.replaceAll("'",escapeString);
			ascrh_x_id_Quatro = ascrh_x_id_Quatro.replaceAll("\\[","[[]");
			a_search += "`id_Quatro` "; // Add field
			a_search += arrfieldopr_x_id_Quatro[0].trim() + " "; // Add operator
			if (arrfieldopr_x_id_Quatro.length >= 2) {
				a_search += arrfieldopr_x_id_Quatro[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_id_Quatro; // Add input parameter
			if (arrfieldopr_x_id_Quatro.length >= 3) {
				a_search += arrfieldopr_x_id_Quatro[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Descricao_da_categoria
String ascrh_x_Descricao_da_categoria = request.getParameter("x_Descricao_da_categoria");
String z_Descricao_da_categoria = request.getParameter("z_Descricao_da_categoria");
	if (z_Descricao_da_categoria != null && z_Descricao_da_categoria.length() > 0 ) {
		String [] arrfieldopr_x_Descricao_da_categoria = z_Descricao_da_categoria.split(",");
		if (ascrh_x_Descricao_da_categoria != null && ascrh_x_Descricao_da_categoria.length() > 0) {
			ascrh_x_Descricao_da_categoria = ascrh_x_Descricao_da_categoria.replaceAll("'",escapeString);
			ascrh_x_Descricao_da_categoria = ascrh_x_Descricao_da_categoria.replaceAll("\\[","[[]");
			a_search += "`Descricao_da_categoria` "; // Add field
			a_search += arrfieldopr_x_Descricao_da_categoria[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Descricao_da_categoria.length >= 2) {
				a_search += arrfieldopr_x_Descricao_da_categoria[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Descricao_da_categoria; // Add input parameter
			if (arrfieldopr_x_Descricao_da_categoria.length >= 3) {
				a_search += arrfieldopr_x_Descricao_da_categoria[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Detalhes_da_categoria
String ascrh_x_Detalhes_da_categoria = request.getParameter("x_Detalhes_da_categoria");
String z_Detalhes_da_categoria = request.getParameter("z_Detalhes_da_categoria");
	if (z_Detalhes_da_categoria != null && z_Detalhes_da_categoria.length() > 0 ) {
		String [] arrfieldopr_x_Detalhes_da_categoria = z_Detalhes_da_categoria.split(",");
		if (ascrh_x_Detalhes_da_categoria != null && ascrh_x_Detalhes_da_categoria.length() > 0) {
			ascrh_x_Detalhes_da_categoria = ascrh_x_Detalhes_da_categoria.replaceAll("'",escapeString);
			ascrh_x_Detalhes_da_categoria = ascrh_x_Detalhes_da_categoria.replaceAll("\\[","[[]");
			a_search += "`Detalhes_da_categoria` "; // Add field
			a_search += arrfieldopr_x_Detalhes_da_categoria[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Detalhes_da_categoria.length >= 2) {
				a_search += arrfieldopr_x_Detalhes_da_categoria[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Detalhes_da_categoria; // Add input parameter
			if (arrfieldopr_x_Detalhes_da_categoria.length >= 3) {
				a_search += arrfieldopr_x_Detalhes_da_categoria[2].trim(); // Add search suffix
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

// Guia_do_usuario
String ascrh_x_Guia_do_usuario = request.getParameter("x_Guia_do_usuario");
String z_Guia_do_usuario = request.getParameter("z_Guia_do_usuario");
	if (z_Guia_do_usuario != null && z_Guia_do_usuario.length() > 0 ) {
		String [] arrfieldopr_x_Guia_do_usuario = z_Guia_do_usuario.split(",");
		if (ascrh_x_Guia_do_usuario != null && ascrh_x_Guia_do_usuario.length() > 0) {
			ascrh_x_Guia_do_usuario = ascrh_x_Guia_do_usuario.replaceAll("'",escapeString);
			ascrh_x_Guia_do_usuario = ascrh_x_Guia_do_usuario.replaceAll("\\[","[[]");
			a_search += "`Guia_do_usuario` "; // Add field
			a_search += arrfieldopr_x_Guia_do_usuario[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Guia_do_usuario.length >= 2) {
				a_search += arrfieldopr_x_Guia_do_usuario[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Guia_do_usuario; // Add input parameter
			if (arrfieldopr_x_Guia_do_usuario.length >= 3) {
				a_search += arrfieldopr_x_Guia_do_usuario[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Guia_tecnico
String ascrh_x_Guia_tecnico = request.getParameter("x_Guia_tecnico");
String z_Guia_tecnico = request.getParameter("z_Guia_tecnico");
	if (z_Guia_tecnico != null && z_Guia_tecnico.length() > 0 ) {
		String [] arrfieldopr_x_Guia_tecnico = z_Guia_tecnico.split(",");
		if (ascrh_x_Guia_tecnico != null && ascrh_x_Guia_tecnico.length() > 0) {
			ascrh_x_Guia_tecnico = ascrh_x_Guia_tecnico.replaceAll("'",escapeString);
			ascrh_x_Guia_tecnico = ascrh_x_Guia_tecnico.replaceAll("\\[","[[]");
			a_search += "`Guia_tecnico` "; // Add field
			a_search += arrfieldopr_x_Guia_tecnico[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Guia_tecnico.length >= 2) {
				a_search += arrfieldopr_x_Guia_tecnico[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Guia_tecnico; // Add input parameter
			if (arrfieldopr_x_Guia_tecnico.length >= 3) {
				a_search += arrfieldopr_x_Guia_tecnico[2].trim(); // Add search suffix
			}
			a_search += " AND ";
		}
	}

// Guia_rapido
String ascrh_x_Guia_rapido = request.getParameter("x_Guia_rapido");
String z_Guia_rapido = request.getParameter("z_Guia_rapido");
	if (z_Guia_rapido != null && z_Guia_rapido.length() > 0 ) {
		String [] arrfieldopr_x_Guia_rapido = z_Guia_rapido.split(",");
		if (ascrh_x_Guia_rapido != null && ascrh_x_Guia_rapido.length() > 0) {
			ascrh_x_Guia_rapido = ascrh_x_Guia_rapido.replaceAll("'",escapeString);
			ascrh_x_Guia_rapido = ascrh_x_Guia_rapido.replaceAll("\\[","[[]");
			a_search += "`Guia_rapido` "; // Add field
			a_search += arrfieldopr_x_Guia_rapido[0].trim() + " "; // Add operator
			if (arrfieldopr_x_Guia_rapido.length >= 2) {
				a_search += arrfieldopr_x_Guia_rapido[1].trim(); // Add search prefix
			}
			a_search += ascrh_x_Guia_rapido; // Add input parameter
			if (arrfieldopr_x_Guia_rapido.length >= 3) {
				a_search += arrfieldopr_x_Guia_rapido[2].trim(); // Add search suffix
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
			b_search = b_search + "`Descricao_da_categoria` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Detalhes_da_categoria` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Imagem` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Guia_do_usuario` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Guia_tecnico` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Guia_rapido` LIKE '%" + kw + "%' OR ";
			b_search = b_search + "`Login` LIKE '%" + kw + "%' OR ";
			if (b_search.substring(b_search.length()-4,b_search.length()).equals(" OR ")) { b_search = b_search.substring(0,b_search.length()-4);}
			b_search = b_search + ") " + pSearchType + " ";
		}
	}else{
		b_search = b_search + "`Descricao_da_categoria` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Detalhes_da_categoria` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Imagem` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Guia_do_usuario` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Guia_tecnico` LIKE '%" + pSearch + "%' OR ";
		b_search = b_search + "`Guia_rapido` LIKE '%" + pSearch + "%' OR ";
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
	session.setAttribute("categorias_searchwhere", searchwhere);
	startRec = 1; // Reset start record counter (new search)
	session.setAttribute("categorias_REC", new Integer(startRec));
}else{
	if (session.getAttribute("categorias_searchwhere") != null)
		searchwhere = (String) session.getAttribute("categorias_searchwhere");
}
%>
<%

// Get clear search cmd
startRec = 0;
if (request.getParameter("cmd") != null && request.getParameter("cmd").length() > 0) {
	String cmd = request.getParameter("cmd");
	if (cmd.toUpperCase().equals("RESET")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("categorias_searchwhere", searchwhere);
	}else if (cmd.toUpperCase().equals("RESETALL")) {
		searchwhere = ""; // Reset search criteria
		session.setAttribute("categorias_searchwhere", searchwhere);
    	key_m = "";
		session.setAttribute("categorias_masterkey", key_m); // Clear master key
    	masterdetailwhere = "";
	}
	startRec = 1; // Reset start record counter (reset command)
	session.setAttribute("categorias_REC", new Integer(startRec));
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
String DefaultOrder = "Descricao_da_categoria";
String DefaultOrderType = "ASC";

// No Default Filter
String DefaultFilter = "";

// Check for an Order parameter
String OrderBy = request.getParameter("order");
if (OrderBy != null && OrderBy.length() > 0) {
	if (session.getAttribute("categorias_OB") != null &&
		((String) session.getAttribute("categorias_OB")).equals(OrderBy)) { // Check if an ASC/DESC toggle is required
		if (((String) session.getAttribute("categorias_OT")).equals("ASC")) {
			session.setAttribute("categorias_OT", "DESC");
		}else{
			session.setAttribute("categorias_OT", "ASC");
		}
	}else{
		session.setAttribute("categorias_OT", "ASC");
	}
	session.setAttribute("categorias_OB", OrderBy);
	session.setAttribute("categorias_REC", new Integer(1));
}else{
	OrderBy = (String) session.getAttribute("categorias_OB");
	if (OrderBy == null || OrderBy.length() == 0) {
		OrderBy = DefaultOrder;
		session.setAttribute("categorias_OB", OrderBy);
		session.setAttribute("categorias_OT", DefaultOrderType);
	}
}

// Open Connection to the database
try{
Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
ResultSet rs = null;

// Build SQL
String strsql = "SELECT * FROM `categorias`";
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
	strsql = strsql + " ORDER BY `" + OrderBy + "` " + (String) session.getAttribute("categorias_OT");
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
	session.setAttribute("categorias_REC", new Integer(startRec));
}else if (request.getParameter("pageno") != null && Integer.parseInt(request.getParameter("pageno")) > 0) {
	pageno = Integer.parseInt(request.getParameter("pageno"));
	if (IsNumeric(request.getParameter("pageno"))) {
		startRec = (pageno-1)*displayRecs+1;
		if (startRec <= 0) {
			startRec = 1;
		}else if (startRec >= ((totalRecs-1)/displayRecs)*displayRecs+1) {
			startRec =  ((totalRecs-1)/displayRecs)*displayRecs+1;
		}
		session.setAttribute("categorias_REC", new Integer(startRec));
	}else {
		startRec = ((Integer) session.getAttribute("categorias_REC")).intValue();
		if (startRec <= 0) {
			startRec = 1; // Reset start record counter
			session.setAttribute("categorias_REC", new Integer(startRec));
		}
	}
}else{
	if (session.getAttribute("categorias_REC") != null)
		startRec = ((Integer) session.getAttribute("categorias_REC")).intValue();
	if (startRec==0) {
		startRec = 1; //Reset start record counter
		session.setAttribute("categorias_REC", new Integer(startRec));
	}
}
%>
<%
ResultSet rsMas = null;
Statement stmtMas = null;
if (key_m != null && key_m.length() > 0) {
	String strmassql = "SELECT * FROM `componentes` WHERE ";
	strmassql = strmassql + "(`id_Categoria` = " + key_m.replaceAll("'",escapeString)  + ")";
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

    // Load Key for record
    String key = "";
    if (rsMas.getString("id_Componente") != null){
    	key = rsMas.getString("id_Componente");
		}else{
			key = "";
		}

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
<p><span class="jspmaker">TABELA: Categorias</span></p>
<form action="categoriaslist.jsp">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td><span class="jspmaker">Procura rapida (*)</span></td>
		<td><span class="jspmaker">
			<input type="text" name="psearch" size="20">
			<input type="Submit" name="Submit" value="OK">
		&nbsp;&nbsp;<a href="categoriaslist.jsp?cmd=reset">Mostrar todos</a>
		&nbsp;&nbsp;<a href="categoriassrch.jsp">Busca avancada</a>
		</span></td>
	</tr>
	<tr><td>&nbsp;</td><td><span class="jspmaker"><input type="radio" name="psearchtype" value="" checked>Frase exata&nbsp;&nbsp;<input type="radio" name="psearchtype" value="AND">Todas as palavras&nbsp;&nbsp;<input type="radio" name="psearchtype" value="OR">Qualquer palavra</span></td></tr>
</table>
</form>
<form method="post">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr bgcolor="#594FBF">
		<td><span class="jspmaker" style="color: #FFFFFF;">
<a href="categoriaslist.jsp?order=<%= java.net.URLEncoder.encode("Descricao_da_categoria","UTF-8") %>" style="color: #FFFFFF;">Descricao da categoria&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Descricao_da_categoria")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("categorias_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("categorias_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Detalhes da categoria&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Detalhes_da_categoria")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("categorias_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("categorias_OT")).equals("DESC")) { %>6<% } %></span><% } %></a>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Imagem&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Imagem")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("categorias_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("categorias_OT")).equals("DESC")) { %>6<% } %></span><% } %>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Guia do usuario&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Guia_do_usuario")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("categorias_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("categorias_OT")).equals("DESC")) { %>6<% } %></span><% } %>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Guia tecnico&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Guia_tecnico")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("categorias_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("categorias_OT")).equals("DESC")) { %>6<% } %></span><% } %>
		</span></td>
		<td><span class="jspmaker" style="color: #FFFFFF;">
Guia rapido&nbsp;(*)<% if (OrderBy != null && OrderBy.equals("Guia_rapido")) { %><span class="ewTableOrderIndicator"><% if (((String) session.getAttribute("categorias_OT")).equals("ASC")) {%>5<% }else if (((String) session.getAttribute("categorias_OT")).equals("DESC")) { %>6<% } %></span><% } %>
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
	String x_id_Categoria = "";
	String x_id_Zero = "";
	String x_id_Um = "";
	String x_id_Dois = "";
	String x_id_Tres = "";
	String x_id_Quatro = "";
	String x_Descricao_da_categoria = "";
	String x_Detalhes_da_categoria = "";
	String x_Imagem = "";
	String x_Guia_do_usuario = "";
	String x_Guia_tecnico = "";
	String x_Guia_rapido = "";
	String x_Login = "";

	// Load Key for record
	String key = "";

	// id_Categoria
	x_id_Categoria = String.valueOf(rs.getLong("id_Categoria"));

	// id_Zero
	x_id_Zero = String.valueOf(rs.getLong("id_Zero"));

	// id_Um
	x_id_Um = String.valueOf(rs.getLong("id_Um"));

	// id_Dois
	x_id_Dois = String.valueOf(rs.getLong("id_Dois"));

	// id_Tres
	x_id_Tres = String.valueOf(rs.getLong("id_Tres"));

	// id_Quatro
	x_id_Quatro = String.valueOf(rs.getLong("id_Quatro"));

	// Descricao_da_categoria
	if (rs.getString("Descricao_da_categoria") != null){
		x_Descricao_da_categoria = rs.getString("Descricao_da_categoria");
	}else{
		x_Descricao_da_categoria = "";
	}

	// Detalhes_da_categoria
	if (rs.getClob("Detalhes_da_categoria") != null) {
		long length = rs.getClob("Detalhes_da_categoria").length();
		x_Detalhes_da_categoria = rs.getClob("Detalhes_da_categoria").getSubString((long) 1, (int) length);
	}else{
		x_Detalhes_da_categoria = "";
	}

	// Imagem
	if (rs.getString("Imagem") != null){
		x_Imagem = rs.getString("Imagem");
	}else{
		x_Imagem = "";
	}

	// Guia_do_usuario
	if (rs.getString("Guia_do_usuario") != null){
		x_Guia_do_usuario = rs.getString("Guia_do_usuario");
	}else{
		x_Guia_do_usuario = "";
	}

	// Guia_tecnico
	if (rs.getString("Guia_tecnico") != null){
		x_Guia_tecnico = rs.getString("Guia_tecnico");
	}else{
		x_Guia_tecnico = "";
	}

	// Guia_rapido
	if (rs.getString("Guia_rapido") != null){
		x_Guia_rapido = rs.getString("Guia_rapido");
	}else{
		x_Guia_rapido = "";
	}

	// Login
	if (rs.getString("Login") != null){
		x_Login = rs.getString("Login");
	}else{
		x_Login = "";
	}
%>
	<tr bgcolor="<%= bgcolor %>">
		<td><span class="jspmaker"><% out.print(x_Descricao_da_categoria); %></span>&nbsp;</td>
		<td><span class="jspmaker"><% if (x_Detalhes_da_categoria != null) { out.print(((String)x_Detalhes_da_categoria).replaceAll("\r\n", "<br>"));} %></span>&nbsp;</td>
		<td><span class="jspmaker"><% if (x_Imagem != null && ((String)x_Imagem).length() > 0) { %>
<a href="uploads/<%= x_Imagem %>" target="blank"><img src="uploads/<%= x_Imagem %>" border="0"></a>
<% } %>
</span>&nbsp;</td>
		<td><span class="jspmaker"><% if (x_Guia_do_usuario != null && ((String)x_Guia_do_usuario).length() > 0) { %>
<a href="uploads/<%= x_Guia_do_usuario %>" target="blank"><%= x_Guia_do_usuario %></a>
<% } %>
</span>&nbsp;</td>
		<td><span class="jspmaker"><% if (x_Guia_tecnico != null && ((String)x_Guia_tecnico).length() > 0) { %>
<a href="uploads/<%= x_Guia_tecnico %>" target="blank"><%= x_Guia_tecnico %></a>
<% } %>
</span>&nbsp;</td>
		<td><span class="jspmaker"><% if (x_Guia_rapido != null && ((String)x_Guia_rapido).length() > 0) { %>
<a href="uploads/<%= x_Guia_rapido %>" target="blank"><%= x_Guia_rapido %></a>
<% } %>
</span>&nbsp;</td>
<% if ((ewCurSec & ewAllowView) == ewAllowView ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Categoria"); 
if (key != null && key.length() > 0) { 
	out.print("categoriasview.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Visualizar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowEdit) == ewAllowEdit ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Categoria"); 
if (key != null && key.length() > 0) { 
	out.print("categoriasedit.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Editar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Categoria"); 
if (key != null && key.length() > 0) { 
	out.print("categoriasadd.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
}else{
	out.print("javascript:alert('Registro invalido! A chave eh nula');");
} %>">Copiar</a></span></td>
<% } %>
<% if ((ewCurSec & ewAllowDelete) == ewAllowDelete ) { %>
<td><span class="jspmaker"><a href="<% key =  rs.getString("id_Categoria"); 
if (key != null && key.length() > 0) { 
	out.print("categoriasdelete.jsp?key=" + java.net.URLEncoder.encode(key,"UTF-8"));
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
	<td><a href="categoriaslist.jsp?start=1"><img src="images/first.gif" alt="First" width="20" height="15" border="0"></a></td>
	<% } %>
<!--previous page button-->
	<% if (PrevStart == startRec) { %>
	<td><img src="images/prevdisab.gif" alt="Previous" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="categoriaslist.jsp?start=<%=PrevStart%>"><img src="images/prev.gif" alt="Previous" width="20" height="15" border="0"></a></td>
	<% } %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(startRec-1)/displayRecs+1%>" size="4"></td>
<!--next page button-->
	<% if (NextStart == startRec) { %>
	<td><img src="images/nextdisab.gif" alt="Next" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="categoriaslist.jsp?start=<%=NextStart%>"><img src="images/next.gif" alt="Next" width="20" height="15" border="0"></a></td>
	<% } %>
<!--last page button-->
	<% if (LastStart == startRec) { %>
	<td><img src="images/lastdisab.gif" alt="Last" width="20" height="15" border="0"></td>
	<% }else{ %>
	<td><a href="categoriaslist.jsp?start=<%=LastStart%>"><img src="images/last.gif" alt="Last" width="20" height="15" border="0"></a></td>
	<% } %>
<% if ((ewCurSec & ewAllowAdd) == ewAllowAdd) { %>
	<td><a href="categoriasadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a></td>
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
<a href="categoriasadd.jsp"><img src="images/addnew.gif" alt="Add new" width="20" height="15" border="0"></a>
<% } %>
</p>
<% } %>
</td></tr></table>
<%@ include file="footer.jsp" %>
