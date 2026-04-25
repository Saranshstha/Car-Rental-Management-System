package com.name.controller;

import com.name.model.User;
import com.name.service.UserService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // Already logged in → redirect
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            User u = (User) session.getAttribute("loggedUser");
            redirect(req, res, u.getRole());
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            User user = userService.authenticate(email, password);
            HttpSession session = req.getSession(true);
            session.setAttribute("loggedUser", user);
            session.setMaxInactiveInterval(30 * 60); // 30 min
            redirect(req, res, user.getRole());
        } catch (IllegalStateException e) {
            // Account locked
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/login.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/login.jsp").forward(req, res);
        }
    }

    private void redirect(HttpServletRequest req, HttpServletResponse res, String role)
            throws IOException {
        if ("admin".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            res.sendRedirect(req.getContextPath() + "/user/home");
        }
    }
}