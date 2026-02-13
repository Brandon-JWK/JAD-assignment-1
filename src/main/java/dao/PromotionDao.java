package dao;

import models.Promotion;
import util.DB;

import java.sql.*;

public class PromotionDao {

    // Banner/theme: gets one active promo for today
    public Promotion getCurrentActivePromo() throws SQLException {
        String sql =
            "SELECT * FROM promotion " +
            "WHERE is_active=1 AND CURDATE() BETWEEN start_date AND end_date " +
            "ORDER BY start_date DESC, promo_id DESC LIMIT 1";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return map(rs);
            return null;
        }
    }

    // Checkout: validates promo code + date + active + min spend
    public Promotion getValidPromoByCode(String code, double subtotal) throws SQLException {
        String sql =
            "SELECT * FROM promotion " +
            "WHERE UPPER(promo_code)=UPPER(?) " +
            "AND is_active=1 " +
            "AND CURDATE() BETWEEN start_date AND end_date " +
            "AND ? >= min_subtotal " +
            "LIMIT 1";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, code);
            ps.setDouble(2, subtotal);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
                return null;
            }
        }
    }

    private Promotion map(ResultSet rs) throws SQLException {
        Promotion p = new Promotion();
        p.setPromoId(rs.getInt("promo_id"));
        p.setPromoCode(rs.getString("promo_code"));
        p.setTitle(rs.getString("title"));
        p.setDescription(rs.getString("description"));
        p.setStartDate(rs.getDate("start_date"));
        p.setEndDate(rs.getDate("end_date"));
        p.setActive(rs.getInt("is_active") == 1);

        p.setDiscountType(rs.getString("discount_type"));   // PERCENT or FIXED
        p.setDiscountValue(rs.getDouble("discount_value"));
        p.setMinSubtotal(rs.getDouble("min_subtotal"));

        p.setBannerText(rs.getString("banner_text"));
        p.setBannerImagePath(rs.getString("banner_image_path"));
        p.setThemePrimary(rs.getString("theme_primary"));
        p.setThemeAccent(rs.getString("theme_accent"));
        return p;
    }
    
    public Promotion getPromoByCode(String code) throws SQLException {
        String sql = "SELECT * FROM promotion WHERE UPPER(promo_code)=UPPER(?) LIMIT 1";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs); // reuse your existing map(ResultSet)
                return null;
            }
        }
    }
}
