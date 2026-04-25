package com.name.controller;

import com.name.model.Car;
import com.name.model.Rental;
import com.name.service.CarService;
import com.name.service.RentalService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 5  * 1024 * 1024,
    maxRequestSize    = 10 * 1024 * 1024
)
@WebServlet("/admin/*")
public class AdminCarServlet extends HttpServlet {

    private final CarService    carService    = new CarService();
    private final RentalService rentalService = new RentalService();
    private static final String UPLOAD_DIR    = "uploads/cars";

    /** Daemon thread for non-blocking housekeeping (release expired rentals). */
    private static final ExecutorService BG = Executors.newSingleThreadExecutor(r -> {
        Thread t = new Thread(r, "driveease-bg");
        t.setDaemon(true);
        return t;
    });

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || path.equals("/")) path = "/dashboard";
        switch (path) {
            case "/dashboard":  showDashboard(req, res); break;
            case "/add-car":    req.getRequestDispatcher("/WEB-INF/views/admin/add-car.jsp").forward(req, res); break;
            case "/edit-car":   showEditCar(req, res);   break;
            case "/delete-car": deleteCar(req, res);     break;
            default:            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/add-car".equals(path))  addCar(req, res);
        if ("/edit-car".equals(path)) updateCar(req, res);
    }

    // ── PAGES ──────────────────────────────────────────────────────

    private void showDashboard(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Fire-and-forget: don't block the page for this
        BG.submit(() -> {
            try { rentalService.releaseExpiredRentals(); }
            catch (Exception ignored) {}
        });

        try {
            List<Car>    cars          = carService.getAllCars();
            List<Rental> rentals       = rentalService.getAllRentals();
            List<Rental> activeRentals = rentalService.getActiveRentals();

            req.setAttribute("cars",          cars);
            req.setAttribute("rentals",       rentals);
            req.setAttribute("activeRentals", activeRentals);
        } catch (Exception e) {
            req.setAttribute("error", "Could not load dashboard: " + e.getMessage());
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, res);
    }

    private void showEditCar(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("car", carService.getCarById(id));
            req.getRequestDispatcher("/WEB-INF/views/admin/edit-car.jsp").forward(req, res);
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Car+not+found");
        }
    }

    // ── ACTIONS ────────────────────────────────────────────────────

    private void addCar(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            Car car = buildCar(req);
            String img = saveImage(req);
            if (img != null) car.setImageUrl(img);
            carService.addCar(car);
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?success=Car+added");
        } catch (Exception e) {
            req.setAttribute("error", "Failed: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/admin/add-car.jsp").forward(req, res);
        }
    }

    private void updateCar(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            Car car = buildCar(req);
            car.setCarId(Integer.parseInt(req.getParameter("carId")));
            String img = saveImage(req);
            if (img != null) car.setImageUrl(img);  // null = keep existing in DB
            carService.updateCar(car);
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?success=Car+updated");
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Update+failed");
        }
    }

    private void deleteCar(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            carService.deleteCar(Integer.parseInt(req.getParameter("id")));
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?success=Car+deleted");
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Delete+failed");
        }
    }

    // ── HELPERS ────────────────────────────────────────────────────

    private Car buildCar(HttpServletRequest req) {
        Car car = new Car();
        car.setName(req.getParameter("name").trim());
        car.setBrand(req.getParameter("brand").trim());
        car.setPrice(Double.parseDouble(req.getParameter("price")));
        car.setAvailability("on".equals(req.getParameter("availability")));
        return car;
    }

    private String saveImage(HttpServletRequest req) throws Exception {
        Part part = req.getPart("carImage");
        if (part == null || part.getSize() == 0) return null;

        String originalName = null;
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                originalName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        if (originalName == null || originalName.isEmpty()) return null;

        String ext = originalName.contains(".")
            ? originalName.substring(originalName.lastIndexOf('.') + 1).toLowerCase() : "";
        if (!ext.matches("jpg|jpeg|png|webp|gif"))
            throw new IllegalArgumentException("Invalid image format. Use JPG, PNG, WEBP or GIF.");

        String safe   = originalName.replaceAll("[^a-zA-Z0-9._-]", "");
        String unique = UUID.randomUUID().toString().replace("-","").substring(0,10) + "_" + safe;
        String path   = req.getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        Files.createDirectories(Paths.get(path));
        part.write(path + File.separator + unique);
        return "/" + UPLOAD_DIR + "/" + unique;
    }
}