package dao;

import models.Booking;
import models.BookingDetail;
import util.DB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDao {

    /**
     * Create booking. If Assignment 2 columns exist, it will write schedule + gst_rate + remarks.
     * If not, fallback to old schema (client_id, status).
     */
    public int createBooking(int clientId, Date scheduledDate, Time scheduledTime, double gstRate, String remarks)
            throws SQLException {

        // Try new schema insert first
        String sqlNew = "INSERT INTO booking (client_id, status, scheduled_date, scheduled_time, gst_rate, remarks) " +
                        "VALUES (?, 'Confirmed', ?, ?, ?, ?)";

        // Old schema insert fallback (your current dump)
        String sqlOld = "INSERT INTO booking (client_id, status) VALUES (?, 'Confirmed')";

        try (Connection conn = DB.getConnection()) {
            // Try new
            try (PreparedStatement ps = conn.prepareStatement(sqlNew, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, clientId);
                ps.setDate(2, scheduledDate);
                ps.setTime(3, scheduledTime);
                ps.setDouble(4, gstRate);
                ps.setString(5, remarks);
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            } catch (SQLException schemaMismatch) {
                // Fallback old schema
                try (PreparedStatement ps2 = conn.prepareStatement(sqlOld, Statement.RETURN_GENERATED_KEYS)) {
                    ps2.setInt(1, clientId);
                    ps2.executeUpdate();

                    try (ResultSet rs = ps2.getGeneratedKeys()) {
                        if (rs.next()) return rs.getInt(1);
                    }
                }
            }
        }
        throw new SQLException("Failed to create booking (no generated key).");
    }

    /**
     * Add booking detail.
     * If quantity/unit_price columns exist, it writes them.
     * If not, fallback to old schema (booking_id, service_id).
     */
    public void addBookingDetail(int bookingId, int serviceId, int quantity, double unitPrice) throws SQLException {
        String sqlNew = "INSERT INTO booking_details (booking_id, service_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
        String sqlOld = "INSERT INTO booking_details (booking_id, service_id) VALUES (?, ?)";

        try (Connection conn = DB.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sqlNew)) {
                ps.setInt(1, bookingId);
                ps.setInt(2, serviceId);
                ps.setInt(3, quantity);
                ps.setDouble(4, unitPrice);
                ps.executeUpdate();
            } catch (SQLException schemaMismatch) {
                try (PreparedStatement ps2 = conn.prepareStatement(sqlOld)) {
                    ps2.setInt(1, bookingId);
                    ps2.setInt(2, serviceId);
                    ps2.executeUpdate();
                }
            }
        }
    }

    public List<Booking> getBookingsByClientId(int clientId) throws SQLException {
        List<Booking> list = new ArrayList<>();

        // Try selecting schedule fields; fallback if not exist
        String sqlNew = "SELECT booking_id, client_id, created_at, status, scheduled_date, scheduled_time, gst_rate, remarks " +
                        "FROM booking WHERE client_id=? ORDER BY created_at DESC";

        String sqlOld = "SELECT booking_id, client_id, created_at, status " +
                        "FROM booking WHERE client_id=? ORDER BY created_at DESC";

        try (Connection conn = DB.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sqlNew)) {
                ps.setInt(1, clientId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Booking b = new Booking(
                                rs.getInt("booking_id"),
                                rs.getInt("client_id"),
                                rs.getTimestamp("created_at"),
                                rs.getString("status")
                        );
                        b.setScheduledDate(rs.getDate("scheduled_date"));
                        b.setScheduledTime(rs.getTime("scheduled_time"));
                        b.setGstRate(rs.getDouble("gst_rate"));
                        b.setRemarks(rs.getString("remarks"));
                        list.add(b);
                    }
                }
            } catch (SQLException schemaMismatch) {
                try (PreparedStatement ps2 = conn.prepareStatement(sqlOld)) {
                    ps2.setInt(1, clientId);
                    try (ResultSet rs = ps2.executeQuery()) {
                        while (rs.next()) {
                            Booking b = new Booking(
                                    rs.getInt("booking_id"),
                                    rs.getInt("client_id"),
                                    rs.getTimestamp("created_at"),
                                    rs.getString("status")
                            );
                            list.add(b);
                        }
                    }
                }
            }
        }
        return list;
    }
    
    public Booking getBookingByBookingId(int booking) {
		Booking bookingObj = null;

		String sql = "SELECT booking_id, client_id, created_at, status, scheduled_date, scheduled_time, gst_rate, remarks " +
					 "FROM booking WHERE booking_id=?";

		try (Connection conn = DB.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, booking);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					bookingObj = new Booking(
							rs.getInt("booking_id"),
							rs.getInt("client_id"),
							rs.getTimestamp("created_at"),
							rs.getString("status")
					);
					bookingObj.setScheduledDate(rs.getDate("scheduled_date"));
					bookingObj.setScheduledTime(rs.getTime("scheduled_time"));
					bookingObj.setGstRate(rs.getDouble("gst_rate"));
					bookingObj.setRemarks(rs.getString("remarks"));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return bookingObj;
	}

    public List<BookingDetail> getBookingDetailsWithServiceName(int bookingId) throws SQLException {
        List<BookingDetail> list = new ArrayList<>();

        // Try new schema with quantity/unit_price
        String sqlNew = "SELECT bd.detail_id, bd.booking_id, bd.service_id, bd.quantity, bd.unit_price, s.service_name " +
                        "FROM booking_details bd JOIN service s ON s.service_id = bd.service_id " +
                        "WHERE bd.booking_id=? ORDER BY bd.detail_id ASC";

        // Old schema
        String sqlOld = "SELECT bd.detail_id, bd.booking_id, bd.service_id, s.service_name " +
                        "FROM booking_details bd JOIN service s ON s.service_id = bd.service_id " +
                        "WHERE bd.booking_id=? ORDER BY bd.detail_id ASC";

        try (Connection conn = DB.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sqlNew)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        BookingDetail d = new BookingDetail();
                        d.setDetailId(rs.getInt("detail_id"));
                        d.setBookingId(rs.getInt("booking_id"));
                        d.setServiceId(rs.getInt("service_id"));
                        d.setQuantity(rs.getInt("quantity"));
                        d.setUnitPrice(rs.getDouble("unit_price"));
                        d.setServiceName(rs.getString("service_name"));
                        list.add(d);
                    }
                }
            } catch (SQLException schemaMismatch) {
                try (PreparedStatement ps2 = conn.prepareStatement(sqlOld)) {
                    ps2.setInt(1, bookingId);
                    try (ResultSet rs = ps2.executeQuery()) {
                        while (rs.next()) {
                            BookingDetail d = new BookingDetail();
                            d.setDetailId(rs.getInt("detail_id"));
                            d.setBookingId(rs.getInt("booking_id"));
                            d.setServiceId(rs.getInt("service_id"));
                            d.setQuantity(1);
                            d.setUnitPrice(0.0);
                            d.setServiceName(rs.getString("service_name"));
                            list.add(d);
                        }
                    }
                }
            }
        }
        return list;
    }
    
    public void fillBookingDetailsPricing(int bookingId) throws SQLException {
        // Set quantity to 1 if null/0 and set unit_price from service.price if 0 or null
        String sql =
            "UPDATE booking_details bd " +
            "JOIN service s ON bd.service_id = s.service_id " +
            "SET bd.quantity = CASE WHEN bd.quantity IS NULL OR bd.quantity = 0 THEN 1 ELSE bd.quantity END, " +
            "    bd.unit_price = CASE WHEN bd.unit_price IS NULL OR bd.unit_price = 0 THEN s.price ELSE bd.unit_price END " +
            "WHERE bd.booking_id = ?";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.executeUpdate();
        }
    }
    
    public void confirmBooking(int bookingId, Date scheduledDate, Time scheduledTime, double gstRate, String remarks) throws SQLException {
        try (Connection conn = DB.getConnection()) {

            // ===== 1. Choose a caregiver (simplest: first available) =====
            int caregiverId = 0;
            String caregiverSql = "SELECT caregiver_id FROM caregiver ORDER BY caregiver_id LIMIT 1";
            try (PreparedStatement psCare = conn.prepareStatement(caregiverSql);
                 ResultSet rs = psCare.executeQuery()) {
                if (rs.next()) {
                    caregiverId = rs.getInt("caregiver_id");
                } else {
                    throw new SQLException("No caregiver available to assign.");
                }
            }

            // ===== 2. Update booking with status, schedule, gst, remarks, caregiver =====
            String sql = "UPDATE booking SET status = 'Confirmed', scheduled_date = ?, scheduled_time = ?, gst_rate = ?, remarks = ?, caregiver_id = ? WHERE booking_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setDate(1, scheduledDate);
                ps.setTime(2, scheduledTime);
                ps.setDouble(3, gstRate);
                ps.setString(4, remarks);
                ps.setInt(5, caregiverId);
                ps.setInt(6, bookingId);
                ps.executeUpdate();
            }

            // ===== 3. Insert service_status for caregiver =====
            String statusSql = "INSERT INTO service_status (booking_id, status, updated_at) VALUES (?, 'Scheduled', NOW())";
            try (PreparedStatement psStatus = conn.prepareStatement(statusSql)) {
                psStatus.setInt(1, bookingId);
                psStatus.executeUpdate();
            }
        }
    }



}
