
package com.studentmanagement.service.impl;

import java.util.List;
import java.util.regex.Pattern;

import org.mindrot.jbcrypt.BCrypt;

import com.studentmanagement.dao.UserDAO;
import com.studentmanagement.dao.impl.UserDAOImpl;
import com.studentmanagement.model.User;
import com.studentmanagement.service.UserService;

public class UserServiceImpl implements UserService {

    private final UserDAO userDAO = new UserDAOImpl();

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    // Existing login functionality
    @Override
    public User authenticate(String email, String password) {

        if (email == null || email.trim().isEmpty()
                || password == null || password.isEmpty()) {
            return null;
        }

        User user = userDAO.findByEmail(email.trim());

        if (user == null) {
            return null;
        }

        if (BCrypt.checkpw(password, user.getPasswordHash())) {
            return user;
        }

        return null;
    }

    // Create a Teacher or Student account
    @Override
    public boolean createUser(User user, String password) {

        if (user == null) {
            return false;
        }

        String fullName = user.getFullName();
        String email = user.getEmail();
        String role = user.getRole();

        // Validate name
        if (fullName == null || fullName.trim().isEmpty()) {
            return false;
        }

        // Validate email
        if (email == null || !EMAIL_PATTERN.matcher(email.trim()).matches()) {
            return false;
        }

        // Validate password
        if (password == null || password.length() < 8) {
            return false;
        }

        // Allow only Teacher and Student accounts
        if (role == null ||
                !(role.equalsIgnoreCase("TEACHER")
                || role.equalsIgnoreCase("STUDENT"))) {
            return false;
        }

        // Check duplicate email
        if (userDAO.findByEmail(email.trim()) != null) {
            return false;
        }

        // Hash the password
        String hashedPassword = BCrypt.hashpw(
                password, BCrypt.gensalt(12));

        // Store user details
        user.setFullName(fullName.trim());
        user.setEmail(email.trim());
        user.setRole(role.toUpperCase());
        user.setPasswordHash(hashedPassword);

        return userDAO.save(user);
    }

    // Retrieve all users
    @Override
    public List<User> getAllUsers() {
        return userDAO.findAll();
    }

    // Change a Teacher's or Student's role
    @Override
    public boolean changeUserRole(int userId, String role) {

        if (userId <= 0 || role == null) {
            return false;
        }

        if (!(role.equalsIgnoreCase("TEACHER")
                || role.equalsIgnoreCase("STUDENT"))) {
            return false;
        }

        // Find the target user and protect Admin accounts
        User targetUser = null;

        for (User user : userDAO.findAll()) {
            if (user.getUserId() == userId) {
                targetUser = user;
                break;
            }
        }

        if (targetUser == null
                || "ADMIN".equalsIgnoreCase(targetUser.getRole())) {
            return false;
        }

        return userDAO.updateRole(userId, role.toUpperCase());
    }

    // Change password securely using BCrypt
    @Override
    public boolean changePassword(String email,
                                  String currentPassword,
                                  String newPassword) {

        if (email == null || email.trim().isEmpty()
                || currentPassword == null || currentPassword.isEmpty()
                || newPassword == null || newPassword.length() < 8) {
            return false;
        }

        User user = userDAO.findByEmail(email.trim());

        if (user == null || user.getPasswordHash() == null) {
            return false;
        }

        // Verify the existing password
        if (!BCrypt.checkpw(currentPassword, user.getPasswordHash())) {
            return false;
        }

        // Prevent choosing the same password again
        if (BCrypt.checkpw(newPassword, user.getPasswordHash())) {
            return false;
        }

        // Hash the new password before storing it
        String newPasswordHash = BCrypt.hashpw(
                newPassword, BCrypt.gensalt(12));

        return userDAO.updatePassword(
                user.getUserId(), newPasswordHash);
    }
}
