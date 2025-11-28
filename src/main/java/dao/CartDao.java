package dao;

import util.SQLDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Service;

public class CartDao {

    // Find an existing pending booking
    private Integer findPendingBookingId(Connection conn, int clientId) throws SQLException {
        String sql = "SELECT booking_id FROM booking WHERE client_id = ? AND status = 'Pending' LIMIT 1";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clientId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("booking_id");
            }
        }
        return null;
    }

    // Create new pending booking
    private int createPendingBooking(Connection conn, int clientId) throws SQLException {
        String sql = "INSERT INTO booking (client_id, status) VALUES (?, 'Pending')";

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, clientId);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("Failed to create pending booking.");
    }

    // Returns existing or creates new
    private int getOrCreatePendingBooking(Connection conn, int clientId) throws SQLException {
        Integer existing = findPendingBookingId(conn, clientId);
        return (existing != null) ? existing : createPendingBooking(conn, clientId);
    }

    // Add item to booking_details
    public void addToCart(int clientId, int serviceId) {
        String sql = "INSERT INTO booking_details (booking_id, service_id) VALUES (?, ?)";

        try (Connection conn = SQLDB.getConnection()) {
            int bookingId = getOrCreatePendingBooking(conn, clientId);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, bookingId);
                ps.setInt(2, serviceId);
                ps.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ============================
    // CORRECT CART SELECT QUERY
    // ============================
    public List<Service> getCartItems(int clientId) {
        List<Service> items = new ArrayList<>();

        String sql =
            "SELECT bd.detail_id, b.booking_id, s.service_id, s.service_name, " +
            "s.description, s.price, s.image_path " +
            "FROM booking b " +
            "JOIN booking_details bd ON b.booking_id = bd.booking_id " +
            "JOIN service s ON bd.service_id = s.service_id " +
            "WHERE b.client_id = ? AND b.status = 'Pending'";

        try (Connection conn = SQLDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service s = new Service();
                    s.setServiceId(rs.getInt("service_id"));
                    s.setServiceName(rs.getString("service_name"));
                    s.setServiceDesc(rs.getString("description"));
                    s.setPrice(rs.getDouble("price"));
                    s.setImagePath(rs.getString("image_path"));
                    s.setBookingId(rs.getInt("booking_id"));
                    s.setDetailId(rs.getInt("detail_id"));   // NEW: needed for deletion
                    items.add(s);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return items;
    }

    // ============================
    // FIX: Remove JUST ONE ITEM
    // ============================
    public void removeFromCart(int detailId) {
        String sql = "DELETE FROM booking_details WHERE detail_id = ?";

        try (Connection conn = SQLDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, detailId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Clear pending booking
    public void clearCart(int clientId) {
        String sql = "DELETE FROM booking WHERE client_id = ? AND status = 'Pending'";

        try (Connection conn = SQLDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Integer getPendingBookingId(int clientId) {
        try (Connection conn = SQLDB.getConnection()) {
            return findPendingBookingId(conn, clientId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
