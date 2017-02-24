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
if ((ewCurSec & ewAllowAdd) != ewAllowAdd) {
	response.sendRedirect("retirada_de_componenteslist.jsp"); 
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
Object x_id_Retirada_de_Componentes = "";
Object x_id_Problema = "";
Object x_id_Componente = "";
Object x_Qtd_retirada = "";
Object x_Data_retirada = "";
Object x_Destino_do_componente = "";
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
Object x_Relacao_confianca = "";
Object x_Com_quem = "";
Object x_Telefone_confianca = "";
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
	if (ht.get("x_id_Componente") != null) {
		x_id_Componente = (String) ht.get("x_id_Componente");
	}else{
		x_id_Componente = "";
	}
	if (ht.get("x_Qtd_retirada") != null) {
		x_Qtd_retirada = (String) ht.get("x_Qtd_retirada");
	}else{
		x_Qtd_retirada = "";
	}
	if (ht.get("x_Data_retirada") != null) {
		x_Data_retirada = (String) ht.get("x_Data_retirada");
	}else{
		x_Data_retirada = "";
	}
	if (ht.get("x_Destino_do_componente") != null) {
		x_Destino_do_componente = (String) ht.get("x_Destino_do_componente");
	}else{
		x_Destino_do_componente = "";
	}
	if (ht.get("x_Relacao_confianca") != null) {
		x_Relacao_confianca = (String) ht.get("x_Relacao_confianca");
	}else{
		x_Relacao_confianca = "";
	}
	if (ht.get("x_Com_quem") != null) {
		x_Com_quem = (String) ht.get("x_Com_quem");
	}else{
		x_Com_quem = "";
	}
	if (ht.get("x_Telefone_confianca") != null) {
		x_Telefone_confianca = (String) ht.get("x_Telefone_confianca");
	}else{
		x_Telefone_confianca = "";
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
		String strsql = "SELECT * FROM `retirada_de_componentes` WHERE `id_Retirada_de_Componentes`=" + tkey;
		rs = stmt.executeQuery(strsql);
		if (!rs.next()) {
			rs.close();
			rs = null;
			stmt.close();
			stmt = null;
			conn.close();
			conn = null;
			out.clear();
			response.sendRedirect("retirada_de_componenteslist.jsp");
			response.flushBuffer();
			return;
		} else {
			rs.first();

			// Get the field contents
			x_id_Problema = String.valueOf(rs.getLong("id_Problema"));
			x_id_Componente = String.valueOf(rs.getLong("id_Componente"));
			x_Qtd_retirada = String.valueOf(rs.getLong("Qtd_retirada"));
			if (rs.getTimestamp("Data_retirada") != null){
				x_Data_retirada = rs.getTimestamp("Data_retirada");
			}else{
				x_Data_retirada = null;
			}
			x_Destino_do_componente = String.valueOf(rs.getLong("Destino_do_componente"));
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
			x_Relacao_confianca = String.valueOf(rs.getLong("Relacao_confianca"));
			if (rs.getString("Com_quem") != null){
				x_Com_quem = rs.getString("Com_quem");
			}else{
				x_Com_quem = "";
			}
			if (rs.getString("Telefone_confianca") != null){
				x_Telefone_confianca = rs.getString("Telefone_confianca");
			}else{
				x_Telefone_confianca = "";
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
		String strsql = "SELECT * FROM `retirada_de_componentes` WHERE 0 = 1";
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

		// Field id_Componente
		tmpfld = ((String) x_id_Componente).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("id_Componente");
		} else {
			rs.updateInt("id_Componente",Integer.parseInt(tmpfld));
		}

		// Field Qtd_retirada
		tmpfld = ((String) x_Qtd_retirada).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("Qtd_retirada");
		} else {
			rs.updateInt("Qtd_retirada",Integer.parseInt(tmpfld));
		}

		// Field Data_retirada
		if (IsDate((String) x_Data_retirada,"EURODATE", locale)) {
			rs.updateTimestamp("Data_retirada", EW_UnFormatDateTime((String)x_Data_retirada,"EURODATE", locale));
		}else{
			rs.updateNull("Data_retirada");
		}

		// Field Destino_do_componente
		tmpfld = ((String) x_Destino_do_componente).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("Destino_do_componente");
		} else {
			rs.updateInt("Destino_do_componente",Integer.parseInt(tmpfld));
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

		// Field Relacao_confianca
		tmpfld = ((String) x_Relacao_confianca).trim();
		if (!IsNumeric(tmpfld)) { tmpfld = "0";}
		if (tmpfld == null) {
			rs.updateNull("Relacao_confianca");
		} else {
			rs.updateInt("Relacao_confianca",Integer.parseInt(tmpfld));
		}

		// Field Com_quem
		tmpfld = ((String) x_Com_quem);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Com_quem");
		}else{
			rs.updateString("Com_quem", tmpfld);
		}

		// Field Telefone_confianca
		tmpfld = ((String) x_Telefone_confianca);
		if (tmpfld == null || tmpfld.trim().length() == 0) {
			tmpfld = null;
		}
		if (tmpfld == null) {
			rs.updateNull("Telefone_confianca");
		}else{
			rs.updateString("Telefone_confianca", tmpfld);
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
		response.sendRedirect("retirada_de_componenteslist.jsp");
		response.flushBuffer();
		return;
	}
}catch (SQLException ex){
	out.println(ex.toString());
}
%>
<%@ include file="header.jsp" %>
<p><span class="jspmaker">Adicionar TABELA: Retirada de componentes<br><br><a href="retirada_de_componenteslist.jsp">Voltar a lista</a></span></p>
<script language="JavaScript" src="ew.js"></script>
<script language="JavaScript" src="popcalendar.js"></script>
<script language="JavaScript">
<!-- start Javascript
function  EW_checkMyForm(EW_this) {
if (EW_this.x_id_Problema && !EW_hasValue(EW_this.x_id_Problema, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_id_Problema, "TEXT", "Numero inteiro invalido! - Problema"))
                return false; 
        }
