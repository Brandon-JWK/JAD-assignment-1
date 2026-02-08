package dao;

import java.sql.*;
import java.util.*;

import util.DB;
import models.Client;

public class ClientDao {

    // Register new client
    public boolean register(Client c) {
        String sql = "INSERT INTO client(full_name, email, password, phone, address) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, c.getFullName());
            ps.setString(2, c.getEmail());
            ps.setString(3, c.getPassword()); // For production: hash it
            ps.setString(4, c.getPhone());
            ps.setString(5, c.getAddress());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Login validation
    public Client login(String email, String password) {
        String sql = "SELECT * FROM client WHERE email = ? AND password = ?";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("DB Connection: " + conn);
            System.out.println("Trying login with: " + email + " / " + password);

            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                System.out.println("Login successful for: " + email);
                return new Client(
                    rs.getInt("client_id"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("phone"),
                    rs.getString("address")
                );
            } else {
                System.out.println("No match found for: " + email + " / " + password);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Retrieve client info
    public Client getClientById(int clientId) {
        String sql = "SELECT * FROM client WHERE client_id = ?";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("Fetching client with ID: " + clientId);
            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Client(
                    rs.getInt("client_id"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("phone"),
                    rs.getString("address")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update
    public boolean update(Client c) {
        String sql = "UPDATE client SET full_name = ?, email = ?, phone = ?, address = ? WHERE client_id = ?";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, c.getFullName());
            ps.setString(2, c.getEmail());
            ps.setString(3, c.getPhone());
            ps.setString(4, c.getAddress());
            ps.setInt(5, c.getClientId());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete
    public boolean delete(int clientId) {
        String sql = "DELETE FROM client WHERE client_id = ?";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    // Get all clients
    public List<Client> getAllClients() {
        List<Client> list = new ArrayList<>();
        String sql = "SELECT * FROM client ORDER BY client_id ASC";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Client(
                    rs.getInt("client_id"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("phone"),
                    rs.getString("address")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}
