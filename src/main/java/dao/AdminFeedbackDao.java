package dao;

import models.Feedback;
import util.DB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminFeedbackDao {

    // Get all feedback with client name & service name
    public List<Feedback> getAllFeedbackAdmin() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.feedback_id, f.client_id, f.service_id, f.rating, f.comments, f.created_at, " +
                     "c.full_name AS client_name, s.service_name " +
                     "FROM feedback f " +
                     "LEFT JOIN client c ON f.client_id = c.client_id " +
                     "LEFT JOIN service s ON f.service_id = s.service_id " +
                     "ORDER BY f.created_at DESC";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Feedback f = new Feedback();
                f.setFeedbackId(rs.getInt("feedback_id"));
                f.setClientId(rs.getInt("client_id"));
                f.setServiceId(rs.getInt("service_id"));
                f.setRating(rs.getInt("rating"));
                f.setComments(rs.getString("comments"));
                f.setCreatedAt(rs.getString("created_at"));
                f.setClientName(rs.getString("client_name"));
                f.setServiceName(rs.getString("service_name"));
                list.add(f);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Delete feedback
    public void deleteFeedback(int feedbackId) {
        String sql = "DELETE FROM feedback WHERE feedback_id=?";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, feedbackId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    
}
