
package com.studentmanagement.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.studentmanagement.dao.AcademicRiskDAO;
import com.studentmanagement.dao.AttendanceDAO;
import com.studentmanagement.dao.StudentDAO;
import com.studentmanagement.dao.impl.AcademicRiskDAOImpl;
import com.studentmanagement.dao.impl.AttendanceDAOImpl;
import com.studentmanagement.dao.impl.StudentDAOImpl;
import com.studentmanagement.model.AcademicRisk;
import com.studentmanagement.model.AcademicRiskSettings;
import com.studentmanagement.model.Student;
import com.studentmanagement.model.TeacherAssignment;
import com.studentmanagement.service.AcademicRiskService;

public class AcademicRiskServiceImpl implements AcademicRiskService {

    private final AcademicRiskDAO riskDAO;
    private final StudentDAO studentDAO;
    private final AttendanceDAO attendanceDAO;

    public AcademicRiskServiceImpl() {
        this.riskDAO = new AcademicRiskDAOImpl();
        this.studentDAO = new StudentDAOImpl();
        this.attendanceDAO = new AttendanceDAOImpl();
    }

    // 1. Retrieve global risk thresholds
    @Override
    public AcademicRiskSettings getRiskSettings() {
        return riskDAO.getSettings();
    }

    // 2. Update global thresholds
    @Override
    public boolean updateSettings(
            int adminId,
            AcademicRiskSettings settings) {

        if (adminId <= 0 || settings == null) {
            throw new IllegalArgumentException(
                    "Invalid admin or settings.");
        }

        BigDecimal attendance =
                settings.getAttendanceThreshold();

        BigDecimal performance =
                settings.getPerformanceThreshold();

        if (attendance == null
                || attendance.compareTo(BigDecimal.ZERO) < 0
                || attendance.compareTo(new BigDecimal("100")) > 0) {

            throw new IllegalArgumentException(
                    "Attendance threshold must be between 0 and 100.");
        }

        if (performance == null
                || performance.compareTo(BigDecimal.ZERO) < 0
                || performance.compareTo(new BigDecimal("100")) > 0) {

            throw new IllegalArgumentException(
                    "Performance threshold must be between 0 and 100.");
        }

        settings.setSettingId(1);
        settings.setUpdatedBy(adminId);

        return riskDAO.updateSettings(settings);
    }

