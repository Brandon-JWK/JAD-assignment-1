package util;

import dao.PromotionDao;
import models.Promotion;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import java.io.IOException;

@WebFilter("/*")
public class PromoFilter implements Filter {

    private final PromotionDao promoDao = new PromotionDao();

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        try {
            Promotion active = promoDao.getCurrentActivePromo();
            req.setAttribute("activePromo", active);
        } catch (Exception ignored) {}

        chain.doFilter(req, res);
    }
}
