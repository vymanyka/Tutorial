<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*,org.apache.commons.fileupload.*"%>
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
ew_SecTable[1] = 11;
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
if ((ewCurSec & ewAllowAdd) != ewAllowAdd) {
	response.sendRedirect("solucoeslist.jsp"); 
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
Object x_id_Solucao = "";
Object x_id_Problema = "";
Object x_Detalhes = "";
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
			if (ht.containsKey(item.getFieldName())){
				String value = (String) ht.get(item.getFieldName());
				ht.put(item.getFieldName(), value + "," + item.getString());
			}else{
				ht.put(item.getFieldName(), item.getString());
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
	int EW_Max_File_Size = Integer.parseInt((String) ht.get("EW_Max_File_Size"));

	// For the BLOB field
	if (ht.get("x_ImagemFileSize") != null){
		fs_x_Imagem = ((Long) ht.get("x_ImagemFileSize")).intValue();

		// Check the file size
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

	// For the BLOB field
	if (ht.get("x_VideoFileSize") != null){
		fs_x_Video = ((Long) ht.get("x_VideoFileSize")).intValue();

		// Check the file size
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

	// For the BLOB field
	if (ht.get("x_SomFileSize") != null){
		fs_x_Som = ((Long) ht.get("x_SomFileSize")).intValue();

		// Check the file size
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

	// for other fields
	if (ht.get("x_id_Problema") != null) {
		x_id_Problema = (String) ht.get("x_id_Problema");
	}else{
		x_id_Problema = "";
	}
	if (ht.get("x_Detalhes") != null) {
		x_Detalhes = (String) ht.get("x_Detalhes");
	}else{
		x_Detalhes = "";
	}
	if (ht.get("x_Login") != null) {
		x_Login = (String) ht.get("x_Login");
	}else{
		x_Login = "";
	}
	ht = null;
} else {
	key = request.getParameter("key");
	if (key != null && key.length() > 0) {
		a = "C"; // Copy record
	} else {
		a = "I"; // Display blank record
	}
}

// Open Connection to the database
	Statement stmt = null;
	ResultSet rs = null;
try{
	stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	rs = null;
	if (a.equals("C")) { // Copy a record
		String tkey = "" + key.replaceAll("'",escapeString) + "";
		String strsql = "SELECT * FROM `solucoes` WHERE `id_Solucao`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("solucoeslist.jsp");
			response.flushBuffer();
			return;
		} else {
			rs.first();

			// Get the field contents
			x_id_Problema = String.valueOf(rs.getLong("id_Problema"));
			if (rs.getClob("Detalhes") != null) {
				long length = rs.getClob("Detalhes").length();
				x_Detalhes = rs.getClob("Detalhes").getSubString((long) 1, (int) length);
			}else{
				x_Detalhes = "";
			}
			if (rs.getString("Imagem") != null){
				x_Imagem = rs.getString("Imagem");
			}else{
				x_Imagem = "";
			}
			if (rs.getString("Video") != null){
				x_Video = rs.getString("Video");
			}else{
				x_Video = "";
			}
			if (rs.getString("Som") != null){
				x_Som = rs.getString("Som");
			}else{
				x_Som = "";
			}
			if (rs.getString("Login") != null){
				x_Login = rs.getString("Login");
			}else{
				x_Login = "";
			}
		}
		rs.close();
		rs = null;
	}else if (a.equals("A")) {// Add
		String strsql = "SELECT * FROM `solucoes` WHERE 0 = 1";
		rs = stmt.executeQuery(strsql);
		rs.moveToInsertRow();

		// Field id_Problema
		tmpfld = ((String) x_id_Problema).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("id_Problema");
		} else {
			rs.updateInt("id_Problema",Integer.parseInt(tmpfld));
		}

		// Field Detalhes
		tmpfld = ((String) x_Detalhes);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = "";
		}
		if (tmpfld == null) {
			rs.updateNull("Detalhes");
		}else{
			rs.updateString("Detalhes", tmpfld);
		}

		// Field Imagem
		tmpfld = fn_x_Imagem;
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

		// Field Video
		tmpfld = fn_x_Video;
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

		// Field Som
		tmpfld = fn_x_Som;
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
		rs.insertRow();
		rs.close();
		rs = null;
		stmt.close();
		stmt = null;
		conn.close();
		conn = null;
		out.clear();
		response.sendRedirect("solucoeslist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Adicionar TABELA: Solucoes<br><br><a href="solucoeslist.jsp">Voltar a lista</a></span></p>
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
if (EW_this.x_id_Problema && !EW_hasValue(EW_this.x_id_Problema, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_id_Problema, "SELECT", "Numero inteiro invalido! - Problema"))
                return false; 
        }
if (EW_this.x_Detalhes && !EW_hasValue(EW_this.x_Detalhes, "TEXTAREA" )) {
            if (!EW_onError(EW_this, EW_this.x_Detalhes, "TEXTAREA", "Informacoes sobre esta operacao sao essenciais!"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="solucoesadd.jsp" method="post" enctype="multipart/form-data">
<p>
<input type="hidden" name="a" value="A">
<input type="hidden" name="EW_Max_File_Size" value="50000000">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Problema</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% String tmp_x_id_Problema = (String) session.getAttribute("solucoes_masterkey");
if (tmp_x_id_Problema != null && tmp_x_id_Problema.length() > 0) {
x_id_Problema = tmp_x_id_Problema; %>
<%
if (x_id_Problema!=null && ((String)x_id_Problema).length() > 0) {
	String sqlwrk_where = "";
	tmpfld = (String) x_id_Problema;
	tmpfld = tmpfld.replaceAll("'", "\\\\'");
	sqlwrk_where = "`id_Problema` = '" + tmpfld + "'";
	String sqlwrk = "SELECT `id_Problema` FROM `problemas`";
	if (sqlwrk_where.length() > 0) {
	sqlwrk += " WHERE " + sqlwrk_where;
	}
	Statement stmtwrk = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rswrk = stmtwrk.executeQuery(sqlwrk);
	if (rswrk.next()) {
		out.print(rswrk.getString("id_Problema"));
	}
	rswrk.close();
	rswrk = null;
	stmtwrk.close();
	stmtwrk = null;
}
%>
<input type="hidden" name="x_id_Problema" value="<%= HTMLEncode((String)x_id_Problema) %>">
<% } else { %>
<%
String cbo_x_id_Problema_js = "";
String x_id_ProblemaList = "<select name=\"x_id_Problema\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Problema = "SELECT `id_Problema` FROM `problemas`" + " ORDER BY `id_Problema` DESC";
Statement stmtwrk_x_id_Problema = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Problema = stmtwrk_x_id_Problema.executeQuery(sqlwrk_x_id_Problema);
	int rowcntwrk_x_id_Problema = 0;
	while (rswrk_x_id_Problema.next()) {
		x_id_ProblemaList += "<option value=\"" + HTMLEncode(rswrk_x_id_Problema.getString("id_Problema")) + "\"";
		if (rswrk_x_id_Problema.getString("id_Problema").equals(x_id_Problema)) {
			x_id_ProblemaList += " selected";
		}
		String tmpValue_x_id_Problema = "";
		if (rswrk_x_id_Problema.getString("id_Problema")!= null) tmpValue_x_id_Problema = rswrk_x_id_Problema.getString("id_Problema");
		x_id_ProblemaList += ">" + tmpValue_x_id_Problema
 + "</option>";
		rowcntwrk_x_id_Problema++;
	}
rswrk_x_id_Problema.close();
rswrk_x_id_Problema = null;
stmtwrk_x_id_Problema.close();
stmtwrk_x_id_Problema = null;
x_id_ProblemaList += "</select>";
out.println(x_id_ProblemaList);
%>
<% } %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Detalhes</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><textarea name="x_Detalhes" cols="80" rows="4"><% if (x_Detalhes!=null) out.print(x_Detalhes); %></textarea><script language="JavaScript1.2">editor_generate('x_Detalhes');</script></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Imagem</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% x_Imagem = ""; // clear Blob related fields %>
<input type="file" name="x_Imagem"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Audio-visual</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% x_Video = ""; // clear Blob related fields %>
<input type="file" name="x_Video"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Audio-visual (cont)</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% x_Som = ""; // clear Blob related fields %>
<input type="file" name="x_Som"></span>&nbsp;</td>
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
<input type="submit" name="Action" value="Cadastrar">
</form>
<%@ include file="footer.jsp" %>
