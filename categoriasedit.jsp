<%@ page session="true" buffer="32kb" import="java.sql.*,java.util.*,java.text.*,org.apache.commons.fileupload.*"%>
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
	response.sendRedirect("categoriaslist.jsp"); 
	response.flushBuffer(); 
	return;
}
%>
<%@ include file="db.jsp" %>
<%@ include file="jspmkrfn.jsp" %>
<%
String tmpfld = null;
String escapeString = "\\\\'";
String a = null;
String key = null;
Object x_id_Categoria = "";
Object x_id_Zero = "";
Object x_id_Um = "";
Object x_id_Dois = "";
Object x_id_Tres = "";
Object x_id_Quatro = "";
Object x_Descricao_da_categoria = "";
Object x_Detalhes_da_categoria = "";
int fs_x_Imagem = 0;
String fn_x_Imagem = null;
String ct_x_Imagem = null;
byte[] byte_x_Imagem = new byte[0];
String x_Imagem = null;
int w_x_Imagem = 0;
int h_x_Imagem = 0;
String a_x_Imagem = "";
int fs_x_Guia_do_usuario = 0;
String fn_x_Guia_do_usuario = null;
String ct_x_Guia_do_usuario = null;
byte[] byte_x_Guia_do_usuario = new byte[0];
String x_Guia_do_usuario = null;
int w_x_Guia_do_usuario = 0;
int h_x_Guia_do_usuario = 0;
String a_x_Guia_do_usuario = "";
int fs_x_Guia_tecnico = 0;
String fn_x_Guia_tecnico = null;
String ct_x_Guia_tecnico = null;
byte[] byte_x_Guia_tecnico = new byte[0];
String x_Guia_tecnico = null;
int w_x_Guia_tecnico = 0;
int h_x_Guia_tecnico = 0;
String a_x_Guia_tecnico = "";
int fs_x_Guia_rapido = 0;
String fn_x_Guia_rapido = null;
String ct_x_Guia_rapido = null;
byte[] byte_x_Guia_rapido = new byte[0];
String x_Guia_rapido = null;
int w_x_Guia_rapido = 0;
int h_x_Guia_rapido = 0;
String a_x_Guia_rapido = "";
Object x_Login = "";
if (request.getContentLength() > 0) {
	request.setCharacterEncoding("UTF-8");
	DiskFileUpload fu = new DiskFileUpload();
	List fileItems = fu.parseRequest(request);
	Iterator iter = fileItems.iterator();
	Hashtable ht = new Hashtable();
	while (iter.hasNext()) {
	    FileItem item = (FileItem) iter.next();
		if (item.isFormField()){
			if (!ht.containsKey(item.getFieldName())){
				ht.put(item.getFieldName(), item.getString());
			}else{
				ht.put(item.getFieldName(), ((String)ht.get(item.getFieldName())) + "," + item.getString());
			}
		}else{
			String name = item.getFieldName();
			ht.put(name+"FileName", item.getName());
			ht.put(name+"ContentType", item.getContentType());
			ht.put(name+"FileSize", new Long(item.getSize()));
			ht.put(name+"FileData", item.get());
		}
	}

	// Get action
	a = (String) ht.get("a");
	key = (String) ht.get("key");
	int EW_Max_File_Size = Integer.parseInt((String) ht.get("EW_Max_File_Size"));

	// For the BLOB field
	if (ht.get("x_ImagemFileSize") != null){
		fs_x_Imagem = ((Long) ht.get("x_ImagemFileSize")).intValue();

		// check the file size
		if (fs_x_Imagem > 0 && EW_Max_File_Size > 0) {
			if (fs_x_Imagem > EW_Max_File_Size) {
				out.println("Max. file size (" + EW_Max_File_Size + " bytes) exceeded.");
				return;
			}
		}
	}
	if (ht.get("x_ImagemFileName") != null) {
		fn_x_Imagem = (String) ht.get("x_ImagemFileName");
		fn_x_Imagem = fn_x_Imagem.substring(fn_x_Imagem.lastIndexOf("\\")+1);
	}
	ct_x_Imagem = (String) ht.get("x_ImagemContentType");
	byte_x_Imagem = (byte[]) ht.get("x_ImagemFileData");
	if (ht.get("w_x_Imagem") != null && ((String) ht.get("w_x_Imagem")).length() > 0) {
		w_x_Imagem = Integer.parseInt((String) ht.get("w_x_Imagem"));
	}
	if (ht.get("h_x_Imagem") != null && ((String) ht.get("h_x_Imagem")).length() > 0) {
		h_x_Imagem = Integer.parseInt((String) ht.get("h_x_Imagem"));
	}
	a_x_Imagem = (String) ht.get("a_x_Imagem");

	// For the BLOB field
	if (ht.get("x_Guia_do_usuarioFileSize") != null){
		fs_x_Guia_do_usuario = ((Long) ht.get("x_Guia_do_usuarioFileSize")).intValue();

		// check the file size
		if (fs_x_Guia_do_usuario > 0 && EW_Max_File_Size > 0) {
			if (fs_x_Guia_do_usuario > EW_Max_File_Size) {
				out.println("Max. file size (" + EW_Max_File_Size + " bytes) exceeded.");
				return;
			}
		}
	}
	if (ht.get("x_Guia_do_usuarioFileName") != null) {
		fn_x_Guia_do_usuario = (String) ht.get("x_Guia_do_usuarioFileName");
		fn_x_Guia_do_usuario = fn_x_Guia_do_usuario.substring(fn_x_Guia_do_usuario.lastIndexOf("\\")+1);
	}
	ct_x_Guia_do_usuario = (String) ht.get("x_Guia_do_usuarioContentType");
	byte_x_Guia_do_usuario = (byte[]) ht.get("x_Guia_do_usuarioFileData");
	if (ht.get("w_x_Guia_do_usuario") != null && ((String) ht.get("w_x_Guia_do_usuario")).length() > 0) {
		w_x_Guia_do_usuario = Integer.parseInt((String) ht.get("w_x_Guia_do_usuario"));
	}
	if (ht.get("h_x_Guia_do_usuario") != null && ((String) ht.get("h_x_Guia_do_usuario")).length() > 0) {
		h_x_Guia_do_usuario = Integer.parseInt((String) ht.get("h_x_Guia_do_usuario"));
	}
	a_x_Guia_do_usuario = (String) ht.get("a_x_Guia_do_usuario");

	// For the BLOB field
	if (ht.get("x_Guia_tecnicoFileSize") != null){
		fs_x_Guia_tecnico = ((Long) ht.get("x_Guia_tecnicoFileSize")).intValue();

		// check the file size
		if (fs_x_Guia_tecnico > 0 && EW_Max_File_Size > 0) {
			if (fs_x_Guia_tecnico > EW_Max_File_Size) {
				out.println("Max. file size (" + EW_Max_File_Size + " bytes) exceeded.");
				return;
			}
		}
	}
	if (ht.get("x_Guia_tecnicoFileName") != null) {
		fn_x_Guia_tecnico = (String) ht.get("x_Guia_tecnicoFileName");
		fn_x_Guia_tecnico = fn_x_Guia_tecnico.substring(fn_x_Guia_tecnico.lastIndexOf("\\")+1);
	}
	ct_x_Guia_tecnico = (String) ht.get("x_Guia_tecnicoContentType");
	byte_x_Guia_tecnico = (byte[]) ht.get("x_Guia_tecnicoFileData");
	if (ht.get("w_x_Guia_tecnico") != null && ((String) ht.get("w_x_Guia_tecnico")).length() > 0) {
		w_x_Guia_tecnico = Integer.parseInt((String) ht.get("w_x_Guia_tecnico"));
	}
	if (ht.get("h_x_Guia_tecnico") != null && ((String) ht.get("h_x_Guia_tecnico")).length() > 0) {
		h_x_Guia_tecnico = Integer.parseInt((String) ht.get("h_x_Guia_tecnico"));
	}
	a_x_Guia_tecnico = (String) ht.get("a_x_Guia_tecnico");

	// For the BLOB field
	if (ht.get("x_Guia_rapidoFileSize") != null){
		fs_x_Guia_rapido = ((Long) ht.get("x_Guia_rapidoFileSize")).intValue();

		// check the file size
		if (fs_x_Guia_rapido > 0 && EW_Max_File_Size > 0) {
			if (fs_x_Guia_rapido > EW_Max_File_Size) {
				out.println("Max. file size (" + EW_Max_File_Size + " bytes) exceeded.");
				return;
			}
		}
	}
	if (ht.get("x_Guia_rapidoFileName") != null) {
		fn_x_Guia_rapido = (String) ht.get("x_Guia_rapidoFileName");
		fn_x_Guia_rapido = fn_x_Guia_rapido.substring(fn_x_Guia_rapido.lastIndexOf("\\")+1);
	}
	ct_x_Guia_rapido = (String) ht.get("x_Guia_rapidoContentType");
	byte_x_Guia_rapido = (byte[]) ht.get("x_Guia_rapidoFileData");
	if (ht.get("w_x_Guia_rapido") != null && ((String) ht.get("w_x_Guia_rapido")).length() > 0) {
		w_x_Guia_rapido = Integer.parseInt((String) ht.get("w_x_Guia_rapido"));
	}
	if (ht.get("h_x_Guia_rapido") != null && ((String) ht.get("h_x_Guia_rapido")).length() > 0) {
		h_x_Guia_rapido = Integer.parseInt((String) ht.get("h_x_Guia_rapido"));
	}
	a_x_Guia_rapido = (String) ht.get("a_x_Guia_rapido");

	// For other fields
	if(ht.get("x_id_Categoria") != null){
		x_id_Categoria = (String) ht.get("x_id_Categoria");
	}else{
		x_id_Categoria = "";
	}
	if(ht.get("x_id_Zero") != null){
		x_id_Zero = (String) ht.get("x_id_Zero");
	}else{
		x_id_Zero = "";
	}
	if(ht.get("x_id_Um") != null){
		x_id_Um = (String) ht.get("x_id_Um");
	}else{
		x_id_Um = "";
	}
	if(ht.get("x_id_Dois") != null){
		x_id_Dois = (String) ht.get("x_id_Dois");
	}else{
		x_id_Dois = "";
	}
	if(ht.get("x_id_Tres") != null){
		x_id_Tres = (String) ht.get("x_id_Tres");
	}else{
		x_id_Tres = "";
	}
	if(ht.get("x_id_Quatro") != null){
		x_id_Quatro = (String) ht.get("x_id_Quatro");
	}else{
		x_id_Quatro = "";
	}
	if(ht.get("x_Descricao_da_categoria") != null){
		x_Descricao_da_categoria = (String) ht.get("x_Descricao_da_categoria");
	}else{
		x_Descricao_da_categoria = "";
	}
	if(ht.get("x_Detalhes_da_categoria") != null){
		x_Detalhes_da_categoria = (String) ht.get("x_Detalhes_da_categoria");
	}else{
		x_Detalhes_da_categoria = "";
	}
	if(ht.get("x_Login") != null){
		x_Login = (String) ht.get("x_Login");
	}else{
		x_Login = "";
	}
	ht = null;
}else{
	key = request.getParameter("key");
	a = "I"; // Display record
}
if (key == null || key.length() == 0 ) {
	response.sendRedirect("categoriaslist.jsp");
	response.flushBuffer();
	return;
}

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `categorias` WHERE `id_Categoria`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("categoriaslist.jsp");
		} else {
			rs.first();

			// Get the field contents
			x_id_Categoria = String.valueOf(rs.getLong("id_Categoria"));
			x_id_Zero = String.valueOf(rs.getLong("id_Zero"));
			x_id_Um = String.valueOf(rs.getLong("id_Um"));
			x_id_Dois = String.valueOf(rs.getLong("id_Dois"));
			x_id_Tres = String.valueOf(rs.getLong("id_Tres"));
			x_id_Quatro = String.valueOf(rs.getLong("id_Quatro"));
			if (rs.getString("Descricao_da_categoria") != null){
				x_Descricao_da_categoria = rs.getString("Descricao_da_categoria");
			}else{
				x_Descricao_da_categoria = "";
			}
			if (rs.getClob("Detalhes_da_categoria") != null) {
				long length = rs.getClob("Detalhes_da_categoria").length();
				x_Detalhes_da_categoria = rs.getClob("Detalhes_da_categoria").getSubString((long) 1, (int) length);
			}else{
				x_Detalhes_da_categoria = "";
			}
			if (rs.getString("Imagem") != null){
				x_Imagem = rs.getString("Imagem");
			}else{
				x_Imagem = "";
			}

			// Get BLOB field width & height
			x_Imagem = rs.getString("Imagem");
			if (rs.getString("Guia_do_usuario") != null){
				x_Guia_do_usuario = rs.getString("Guia_do_usuario");
			}else{
				x_Guia_do_usuario = "";
			}

			// Get BLOB field width & height
			x_Guia_do_usuario = rs.getString("Guia_do_usuario");
			if (rs.getString("Guia_tecnico") != null){
				x_Guia_tecnico = rs.getString("Guia_tecnico");
			}else{
				x_Guia_tecnico = "";
			}

			// Get BLOB field width & height
			x_Guia_tecnico = rs.getString("Guia_tecnico");
			if (rs.getString("Guia_rapido") != null){
				x_Guia_rapido = rs.getString("Guia_rapido");
			}else{
				x_Guia_rapido = "";
			}

			// Get BLOB field width & height
			x_Guia_rapido = rs.getString("Guia_rapido");
			if (rs.getString("Login") != null){
				x_Login = rs.getString("Login");
			}else{
				x_Login = "";
			}
		}
		rs.close();
		rs = null;
	}else if (a.equals("U")) { // Update

		// Open record
		String tkey = "" + key.replaceAll("'","\\\\'") + "";
		String strsql = "SELECT * FROM `categorias` WHERE `id_Categoria`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("categoriaslist.jsp");
			response.flushBuffer();
			return;
		}

		// Field id_Zero
		tmpfld = ((String) x_id_Zero).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("id_Zero");
		} else {
			rs.updateInt("id_Zero",Integer.parseInt(tmpfld));
		}

		// Field id_Um
		tmpfld = ((String) x_id_Um).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("id_Um");
		} else {
			rs.updateInt("id_Um",Integer.parseInt(tmpfld));
		}

		// Field id_Dois
		tmpfld = ((String) x_id_Dois).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("id_Dois");
		} else {
			rs.updateInt("id_Dois",Integer.parseInt(tmpfld));
		}

		// Field id_Tres
		tmpfld = ((String) x_id_Tres).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("id_Tres");
		} else {
			rs.updateInt("id_Tres",Integer.parseInt(tmpfld));
		}

		// Field id_Quatro
		tmpfld = ((String) x_id_Quatro).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = null;}
		if (tmpfld == null) {
			rs.updateNull("id_Quatro");
		} else {
			rs.updateInt("id_Quatro",Integer.parseInt(tmpfld));
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

		// Field Detalhes_da_categoria
		tmpfld = ((String) x_Detalhes_da_categoria);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Detalhes_da_categoria");
		}else{
			rs.updateString("Detalhes_da_categoria", tmpfld);
		}

		// Field Imagem
		if (a_x_Imagem.equals("2") || a_x_Imagem.equals("3")) {tmpfld = fn_x_Imagem;
		if (tmpfld.length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Imagem"); 
		}else {
			rs.updateString("Imagem", tmpfld); 
			if (byte_x_Imagem != null) {
				java.io.File file = new java.io.File(request.getRealPath("/") + "uploads/", fn_x_Imagem);
				if (!file.exists()) {file.createNewFile();}
				java.io.FileOutputStream fos = new java.io.FileOutputStream(file);
				fos.write(byte_x_Imagem);
				fos.close();
			}
		}
		}

		// Field Guia_do_usuario
		if (a_x_Guia_do_usuario.equals("2") || a_x_Guia_do_usuario.equals("3")) {tmpfld = fn_x_Guia_do_usuario;
		if (tmpfld.length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Guia_do_usuario"); 
		}else {
			rs.updateString("Guia_do_usuario", tmpfld); 
			if (byte_x_Guia_do_usuario != null) {
				java.io.File file = new java.io.File(request.getRealPath("/") + "uploads/", fn_x_Guia_do_usuario);
				if (!file.exists()) {file.createNewFile();}
				java.io.FileOutputStream fos = new java.io.FileOutputStream(file);
				fos.write(byte_x_Guia_do_usuario);
				fos.close();
			}
		}
		}

		// Field Guia_tecnico
		if (a_x_Guia_tecnico.equals("2") || a_x_Guia_tecnico.equals("3")) {tmpfld = fn_x_Guia_tecnico;
		if (tmpfld.length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Guia_tecnico"); 
		}else {
			rs.updateString("Guia_tecnico", tmpfld); 
			if (byte_x_Guia_tecnico != null) {
				java.io.File file = new java.io.File(request.getRealPath("/") + "uploads/", fn_x_Guia_tecnico);
				if (!file.exists()) {file.createNewFile();}
				java.io.FileOutputStream fos = new java.io.FileOutputStream(file);
				fos.write(byte_x_Guia_tecnico);
				fos.close();
			}
		}
		}

		// Field Guia_rapido
		if (a_x_Guia_rapido.equals("2") || a_x_Guia_rapido.equals("3")) {tmpfld = fn_x_Guia_rapido;
		if (tmpfld.length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Guia_rapido"); 
		}else {
			rs.updateString("Guia_rapido", tmpfld); 
			if (byte_x_Guia_rapido != null) {
				java.io.File file = new java.io.File(request.getRealPath("/") + "uploads/", fn_x_Guia_rapido);
				if (!file.exists()) {file.createNewFile();}
				java.io.FileOutputStream fos = new java.io.FileOutputStream(file);
				fos.write(byte_x_Guia_rapido);
				fos.close();
			}
		}
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
		out.clear();
		response.sendRedirect("categoriaslist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
	out.println(ex.toString());}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Editar TABELA: Categorias<br><br><a href="categoriaslist.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript">
<!-- start Javascript
_editor_url = "";                     // URL to htmlarea files
var win_ie_ver = parseFloat(navigator.appVersion.split("MSIE")[1]);
if (navigator.userAgent.indexOf('Mac')        >= 0) { win_ie_ver = 0; }
if (navigator.userAgent.indexOf('Windows CE') >= 0) { win_ie_ver = 0; }
if (navigator.userAgent.indexOf('Opera')      >= 0) { win_ie_ver = 0; }
if (win_ie_ver >= 5.5) {
  document.write('<scr' + 'ipt src="' +_editor_url+ 'editor.js" language="Javascript"></scr' + 'ipt>');
} else { document.write('<scr'+'ipt>function editor_generate() { return false; }</scr'+'ipt>'); }

// end JavaScript -->
</script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_id_Zero && !EW_hasValue(EW_this.x_id_Zero, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_id_Zero, "SELECT", "Forneca a categoria primaria!"))
                return false; 
        }
