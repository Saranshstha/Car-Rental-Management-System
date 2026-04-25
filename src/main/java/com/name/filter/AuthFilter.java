package com.name.filter;

import com.name.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/user/*", "/search"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req = (HttpServletRequest)  request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        String path = req.getRequestURI();

        // Not logged in → redirect to login
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Non-admin trying to access /admin/* → redirect to user home
        if (path.contains("/admin/") && !"admin".equals(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/user/home");
            return;
        }

        chain.doFilter(request, response);
    }
}