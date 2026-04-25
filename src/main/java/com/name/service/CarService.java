package com.name.service;

import com.name.dao.CarDAO;
import com.name.model.Car;
import java.sql.SQLException;
import java.util.List;

public class CarService {

    private final CarDAO carDAO = new CarDAO();

    public List<Car> getAllCars() throws SQLException {
        return carDAO.findAll();
    }

    public List<Car> getAvailableCars() throws SQLException {
        return carDAO.findAvailable();
    }

    public Car getCarById(int id) throws SQLException {
        return carDAO.findById(id);
    }

    public boolean addCar(Car car) throws SQLException {
        return carDAO.save(car);
    }

    public boolean updateCar(Car car) throws SQLException {
        return carDAO.update(car);
    }

    public boolean deleteCar(int carId) throws SQLException {
        return carDAO.delete(carId);
    }

    public List<Car> searchCars(String keyword) throws SQLException {
        return carDAO.search(keyword == null ? "" : keyword.trim());
    }
}