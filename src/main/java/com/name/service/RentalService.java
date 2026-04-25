package com.name.service;

import com.name.dao.CarDAO;
import com.name.dao.RentalDAO;
import com.name.model.Rental;
import java.sql.*;
import java.util.List;

public class RentalService {

    private final RentalDAO rentalDAO = new RentalDAO();
    private final CarDAO    carDAO    = new CarDAO();

    public boolean rentCar(int userId, int carId, int days,
                           String name, String email, String phone,
                           String location, Timestamp pickupDt, Timestamp returnDt)
            throws SQLException {
        Rental r = new Rental();
        r.setUserId(userId);
        r.setCarId(carId);
        r.setRentalDate(new Date(System.currentTimeMillis()));
        r.setDays(days > 0 ? days : 1);
        r.setRenterName(name);
        r.setRenterEmail(email);
        r.setRenterPhone(phone);
        r.setRenterLocation(location);
        r.setPickupDatetime(pickupDt);
        r.setReturnDatetime(returnDt);

        double price = 0;
        try {
            com.name.model.Car car = carDAO.findById(carId);
            if (car != null) price = car.getPrice();
        } catch (Exception ignored) {}
        r.setTotalCost(price * r.getDays());

        boolean saved = rentalDAO.save(r);
        if (saved) carDAO.updateAvailability(carId, false);
        return saved;
    }

    public boolean confirmRental(int rentalId) throws SQLException {
        return rentalDAO.confirm(rentalId);
    }

    public boolean cancelRental(int rentalId) throws SQLException {
        Rental r = rentalDAO.findById(rentalId);
        boolean deleted = rentalDAO.cancel(rentalId);
        if (deleted && r != null) carDAO.updateAvailability(r.getCarId(), true);
        return deleted;
    }

    public Rental getRentalById(int rentalId) throws SQLException {
        return rentalDAO.findById(rentalId);
    }

    public List<Rental> getRentalsByUser(int userId) throws SQLException {
        return rentalDAO.findByUserId(userId);
    }

    public List<Rental> getActiveRentals() throws SQLException {
        return rentalDAO.findActive();
    }

    public List<Rental> getAllRentals() throws SQLException {
        return rentalDAO.findAll();
    }

    public void releaseExpiredRentals() throws SQLException {
        rentalDAO.releaseExpired();
    }
}