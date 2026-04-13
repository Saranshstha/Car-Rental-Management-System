package com.name.dao;

import com.name.config.DBConfig;
import com.name.model.Rental;
import java.sql.*;
import java.util.*;

public class RentalDAO {

    public boolean save(Rental rental) throws SQLException {
        String sql = "INSERT INTO rentals (user_id, car_id, rental_date) VALUES (?,?,?)";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, rental.getUserId());
            ps.setInt(2, rental.getCarId());
            ps.setDate(3, rental.getRentalDate());
            return ps.executeUpdate() > 0;
        }
    }

    public List<Rental> findByUserId(int userId) throws SQLException {
        List<Rental> list = new ArrayList<>();
        String sql = "SELECT r.*, c.name AS car_name, c.brand AS car_brand, c.price AS car_price "
                   + "FROM rentals r JOIN cars c ON r.car_id = c.car_id WHERE r.user_id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public List<Rental> findAll() throws SQLException {
        List<Rental> list = new ArrayList<>();
        String sql = "SELECT r.*, c.name AS car_name, c.brand AS car_brand, c.price AS car_price "
                   + "FROM rentals r JOIN cars c ON r.car_id = c.car_id";
        try (Connection c = DBConfig.getConnection();
             ResultSet rs = c.createStatement().executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    private Rental map(ResultSet rs) throws SQLException {
        Rental r = new Rental();
        r.setRentalId(rs.getInt("rental_id"));
        r.setUserId(rs.getInt("user_id"));
        r.setCarId(rs.getInt("car_id"));
        r.setRentalDate(rs.getDate("rental_date"));
        r.setCarName(rs.getString("car_name"));
        r.setCarBrand(rs.getString("car_brand"));
        r.setCarPrice(rs.getDouble("car_price"));
        return r;
    }
}