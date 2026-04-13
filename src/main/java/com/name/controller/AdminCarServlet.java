package com.name.controller;
import com.name.model.Car;
import com.name.service.CarService;
import com.name.service.RentalService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/*")
public class AdminCarServlet extends HttpServlet {
    private final CarService carService = new CarService();
    private final RentalService rentalService = new RentalService();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || path.equals("/")) path = "/dashboard";
        switch (path) {
            case "/dashboard": showDashboard(req, res); break;
            case "/add-car":   req.getRequestDispatcher("/WEB-INF/views/admin/add-car.jsp").forward(req, res); break;
            case "/edit-car":  showEditCar(req, res);   break;
            case "/delete-car": deleteCar(req, res);    break;
            default: res.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/add-car".equals(path))  addCar(req, res);
        if ("/edit-car".equals(path)) updateCar(req, res);
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            req.setAttribute("cars", carService.getAllCars());
            req.setAttribute("rentals", rentalService.getAllRentals());
        } catch (Exception e) { req.setAttribute("error", "DB error: " + e.getMessage()); }
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, res);
    }

    private void showEditCar(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            Car car = carService.getCarById(Integer.parseInt(req.getParameter("id")));
            req.setAttribute("car", car);
            req.getRequestDispatcher("/WEB-INF/views/admin/edit-car.jsp").forward(req, res);
        } catch (Exception e) { res.sendRedirect(req.getContextPath() + "/admin/dashboard"); }
    }

    private void addCar(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            carService.addCar(buildCar(req));
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?success=Car+added");
        } catch (Exception e) {
            req.setAttribute("error", "Failed to add car.");
            req.getRequestDispatcher("/WEB-INF/views/admin/add-car.jsp").forward(req, res);
        }
    }

    private void updateCar(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try {
            Car car = buildCar(req);
            car.setCarId(Integer.parseInt(req.getParameter("carId")));
            carService.updateCar(car);
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?success=Car+updated");
        } catch (Exception e) { res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Update+failed"); }
    }

    private void deleteCar(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try {
            carService.deleteCar(Integer.parseInt(req.getParameter("id")));
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?success=Car+deleted");
        } catch (Exception e) { res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Delete+failed"); }
    }

    private Car buildCar(HttpServletRequest req) {
        Car car = new Car();
        car.setName(req.getParameter("name")); car.setBrand(req.getParameter("brand"));
        car.setPrice(Double.parseDouble(req.getParameter("price")));
        car.setAvailability("on".equals(req.getParameter("availability")));
        return car;
    }
}