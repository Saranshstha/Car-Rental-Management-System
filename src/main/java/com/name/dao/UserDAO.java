package com.name.dao;

import com.name.config.DBConfig;
import com.name.model.user;
import java.sql.*;

public class UserDAO {
    public user findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        }
        return null;
    }

    public boolean save(User user) throws SQLException {
        String sql = "INSERT INTO users (name, email, password, role) VALUES (?,?,?,?)";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());
            return ps.executeUpdate() > 0;
        }
    }

    public void updateFailedAttempts(int userId, int attempts) throws SQLException {
        String sql = "UPDATE users SET failed_attempts = ? WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, attempts); ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    public void lockAccount(int userId) throws SQLException {
        String sql = "UPDATE users SET is_locked = 1 WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId); ps.executeUpdate();
        }
    }

    public void resetFailedAttempts(int userId) throws SQLException {
        String sql = "UPDATE users SET failed_attempts = 0 WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId); ps.executeUpdate();
        }
    }

    public boolean updatePassword(String email, String newPassword) throws SQLException {
        String sql = "UPDATE users SET password=?, is_locked=0, failed_attempts=0 WHERE email=?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, newPassword); ps.setString(2, email);
            return ps.executeUpdate() > 0;
        }
    }

    private User map(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setName(rs.getString("name"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setRole(rs.getString("role"));
        u.setFailedAttempts(rs.getInt("failed_attempts"));
        u.setLocked(rs.getBoolean("is_locked"));
        return u;
    }
}