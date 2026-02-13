package models;

import java.sql.Date;

public class Promotion {
    private int promoId;
    private String promoCode;
    private String title;
    private String description;
    private Date startDate;
    private Date endDate;
    private boolean active;

    private String discountType; // "PERCENT" or "FIXED"
    private double discountValue;
    private double minSubtotal;

    private String bannerText;
    private String bannerImagePath;
    private String themePrimary;
    private String themeAccent;

    // getters/setters
    public int getPromoId() { return promoId; }
    public void setPromoId(int promoId) { this.promoId = promoId; }

    public String getPromoCode() { return promoCode; }
    public void setPromoCode(String promoCode) { this.promoCode = promoCode; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }

    public double getDiscountValue() { return discountValue; }
    public void setDiscountValue(double discountValue) { this.discountValue = discountValue; }

    public double getMinSubtotal() { return minSubtotal; }
    public void setMinSubtotal(double minSubtotal) { this.minSubtotal = minSubtotal; }

    public String getBannerText() { return bannerText; }
    public void setBannerText(String bannerText) { this.bannerText = bannerText; }

    public String getBannerImagePath() { return bannerImagePath; }
    public void setBannerImagePath(String bannerImagePath) { this.bannerImagePath = bannerImagePath; }

    public String getThemePrimary() { return themePrimary; }
    public void setThemePrimary(String themePrimary) { this.themePrimary = themePrimary; }

    public String getThemeAccent() { return themeAccent; }
    public void setThemeAccent(String themeAccent) { this.themeAccent = themeAccent; }
}