if (EW_this.x_id_Problema && !EW_checkinteger(EW_this.x_id_Problema.value)) {
        if (!EW_onError(EW_this, EW_this.x_id_Problema, "TEXT", "Numero inteiro invalido! - Problema"))
            return false; 
        }
if (EW_this.x_id_Componente && !EW_hasValue(EW_this.x_id_Componente, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_id_Componente, "SELECT", "Informe o componente retirado!"))
                return false; 
        }
if (EW_this.x_Qtd_retirada && !EW_hasValue(EW_this.x_Qtd_retirada, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_Qtd_retirada, "TEXT", "Informe a quantidade retirada!"))
                return false; 
        }
if (EW_this.x_Qtd_retirada && !EW_checkinteger(EW_this.x_Qtd_retirada.value)) {
        if (!EW_onError(EW_this, EW_this.x_Qtd_retirada, "TEXT", "Informe a quantidade retirada!"))
            return false; 
        }
if (EW_this.x_Data_retirada && !EW_hasValue(EW_this.x_Data_retirada, "TEXT" )) {
            if (!EW_onError(EW_this, EW_this.x_Data_retirada, "TEXT", "Informe a data da retirada!"))
                return false; 
        }
if (EW_this.x_Data_retirada && !EW_checkeurodate(EW_this.x_Data_retirada.value)) {
        if (!EW_onError(EW_this, EW_this.x_Data_retirada, "TEXT", "Informe a data da retirada!"))
            return false; 
        }
if (EW_this.x_Destino_do_componente && !EW_hasValue(EW_this.x_Destino_do_componente, "SELECT" )) {
            if (!EW_onError(EW_this, EW_this.x_Destino_do_componente, "SELECT", "Informe o estado do componente retirado!"))
                return false; 
        }
if (EW_this.x_Relacao_confianca && !EW_hasValue(EW_this.x_Relacao_confianca, "RADIO" )) {
            if (!EW_onError(EW_this, EW_this.x_Relacao_confianca, "RADIO", "Informe o tipo de retirada!"))
                return false; 
        }
return true;
}

