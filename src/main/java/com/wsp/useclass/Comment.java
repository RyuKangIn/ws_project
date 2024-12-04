package com.wsp.useclass;

import java.util.ArrayList;
import java.util.List;

public class Comment {
    private int id; // 댓글의 고유 ID
    private int userId; // 댓글 작성자의 ID
    private String author; // 댓글 작성자 이름 또는 닉네임
    private String content; // 댓글 내용
    private String created_at;

    // 생성자
    public Comment(int id, int userId, String author, String content, String created_at) {
        this.id = id;
        this.userId = userId;
        this.author = author;
        this.content = content;
        this.created_at = created_at;
    }

    // ID getter
    public int getId() {
        return id;
    }

    // ID setter
    public void setId(int id) {
        this.id = id;
    }

    // 작성자 ID getter
    public int getUserId() {
        return userId;
    }

    // 작성자 ID setter
    public void setUserId(int userId) {
        this.userId = userId;
    }

    // 작성자 이름 getter
    public String getAuthor() {
        return author;
    }

    // 작성자 이름 setter
    public void setAuthor(String author) {
        this.author = author;
    }

    // 내용 getter
    public String getContent() {
        return content;
    }

    // 내용 setter
    public void setContent(String content) {
        this.content = content;
    }
    // 내용 getter
    public String getCreatedAt() {
        return created_at;
    }

    // 내용 setter
    public void setCreatedAt(String created_at) {
        this.created_at = created_at;
    }
}
