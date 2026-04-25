package com.name.dao;

import com.name.config.DBConfig;
import com.name.model.Rental;
import java.sql.*;
import java.util.*;

public class RentalDAO {

    private static final String SELECT =
        "SELECT r.*, c.name AS car_name, c.brand AS car_brand, " +
        "c.price AS car_price, c.image_url AS car_image_url " +
        "FROM rentals r JOIN cars c ON r.car_id = c.car_id ";

    // ── WRITE ──────────────────────────────────────────────────────

    public boolean save(Rental r) throws SQLException {
        String sql =
            "INSERT INTO rentals (user_id,car_id,rental_date,days,total_cost," +
            "renter_name,renter_email,renter_phone,renter_location," +
            "pickup_datetime,return_datetime,is_confirmed) VALUES (?,?,?,?,?,?,?,?,?,?,?,0)";
        try (Connection c = DBConfig.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, r.getUserId());
            ps.setInt(2, r.getCarId());
            ps.setDate(3, r.getRentalDate());
            ps.setInt(4, r.getDays());
            ps.setDouble(5, r.getTotalCost());
            ps.setString(6, r.getRenterName());
            ps.setString(7, r.getRenterEmail());
            ps.setString(8, r.getRenterPhone());
            ps.setString(9, r.getRenterLocation());
            ps.setTimestamp(10, r.getPickupDatetime());
            ps.setTimestamp(11, r.getReturnDatetime());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean confirm(int rentalId) throws SQLException {
        String sql = "UPDATE rentals SET is_confirmed=1 WHERE rental_id=?";
        try (Connection c = DBConfig.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, rentalId); return ps.executeUpdate() > 0;
        }
    }

    public boolean cancel(int rentalId) throws SQLException {
        String sql = "DELETE FROM rentals WHERE rental_id=?";
        try (Connection c = DBConfig.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, rentalId); return ps.executeUpdate() > 0;
        }
    }

    // ── READ ───────────────────────────────────────────────────────

    public Rental findById(int rentalId) throws SQLException {
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(SELECT + "WHERE r.rental_id=?")) {
            ps.setInt(1, rentalId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        }
        return null;
    }

    public List<Rental> findByUserId(int userId) throws SQLException {
        List<Rental> list = new ArrayList<>();
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     SELECT + "WHERE r.user_id=? ORDER BY r.rental_date DESC, r.rental_id DESC")) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public List<Rental> findAll() throws SQLException {
        List<Rental> list = new ArrayList<>();
        try (Connection c = DBConfig.getConnection();
             ResultSet rs = c.createStatement().executeQuery(
                     SELECT + "ORDER BY r.rental_date DESC, r.rental_id DESC")) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    /** Returns only rentals whose return_datetime is in the future (or NULL) */
    public List<Rental> findActive() throws SQLException {
        List<Rental> list = new ArrayList<>();
        String sql = SELECT +
            "WHERE (r.return_datetime IS NULL OR r.return_datetime > NOW()) " +
            "ORDER BY r.return_datetime ASC";
        try (Connection c = DBConfig.getConnection();
             ResultSet rs = c.createStatement().executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    /** Set car availability=1 for any rental whose return_datetime has passed */
    public void releaseExpired() throws SQLException {
        String sql =
            "UPDATE cars SET availability=1 WHERE car_id IN " +
            "(SELECT car_id FROM rentals WHERE return_datetime IS NOT NULL AND return_datetime < NOW())";
        try (Connection c = DBConfig.getConnection(); Statement st = c.createStatement()) {
            st.executeUpdate(sql);
        }
    }

    // ── MAPPER ─────────────────────────────────────────────────────

    private Rental map(ResultSet rs) throws SQLException {
        Rental r = new Rental();
        r.setRentalId(rs.getInt("rental_id"));
        r.setUserId(rs.getInt("user_id"));
        r.setCarId(rs.getInt("car_id"));
        r.setRentalDate(rs.getDate("rental_date"));
        r.setCarName(rs.getString("car_name"));
        r.setCarBrand(rs.getString("car_brand"));
        r.setCarPrice(rs.getDouble("car_price"));

        // car_image_url comes from the JOIN — safe to be null
        try { r.setCarImageUrl(rs.getString("car_image_url")); } catch (SQLException ignored) {}

        try { r.setDays(rs.getInt("days")); }                    catch (SQLException ignored) {}
        try { r.setTotalCost(rs.getDouble("total_cost")); }      catch (SQLException ignored) {}
        try { r.setRenterName(rs.getString("renter_name")); }    catch (SQLException ignored) {}
        try { r.setRenterEmail(rs.getString("renter_email")); }  catch (SQLException ignored) {}
        try { r.setRenterPhone(rs.getString("renter_phone")); }  catch (SQLException ignored) {}
        try { r.setRenterLocation(rs.getString("renter_location")); } catch (SQLException ignored) {}
        try { r.setPickupDatetime(rs.getTimestamp("pickup_datetime")); } catch (SQLException ignored) {}
        try { r.setReturnDatetime(rs.getTimestamp("return_datetime")); } catch (SQLException ignored) {}
        try { r.setIsConfirmed(rs.getInt("is_confirmed")); }     catch (SQLException ignored) {}
        return r;
    }
}