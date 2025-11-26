package dao;

import util.SQLDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Service;

public class CartDao {

    // Add service to cart/booking
    public void addToCart(int clientId, int serviceId) {
        String sql = "INSERT INTO booking (client_id, service_id) VALUES (?, ?)";

        try (Connection conn = SQLDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ps.setInt(2, serviceId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Get all cart items for a client
    public List<Service> getCartItems(int clientId) {
        List<Service> items = new ArrayList<>();

        String sql = "SELECT s.service_id, s.service_name, s.description, s.price, s.image_path " +
                     "FROM booking b JOIN service s ON b.service_id = s.service_id " +
                     "WHERE b.client_id = ?";

        try (Connection conn = SQLDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Service s = new Service();
                s.setServiceId(rs.getInt("service_id"));
                s.setServiceName(rs.getString("service_name"));
                s.setServiceDesc(rs.getString("description"));
                s.setPrice(rs.getDouble("price"));
                s.setImagePath(rs.getString("image_path"));
                items.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return items;
    }

    // Optional: Remove a service from cart
    public void removeFromCart(int clientId, int serviceId) {
        String sql = "DELETE FROM booking WHERE client_id = ? AND service_id = ?";

        try (Connection conn = SQLDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ps.setInt(2, serviceId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Optional: Clear all cart items for a client
    public void clearCart(int clientId) {
        String sql = "DELETE FROM booking WHERE client_id = ?";

        try (Connection conn = SQLDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}