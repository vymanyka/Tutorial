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
if ((ewCurSec & ewAllowEdit) != ewAllowEdit) {
	response.sendRedirect("problemaslist.jsp"); 
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
Object x_id_Problema = "";
Object x_id_Movimentacao = "";
Object x_id_Dano = "";
Object x_Descricao_do_problema = "";
int fs_x_Imagem = 0;
String fn_x_Imagem = null;
String ct_x_Imagem = null;
byte[] byte_x_Imagem = new byte[0];
String x_Imagem = null;
int w_x_Imagem = 0;
int h_x_Imagem = 0;
String a_x_Imagem = "";
int fs_x_Video = 0;
String fn_x_Video = null;
String ct_x_Video = null;
byte[] byte_x_Video = new byte[0];
String x_Video = null;
int w_x_Video = 0;
int h_x_Video = 0;
String a_x_Video = "";
int fs_x_Som = 0;
String fn_x_Som = null;
String ct_x_Som = null;
byte[] byte_x_Som = new byte[0];
String x_Som = null;
int w_x_Som = 0;
int h_x_Som = 0;
String a_x_Som = "";
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
	if (ht.get("x_VideoFileSize") != null){
		fs_x_Video = ((Long) ht.get("x_VideoFileSize")).intValue();

		// check the file size
		if (fs_x_Video > 0 && EW_Max_File_Size > 0) {
			if (fs_x_Video > EW_Max_File_Size) {
				out.println("Max. file size (" + EW_Max_File_Size + " bytes) exceeded.");
				return;
			}
		}
	}
	if (ht.get("x_VideoFileName") != null) {
		fn_x_Video = (String) ht.get("x_VideoFileName");
		fn_x_Video = fn_x_Video.substring(fn_x_Video.lastIndexOf("\\")+1);
	}
	ct_x_Video = (String) ht.get("x_VideoContentType");
	byte_x_Video = (byte[]) ht.get("x_VideoFileData");
	if (ht.get("w_x_Video") != null && ((String) ht.get("w_x_Video")).length() > 0) {
		w_x_Video = Integer.parseInt((String) ht.get("w_x_Video"));
	}
	if (ht.get("h_x_Video") != null && ((String) ht.get("h_x_Video")).length() > 0) {
		h_x_Video = Integer.parseInt((String) ht.get("h_x_Video"));
	}
	a_x_Video = (String) ht.get("a_x_Video");

	// For the BLOB field
	if (ht.get("x_SomFileSize") != null){
		fs_x_Som = ((Long) ht.get("x_SomFileSize")).intValue();

		// check the file size
		if (fs_x_Som > 0 && EW_Max_File_Size > 0) {
			if (fs_x_Som > EW_Max_File_Size) {
				out.println("Max. file size (" + EW_Max_File_Size + " bytes) exceeded.");
				return;
			}
		}
	}
	if (ht.get("x_SomFileName") != null) {
		fn_x_Som = (String) ht.get("x_SomFileName");
		fn_x_Som = fn_x_Som.substring(fn_x_Som.lastIndexOf("\\")+1);
	}
	ct_x_Som = (String) ht.get("x_SomContentType");
	byte_x_Som = (byte[]) ht.get("x_SomFileData");
	if (ht.get("w_x_Som") != null && ((String) ht.get("w_x_Som")).length() > 0) {
		w_x_Som = Integer.parseInt((String) ht.get("w_x_Som"));
	}
	if (ht.get("h_x_Som") != null && ((String) ht.get("h_x_Som")).length() > 0) {
		h_x_Som = Integer.parseInt((String) ht.get("h_x_Som"));
	}
	a_x_Som = (String) ht.get("a_x_Som");

	// For other fields
	if(ht.get("x_id_Problema") != null){
		x_id_Problema = (String) ht.get("x_id_Problema");
	}else{
		x_id_Problema = "";
	}
	if(ht.get("x_id_Movimentacao") != null){
		x_id_Movimentacao = (String) ht.get("x_id_Movimentacao");
	}else{
		x_id_Movimentacao = "";
	}
	if(ht.get("x_id_Dano") != null){
		x_id_Dano = (String) ht.get("x_id_Dano");
	}else{
		x_id_Dano = "";
	}
	if(ht.get("x_Descricao_do_problema") != null){
		x_Descricao_do_problema = (String) ht.get("x_Descricao_do_problema");
	}else{
		x_Descricao_do_problema = "";
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
	response.sendRedirect("problemaslist.jsp");
	response.flushBuffer();
	return;
}

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	if (a.equals("I")){ // Get a record to display
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `problemas` WHERE `id_Problema`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			out.clear();
			response.sendRedirect("problemaslist.jsp");
		} else {
			rs.first();

			// Get the field contents
			x_id_Problema = String.valueOf(rs.getLong("id_Problema"));
			x_id_Movimentacao = String.valueOf(rs.getLong("id_Movimentacao"));
			x_id_Dano = String.valueOf(rs.getLong("id_Dano"));
			if (rs.getClob("Descricao_do_problema") != null) {
				long length = rs.getClob("Descricao_do_problema").length();
				x_Descricao_do_problema = rs.getClob("Descricao_do_problema").getSubString((long) 1, (int) length);
			}else{
				x_Descricao_do_problema = "";
			}
			if (rs.getString("Imagem") != null){
				x_Imagem = rs.getString("Imagem");
			}else{
				x_Imagem = "";
			}

			// Get BLOB field width & height
			x_Imagem = rs.getString("Imagem");
			if (rs.getString("Video") != null){
				x_Video = rs.getString("Video");
			}else{
				x_Video = "";
			}

			// Get BLOB field width & height
			x_Video = rs.getString("Video");
			if (rs.getString("Som") != null){
				x_Som = rs.getString("Som");
			}else{
				x_Som = "";
			}

			// Get BLOB field width & height
			x_Som = rs.getString("Som");
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
		String strsql = "SELECT * FROM `problemas` WHERE `id_Problema`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("problemaslist.jsp");
			response.flushBuffer();
			return;
		}

		// Field id_Movimentacao
		tmpfld = ((String) x_id_Movimentacao).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("id_Movimentacao");
		} else {
			rs.updateInt("id_Movimentacao",Integer.parseInt(tmpfld));
		}

		// Field id_Dano
		tmpfld = ((String) x_id_Dano).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("id_Dano");
		} else {
			rs.updateInt("id_Dano",Integer.parseInt(tmpfld));
		}

		// Field Descricao_do_problema
		tmpfld = ((String) x_Descricao_do_problema);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Descricao_do_problema");
		}else{
			rs.updateString("Descricao_do_problema", tmpfld);
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

		// Field Video
		if (a_x_Video.equals("2") || a_x_Video.equals("3")) {tmpfld = fn_x_Video;
		if (tmpfld.length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Video"); 
		}else {
			rs.updateString("Video", tmpfld); 
			if (byte_x_Video != null) {
				java.io.File file = new java.io.File(request.getRealPath("/") + "uploads/", fn_x_Video);
				if (!file.exists()) {file.createNewFile();}
				java.io.FileOutputStream fos = new java.io.FileOutputStream(file);
				fos.write(byte_x_Video);
				fos.close();
			}
		}
		}

		// Field Som
		if (a_x_Som.equals("2") || a_x_Som.equals("3")) {tmpfld = fn_x_Som;
		if (tmpfld.length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Som"); 
		}else {
			rs.updateString("Som", tmpfld); 
			if (byte_x_Som != null) {
				java.io.File file = new java.io.File(request.getRealPath("/") + "uploads/", fn_x_Som);
				if (!file.exists()) {file.createNewFile();}
				java.io.FileOutputStream fos = new java.io.FileOutputStream(file);
				fos.write(byte_x_Som);
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
		response.sendRedirect("problemaslist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
	out.println(ex.toString());}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Editar TABELA: Problemas<br><br><a href="problemaslist.jsp">Voltar a lista</a></span></p>
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
if (EW_this.x_id_Movimentacao && !EW_hasValue(EW_this.x_id_Movimentacao, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_id_Movimentacao, "SELECT", "Escolha o bem e a movimentacao!"))
                return false; 
        }
if (EW_this.x_id_Dano && !EW_hasValue(EW_this.x_id_Dano, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_id_Dano, "SELECT", "Forneca o tipo do dano deste problema!"))
                return false; 
        }
if (EW_this.x_Descricao_do_problema && !EW_hasValue(EW_this.x_Descricao_do_problema, "TEXTAREA" )) {
            if (!EW_onError(EW_this, EW_this.x_Descricao_do_problema, "TEXTAREA", "Informacoes sobre esta operacao sao essenciais!"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  name="problemasedit" action="problemasedit.jsp" method="post" enctype="multipart/form-data">
<p>
<input type="hidden" name="a" value="U">
<input type="hidden" name="key" value="<%= key %>">
<input type="hidden" name="EW_Max_File_Size" value="50000000">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Codigo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% out.print(x_id_Problema); %></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Movimentacao</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% String tmp_x_id_Movimentacao = (String) session.getAttribute("problemas_masterkey");
if (tmp_x_id_Movimentacao != null && tmp_x_id_Movimentacao.length() > 0) {
x_id_Movimentacao = tmp_x_id_Movimentacao; %>
<%
if (x_id_Movimentacao!=null && ((String)x_id_Movimentacao).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Movimentacao;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Movimentacao` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Movimentacao`, `id_Bem` FROM `movimentacao`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("id_Bem"));
		out.print(", " + rswrk.getString("id_Movimentacao"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
<input type="hidden" name="x_id_Movimentacao" value="<%= HTMLEncode((String)x_id_Movimentacao) %>">
<% } else { %>
<%
String cbo_x_id_Movimentacao_js = "";
String x_id_MovimentacaoList = "<select name=\"x_id_Movimentacao\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Movimentacao = "SELECT `id_Movimentacao`, `id_Bem` FROM `movimentacao`" + " ORDER BY `id_Bem` ASC";
Statement stmtwrk_x_id_Movimentacao = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Movimentacao = stmtwrk_x_id_Movimentacao.executeQuery(sqlwrk_x_id_Movimentacao);
	int rowcntwrk_x_id_Movimentacao = 0;
	while (rswrk_x_id_Movimentacao.next()) {
		x_id_MovimentacaoList += "<option value=\"" + HTMLEncode(rswrk_x_id_Movimentacao.getString("id_Movimentacao")) + "\"";
		if (rswrk_x_id_Movimentacao.getString("id_Movimentacao").equals(x_id_Movimentacao)) {
			x_id_MovimentacaoList += " selected";
		}
		String tmpValue_x_id_Movimentacao = "";
		if (rswrk_x_id_Movimentacao.getString("id_Bem")!= null) tmpValue_x_id_Movimentacao = rswrk_x_id_Movimentacao.getString("id_Bem");
		x_id_MovimentacaoList += ">" + tmpValue_x_id_Movimentacao
 + ", " + rswrk_x_id_Movimentacao.getString("id_Movimentacao") + "</option>";
		rowcntwrk_x_id_Movimentacao++;
	}
rswrk_x_id_Movimentacao.close();
rswrk_x_id_Movimentacao = null;
stmtwrk_x_id_Movimentacao.close();
stmtwrk_x_id_Movimentacao = null;
x_id_MovimentacaoList += "</select>";
out.println(x_id_MovimentacaoList);
%>
<% } %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Dano</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Dano_js = "";
String x_id_DanoList = "<select name=\"x_id_Dano\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Dano = "SELECT `id_Dano`, `Descricao_do_dano` FROM `tipos_de_dano`" + " ORDER BY `Descricao_do_dano` ASC";
Statement stmtwrk_x_id_Dano = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Dano = stmtwrk_x_id_Dano.executeQuery(sqlwrk_x_id_Dano);
	int rowcntwrk_x_id_Dano = 0;
	while (rswrk_x_id_Dano.next()) {
		x_id_DanoList += "<option value=\"" + HTMLEncode(rswrk_x_id_Dano.getString("id_Dano")) + "\"";
		if (rswrk_x_id_Dano.getString("id_Dano").equals(x_id_Dano)) {
			x_id_DanoList += " selected";
		}
		String tmpValue_x_id_Dano = "";
		if (rswrk_x_id_Dano.getString("Descricao_do_dano")!= null) tmpValue_x_id_Dano = rswrk_x_id_Dano.getString("Descricao_do_dano");
		x_id_DanoList += ">" + tmpValue_x_id_Dano
 + "</option>";
		rowcntwrk_x_id_Dano++;
	}
rswrk_x_id_Dano.close();
rswrk_x_id_Dano = null;
stmtwrk_x_id_Dano.close();
stmtwrk_x_id_Dano = null;
x_id_DanoList += "</select>";
out.println(x_id_DanoList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Descricao do problema</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Descricao_do_problema" cols="80" rows="4"><% if (x_Descricao_do_problema!=null) out.print(x_Descricao_do_problema); %></textarea><script language="JavaScript1.2">editor_generate('x_Descricao_do_problema');</script></span>&nbsp;</td>
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
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Audio-visual</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_Video!=null && x_Video.length() > 0) { %>
<input type="radio" name="a_x_Video" value="1" checked>Manter&nbsp;<input type="radio" name="a_x_Video" value="2">Remover&nbsp;<input type="radio" name="a_x_Video" value="3">Recolocar<br>
<% } else { %>
<input type="hidden" name="a_x_Video" value="3">
<% } %>
<input type="file" name="x_Video" onChange="if (this.form.a_x_Video[2]) this.form.a_x_Video[2].checked=true;"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Audio-visual (cont)</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% if (x_Som!=null && x_Som.length() > 0) { %>
<input type="radio" name="a_x_Som" value="1" checked>Manter&nbsp;<input type="radio" name="a_x_Som" value="2">Remover&nbsp;<input type="radio" name="a_x_Som" value="3">Recolocar<br>
<% } else { %>
<input type="hidden" name="a_x_Som" value="3">
<% } %>
<input type="file" name="x_Som" onChange="if (this.form.a_x_Som[2]) this.form.a_x_Som[2].checked=true;"></span>&nbsp;</td>
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
