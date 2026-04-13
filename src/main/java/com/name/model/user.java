package com.name.model;

public class User {

    private int id;
    private String name;
    private String email;
    private String password;
    private String role;
    private int failedAttempts;
    private boolean locked;

    public User() {}

    public int getId()                     { return id; }
    public void setId(int id)              { this.id = id; }
    public String getName()                { return name; }
    public void setName(String name)       { this.name = name; }
    public String getEmail()               { return email; }
    public void setEmail(String email)     { this.email = email; }
    public String getPassword()            { return password; }
    public void setPassword(String pw)     { this.password = pw; }
    public String getRole()                { return role; }
    public void setRole(String role)       { this.role = role; }
    public int getFailedAttempts()         { return failedAttempts; }
    public void setFailedAttempts(int n)   { this.failedAttempts = n; }
    public boolean isLocked()              { return locked; }
    public void setLocked(boolean locked)  { this.locked = locked; }
}