package com.studentmanagement.dao.impl;

import com.studentmanagement.dao.ImprovementPlanDAO;
import com.studentmanagement.model.Student;
import com.studentmanagement.model.SubjectImprovement;
import com.studentmanagement.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ImprovementPlanDAOImpl implements ImprovementPlanDAO {
    @Override
    public List<SubjectImprovement> getSubjectAttendance(Student student) {
        List<SubjectImprovement> subjects = new ArrayList<>();
        String sql = """
            SELECT ta.assignment_id, ta.subject_name,
                   COUNT(DISTINCT s.session_id) AS total_sessions,
                   COUNT(DISTINCT CASE WHEN UPPER(ar.status) = 'PRESENT'
                       THEN s.session_id END) AS present_sessions
            FROM teacher_assignments ta
            LEFT JOIN attendance_sessions s
                ON s.assignment_id = ta.assignment_id
                AND s.session_date <= CURRENT_DATE
            LEFT JOIN attendance_records ar
                ON ar.session_id = s.session_id AND ar.student_id = ?
            WHERE ta.department = ? AND ta.year_of_study = ? AND ta.section = ?
            GROUP BY ta.assignment_id, ta.subject_name
            ORDER BY ta.subject_name
            """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, student.getStudentId());
            ps.setString(2, student.getDepartment());
            ps.setInt(3, student.getYearOfStudy());
            ps.setString(4, student.getSection());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SubjectImprovement item = new SubjectImprovement();
                    item.setAssignmentId(rs.getInt("assignment_id"));
                    item.setSubjectName(rs.getString("subject_name"));
                    item.setTotalSessions(rs.getInt("total_sessions"));
                    item.setPresentSessions(rs.getInt("present_sessions"));
                    subjects.add(item);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Unable to load subject attendance", e);
        }
        return subjects;
    }
}
