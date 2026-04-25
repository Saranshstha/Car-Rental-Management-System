package com.name.model;

public class User {
    private int     id;
    private String  name;
    private String  email;
    private String  password;
    private String  role;
    private int     failedAttempts;
    private boolean locked;

    public User() {}

    public int     getId()                       { return id; }
    public void    setId(int v)                  { this.id = v; }
    public String  getName()                     { return name; }
    public void    setName(String v)             { this.name = v; }
    public String  getEmail()                    { return email; }
    public void    setEmail(String v)            { this.email = v; }
    public String  getPassword()                 { return password; }
    public void    setPassword(String v)         { this.password = v; }
    public String  getRole()                     { return role; }
    public void    setRole(String v)             { this.role = v; }
    public int     getFailedAttempts()           { return failedAttempts; }
    public void    setFailedAttempts(int v)      { this.failedAttempts = v; }
    public boolean isLocked()                    { return locked; }
    public void    setLocked(boolean v)          { this.locked = v; }
}