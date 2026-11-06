
package com.studentmanagement.dao.impl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.studentmanagement.dao.TeacherInterventionDAO;
import com.studentmanagement.model.TeacherIntervention;
import com.studentmanagement.util.DBConnection;

public class TeacherInterventionDAOImpl
        implements TeacherInterventionDAO {

    // 1. Save a teacher intervention
    @Override
    public boolean saveIntervention(
            TeacherIntervention intervention) {

        String sql = """
                INSERT INTO teacher_interventions
                (student_id, teacher_id, intervention_type,
                 action_taken, follow_up_date,
                 follow_up_status, notes)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, intervention.getStudentId());
            ps.setInt(2, intervention.getTeacherId());
            ps.setString(3, intervention.getInterventionType());
            ps.setString(4, intervention.getActionTaken());

            if (intervention.getFollowUpDate() != null) {
                ps.setDate(5, Date.valueOf(
                        intervention.getFollowUpDate()));
            } else {
                ps.setNull(5, java.sql.Types.DATE);
            }

            ps.setString(6, intervention.getFollowUpStatus());
            ps.setString(7, intervention.getNotes());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to save teacher intervention.", e);
        }
    }

    // 2. Get interventions for a particular student
    @Override
    public List<TeacherIntervention> getInterventionsByStudent(
            int studentId) {

        List<TeacherIntervention> interventions =
                new ArrayList<>();

        String sql = """
                SELECT *
                FROM teacher_interventions
                WHERE student_id = ?
                ORDER BY created_at DESC
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    interventions.add(mapResultSet(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to retrieve student interventions.", e);
        }

        return interventions;
    }

    // 3. Get interventions recorded by a particular teacher
    @Override
    public List<TeacherIntervention> getInterventionsByTeacher(
            int teacherId) {

        List<TeacherIntervention> interventions =
                new ArrayList<>();

        String sql = """
                SELECT *
                FROM teacher_interventions
                WHERE teacher_id = ?
                ORDER BY created_at DESC
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, teacherId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    interventions.add(mapResultSet(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to retrieve teacher interventions.", e);
        }

        return interventions;
    }

    // 4. Get interventions for a student recorded by a specific teacher
    @Override
    public List<TeacherIntervention> getInterventionsByStudentAndTeacher(
            int studentId,
            int teacherId) {

        List<TeacherIntervention> interventions =
                new ArrayList<>();

        String sql = """
                SELECT *
                FROM teacher_interventions
                WHERE student_id = ?
                  AND teacher_id = ?
                ORDER BY created_at DESC
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, teacherId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    interventions.add(mapResultSet(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to retrieve teacher interventions for student.",
                    e);
        }

        return interventions;
    }

    // 5. Update follow-up only if the intervention belongs to the teacher
    @Override
    public boolean updateFollowUpStatus(
            int interventionId,
            int teacherId,
            String status,
            String notes) {

        String sql = """
                UPDATE teacher_interventions
                SET follow_up_status = ?,
                    notes = COALESCE(?, notes)
                WHERE intervention_id = ?
                  AND teacher_id = ?
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, notes);
            ps.setInt(3, interventionId);
            ps.setInt(4, teacherId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to update intervention follow-up.", e);
        }
    }

    // 6. Convert database result into TeacherIntervention object
    private TeacherIntervention mapResultSet(ResultSet rs)
            throws SQLException {

        TeacherIntervention intervention =
                new TeacherIntervention();

        intervention.setInterventionId(
                rs.getInt("intervention_id"));

        intervention.setStudentId(
                rs.getInt("student_id"));

        intervention.setTeacherId(
                rs.getInt("teacher_id"));

        intervention.setInterventionType(
                rs.getString("intervention_type"));

        intervention.setActionTaken(
                rs.getString("action_taken"));

        Date followUpDate = rs.getDate("follow_up_date");

        if (followUpDate != null) {
            intervention.setFollowUpDate(
                    followUpDate.toLocalDate());
        }

        intervention.setFollowUpStatus(
                rs.getString("follow_up_status"));

        intervention.setNotes(
                rs.getString("notes"));

        Timestamp createdAt = rs.getTimestamp("created_at");

        if (createdAt != null) {
            intervention.setCreatedAt(
                    createdAt.toLocalDateTime());
        }

        return intervention;
    }
}