// end JavaScript -->
</script>
<form onSubmit="return EW_checkMyForm(this);"  action="retirada_de_componentesadd.jsp" method="post" enctype="multipart/form-data">
<p>
<input type="hidden" name="a" value="A">
<input type="hidden" name="EW_Max_File_Size" value="50000000">
<table border="0" cellspacing="1" cellpadding="4" bgcolor="#CCCCCC">
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Problema</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><% String tmp_x_id_Problema = (String) session.getAttribute("retirada_de_componentes_masterkey");
if (tmp_x_id_Problema != null && tmp_x_id_Problema.length() > 0) {
x_id_Problema = tmp_x_id_Problema; %>
<% out.print(x_id_Problema); %><input type="hidden" name="x_id_Problema" value="<%= HTMLEncode((String)x_id_Problema) %>">
<% } else { %>
<input type="text" name="x_id_Problema" size="30" value="<%= HTMLEncode((String)x_id_Problema) %>">
<% } %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Componente</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_id_Componente_js = "";
String x_id_ComponenteList = "<select name=\"x_id_Componente\"><option value=\"\">Selecione</option>";
String sqlwrk_x_id_Componente = "SELECT `id_Componente`, `Descricao_do_componente` FROM `componentes`" + " ORDER BY `Descricao_do_componente` ASC";
Statement stmtwrk_x_id_Componente = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
ResultSet rswrk_x_id_Componente = stmtwrk_x_id_Componente.executeQuery(sqlwrk_x_id_Componente);
	int rowcntwrk_x_id_Componente = 0;
	while (rswrk_x_id_Componente.next()) {
		x_id_ComponenteList += "<option value=\"" + HTMLEncode(rswrk_x_id_Componente.getString("id_Componente")) + "\"";
		if (rswrk_x_id_Componente.getString("id_Componente").equals(x_id_Componente)) {
			x_id_ComponenteList += " selected";
		}
		String tmpValue_x_id_Componente = "";
		if (rswrk_x_id_Componente.getString("Descricao_do_componente")!= null) tmpValue_x_id_Componente = rswrk_x_id_Componente.getString("Descricao_do_componente");
		x_id_ComponenteList += ">" + tmpValue_x_id_Componente
 + "</option>";
		rowcntwrk_x_id_Componente++;
	}
rswrk_x_id_Componente.close();
rswrk_x_id_Componente = null;
stmtwrk_x_id_Componente.close();
stmtwrk_x_id_Componente = null;
x_id_ComponenteList += "</select>";
out.println(x_id_ComponenteList);
%>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Qtd retirada</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Qtd_retirada" size="30" value="<%= HTMLEncode((String)x_Qtd_retirada) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Data retirada</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Data_retirada" value="<%= EW_FormatDateTime(x_Data_retirada,7, locale) %>">&nbsp;<input type="image" src="images/ew_calendar.gif" alt="Pick a Date" onClick="popUpCalendar(this, this.form.x_Data_retirada,'dd/mm/yyyy');return false;"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Estado do componente</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><%
String cbo_x_Destino_do_componente_js = "";
String x_Destino_do_componenteList = "<select name=\"x_Destino_do_componente\"><option value=\"\">Selecione</option>";
x_Destino_do_componenteList += "<option value=\"" + HTMLEncode("1") + "\"";
if (x_Destino_do_componente != null && x_Destino_do_componente.equals("1")) {
	x_Destino_do_componenteList += " selected";
}
x_Destino_do_componenteList += ">" + "Novo" + "</option>";
x_Destino_do_componenteList += "<option value=\"" + HTMLEncode("2") + "\"";
if (x_Destino_do_componente != null && x_Destino_do_componente.equals("2")) {
	x_Destino_do_componenteList += " selected";
}
x_Destino_do_componenteList += ">" + "Seminovo" + "</option>";
x_Destino_do_componenteList += "<option value=\"" + HTMLEncode("3") + "\"";
if (x_Destino_do_componente != null && x_Destino_do_componente.equals("3")) {
	x_Destino_do_componenteList += " selected";
}
x_Destino_do_componenteList += ">" + "Recuperavel" + "</option>";
x_Destino_do_componenteList += "<option value=\"" + HTMLEncode("4") + "\"";
if (x_Destino_do_componente != null && x_Destino_do_componente.equals("4")) {
	x_Destino_do_componenteList += " selected";
}
x_Destino_do_componenteList += ">" + "Irrecuperavel" + "</option>";
x_Destino_do_componenteList += "</select>";
out.print(x_Destino_do_componenteList);
%>
</span>&nbsp;</td>
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
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Tipo de retirada</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="radio" name="x_Relacao_confianca"<% if (x_Relacao_confianca != null && ((String)x_Relacao_confianca).equals("1")) { out.print(" checked"); } %> value="<%= HTMLEncode("1") %>"><%= "Interna" %>
<input type="radio" name="x_Relacao_confianca"<% if (x_Relacao_confianca != null && ((String)x_Relacao_confianca).equals("2")) { out.print(" checked"); } %> value="<%= HTMLEncode("2") %>"><%= "Externa" %>
</span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Executor externo</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Com_quem" size="70" maxlength="50" value="<%= HTMLEncode((String)x_Com_quem) %>"></span>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#594FBF"><span class="jspmaker" style="color: #FFFFFF;">Telefone do executor</span>&nbsp;</td>
		<td bgcolor="#F5F5F5"><span class="jspmaker"><input type="text" name="x_Telefone_confianca" size="70" maxlength="50" value="<%= HTMLEncode((String)x_Telefone_confianca) %>"></span>&nbsp;</td>
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
