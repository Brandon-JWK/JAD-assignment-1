package dao;

import java.sql.*;
import util.DB;

public class AdminDao {

    // Admin login validation
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

    // Delete client (admin privilege)
    public boolean deleteClient(int clientId) {
        String deleteFeedbackSql = "DELETE FROM feedback WHERE client_id = ?";
        String deleteClientSql = "DELETE FROM client WHERE client_id = ?";

        try (Connection conn = DB.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(deleteFeedbackSql)) {
                ps1.setInt(1, clientId);
                ps1.executeUpdate();
            }

            int rowsDeleted = 0;
            try (PreparedStatement ps2 = conn.prepareStatement(deleteClientSql)) {
                ps2.setInt(1, clientId);
                rowsDeleted = ps2.executeUpdate();
            }

            conn.commit();
            return rowsDeleted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
