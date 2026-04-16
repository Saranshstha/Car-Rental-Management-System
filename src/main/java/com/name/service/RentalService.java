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

    public boolean rentCar(int userId, int carId, int days,
                           String renterName, String renterEmail, String renterPhone)
            throws SQLException {
        Rental rental = new Rental();
        rental.setUserId(userId);
        rental.setCarId(carId);
        rental.setRentalDate(new Date(System.currentTimeMillis()));
        rental.setDays(days > 0 ? days : 1);

        double price = 0;
        try {
            com.name.model.Car car = carDAO.findById(carId);
            if (car != null) price = car.getPrice();
        } catch (Exception ignored) {}
        rental.setTotalCost(price * rental.getDays());

        rental.setRenterName(renterName);
        rental.setRenterEmail(renterEmail);
        rental.setRenterPhone(renterPhone);

        boolean saved = rentalDAO.save(rental);
        if (saved) carDAO.updateAvailability(carId, false);
        return saved;
    }

    public boolean cancelRental(int rentalId) throws SQLException {
        Rental rental = rentalDAO.findById(rentalId);
        boolean deleted = rentalDAO.cancel(rentalId);
        if (deleted && rental != null) {
            carDAO.updateAvailability(rental.getCarId(), true);
        }
        return deleted;
    }

    public List<Rental> getRentalsByUser(int userId) throws SQLException {
        return rentalDAO.findByUserId(userId);
    }

    public List<Rental> getAllRentals() throws SQLException {
        return rentalDAO.findAll();
    }
}