if (EW_this.x_id_Um && !EW_hasValue(EW_this.x_id_Um, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_id_Um, "SELECT", "Forneca a categoria secundaria!"))
                return false; 
        }
if (EW_this.x_id_Dois && !EW_hasValue(EW_this.x_id_Dois, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_id_Dois, "SELECT", "Forneca a categoria terciaria!"))
                return false; 
        }
if (EW_this.x_Descricao_da_categoria && !EW_hasValue(EW_this.x_Descricao_da_categoria, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_Descricao_da_categoria, "TEXT", "Descreva a categoria!"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="categoriasedit" action="categoriasedit.jsp" method="post" enctype="multipart/form-data">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<input type="hidden" name="EW_Max_File_Size" value="50000000">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% String tmp_x_id_Categoria = (String) session.getAttribute("categorias_masterkey");
if (tmp_x_id_Categoria != null && tmp_x_id_Categoria.length() > 0) {
x_id_Categoria = tmp_x_id_Categoria; %>
<% out.print(x_id_Categoria); %><input type="hidden" name="x_id_Categoria" value="<%= HTMLEncode((String)x_id_Categoria) %>">
<% } else { %>
<% out.print(x_id_Categoria); %>
<% } %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria primaria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Zero_js = "";
String x_id_ZeroList = "<select name=\"x_id_Zero\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Zero = "SELECT `id_Zero`, `Descricao_da_categoria` FROM `sub_categoria_0`" + " ORDER BY `Descricao_da_categoria` ASC";
Statement stmtwrk_x_id_Zero = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Zero = stmtwrk_x_id_Zero.executeQuery(sqlwrk_x_id_Zero);
	int rowcntwrk_x_id_Zero = 0;
	while (rswrk_x_id_Zero.next()) {
		x_id_ZeroList += "<option value=\"" + HTMLEncode(rswrk_x_id_Zero.getString("id_Zero")) + "\"";
		if (rswrk_x_id_Zero.getString("id_Zero").equals(x_id_Zero)) {
			x_id_ZeroList += " selected";
		}
		String tmpValue_x_id_Zero = "";
		if (rswrk_x_id_Zero.getString("Descricao_da_categoria")!= null) tmpValue_x_id_Zero = rswrk_x_id_Zero.getString("Descricao_da_categoria");
		x_id_ZeroList += ">" + tmpValue_x_id_Zero
 + "</option>";
		rowcntwrk_x_id_Zero++;
	}
rswrk_x_id_Zero.close();
rswrk_x_id_Zero = null;
stmtwrk_x_id_Zero.close();
stmtwrk_x_id_Zero = null;
x_id_ZeroList += "</select>";
out.println(x_id_ZeroList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria secundaria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Um_js = "";
String x_id_UmList = "<select name=\"x_id_Um\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Um = "SELECT `id_Um`, `Descricao_da_categoria` FROM `sub_categoria_1`" + " ORDER BY `Descricao_da_categoria` ASC";
Statement stmtwrk_x_id_Um = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Um = stmtwrk_x_id_Um.executeQuery(sqlwrk_x_id_Um);
	int rowcntwrk_x_id_Um = 0;
	while (rswrk_x_id_Um.next()) {
		x_id_UmList += "<option value=\"" + HTMLEncode(rswrk_x_id_Um.getString("id_Um")) + "\"";
		if (rswrk_x_id_Um.getString("id_Um").equals(x_id_Um)) {
			x_id_UmList += " selected";
		}
		String tmpValue_x_id_Um = "";
		if (rswrk_x_id_Um.getString("Descricao_da_categoria")!= null) tmpValue_x_id_Um = rswrk_x_id_Um.getString("Descricao_da_categoria");
		x_id_UmList += ">" + tmpValue_x_id_Um
 + "</option>";
		rowcntwrk_x_id_Um++;
	}
rswrk_x_id_Um.close();
rswrk_x_id_Um = null;
stmtwrk_x_id_Um.close();
stmtwrk_x_id_Um = null;
x_id_UmList += "</select>";
out.println(x_id_UmList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria terciaria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Dois_js = "";
String x_id_DoisList = "<select name=\"x_id_Dois\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Dois = "SELECT `id_Dois`, `Descricao_da_categoria` FROM `sub_categoria_2`" + " ORDER BY `Descricao_da_categoria` ASC";
Statement stmtwrk_x_id_Dois = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Dois = stmtwrk_x_id_Dois.executeQuery(sqlwrk_x_id_Dois);
	int rowcntwrk_x_id_Dois = 0;
	while (rswrk_x_id_Dois.next()) {
		x_id_DoisList += "<option value=\"" + HTMLEncode(rswrk_x_id_Dois.getString("id_Dois")) + "\"";
		if (rswrk_x_id_Dois.getString("id_Dois").equals(x_id_Dois)) {
			x_id_DoisList += " selected";
		}
		String tmpValue_x_id_Dois = "";
		if (rswrk_x_id_Dois.getString("Descricao_da_categoria")!= null) tmpValue_x_id_Dois = rswrk_x_id_Dois.getString("Descricao_da_categoria");
		x_id_DoisList += ">" + tmpValue_x_id_Dois
 + "</option>";
		rowcntwrk_x_id_Dois++;
	}
rswrk_x_id_Dois.close();
rswrk_x_id_Dois = null;
stmtwrk_x_id_Dois.close();
stmtwrk_x_id_Dois = null;
x_id_DoisList += "</select>";
out.println(x_id_DoisList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria quaternaria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Tres_js = "";
String x_id_TresList = "<select name=\"x_id_Tres\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Tres = "SELECT `id_Tres`, `Descricao_da_categoria` FROM `sub_categoria_3`" + " ORDER BY `Descricao_da_categoria` ASC";
Statement stmtwrk_x_id_Tres = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Tres = stmtwrk_x_id_Tres.executeQuery(sqlwrk_x_id_Tres);
	int rowcntwrk_x_id_Tres = 0;
	while (rswrk_x_id_Tres.next()) {
		x_id_TresList += "<option value=\"" + HTMLEncode(rswrk_x_id_Tres.getString("id_Tres")) + "\"";
		if (rswrk_x_id_Tres.getString("id_Tres").equals(x_id_Tres)) {
			x_id_TresList += " selected";
		}
		String tmpValue_x_id_Tres = "";
		if (rswrk_x_id_Tres.getString("Descricao_da_categoria")!= null) tmpValue_x_id_Tres = rswrk_x_id_Tres.getString("Descricao_da_categoria");
		x_id_TresList += ">" + tmpValue_x_id_Tres
 + "</option>";
		rowcntwrk_x_id_Tres++;
	}
rswrk_x_id_Tres.close();
rswrk_x_id_Tres = null;
stmtwrk_x_id_Tres.close();
stmtwrk_x_id_Tres = null;
x_id_TresList += "</select>";
out.println(x_id_TresList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Categoria quinquenaria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Quatro_js = "";
String x_id_QuatroList = "<select name=\"x_id_Quatro\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Quatro = "SELECT `id_Quatro`, `Descricao_da_categoria` FROM `sub_categoria_4`" + " ORDER BY `Descricao_da_categoria` ASC";
Statement stmtwrk_x_id_Quatro = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Quatro = stmtwrk_x_id_Quatro.executeQuery(sqlwrk_x_id_Quatro);
	int rowcntwrk_x_id_Quatro = 0;
	while (rswrk_x_id_Quatro.next()) {
		x_id_QuatroList += "<option value=\"" + HTMLEncode(rswrk_x_id_Quatro.getString("id_Quatro")) + "\"";
		if (rswrk_x_id_Quatro.getString("id_Quatro").equals(x_id_Quatro)) {
			x_id_QuatroList += " selected";
		}
		String tmpValue_x_id_Quatro = "";
		if (rswrk_x_id_Quatro.getString("Descricao_da_categoria")!= null) tmpValue_x_id_Quatro = rswrk_x_id_Quatro.getString("Descricao_da_categoria");
		x_id_QuatroList += ">" + tmpValue_x_id_Quatro
 + "</option>";
		rowcntwrk_x_id_Quatro++;
	}
rswrk_x_id_Quatro.close();
rswrk_x_id_Quatro = null;
stmtwrk_x_id_Quatro.close();
stmtwrk_x_id_Quatro = null;
x_id_QuatroList += "</select>";
out.println(x_id_QuatroList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Descricao da categoria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Descricao_da_categoria" size="70" maxlength="50" value="<%= HTMLEncode((String)x_Descricao_da_categoria) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Detalhes da categoria</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Detalhes_da_categoria" cols="80" rows="4"><% if (x_Detalhes_da_categoria!=null) out.print(x_Detalhes_da_categoria); %></textarea><script language="JavaScript1.2">editor_generate('x_Detalhes_da_categoria');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Imagem</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_Imagem!=null && x_Imagem.length() > 0) { %>
<input type="radio" name="a_x_Imagem" value="1" checked>Manter&nbsp;<input type="radio" name="a_x_Imagem" value="2">Remover&nbsp;<input type="radio" name="a_x_Imagem" value="3">Recolocar<br>
<% } else { %>
<input type="hidden" name="a_x_Imagem" value="3">
<% } %>
<input type="file" name="x_Imagem" onChange="if (this.form.a_x_Imagem[2]) this.form.a_x_Imagem[2].checked=true;"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Guia do usuario</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_Guia_do_usuario!=null && x_Guia_do_usuario.length() > 0) { %>
<input type="radio" name="a_x_Guia_do_usuario" value="1" checked>Manter&nbsp;<input type="radio" name="a_x_Guia_do_usuario" value="2">Remover&nbsp;<input type="radio" name="a_x_Guia_do_usuario" value="3">Recolocar<br>
<% } else { %>
<input type="hidden" name="a_x_Guia_do_usuario" value="3">
<% } %>
<input type="file" name="x_Guia_do_usuario" onChange="if (this.form.a_x_Guia_do_usuario[2]) this.form.a_x_Guia_do_usuario[2].checked=true;"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Guia tecnico</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_Guia_tecnico!=null && x_Guia_tecnico.length() > 0) { %>
<input type="radio" name="a_x_Guia_tecnico" value="1" checked>Manter&nbsp;<input type="radio" name="a_x_Guia_tecnico" value="2">Remover&nbsp;<input type="radio" name="a_x_Guia_tecnico" value="3">Recolocar<br>
<% } else { %>
<input type="hidden" name="a_x_Guia_tecnico" value="3">
<% } %>
<input type="file" name="x_Guia_tecnico" onChange="if (this.form.a_x_Guia_tecnico[2]) this.form.a_x_Guia_tecnico[2].checked=true;"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Guia rapido</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_Guia_rapido!=null && x_Guia_rapido.length() > 0) { %>
<input type="radio" name="a_x_Guia_rapido" value="1" checked>Manter&nbsp;<input type="radio" name="a_x_Guia_rapido" value="2">Remover&nbsp;<input type="radio" name="a_x_Guia_rapido" value="3">Recolocar<br>
<% } else { %>
<input type="hidden" name="a_x_Guia_rapido" value="3">
<% } %>
<input type="file" name="x_Guia_rapido" onChange="if (this.form.a_x_Guia_rapido[2]) this.form.a_x_Guia_rapido[2].checked=true;"></span>&nbsp;</td>
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
