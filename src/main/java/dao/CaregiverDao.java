package dao;

import models.Caregiver;
import models.ServiceStatus;
import util.DB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CaregiverDao {

    // -------------------- LOGIN --------------------
    public Caregiver login(String email, String password) {
        String sql = "SELECT * FROM caregiver WHERE email = ? AND password = ?";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Caregiver(
                        rs.getInt("caregiver_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("phone"),
                        rs.getString("specialization")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // -------------------- BOOKINGS & SERVICE STATUS --------------------
    public List<ServiceStatus> getAssignedBookings(int caregiverId) {
        List<ServiceStatus> list = new ArrayList<>();
        String sql = "SELECT ss.status_id, ss.booking_id, ss.status, ss.check_in_time, ss.check_out_time, ss.caregiver_notes, ss.updated_at, "
                   + "b.client_id, b.scheduled_date, b.scheduled_time "
                   + "FROM service_status ss "
                   + "JOIN booking b ON ss.booking_id = b.booking_id "
                   + "WHERE b.caregiver_id = ? "
                   + "ORDER BY b.scheduled_date, b.scheduled_time";

        // Use try-with-resources to get connection internally
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, caregiverId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ServiceStatus ss = new ServiceStatus();
                ss.setStatusId(rs.getInt("status_id"));
                ss.setBookingId(rs.getInt("booking_id"));
                ss.setStatus(rs.getString("status"));
                ss.setCheckInTime(rs.getTimestamp("check_in_time") != null
                                  ? rs.getTimestamp("check_in_time").toLocalDateTime() : null);
                ss.setCheckOutTime(rs.getTimestamp("check_out_time") != null
                                   ? rs.getTimestamp("check_out_time").toLocalDateTime() : null);
                ss.setCaregiverNotes(rs.getString("caregiver_notes"));
                ss.setUpdatedAt(rs.getTimestamp("updated_at") != null
                                ? rs.getTimestamp("updated_at").toLocalDateTime() : null);
                list.add(ss);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

 // -------------------- BOOKINGS & SERVICE STATUS --------------------
    public boolean checkIn(int statusId) throws SQLException {
        String sql = "UPDATE service_status " +
                     "SET check_in_time = NOW(), status = 'In Progress' " +
                     "WHERE status_id = ? AND check_in_time IS NULL";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, statusId);
            int rows = ps.executeUpdate();
            return rows > 0; // true if check-in succeeded
        }
    }

    public boolean checkOut(int statusId) throws SQLException {
        String sql = "UPDATE service_status " +
                     "SET check_out_time = NOW(), status = 'Completed' " +
                     "WHERE status_id = ? AND check_in_time IS NOT NULL AND check_out_time IS NULL";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, statusId);
            int rows = ps.executeUpdate();
            return rows > 0; // true if check-out succeeded
        }
    }



    public void addNotes(int statusId, String notes) {
        String sql = "UPDATE service_status SET caregiver_notes = ? WHERE status_id = ?";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, notes);
            ps.setInt(2, statusId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    
}
