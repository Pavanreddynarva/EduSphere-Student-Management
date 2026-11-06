
package com.studentmanagement.dao.impl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.studentmanagement.dao.StudentAssessmentDAO;
import com.studentmanagement.model.StudentAssessment;
import com.studentmanagement.util.DBConnection;

public class StudentAssessmentDAOImpl implements StudentAssessmentDAO {

    @Override
    public boolean saveAssessment(StudentAssessment assessment) {

        String sql = """
            INSERT INTO student_assessments
            (student_id, assignment_id, assessment_name,
             assessment_date, marks_obtained, max_marks)
            VALUES (?, ?, ?, ?, ?, ?)
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, assessment.getStudentId());
            ps.setInt(2, assessment.getAssignmentId());
            ps.setString(3, assessment.getAssessmentName());
            ps.setDate(4, Date.valueOf(assessment.getAssessmentDate()));
            ps.setBigDecimal(5, assessment.getMarksObtained());
            ps.setBigDecimal(6, assessment.getMaxMarks());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<StudentAssessment> getAssessmentsByStudent(int studentId) {

        List<StudentAssessment> assessments = new ArrayList<>();

        String sql = """
            SELECT * FROM student_assessments
            WHERE student_id = ?
            ORDER BY assessment_date DESC
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    assessments.add(mapResultSet(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return assessments;
    }

    @Override
    public List<StudentAssessment> getAssessmentsByAssignment(int assignmentId) {

        List<StudentAssessment> assessments = new ArrayList<>();

        String sql = """
            SELECT * FROM student_assessments
            WHERE assignment_id = ?
            ORDER BY assessment_date DESC
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, assignmentId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    assessments.add(mapResultSet(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return assessments;
    }

    private StudentAssessment mapResultSet(ResultSet rs)
            throws SQLException {

        StudentAssessment assessment = new StudentAssessment();

        assessment.setAssessmentId(rs.getInt("assessment_id"));
        assessment.setStudentId(rs.getInt("student_id"));
        assessment.setAssignmentId(rs.getInt("assignment_id"));
        assessment.setAssessmentName(rs.getString("assessment_name"));
        assessment.setAssessmentDate(
                rs.getDate("assessment_date").toLocalDate()
        );
        assessment.setMarksObtained(rs.getBigDecimal("marks_obtained"));
        assessment.setMaxMarks(rs.getBigDecimal("max_marks"));

        return assessment;
    }
}
