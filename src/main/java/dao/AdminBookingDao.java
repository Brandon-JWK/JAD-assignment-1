package dao;

import models.Booking;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DB;

public class AdminBookingDao {

    // Get all bookings with client name, scheduled date/time, and status
    public List<Booking> getAllBookingsAdmin() throws SQLException {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.booking_id, b.client_id, c.full_name AS client_name, b.created_at, " +
                     "b.status, b.scheduled_date, b.scheduled_time, b.gst_rate, b.remarks " +
                     "FROM booking b JOIN client c ON b.client_id = c.client_id " +
                     "ORDER BY b.created_at DESC";

        try (Connection conn = DB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking(
                        rs.getInt("booking_id"),
                        rs.getInt("client_id"),
                        rs.getTimestamp("created_at"),
                        rs.getString("status")
                    );
                    b.setClientName(rs.getString("client_name"));
                    b.setScheduledDate(rs.getDate("scheduled_date"));
                    b.setScheduledTime(rs.getTime("scheduled_time"));
                    b.setGstRate(rs.getDouble("gst_rate"));
                    b.setRemarks(rs.getString("remarks"));
                    list.add(b);
                }
            }
        }
        return list;
    }

    /**
     * Update booking status and sync with service_status table.
     * Handles special cases for Cancelled / Completed.
     */
    public void updateBookingStatus(int bookingId, String status) throws SQLException {
        String sqlBooking = "UPDATE booking SET status=? WHERE booking_id=?";
        String sqlServiceStatus = "UPDATE service_status SET status=?";

        // Special handling for Cancelled or Completed
        if ("Cancelled".equalsIgnoreCase(status)) {
            sqlServiceStatus += ", check_in_time=NULL, check_out_time=NULL ";
        } else if ("Completed".equalsIgnoreCase(status)) {
            sqlServiceStatus += ", check_out_time=COALESCE(check_out_time, NOW()) ";
        }

        sqlServiceStatus += "WHERE booking_id=?";

        try (Connection conn = DB.getConnection()) {
            conn.setAutoCommit(false); // Transaction start

            try (PreparedStatement psBooking = conn.prepareStatement(sqlBooking);
                 PreparedStatement psStatus = conn.prepareStatement(sqlServiceStatus)) {

                // Update booking table
                psBooking.setString(1, status);
                psBooking.setInt(2, bookingId);
                psBooking.executeUpdate();

                // Update service_status table
                psStatus.setString(1, status);
                psStatus.setInt(2, bookingId);
                psStatus.executeUpdate();

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    // Delete booking (also deletes booking_details because of ON DELETE CASCADE)
    public void deleteBooking(int bookingId) throws SQLException {
        String sql = "DELETE FROM booking WHERE booking_id=?";
        try (Connection conn = DB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.executeUpdate();
        }
    }
}
