package com.name.controller;

import com.name.model.Rental;
import com.name.model.User;
import com.name.service.CarService;
import com.name.service.RentalService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

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
        if ("/rent".equals(path))    rentCar(req, res);
        if ("/confirm".equals(path)) confirmRental(req, res);
        if ("/cancel".equals(path))  cancelRental(req, res);
    }

    // ── PAGES ──────────────────────────────────────────────────────

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

    // ── ACTIONS ────────────────────────────────────────────────────

    private void rentCar(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try {
            User user    = (User) req.getSession().getAttribute("loggedUser");
            int  carId   = Integer.parseInt(req.getParameter("carId"));
            int  days    = parseSafeInt(req.getParameter("days"), 1);
            String name  = req.getParameter("renterName");
            String email = req.getParameter("renterEmail");
            String phone = req.getParameter("renterPhone");
            String loc   = req.getParameter("renterLocation");

            String pickupStr = req.getParameter("pickupDatetime");
            Timestamp pickupTs;
            Timestamp returnTs;
            if (pickupStr != null && !pickupStr.isEmpty()) {
                try {
                    LocalDateTime pickup = LocalDateTime.parse(pickupStr,
                            DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                    pickupTs = Timestamp.valueOf(pickup);
                    returnTs = Timestamp.valueOf(pickup.plusDays(days));
                } catch (DateTimeParseException e) {
                    LocalDateTime now = LocalDateTime.now();
                    pickupTs = Timestamp.valueOf(now);
                    returnTs = Timestamp.valueOf(now.plusDays(days));
                }
            } else {
                LocalDateTime now = LocalDateTime.now();
                pickupTs = Timestamp.valueOf(now);
                returnTs = Timestamp.valueOf(now.plusDays(days));
            }

            rentalService.rentCar(user.getId(), carId, days, name, email, phone, loc, pickupTs, returnTs);
            res.sendRedirect(req.getContextPath() + "/user/home?success=Car+rented+successfully");
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/user/home?error=" +
                    java.net.URLEncoder.encode("Rental failed: " + e.getMessage(), "UTF-8"));
        }
    }

    private void confirmRental(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try {
            int rentalId = Integer.parseInt(req.getParameter("rentalId"));
            rentalService.confirmRental(rentalId);
            res.sendRedirect(req.getContextPath() + "/user/rented-cars?success=Rental+confirmed");
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/user/rented-cars?error=Confirmation+failed");
        }
    }

    private void cancelRental(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try {
            int rentalId = Integer.parseInt(req.getParameter("rentalId"));
            Rental rental = rentalService.getRentalById(rentalId);
            if (rental == null || !rental.isCanCancel()) {
                res.sendRedirect(req.getContextPath() +
                        "/user/rented-cars?error=Cannot+cancel+a+confirmed+or+expired+rental");
                return;
            }
            rentalService.cancelRental(rentalId);
            res.sendRedirect(req.getContextPath() + "/user/rented-cars?success=Reservation+cancelled");
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/user/rented-cars?error=Cancel+failed");
        }
    }

    private int parseSafeInt(String s, int def) {
        try { return (s != null && !s.isEmpty()) ? Integer.parseInt(s.trim()) : def; }
        catch (NumberFormatException e) { return def; }
    }
}