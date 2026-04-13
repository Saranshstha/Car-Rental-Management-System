package com.name.filter;
import com.name.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter({"/admin/*", "/user/*", "/search"})
public class AuthFilter implements Filter {

    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String uri = request.getRequestURI();
        if (uri.contains("/admin/") && !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/user/home");
            return;
        }

        chain.doFilter(req, res);
    }

    public void init(FilterConfig fc) {}
    public void destroy() {}
}