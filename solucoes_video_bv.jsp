<%@ include file="db.jsp" %>
<%@ page session="true" buffer="16kb" import="java.sql.*,java.util.*,java.text.*,java.io.*"%>
<%
String escapeString = "\\\\'";

// Get key
String key = request.getParameter("key");
if (key == null || key.length() == 0) {
	response.sendRedirect("solucoeslist.jsp");
	response.flushBuffer();
	return;
}

// Open Connection to the database
try{
	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	ResultSet rs = null;
	String tkey = "" + key.replaceAll("'","\\\\'") + "";
	String strsql = "SELECT * FROM `solucoes` WHERE `id_Solucao`=" + tkey;
	rs = stmt.executeQuery(strsql);
	if (rs.next()) {
		out.clear();
		if (rs.getString("Video") != null) {
			response.addHeader("Content-Disposition", "attachment; filename=\"" + rs.getString("Video") + "\"");
		}
		response.flushBuffer();
	}
rs.close();
rs = null;
stmt.close();
stmt = null;
conn.close();
conn = null;
}catch (SQLException ex){
	out.println(ex.toString());
}
%>
