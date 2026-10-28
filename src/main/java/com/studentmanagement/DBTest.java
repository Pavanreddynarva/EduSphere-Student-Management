
package com.studentmanagement;

import java.sql.Connection;
import java.sql.SQLException;

import com.studentmanagement.util.DBConnection;

public class DBTest {

    public static void main(String[] args) {
        try (Connection con = DBConnection.getConnection()) {
            System.out.println("Database connected successfully!");
        } catch (SQLException e) {
            System.out.println("Database connection failed!");
            e.printStackTrace();
        }
    }
}
