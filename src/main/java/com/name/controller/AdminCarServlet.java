package com.name.controller;

import com.name.model.Car;
import com.name.service.CarService;
import com.name.service.RentalService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.util.UUID;

/**
 * @MultipartConfig enables the servlet to process multipart/form-data requests
 * (i.e. file uploads).
 *
 * fileSizeThreshold  — files smaller than 1 MB are kept in memory; larger ones
 *                      are written to disk at the temp location below.
 * maxFileSize        — maximum size for a single uploaded file (5 MB).
 * maxRequestSize     — maximum total request body size (10 MB).
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,       // 1 MB
    maxFileSize       = 5  * 1024 * 1024,  // 5 MB per file
    maxRequestSize    = 10 * 1024 * 1024   // 10 MB total
)
@WebServlet("/admin/*")
public class AdminCarServlet extends HttpServlet {

    private final CarService    carService    = new CarService();
    private final RentalService rentalService = new RentalService();

    /** Folder relative to the web application root where car images are saved. */
    private static final String UPLOAD_DIR = "uploads/cars";

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

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/add-car".equals(path))  addCar(req, res);
        if ("/edit-car".equals(path)) updateCar(req, res);
    }

    // ── DASHBOARD ──────────────────────────────────────────────
    private void showDashboard(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            req.setAttribute("cars",    carService.getAllCars());
            req.setAttribute("rentals", rentalService.getAllRentals());
        } catch (Exception e) {
            req.setAttribute("error", "DB error: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, res);
    }

    // ── EDIT FORM ──────────────────────────────────────────────
    private void showEditCar(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            int id  = Integer.parseInt(req.getParameter("id"));
            Car car = carService.getCarById(id);
            req.setAttribute("car", car);
            req.getRequestDispatcher("/WEB-INF/views/admin/edit-car.jsp").forward(req, res);
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    // ── ADD CAR ────────────────────────────────────────────────
    private void addCar(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            Car car = buildCar(req);

            /* Handle optional image upload */
            String imageUrl = saveImage(req);
            if (imageUrl != null) car.setImageUrl(imageUrl);

            carService.addCar(car);
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?success=Car+added+successfully");
        } catch (Exception e) {
            req.setAttribute("error", "Failed to add car: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/admin/add-car.jsp").forward(req, res);
        }
    }

    // ── UPDATE CAR ─────────────────────────────────────────────
    private void updateCar(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            Car car = buildCar(req);
            car.setCarId(Integer.parseInt(req.getParameter("carId")));

            /* Only replace image if admin uploaded a new one */
            String imageUrl = saveImage(req);
            if (imageUrl != null) {
                car.setImageUrl(imageUrl);
            }
            /* If no new image, imageUrl stays null → CarDAO.update keeps the existing value */

            carService.updateCar(car);
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?success=Car+updated+successfully");
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Update+failed");
        }
    }

    // ── DELETE CAR ─────────────────────────────────────────────
    private void deleteCar(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            carService.deleteCar(Integer.parseInt(req.getParameter("id")));
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?success=Car+deleted+successfully");
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard?error=Delete+failed");
        }
    }

    // ── HELPERS ────────────────────────────────────────────────

    /**
     * Reads the text form fields (name, brand, price, availability) and builds
     * a Car object.  Does NOT set imageUrl — that is handled by saveImage().
     */
    private Car buildCar(HttpServletRequest req) {
        Car car = new Car();
        car.setName(req.getParameter("name"));
        car.setBrand(req.getParameter("brand"));
        car.setPrice(Double.parseDouble(req.getParameter("price")));
        car.setAvailability("on".equals(req.getParameter("availability")));
        return car;
    }

    /**
     * Saves the uploaded image file to {webappRoot}/uploads/cars/ and returns
     * the context-relative URL (e.g. /uploads/cars/a1b2c3_civic.jpg).
     *
     * Returns null if no file was uploaded (empty Part) — the caller can then
     * decide whether to leave the existing imageUrl intact.
     *
     * Allowed extensions: jpg, jpeg, png, webp, gif
     */
    private String saveImage(HttpServletRequest req) throws Exception {
        Part part = req.getPart("carImage");
        if (part == null || part.getSize() == 0) return null;

        /* Get original filename from Content-Disposition header */
        String originalName = extractFileName(part);
        if (originalName == null || originalName.isEmpty()) return null;

        /* Validate extension */
        String ext = originalName.contains(".")
            ? originalName.substring(originalName.lastIndexOf('.') + 1).toLowerCase()
            : "";
        if (!ext.matches("jpg|jpeg|png|webp|gif")) {
            throw new IllegalArgumentException("Invalid image format. Use JPG, PNG, WEBP, or GIF.");
        }

        /* Create unique filename to avoid collisions */
        String uniqueName = UUID.randomUUID().toString().replace("-", "").substring(0, 10)
                          + "_" + originalName.replaceAll("[^a-zA-Z0-9._-]", "");

        /* Resolve absolute path on the server */
        String uploadPath = req.getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        Files.createDirectories(Paths.get(uploadPath));

        /* Write file to disk */
        part.write(uploadPath + File.separator + uniqueName);

        /* Return the web-accessible relative path */
        return "/" + UPLOAD_DIR + "/" + uniqueName;
    }

    /**
     * Extracts the original filename from the Part's Content-Disposition header.
     * Example header: form-data; name="carImage"; filename="civic.jpg"
     */
    private String extractFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}