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

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            User u = (User) session.getAttribute("loggedUser");
            res.sendRedirect(req.getContextPath() + ("admin".equals(u.getRole()) ? "/admin/dashboard" : "/user/home"));
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        try {
            User user = userService.authenticate(email, password);
            if (user == null) {
                req.setAttribute("error", "Invalid email or password.");
                req.getRequestDispatcher("/login.jsp").forward(req, res); return;
            }
            req.getSession().setAttribute("loggedUser", user);
            res.sendRedirect(req.getContextPath() + ("admin".equals(user.getRole()) ? "/admin/dashboard" : "/user/home"));
        } catch (IllegalStateException e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/login.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("error", "An error occurred. Please try again.");
            req.getRequestDispatcher("/login.jsp").forward(req, res);
        }
    }
}