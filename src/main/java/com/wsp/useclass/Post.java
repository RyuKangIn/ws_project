package com.wsp.useclass;

public class Post {
	private int id;
    private String title;
    private String content;
    private String nickname;
    
    public Post() {
    	
    }
    public Post(int pid, String title) {
    	this.id= pid;
    	this.title=title;
    }
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }
}
