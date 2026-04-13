package com.name.config;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
public class DBConfig {
	private static final String URL = "jdbc:mysql://127.0.0.1:3306/car_rental_management_sys";
	private static final String USERNAME = "user";
	private static final String PASSWORD = "";
	static {
    try {
        // Registering the JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    }
}
/**
Establishes and returns a database connection.*/
public static Connection getConnection() throws SQLException {
  return DriverManager.getConnection(URL, USERNAME, PASSWORD);}
}