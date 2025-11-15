package dao;

import java.sql.*;
import util.DB;

public class AdminDao {

    public boolean validateLogin(String username, String password) {
        String sql = "SELECT * FROM admin WHERE username = ? AND password = ?";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            return rs.next(); // found admin

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
