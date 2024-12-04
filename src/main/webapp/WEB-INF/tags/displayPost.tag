<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="comment" required="true" type="com.wsp.useclass.Comment" %>


작성자: <%= comment.getAuthor() %> | 작성일: <%= comment.getCreatedAt() %>