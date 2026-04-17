package com.name.dao;

import com.name.config.DBConfig;
import com.name.model.Car;
import java.sql.*;
import java.util.*;

public class CarDAO {

    public List<Car> findAll() throws SQLException {
        List<Car> list = new ArrayList<>();
        try (Connection c = DBConfig.getConnection();
             ResultSet rs = c.createStatement().executeQuery("SELECT * FROM cars")) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public List<Car> findAvailable() throws SQLException {
        List<Car> list = new ArrayList<>();
        try (Connection c = DBConfig.getConnection();
             ResultSet rs = c.createStatement().executeQuery(
                     "SELECT * FROM cars WHERE availability = 1")) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public Car findById(int id) throws SQLException {
        String sql = "SELECT * FROM cars WHERE car_id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        }
        return null;
    }

    public boolean save(Car car) throws SQLException {
        String sql = "INSERT INTO cars (name, brand, price, availability, image_url) VALUES (?,?,?,?,?)";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, car.getName());
            ps.setString(2, car.getBrand());
            ps.setDouble(3, car.getPrice());
            ps.setBoolean(4, car.isAvailability());
            ps.setString(5, car.getImageUrl());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean update(Car car) throws SQLException {
        String sql = "UPDATE cars SET name=?, brand=?, price=?, availability=?"
                   + (car.getImageUrl() != null ? ", image_url=?" : "")
                   + " WHERE car_id=?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, car.getName());
            ps.setString(2, car.getBrand());
            ps.setDouble(3, car.getPrice());
            ps.setBoolean(4, car.isAvailability());
            if (car.getImageUrl() != null) {
                ps.setString(5, car.getImageUrl());
                ps.setInt(6, car.getCarId());
            } else {
                ps.setInt(5, car.getCarId());
            }
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int carId) throws SQLException {
        String sql = "DELETE FROM cars WHERE car_id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, carId);
            return ps.executeUpdate() > 0;
        }
    }

    public List<Car> search(String keyword) throws SQLException {
        List<Car> list = new ArrayList<>();
        String sql = "SELECT * FROM cars WHERE name LIKE ? OR brand LIKE ? OR CAST(price AS CHAR) LIKE ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            String k = "%" + keyword + "%";
            ps.setString(1, k); ps.setString(2, k); ps.setString(3, k);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public void updateAvailability(int carId, boolean available) throws SQLException {
        String sql = "UPDATE cars SET availability = ? WHERE car_id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setBoolean(1, available);
            ps.setInt(2, carId);
            ps.executeUpdate();
        }
    }

    private Car map(ResultSet rs) throws SQLException {
        Car car = new Car();
        car.setCarId(rs.getInt("car_id"));
        car.setName(rs.getString("name"));
        car.setBrand(rs.getString("brand"));
        car.setPrice(rs.getDouble("price"));
        car.setAvailability(rs.getBoolean("availability"));
        try { car.setImageUrl(rs.getString("image_url")); } catch (SQLException ignored) {}
        return car;
    }
}