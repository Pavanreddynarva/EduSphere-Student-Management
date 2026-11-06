
package com.studentmanagement.dao;

import java.util.List;

import com.studentmanagement.model.User;

public interface UserDAO {

    User findByEmail(String email);

    boolean save(User user);

    List<User> findAll();

    boolean updateRole(int userId, String role);

    // Update an existing user's password
    boolean updatePassword(int userId, String passwordHash);
}
