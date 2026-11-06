
package com.studentmanagement.service.impl;

import java.util.List;

import com.studentmanagement.dao.AttendanceDAO;
import com.studentmanagement.dao.StudentDAO;
import com.studentmanagement.dao.TeacherInterventionDAO;
import com.studentmanagement.dao.impl.AttendanceDAOImpl;
import com.studentmanagement.dao.impl.StudentDAOImpl;
import com.studentmanagement.dao.impl.TeacherInterventionDAOImpl;
import com.studentmanagement.model.Student;
import com.studentmanagement.model.TeacherAssignment;
import com.studentmanagement.model.TeacherIntervention;
import com.studentmanagement.service.TeacherInterventionService;

public class TeacherInterventionServiceImpl
        implements TeacherInterventionService {

    private final TeacherInterventionDAO interventionDAO;
    private final StudentDAO studentDAO;
    private final AttendanceDAO attendanceDAO;

    public TeacherInterventionServiceImpl() {
        this.interventionDAO =
                new TeacherInterventionDAOImpl();

        this.studentDAO = new StudentDAOImpl();

        this.attendanceDAO = new AttendanceDAOImpl();
    }

    // 1. Record an intervention
    @Override
    public boolean recordIntervention(
            int teacherId,
            TeacherIntervention intervention) {

        if (teacherId <= 0 || intervention == null) {
            throw new IllegalArgumentException(
                    "Invalid teacher or intervention.");
        }

        if (intervention.getStudentId() <= 0) {
            throw new IllegalArgumentException(
                    "Invalid student ID.");
        }

        if (intervention.getInterventionType() == null
                || intervention.getInterventionType().isBlank()) {
            throw new IllegalArgumentException(
                    "Intervention type is required.");
        }

        if (intervention.getActionTaken() == null
                || intervention.getActionTaken().isBlank()) {
            throw new IllegalArgumentException(
                    "Action taken is required.");
        }

        String status = intervention.getFollowUpStatus();

        if (status == null || status.isBlank()) {
            status = "PENDING";
        }

        validateFollowUpStatus(status);

        Student student = studentDAO
                .getStudentById(intervention.getStudentId())
                .orElseThrow(() ->
                        new IllegalArgumentException(
                                "Student not found."));

        // Verify teacher's class assignment
        if (!isTeacherAssignedToStudent(teacherId, student)) {
            throw new SecurityException(
                    "You are not authorized to record an intervention "
                    + "for this student.");
        }

        intervention.setTeacherId(teacherId);

        intervention.setInterventionType(
                intervention.getInterventionType().trim());

        intervention.setActionTaken(
                intervention.getActionTaken().trim());

        intervention.setFollowUpStatus(status.toUpperCase());

        if (intervention.getNotes() != null) {
            intervention.setNotes(
                    intervention.getNotes().trim());
        }

        return interventionDAO.saveIntervention(intervention);
    }

    // 2. Retrieve all interventions for a student
    @Override
    public List<TeacherIntervention> getStudentInterventions(
            int studentId) {

        if (studentId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid student ID.");
        }

        return interventionDAO.getInterventionsByStudent(studentId);
    }

    // 3. Retrieve interventions recorded by a teacher
    @Override
    public List<TeacherIntervention> getTeacherInterventions(
            int teacherId) {

        if (teacherId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid teacher ID.");
        }

        return interventionDAO.getInterventionsByTeacher(teacherId);
    }

    // 4. Retrieve a teacher's own interventions for a student
    @Override
    public List<TeacherIntervention> getStudentInterventionsForTeacher(
            int studentId,
            int teacherId) {

        if (studentId <= 0 || teacherId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid student or teacher ID.");
        }

        Student student = studentDAO
                .getStudentById(studentId)
                .orElseThrow(() ->
                        new IllegalArgumentException(
                                "Student not found."));

        if (!isTeacherAssignedToStudent(teacherId, student)) {
            throw new SecurityException(
                    "You are not authorized to view interventions "
                    + "for this student.");
        }

        return interventionDAO
                .getInterventionsByStudentAndTeacher(
                        studentId, teacherId);
    }

    // 5. Update an intervention's follow-up
    @Override
    public boolean updateFollowUp(
            int interventionId,
            int teacherId,
            String status,
            String notes) {

        if (interventionId <= 0 || teacherId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid intervention or teacher ID.");
        }

        validateFollowUpStatus(status);

        return interventionDAO.updateFollowUpStatus(
                interventionId,
                teacherId,
                status.toUpperCase(),
                notes == null ? null : notes.trim());
    }

    // 6. Verify teacher's class assignment
    private boolean isTeacherAssignedToStudent(
            int teacherId,
            Student student) {

        List<TeacherAssignment> assignments =
                attendanceDAO.getAssignmentsByTeacher(teacherId);

        for (TeacherAssignment assignment : assignments) {

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
                return true;
            }
        }

        return false;
    }

    // 7. Validate follow-up status
    private void validateFollowUpStatus(String status) {

        if (status == null
                || (!"PENDING".equalsIgnoreCase(status)
                && !"COMPLETED".equalsIgnoreCase(status)
                && !"OVERDUE".equalsIgnoreCase(status))) {

            throw new IllegalArgumentException(
                    "Follow-up status must be PENDING, "
                    + "COMPLETED, or OVERDUE.");
        }
    }
}
