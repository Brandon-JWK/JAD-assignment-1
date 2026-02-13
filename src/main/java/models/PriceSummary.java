package models;

import java.math.BigDecimal;

public class PriceSummary {
    private BigDecimal subtotal;
    private BigDecimal discount;
    private BigDecimal gst;
    private BigDecimal total;
    private Promotion promo;

    public PriceSummary(BigDecimal subtotal, BigDecimal discount, BigDecimal gst, BigDecimal total, Promotion promo) {
        this.subtotal = subtotal;
        this.discount = discount;
        this.gst = gst;
        this.total = total;
        this.promo = promo;
    }

    public BigDecimal getSubtotal() { return subtotal; }
    public BigDecimal getDiscount() { return discount; }
    public BigDecimal getGst() { return gst; }
    public BigDecimal getTotal() { return total; }
    public Promotion getPromo() { return promo; }
}