    // 3. Calculate risk for an individual student
    @Override
    public AcademicRisk calculateStudentRisk(int studentId) {

        if (studentId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid student ID.");
        }

        Student student = studentDAO.getStudentById(studentId)
                .orElseThrow(() ->
                        new IllegalArgumentException(
                                "Student not found."));

        AcademicRiskSettings settings = riskDAO.getSettings();

        AcademicRisk risk = new AcademicRisk();

        // Student details
        risk.setStudentId(student.getStudentId());
        risk.setRollNumber(student.getRollNumber());
        risk.setFullName(student.getFullName());
        risk.setDepartment(student.getDepartment());
        risk.setYearOfStudy(student.getYearOfStudy());
        risk.setSection(student.getSection());

        // Attendance calculation
        int[] attendanceCounts =
                riskDAO.getAttendanceCountsForStudent(studentId);

        int totalSessions = attendanceCounts[0];
        int presentSessions = attendanceCounts[1];

        risk.setTotalSessions(totalSessions);
        risk.setPresentSessions(presentSessions);

        BigDecimal attendancePercentage = null;

        if (totalSessions > 0) {

            attendancePercentage =
                    BigDecimal.valueOf(presentSessions)
                            .multiply(new BigDecimal("100"))
                            .divide(
                                    BigDecimal.valueOf(totalSessions),
                                    2,
                                    RoundingMode.HALF_UP
                            );
        }

        risk.setAttendancePercentage(attendancePercentage);

        // Academic calculation
        BigDecimal academicPercentage =
                riskDAO.getAcademicPercentageForStudent(studentId);

        int assessmentCount =
                riskDAO.getAssessmentCountForStudent(studentId);

        risk.setAcademicPercentage(academicPercentage);
        risk.setTotalAssessments(assessmentCount);

        // Risk classification
        boolean attendanceRisk = false;
        boolean academicRisk = false;

        List<String> reasons = new ArrayList<>();
        List<String> improvementAreas = new ArrayList<>();

        if (attendancePercentage != null) {

            if (attendancePercentage.compareTo(
                    settings.getAttendanceThreshold()) < 0) {

                attendanceRisk = true;

                reasons.add(
                        "Attendance is " + attendancePercentage
                        + "%, below the required threshold of "
                        + settings.getAttendanceThreshold() + "%.");

                improvementAreas.add(
                        "Improve class attendance.");
            }
        }

        if (academicPercentage != null) {

            if (academicPercentage.compareTo(
                    settings.getPerformanceThreshold()) < 0) {

                academicRisk = true;

                reasons.add(
                        "Academic performance is " + academicPercentage
                        + "%, below the required threshold of "
                        + settings.getPerformanceThreshold() + "%.");

                improvementAreas.add(
                        "Improve assessment performance.");
            }
        }

        // Set risk flags
        risk.setAttendanceRisk(attendanceRisk);
        risk.setAcademicRisk(academicRisk);

        // Set overall risk status
        if (totalSessions == 0 && assessmentCount == 0) {

            risk.setRiskStatus("INSUFFICIENT_DATA");

            reasons.add(
                    "No attendance sessions or assessments are available.");

            improvementAreas.add(
                    "Attendance and academic performance cannot be evaluated yet.");

        } else if (attendanceRisk && academicRisk) {

            risk.setRiskStatus("HIGH_RISK");

        } else if (attendanceRisk) {

            risk.setRiskStatus("ATTENDANCE_RISK");

        } else if (academicRisk) {

            risk.setRiskStatus("ACADEMIC_RISK");

        } else {

            risk.setRiskStatus("LOW_RISK");

            reasons.add(
                    "Available attendance and academic performance "
                    + "are meeting the configured thresholds.");

        }

        // Handle partially available data
        if (totalSessions == 0 && assessmentCount > 0) {
            reasons.add(
                    "Attendance data is not available yet.");
        }

        if (assessmentCount == 0 && totalSessions > 0) {
            reasons.add(
                    "Academic assessment data is not available yet.");
        }

        risk.setRiskReasons(reasons);
        risk.setImprovementAreas(improvementAreas);

        return risk;
    }

    // 4. Admin: Get risk reports for all students
    @Override
    public List<AcademicRisk> getAllStudentRisks() {

        List<Student> students = studentDAO.getAllStudents();

        List<AcademicRisk> risks = new ArrayList<>();

        for (Student student : students) {

            risks.add(
                    calculateStudentRisk(student.getStudentId()));
        }

        return risks;
    }

    // 5. Teacher: Get risk reports for assigned classes only
    @Override
    public List<AcademicRisk> getTeacherStudentRisks(int teacherId) {

        if (teacherId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid teacher ID.");
        }

        List<TeacherAssignment> assignments =
                attendanceDAO.getAssignmentsByTeacher(teacherId);

        List<Student> allStudents =
                studentDAO.getAllStudents();

        // LinkedHashMap prevents duplicate students when
        // a teacher teaches multiple subjects to the same class.
        Map<Integer, Student> assignedStudents =
                new LinkedHashMap<>();

        for (TeacherAssignment assignment : assignments) {

            for (Student student : allStudents) {

                boolean sameDepartment =
                        assignment.getDepartment().equalsIgnoreCase(
                                student.getDepartment());

                boolean sameYear =
                        assignment.getYearOfStudy()
                                == student.getYearOfStudy();

                boolean sameSection =
                        assignment.getSection().equalsIgnoreCase(
                                student.getSection());

                if (sameDepartment && sameYear && sameSection) {

                    assignedStudents.put(
                            student.getStudentId(), student);
                }
            }
        }

        List<AcademicRisk> risks = new ArrayList<>();

        for (Student student : assignedStudents.values()) {

            risks.add(
                    calculateStudentRisk(student.getStudentId()));
        }

        return risks;
    }
}
