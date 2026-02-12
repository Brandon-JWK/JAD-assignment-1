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
                    b.setClientName(rs.getString("client_name")); // You may need to add this field in Booking.java
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

    // Update booking status
    public void updateBookingStatus(int bookingId, String status) throws SQLException {
        String sql = "UPDATE booking SET status=? WHERE booking_id=?";
        try (Connection conn = DB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            ps.executeUpdate();
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
