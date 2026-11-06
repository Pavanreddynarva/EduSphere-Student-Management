
package com.studentmanagement.dao.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import com.studentmanagement.dao.AcademicRiskDAO;
import com.studentmanagement.model.AcademicRiskSettings;
import com.studentmanagement.util.DBConnection;

public class AcademicRiskDAOImpl implements AcademicRiskDAO {

    // 1. Retrieve global academic risk settings
    @Override
    public AcademicRiskSettings getSettings() {

        String sql = """
                SELECT *
                FROM academic_risk_settings
                WHERE setting_id = 1
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                AcademicRiskSettings settings =
                        new AcademicRiskSettings();

                settings.setSettingId(rs.getInt("setting_id"));

                settings.setAttendanceThreshold(
                        rs.getBigDecimal("attendance_threshold"));

                settings.setPerformanceThreshold(
                        rs.getBigDecimal("performance_threshold"));

                int updatedBy = rs.getInt("updated_by");

                settings.setUpdatedBy(
                        rs.wasNull() ? null : updatedBy);

                Timestamp timestamp = rs.getTimestamp("updated_at");

                if (timestamp != null) {
                    settings.setUpdatedAt(
                            timestamp.toLocalDateTime());
                }

                return settings;
            }

            throw new IllegalStateException(
                    "Academic risk settings not found.");

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to retrieve academic risk settings.", e);
        }
    }

    // 2. Update global academic risk settings
    @Override
    public boolean updateSettings(AcademicRiskSettings settings) {

        String sql = """
                UPDATE academic_risk_settings
                SET attendance_threshold = ?,
                    performance_threshold = ?,
                    updated_by = ?
                WHERE setting_id = 1
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setBigDecimal(
                    1, settings.getAttendanceThreshold());

            ps.setBigDecimal(
                    2, settings.getPerformanceThreshold());

            ps.setInt(3, settings.getUpdatedBy());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to update academic risk settings.", e);
        }
    }

    // 3. Get total conducted sessions and attended sessions
    @Override
    public int[] getAttendanceCountsForStudent(int studentId) {

        String sql = """
                SELECT
                    COUNT(DISTINCT s.session_id) AS total_sessions,

                    COUNT(DISTINCT
                        CASE
                            WHEN ar.status = 'PRESENT'
                            THEN s.session_id
                        END
                    ) AS present_sessions

                FROM students st

                LEFT JOIN teacher_assignments ta
                    ON ta.department = st.department
                    AND ta.year_of_study = st.year_of_study
                    AND ta.section = st.section

                LEFT JOIN attendance_sessions s
                    ON s.assignment_id = ta.assignment_id
                    AND s.status = 'ACTIVE'
                    AND s.start_time <= CURRENT_TIMESTAMP

                LEFT JOIN attendance_records ar
                    ON ar.session_id = s.session_id
                    AND ar.student_id = st.student_id

                WHERE st.student_id = ?
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    int totalSessions =
                            rs.getInt("total_sessions");

                    int presentSessions =
                            rs.getInt("present_sessions");

                    return new int[]{
                            totalSessions,
                            presentSessions
                    };
                }

            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to calculate student attendance.", e);
        }

        return new int[]{0, 0};
    }

    // 4. Calculate weighted academic percentage
    @Override
    public BigDecimal getAcademicPercentageForStudent(int studentId) {

        String sql = """
                SELECT
                    SUM(marks_obtained) AS total_obtained,
                    SUM(max_marks) AS total_maximum
                FROM student_assessments
                WHERE student_id = ?
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    BigDecimal obtained =
                            rs.getBigDecimal("total_obtained");

                    BigDecimal maximum =
                            rs.getBigDecimal("total_maximum");

                    if (obtained == null || maximum == null
                            || maximum.compareTo(BigDecimal.ZERO) == 0) {
                        return null;
                    }

                    return obtained
                            .multiply(new BigDecimal("100"))
                            .divide(maximum, 2, RoundingMode.HALF_UP);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to calculate academic performance.", e);
        }

        return null;
    }

    // 5. Get the number of assessments recorded for a student
    @Override
    public int getAssessmentCountForStudent(int studentId) {

        String sql = """
                SELECT COUNT(*)
                FROM student_assessments
                WHERE student_id = ?
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to count student assessments.", e);
        }

        return 0;
    }
}
