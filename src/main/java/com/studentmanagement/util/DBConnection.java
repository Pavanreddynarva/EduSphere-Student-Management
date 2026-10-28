
package com.studentmanagement.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

    private static final Properties properties = new Properties();

    static {
        try {
            // Explicitly load the MySQL JDBC driver.
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (InputStream input = DBConnection.class
                    .getClassLoader()
                    .getResourceAsStream("db.properties")) {

                if (input == null) {
                    throw new IllegalStateException(
                            "db.properties not found in application resources."
                    );
                }

                properties.load(input);
            }

        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(
                    "MySQL JDBC driver not found. Check the Maven dependency."
            );
        } catch (IOException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    public static Connection getConnection() throws SQLException {
        String url = properties.getProperty("db.url");
        String username = properties.getProperty("db.username");
        String password = properties.getProperty("db.password");

        if (url == null || username == null || password == null) {
            throw new IllegalStateException(
                    "Database configuration is incomplete."
            );
        }

        return DriverManager.getConnection(url, username, password);
    }
}
