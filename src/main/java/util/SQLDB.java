package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class SQLDB {
	public static Connection getConnection() throws SQLException {
		String url = System.getenv("DB_URL");
		String user = System.getenv("DB_USER");
		String db = System.getenv("DB_PASSWORD");
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		return DriverManager.getConnection(url, user, db);
	}
}


