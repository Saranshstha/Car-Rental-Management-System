package com.name.controller;

import com.name.model.User;
import com.name.service.CarService;
import com.name.service.RentalService;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/user/*")
public class UserHomeServlet extends HttpServlet {
    private final CarService carService = new CarService();
    private final RentalService rentalService = new RentalService();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || path.equals("/")) path = "/home";
        switch (path) {
            case "/home":        showHome(req, res);       break;
            case "/rented-cars": showRentedCars(req, res); break;
            default: res.sendRedirect(req.getContextPath() + "/user/home");
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if ("/rent".equals(req.getPathInfo())) rentCar(req, res);
    }

    private void showHome(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try { req.setAttribute("cars", carService.getAvailableCars()); }
        catch (Exception e) { req.setAttribute("error", "Could not load cars."); }
        req.getRequestDispatcher("/WEB-INF/views/user/home.jsp").forward(req, res);
    }

    private void showRentedCars(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            User user = (User) req.getSession().getAttribute("loggedUser");
            req.setAttribute("rentals", rentalService.getRentalsByUser(user.getId()));
        } catch (Exception e) { req.setAttribute("error", "Could not load rentals."); }
        req.getRequestDispatcher("/WEB-INF/views/user/rented-cars.jsp").forward(req, res);
    }

    private void rentCar(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try {
            User user = (User) req.getSession().getAttribute("loggedUser");
            rentalService.rentCar(user.getId(), Integer.parseInt(req.getParameter("carId")));
            res.sendRedirect(req.getContextPath() + "/user/home?success=Car+rented+successfully");
        } catch (Exception e) { res.sendRedirect(req.getContextPath() + "/user/home?error=Rental+failed"); }
    }
}