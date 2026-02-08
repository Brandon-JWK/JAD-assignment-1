package dao;

import java.sql.*;
import java.util.*;
import util.SQLDB;
import models.Service;

public class ServiceDao {

    // List all services
    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT * FROM service ORDER BY service_id ASC";

        try (Connection conn = SQLDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Service(
                    rs.getInt("service_id"),
                    rs.getString("service_name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("category_id"),
                    rs.getString("image_path")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get services by category
    public List<Service> getServicesByCategory(int categoryId) {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT * FROM service WHERE category_id = ?";

        try (Connection conn = SQLDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new Service(
                    rs.getInt("service_id"),
                    rs.getString("service_name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("category_id"),
                    rs.getString("image_path")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

//    // Retrieve 1 service
//    public Service getServiceById(int serviceId) {
//        String sql = "SELECT * FROM service WHERE service_id = ?";
//
//        try (Connection conn = SQLDB.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, serviceId);
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return new Service(
//                    rs.getInt("service_id"),
//                    rs.getString("service_name"),
//                    rs.getString("service_desc"),
//                    rs.getDouble("price"),
//                    rs.getInt("category_id"),
//                    rs.getString("image_path")
//                );
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
    public Service getServiceById(int serviceId) {
        String sql = "SELECT * FROM service WHERE service_id = ?";

        try (Connection conn = SQLDB.getConnection();   // <-- FIXED
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Service(
                    rs.getInt("service_id"),
                    rs.getString("service_name"),
                    rs.getString("description"),  // matches DB
                    rs.getDouble("price"),
                    rs.getInt("category_id"),
                    rs.getString("image_path")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addService(Service s) {
        String sql = "INSERT INTO service(service_name, description, price, category_id, image_path) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = SQLDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, s.getServiceName());
            ps.setString(2, s.getServiceDesc()); // mapped correctly
            ps.setDouble(3, s.getPrice());
            ps.setInt(4, s.getCategoryId());
            ps.setString(5, s.getImagePath());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    public boolean updateService(Service s) {
        String sql = "UPDATE service SET service_name = ?, description = ?, price = ?, category_id = ?, image_path = ? WHERE service_id = ?";

        try (Connection conn = SQLDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, s.getServiceName());
            ps.setString(2, s.getServiceDesc());
            ps.setDouble(3, s.getPrice());
            ps.setInt(4, s.getCategoryId());
            ps.setString(5, s.getImagePath());
            ps.setInt(6, s.getServiceId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    // Delete
    public boolean deleteService(int id) {
        String sql = "DELETE FROM service WHERE service_id = ?";

        try (Connection conn = SQLDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Service> searchFilterPaginate(String keyword, Integer categoryId, int offset, int limit) {
        List<Service> list = new ArrayList<>();

        String sql = "SELECT * FROM service WHERE 1=1";

        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND service_name LIKE ?";
        }

        if (categoryId != null) {
            sql += " AND category_id = ?";
        }

        sql += " LIMIT ? OFFSET ?";

        try (Connection conn = SQLDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int index = 1;

            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }

            if (categoryId != null) {
                ps.setInt(index++, categoryId);
            }

            ps.setInt(index++, limit);
            ps.setInt(index++, offset);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new Service(
                    rs.getInt("service_id"),
                    rs.getString("service_name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("category_id"),
                    rs.getString("image_path")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public int countServices(String keyword, Integer categoryId) {
        int count = 0;

        String sql = "SELECT COUNT(*) FROM service WHERE 1=1";

        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND service_name LIKE ?";
        }

        if (categoryId != null) {
            sql += " AND category_id = ?";
        }

        try (Connection conn = SQLDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int index = 1;

            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }

            if (categoryId != null) {
                ps.setInt(index++, categoryId);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

}
