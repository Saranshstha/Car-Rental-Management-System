package com.name.controller;

import com.name.service.UserService;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final UserService userService = new UserService();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        try {
            if (userService.register(name, email, password)) {
                res.sendRedirect(req.getContextPath() + "/login?registered=true");
            } else {
                req.setAttribute("error", "Registration failed. Email may already exist or input is invalid.");
                req.getRequestDispatcher("/register.jsp").forward(req, res);
            }
        } catch (Exception e) {
            req.setAttribute("error", "An error occurred.");
            req.getRequestDispatcher("/register.jsp").forward(req, res);
        }
    }
}