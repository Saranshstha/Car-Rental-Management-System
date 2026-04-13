package com.name.service;

import com.name.dao.CarDAO;
import com.name.dao.RentalDAO;
import com.name.model.Rental;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

public class RentalService {

    private final RentalDAO rentalDAO = new RentalDAO();
    private final CarDAO    carDAO    = new CarDAO();

    public boolean rentCar(int userId, int carId) throws SQLException {
        Rental rental = new Rental();
        rental.setUserId(userId);
        rental.setCarId(carId);
        rental.setRentalDate(new Date(System.currentTimeMillis()));
        boolean saved = rentalDAO.save(rental);
        if (saved) carDAO.updateAvailability(carId, false);
        return saved;
    }

    public List<Rental> getRentalsByUser(int userId) throws SQLException {
        return rentalDAO.findByUserId(userId);
    }

    public List<Rental> getAllRentals() throws SQLException {
        return rentalDAO.findAll();
    }
}