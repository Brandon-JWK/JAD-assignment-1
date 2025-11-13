//package dao;
//
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//
//import util.DB;
//
//public class UserDao {
//	public boolean getUser(String loginId, String password) {
//		try (Connection c = DB.getConnection()) {
//			// Prepare an SQL statement with placeholders (?) to prevent SQL injection
//			PreparedStatement ps = c.prepareStatement("SELECT * FROM users WHERE loginid = ? AND password = ?");
//			// Bind the parameters to the SQL query
//            ps.setString(1, loginId);
//            ps.setString(2, password);
//            // Execute the query and store the result set
//			ResultSet rs = ps.executeQuery();
//			// If the query returns at least one record, credentials are valid
//			return rs.next();
//
//		} catch (Exception err) {
//			err.printStackTrace();
//			return false;
//		}
//	}
//	
//	public static void main(String[]args) {
//
//	}
//}