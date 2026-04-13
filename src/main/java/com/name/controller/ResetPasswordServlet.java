package com.name.controller;

import com.name.service.UserService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private final UserService userService = new UserService();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/reset-password.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String email       = req.getParameter("email");
        String newPassword = req.getParameter("newPassword");
        try {
            boolean success = userService.resetPassword(email, newPassword);
            if (success) {
                req.setAttribute("success", "Password reset successfully. You can now login.");
            } else {
                req.setAttribute("error", "Email not found or password too short (min 6 chars).");
            }
        } catch (Exception e) {
            req.setAttribute("error", "An error occurred. Please try again.");
        }
        req.getRequestDispatcher("/reset-password.jsp").forward(req, res);
    }
}