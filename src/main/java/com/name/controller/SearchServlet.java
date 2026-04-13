package com.name.controller;

import com.name.model.User;
import com.name.service.CarService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    private final CarService carService = new CarService();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        if (keyword == null) keyword = "";
        try {
            req.setAttribute("cars", carService.searchCars(keyword));
            req.setAttribute("keyword", keyword);
            User user = (User) req.getSession().getAttribute("loggedUser");
            String view = "admin".equals(user.getRole())
                    ? "/WEB-INF/views/admin/search-results.jsp"
                    : "/WEB-INF/views/user/search-results.jsp";
            req.getRequestDispatcher(view).forward(req, res);
        } catch (Exception e) { res.sendRedirect(req.getContextPath() + "/login"); }
    }
}