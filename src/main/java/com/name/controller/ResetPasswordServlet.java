package com.name.controller;

import com.name.service.UserService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/reset-password.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String email       = req.getParameter("email");
        String newPassword = req.getParameter("newPassword");

        try {
            userService.resetPassword(email, newPassword);
            req.setAttribute("success", "Password reset successfully. You can now login.");
            req.getRequestDispatcher("/reset-password.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/reset-password.jsp").forward(req, res);
        }
    }
}