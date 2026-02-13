package util;

import models.PriceSummary;
import models.Promotion;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class PricingUtil {

    public static PriceSummary compute(BigDecimal subtotal, BigDecimal gstRate, Promotion promo) {
        BigDecimal discount = BigDecimal.ZERO;

        if (promo != null) {
            String type = promo.getDiscountType();
            BigDecimal val = BigDecimal.valueOf(promo.getDiscountValue());

            if ("PERCENT".equalsIgnoreCase(type)) {
                discount = subtotal.multiply(val).divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
            } else if ("FIXED".equalsIgnoreCase(type)) {
                discount = val.min(subtotal).setScale(2, RoundingMode.HALF_UP);
            }
        }

        BigDecimal afterDiscount = subtotal.subtract(discount).max(BigDecimal.ZERO);
        BigDecimal gst = afterDiscount.multiply(gstRate).setScale(2, RoundingMode.HALF_UP);
        BigDecimal total = afterDiscount.add(gst).setScale(2, RoundingMode.HALF_UP);

        return new PriceSummary(
                subtotal.setScale(2, RoundingMode.HALF_UP),
                discount.setScale(2, RoundingMode.HALF_UP),
                gst,
                total,
                promo
        );
    }
}
