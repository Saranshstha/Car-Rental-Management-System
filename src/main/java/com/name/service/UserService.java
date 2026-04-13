package com.name.service;
import com.name.dao.UserDAO;
import com.name.model.User;
import com.name.util.PasswordUtil;
import com.name.util.ValidationUtil;
import java.sql.SQLException;

public class UserService {

    private static final int MAX_ATTEMPTS = 5;
    private final UserDAO userDAO = new UserDAO();

    public User authenticate(String email, String password) throws SQLException {
        User user = userDAO.findByEmail(email);
        if (user == null) return null;

        if (user.isLocked()) {
            throw new IllegalStateException("Account locked after too many failed attempts.");
        }

        if (!PasswordUtil.verify(password, user.getPassword())) {
            int attempts = user.getFailedAttempts() + 1;
            userDAO.updateFailedAttempts(user.getId(), attempts);
            if (attempts >= MAX_ATTEMPTS) userDAO.lockAccount(user.getId());
            return null;
        }

        userDAO.resetFailedAttempts(user.getId());
        return user;
    }

    public boolean register(String name, String email, String password) throws SQLException {
        if (!ValidationUtil.isNotEmpty(name)
                || !ValidationUtil.isValidEmail(email)
                || !ValidationUtil.isValidPassword(password)) {
            return false;
        }
        if (userDAO.findByEmail(email) != null) return false;

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(PasswordUtil.hash(password));
        user.setRole("user");
        return userDAO.save(user);
    }

    public boolean resetPassword(String email, String newPassword) throws SQLException {
        if (!ValidationUtil.isValidPassword(newPassword)) return false;
        return userDAO.updatePassword(email, PasswordUtil.hash(newPassword));
    }
}