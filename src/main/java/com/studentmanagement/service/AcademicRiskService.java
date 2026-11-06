
package com.studentmanagement.service;

import java.util.List;

import com.studentmanagement.model.AcademicRisk;
import com.studentmanagement.model.AcademicRiskSettings;

public interface AcademicRiskService {

    // Global threshold settings
    AcademicRiskSettings getRiskSettings();

    boolean updateSettings(
            int adminId,
            AcademicRiskSettings settings
    );

    // Risk calculation for an individual student
    AcademicRisk calculateStudentRisk(int studentId);

    // Risk reports for different roles
    List<AcademicRisk> getAllStudentRisks();

    List<AcademicRisk> getTeacherStudentRisks(int teacherId);
}
