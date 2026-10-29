
package com.studentmanagement.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import com.studentmanagement.dao.StudentDAO;
import com.studentmanagement.model.Student;
import com.studentmanagement.util.DBConnection;

public class StudentDAOImpl implements StudentDAO {

    @Override
    public void addStudent(Student student) {
        String sql = """
            INSERT INTO students
            (roll_number, full_name, email, phone,
             department, year_of_study, marks)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(
                         sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, student.getRollNumber());
            ps.setString(2, student.getFullName());
            ps.setString(3, student.getEmail());
            ps.setString(4, student.getPhone());
            ps.setString(5, student.getDepartment());
            ps.setInt(6, student.getYearOfStudy());
            ps.setBigDecimal(7, student.getMarks());

            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    student.setStudentId(keys.getInt(1));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Unable to add student", e);
        }
    }

    @Override
    public Optional<Student> getStudentById(int studentId) {
        String sql =
            "SELECT * FROM students WHERE student_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Student student = new Student();

                    student.setStudentId(rs.getInt("student_id"));
                    student.setRollNumber(rs.getString("roll_number"));
                    student.setFullName(rs.getString("full_name"));
                    student.setEmail(rs.getString("email"));
                    student.setPhone(rs.getString("phone"));
                    student.setDepartment(rs.getString("department"));
                    student.setYearOfStudy(
                        rs.getInt("year_of_study"));
                    student.setMarks(rs.getBigDecimal("marks"));

                    return Optional.of(student);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Unable to retrieve student", e);
        }

        return Optional.empty();
    }

    @Override
    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Student student = new Student();

                student.setStudentId(rs.getInt("student_id"));
                student.setRollNumber(rs.getString("roll_number"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setPhone(rs.getString("phone"));
                student.setDepartment(rs.getString("department"));
                student.setYearOfStudy(
                    rs.getInt("year_of_study"));
                student.setMarks(rs.getBigDecimal("marks"));

                students.add(student);
            }

        } catch (SQLException e) {
            throw new RuntimeException("Unable to retrieve students", e);
        }

        return students;
    }

    @Override
    public boolean updateStudent(Student student) {
        String sql = """
            UPDATE students
            SET roll_number = ?, full_name = ?, email = ?,
                phone = ?, department = ?, year_of_study = ?,
                marks = ?
            WHERE student_id = ?
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, student.getRollNumber());
            ps.setString(2, student.getFullName());
            ps.setString(3, student.getEmail());
            ps.setString(4, student.getPhone());
            ps.setString(5, student.getDepartment());
            ps.setInt(6, student.getYearOfStudy());
            ps.setBigDecimal(7, student.getMarks());
            ps.setInt(8, student.getStudentId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Unable to update student", e);
        }
    }

    @Override
    public boolean deleteStudent(int studentId) {
        String sql =
            "DELETE FROM students WHERE student_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Unable to delete student", e);
        }
    }

    // Checks whether any student already uses this roll number.
    @Override
    public boolean existsByRollNumber(String rollNumber) {
        String sql = """
            SELECT 1
            FROM students
            WHERE roll_number = ?
            LIMIT 1
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, rollNumber);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                "Unable to check roll number", e);
        }
    }

    // Checks for a duplicate while excluding the student being edited.
    @Override
    public boolean existsByRollNumberExcludingStudent(
            String rollNumber, int studentId) {

        String sql = """
            SELECT 1
            FROM students
            WHERE roll_number = ?
              AND student_id <> ?
            LIMIT 1
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, rollNumber);
            ps.setInt(2, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                "Unable to check roll number", e);
        }
    }
}
