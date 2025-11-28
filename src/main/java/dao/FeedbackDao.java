package dao;

import util.SQLDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Feedback;

public class FeedbackDao {

    // Add new feedback
    public void addFeedback(Feedback fb) {
        String sql = "INSERT INTO feedback (client_id, service_id, rating, comments) VALUES (?, ?, ?, ?)";

        try (Connection conn = SQLDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, fb.getClientId());
            ps.setInt(2, fb.getServiceId());
            ps.setInt(3, fb.getRating());
            ps.setString(4, fb.getComments());
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Get all feedback for a service
    public List<Feedback> getFeedbackByService(int serviceId) {
        List<Feedback> list = new ArrayList<>();

        String sql = "SELECT * FROM feedback WHERE service_id = ? ORDER BY created_at DESC";

        try (Connection conn = SQLDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Feedback fb = new Feedback();
                fb.setFeedbackId(rs.getInt("feedback_id"));
                fb.setClientId(rs.getInt("client_id"));
                fb.setServiceId(rs.getInt("service_id"));
                fb.setRating(rs.getInt("rating"));
                fb.setComments(rs.getString("comments"));
                fb.setCreatedAt(rs.getString("created_at"));
                list.add(fb);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Optional: Get all feedback by a client
    public List<Feedback> getFeedbackByClient(int clientId) {
        List<Feedback> list = new ArrayList<>();

        String sql = "SELECT * FROM feedback WHERE client_id = ? ORDER BY created_at DESC";

        try (Connection conn = SQLDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Feedback fb = new Feedback();
                fb.setFeedbackId(rs.getInt("feedback_id"));
                fb.setClientId(rs.getInt("client_id"));
                fb.setServiceId(rs.getInt("service_id"));
                fb.setRating(rs.getInt("rating"));
                fb.setComments(rs.getString("comments"));
                fb.setCreatedAt(rs.getString("created_at"));
                list.add(fb);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
