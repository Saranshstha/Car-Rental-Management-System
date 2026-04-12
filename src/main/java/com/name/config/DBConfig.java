package com.name.config;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
public class DBConfig {
	private static final String URL = "jdbc:mysql://127.0.0.1:3306/auth_db";
	private static final String USERNAME = "user";
	private static final String PASSWORD = "";
	
		public static Connection getdbConnection()
		        throws SQLException, ClassNotFoundException{
			Class.forName("com.mysql.cj.jdbc.Driver");
			return DriverManager.getConnection(URL, USERNAME, PASSWORD);
		}
	
}