package com.name.controller;

import com.name.model.User;
import com.name.service.CarService;
import com.name.service.RentalService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/user/*")
public class UserHomeServlet extends HttpServlet {

    private final CarService    carService    = new CarService();
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
        String path = req.getPathInfo();
        if ("/rent".equals(path))   rentCar(req, res);
        if ("/cancel".equals(path)) cancelRental(req, res);
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
            User user   = (User) req.getSession().getAttribute("loggedUser");
            int  carId  = Integer.parseInt(req.getParameter("carId"));
            int  days   = Integer.parseInt(req.getParameter("days") != null && !req.getParameter("days").isEmpty()
                            ? req.getParameter("days") : "1");
            String name  = req.getParameter("renterName");
            String email = req.getParameter("renterEmail");
            String phone = req.getParameter("renterPhone");
            rentalService.rentCar(user.getId(), carId, days, name, email, phone);
            res.sendRedirect(req.getContextPath() + "/user/home?success=Car+rented+successfully");
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/user/home?error=Rental+failed");
        }
    }

    private void cancelRental(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try {
            int rentalId = Integer.parseInt(req.getParameter("rentalId"));
            rentalService.cancelRental(rentalId);
            res.sendRedirect(req.getContextPath() + "/user/rented-cars?success=Reservation+cancelled");
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/user/rented-cars?error=Cancel+failed");
        }
    }
}
