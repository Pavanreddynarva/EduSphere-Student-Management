
package com.studentmanagement.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.studentmanagement.dao.UserDAO;
import com.studentmanagement.model.User;
import com.studentmanagement.util.DBConnection;

public class UserDAOImpl implements UserDAO {

    // Find a user using email (used during login)
    @Override
    public User findByEmail(String email) {

        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, email);

            try (ResultSet rs = statement.executeQuery()) {

                if (rs.next()) {

                    User user = new User();

                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPasswordHash(rs.getString("password"));
                    user.setRole(rs.getString("role"));

                    return user;
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Unable to find user", e);
        }

        return null;
    }

    // Save a new user
    @Override
    public boolean save(User user) {

        String sql = "INSERT INTO users (full_name, email, password, role) "
                   + "VALUES (?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, user.getFullName());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPasswordHash());
            statement.setString(4, user.getRole());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Unable to save user", e);
        }
    }

    // Retrieve all users
    @Override
    public List<User> findAll() {

        List<User> users = new ArrayList<>();

        String sql = "SELECT user_id, full_name, email, role "
                   + "FROM users ORDER BY user_id";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {

                User user = new User();

                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));

                users.add(user);
            }

        } catch (SQLException e) {
            throw new RuntimeException("Unable to retrieve users", e);
        }

        return users;
    }

    // Update a user's role
    @Override
    public boolean updateRole(int userId, String role) {

        String sql = "UPDATE users SET role = ? WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, role);
            statement.setInt(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Unable to update user role", e);
        }
    }

    // Update an existing user's password
    @Override
    public boolean updatePassword(int userId, String passwordHash) {

        String sql = "UPDATE users SET password = ? WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, passwordHash);
            statement.setInt(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Unable to update password", e);
        }
    }
}
