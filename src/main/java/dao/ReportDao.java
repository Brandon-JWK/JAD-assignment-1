package dao;

import util.DB;

import java.sql.*;
import java.util.*;

public class ReportDao {

    public List<Map<String, Object>> getServiceRatings(boolean bestFirst, int limit) throws SQLException {
        String order = bestFirst ? "DESC" : "ASC";

        String sql =
            "SELECT s.service_id, s.service_name, " +
            "       ROUND(AVG(f.rating), 2) AS avg_rating, COUNT(*) AS total_reviews " +
            "FROM service s " +
            "JOIN feedback f ON f.service_id = s.service_id " +
            "GROUP BY s.service_id, s.service_name " +
            "ORDER BY avg_rating " + order + " " +
            "LIMIT ?";

        List<Map<String, Object>> rows = new ArrayList<>();

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("serviceId", rs.getInt("service_id"));
                    row.put("serviceName", rs.getString("service_name"));
                    row.put("avgRating", rs.getDouble("avg_rating"));
                    row.put("totalReviews", rs.getInt("total_reviews"));
                    rows.add(row);
                }
            }
        }
        return rows;
    }

    public List<Map<String, Object>> getHighDemandServices(int limit) throws SQLException {
        String sql =
            "SELECT s.service_id, s.service_name, COUNT(*) AS times_booked " +
            "FROM booking_details bd " +
            "JOIN booking b ON b.booking_id = bd.booking_id " +
            "JOIN service s ON s.service_id = bd.service_id " +
            "WHERE b.status = 'Confirmed' " +
            "GROUP BY s.service_id, s.service_name " +
            "ORDER BY times_booked DESC " +
            "LIMIT ?";

        List<Map<String, Object>> rows = new ArrayList<>();

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("serviceId", rs.getInt("service_id"));
                    row.put("serviceName", rs.getString("service_name"));
                    row.put("timesBooked", rs.getInt("times_booked"));
                    rows.add(row);
                }
            }
        }
        return rows;
    }

    // FIXED ONLY_FULL_GROUP_BY
    public List<Map<String, Object>> getBookingsByMonth() throws SQLException {
        String sql =
            "SELECT DATE_FORMAT(b.created_at, '%Y-%m') AS ym, " +
            "       COUNT(DISTINCT b.booking_id) AS total_bookings, " +
            "       ROUND(SUM(bd.quantity * bd.unit_price) * (1 + IFNULL(AVG(b.gst_rate), 0)), 2) AS revenue " +
            "FROM booking b " +
            "JOIN booking_details bd ON bd.booking_id = b.booking_id " +
            "WHERE b.status = 'Confirmed' " +
            "GROUP BY ym " +
            "ORDER BY ym DESC";

        List<Map<String, Object>> rows = new ArrayList<>();

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("month", rs.getString("ym"));
                row.put("totalBookings", rs.getInt("total_bookings"));
                row.put("revenue", rs.getDouble("revenue"));
                rows.add(row);
            }
        }
        return rows;
    }

    // FIXED ONLY_FULL_GROUP_BY
    public List<Map<String, Object>> getTopClients(int limit) throws SQLException {
        String sql =
            "SELECT c.client_id, c.full_name, c.email, " +
            "       ROUND(SUM(bd.quantity * bd.unit_price) * (1 + IFNULL(AVG(b.gst_rate), 0)), 2) AS total_value, " +
            "       COUNT(DISTINCT b.booking_id) AS total_bookings " +
            "FROM client c " +
            "JOIN booking b ON b.client_id = c.client_id " +
            "JOIN booking_details bd ON bd.booking_id = b.booking_id " +
            "WHERE b.status = 'Confirmed' " +
            "GROUP BY c.client_id, c.full_name, c.email " +
            "ORDER BY total_value DESC " +
            "LIMIT ?";

        List<Map<String, Object>> rows = new ArrayList<>();

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("clientId", rs.getInt("client_id"));
                    row.put("fullName", rs.getString("full_name"));
                    row.put("email", rs.getString("email"));
                    row.put("totalValue", rs.getDouble("total_value"));
                    row.put("totalBookings", rs.getInt("total_bookings"));
                    rows.add(row);
                }
            }
        }
        return rows;
    }
}
