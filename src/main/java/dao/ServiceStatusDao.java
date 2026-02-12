package dao;

import models.ServiceStatus;
import util.DB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceStatusDao {

    public ServiceStatusDao() {
        // empty constructor
    }

    public List<ServiceStatus> getStatusesByClientId(int clientId) {

        List<ServiceStatus> list = new ArrayList<>();

        String sql = "SELECT ss.* " +
                     "FROM service_status ss " +
                     "JOIN booking b ON ss.booking_id = b.booking_id " +
                     "WHERE b.client_id = ? " +
                     "ORDER BY ss.updated_at DESC";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                ServiceStatus ss = new ServiceStatus();

                ss.setStatusId(rs.getInt("status_id"));
                ss.setBookingId(rs.getInt("booking_id"));
                ss.setStatus(rs.getString("status"));

                ss.setCheckInTime(
                        rs.getTimestamp("check_in_time") != null
                                ? rs.getTimestamp("check_in_time").toLocalDateTime()
                                : null
                );

                ss.setCheckOutTime(
                        rs.getTimestamp("check_out_time") != null
                                ? rs.getTimestamp("check_out_time").toLocalDateTime()
                                : null
                );

                ss.setCaregiverNotes(rs.getString("caregiver_notes"));

                ss.setUpdatedAt(
                        rs.getTimestamp("updated_at") != null
                                ? rs.getTimestamp("updated_at").toLocalDateTime()
                                : null
                );

                list.add(ss);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
