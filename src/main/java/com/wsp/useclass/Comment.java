package com.wsp.useclass;

import java.util.ArrayList;
import java.util.List;

public class Comment {
    private String author;
    private String content;
    
    public Comment(String author, String content) {
    	this.author = author;
    	this.content = content;
    }

    // 작성자 getter
    public String getAuthor() {
        return author;
    }

    // 내용 getter
    public String getContent() {
        return content;
    }
}
