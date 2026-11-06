
package com.studentmanagement.service.impl;

import java.math.BigDecimal;
import java.util.List;

import com.studentmanagement.dao.AttendanceDAO;
import com.studentmanagement.dao.StudentAssessmentDAO;
import com.studentmanagement.dao.StudentDAO;
import com.studentmanagement.dao.impl.AttendanceDAOImpl;
import com.studentmanagement.dao.impl.StudentAssessmentDAOImpl;
import com.studentmanagement.dao.impl.StudentDAOImpl;
import com.studentmanagement.model.Student;
import com.studentmanagement.model.StudentAssessment;
import com.studentmanagement.model.TeacherAssignment;
import com.studentmanagement.service.StudentAssessmentService;

public class StudentAssessmentServiceImpl
        implements StudentAssessmentService {

    private final AttendanceDAO attendanceDAO;
    private final StudentDAO studentDAO;
    private final StudentAssessmentDAO assessmentDAO;

    public StudentAssessmentServiceImpl() {
        this.attendanceDAO = new AttendanceDAOImpl();
        this.studentDAO = new StudentDAOImpl();
        this.assessmentDAO = new StudentAssessmentDAOImpl();
    }

    @Override
    public boolean recordAssessment(
            int teacherId,
            StudentAssessment assessment) {

        if (teacherId <= 0 || assessment == null) {
            throw new IllegalArgumentException(
                    "Invalid teacher or assessment."
            );
        }

        if (assessment.getStudentId() <= 0
                || assessment.getAssignmentId() <= 0) {
            throw new IllegalArgumentException(
                    "Invalid student or assignment."
            );
        }

        if (assessment.getAssessmentName() == null
                || assessment.getAssessmentName().trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Assessment name is required."
            );
        }

        if (assessment.getAssessmentDate() == null) {
            throw new IllegalArgumentException(
                    "Assessment date is required."
            );
        }

        BigDecimal obtained = assessment.getMarksObtained();
        BigDecimal maximum = assessment.getMaxMarks();

        if (obtained == null || maximum == null
                || maximum.compareTo(BigDecimal.ZERO) <= 0
                || obtained.compareTo(BigDecimal.ZERO) < 0
                || obtained.compareTo(maximum) > 0) {

            throw new IllegalArgumentException(
                    "Marks must be between zero and maximum marks."
            );
        }

        // Verify that the assignment exists and belongs to this teacher.
        TeacherAssignment assignment =
                attendanceDAO.getAssignmentById(
                        assessment.getAssignmentId()
                ).orElseThrow(() ->
                        new IllegalArgumentException(
                                "Assignment not found."
                        )
                );

        if (assignment.getTeacherId() != teacherId) {
            throw new IllegalArgumentException(
                    "You are not authorized for this assignment."
            );
        }

        // Verify that the student exists.
        Student student = studentDAO.getStudentById(
                assessment.getStudentId()
        ).orElseThrow(() ->
                new IllegalArgumentException(
                        "Student not found."
                )
        );

        // Verify that the student belongs to the assigned class.
        boolean sameClass =
                student.getDepartment().equalsIgnoreCase(
                        assignment.getDepartment()
                )
                && student.getYearOfStudy()
                        == assignment.getYearOfStudy()
                && student.getSection().equalsIgnoreCase(
                        assignment.getSection()
                );

        if (!sameClass) {
            throw new IllegalArgumentException(
                    "Student does not belong to this assigned class."
            );
        }

        assessment.setAssessmentName(
                assessment.getAssessmentName().trim()
        );

        return assessmentDAO.saveAssessment(assessment);
    }

    @Override
    public List<StudentAssessment> getStudentAssessmentHistory(
            int studentId) {

        if (studentId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid student ID."
            );
        }

        return assessmentDAO.getAssessmentsByStudent(studentId);
    }

    @Override
    public List<StudentAssessment> getAssignmentAssessments(
            int teacherId,
            int assignmentId) {

        if (teacherId <= 0 || assignmentId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid teacher or assignment."
            );
        }

        TeacherAssignment assignment =
                attendanceDAO.getAssignmentById(
                        assignmentId
                ).orElseThrow(() ->
                        new IllegalArgumentException(
                                "Assignment not found."
                        )
                );

        if (assignment.getTeacherId() != teacherId) {
            throw new IllegalArgumentException(
                    "You are not authorized for this assignment."
            );
        }

        return assessmentDAO.getAssessmentsByAssignment(
                assignmentId
        );
    }
}
