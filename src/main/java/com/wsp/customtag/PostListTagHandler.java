package com.wsp.customtag;

import jakarta.servlet.jsp.tagext.TagSupport;
import jakarta.servlet.jsp.JspException;
import jakarta.servlet.jsp.JspWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.wsp.useclass.*;

public class PostListTagHandler extends TagSupport {
	private static final long serialVersionUID = 1L;
	
    @Override
    public int doStartTag() throws JspException {
        String dbURL = "jdbc:mysql://localhost:3306/ws_db";
        String dbUser = "wsp";
        String dbPassword = "1234";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
            String query = "SELECT id, title, content, user_nickname FROM posts ORDER BY created_at DESC";
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rs = pstmt.executeQuery();
            
            JspWriter out = pageContext.getOut();
            while (rs.next()) {
            	Post post = new Post();
            	post.setId(rs.getInt("id"));
            	post.setTitle(rs.getString("title"));
                post.setNickname(rs.getString("user_nickname"));
                
                out.write("<div class='post-item' onclick=\"location.href='content_board.jsp?post_id=" + post.getId() + "'\">");
                out.write("<span class='post-title'>" + post.getTitle() + "</span> - <span class='post-content'>" + post.getNickname() + "</span>");
                out.write("</div>");
            }
            rs.close();
            pstmt.close();
            conn.close();

        } catch (Exception e) {
            throw new JspException("Error: " + e.getMessage());
        }
        return SKIP_BODY;
    }
    
    @Override
    public int doAfterBody() throws JspException {
    	return super.doAfterBody();
    }
    
    @Override
	public int doEndTag() throws JspException {
    	return EVAL_PAGE;
	}
}
