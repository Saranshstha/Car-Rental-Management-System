package com.name.service;

import com.name.dao.UserDAO;
import com.name.model.User;
import com.name.util.PasswordUtil;
import com.name.util.ValidationUtil;
import java.sql.SQLException;

public class UserService {

    private static final int MAX_ATTEMPTS = 5;
    private final UserDAO userDAO = new UserDAO();

    /**
     * Returns the authenticated User, or throws an exception with a message.
     */
    public User authenticate(String email, String rawPassword) throws Exception {
        if (!ValidationUtil.isNotEmpty(email) || !ValidationUtil.isNotEmpty(rawPassword)) {
            throw new IllegalArgumentException("Email and password are required.");
        }

        User user = userDAO.findByEmail(email.trim().toLowerCase());
        if (user == null) {
            throw new IllegalArgumentException("No account found for that email.");
        }

        if (user.isLocked()) {
            throw new IllegalStateException("Account is locked. Please reset your password.");
        }

        if (!PasswordUtil.verify(rawPassword, user.getPassword())) {
            userDAO.incrementFailedAttempts(user.getId());
            int remaining = MAX_ATTEMPTS - (user.getFailedAttempts() + 1);
            if (remaining <= 0) {
                userDAO.lockAccount(user.getId());
                throw new IllegalStateException("Account locked after too many failed attempts. Reset your password to unlock.");
            }
            throw new IllegalArgumentException("Incorrect password. " + remaining + " attempt(s) remaining.");
        }

        // Successful login — reset counter
        if (user.getFailedAttempts() > 0) {
            userDAO.resetFailedAttempts(user.getId());
        }
        return user;
    }

    public void register(String name, String email, String rawPassword) throws Exception {
        if (!ValidationUtil.isNotEmpty(name))
            throw new IllegalArgumentException("Full name is required.");
        if (!ValidationUtil.isValidEmail(email))
            throw new IllegalArgumentException("Invalid email address.");
        if (!ValidationUtil.isValidPassword(rawPassword))
            throw new IllegalArgumentException("Password must be at least 6 characters.");

        String normalised = email.trim().toLowerCase();
        if (userDAO.findByEmail(normalised) != null)
            throw new IllegalArgumentException("An account with that email already exists.");

        User user = new User();
        user.setName(name.trim());
        user.setEmail(normalised);
        user.setPassword(PasswordUtil.hash(rawPassword));
        userDAO.save(user);
    }

    public void resetPassword(String email, String newPassword) throws Exception {
        if (!ValidationUtil.isValidEmail(email))
            throw new IllegalArgumentException("Invalid email address.");
        if (!ValidationUtil.isValidPassword(newPassword))
            throw new IllegalArgumentException("Password must be at least 6 characters.");

        String normalised = email.trim().toLowerCase();
        if (userDAO.findByEmail(normalised) == null)
            throw new IllegalArgumentException("No account found for that email.");

        userDAO.updatePassword(normalised, PasswordUtil.hash(newPassword));
    }
}