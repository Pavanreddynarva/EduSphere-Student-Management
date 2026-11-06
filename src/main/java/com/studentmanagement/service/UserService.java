
package com.studentmanagement.service;

import java.util.List;

import com.studentmanagement.model.User;

public interface UserService {

    // Existing login functionality
    User authenticate(String username, String password);

    // Create a Teacher or Student account
    boolean createUser(User user, String password);

    // Retrieve all registered users
    List<User> getAllUsers();

    // Change a Teacher's or Student's role
    boolean changeUserRole(int userId, String role);

    // Change the password of the currently authenticated user
    boolean changePassword(String email, String currentPassword,
                           String newPassword);
}
