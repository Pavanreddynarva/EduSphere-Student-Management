
package com.studentmanagement.dao;

import java.math.BigDecimal;

import com.studentmanagement.model.AcademicRiskSettings;

public interface AcademicRiskDAO {

    AcademicRiskSettings getSettings();

    boolean updateSettings(AcademicRiskSettings settings);

    int[] getAttendanceCountsForStudent(int studentId);

    BigDecimal getAcademicPercentageForStudent(int studentId);

    int getAssessmentCountForStudent(int studentId);
}
