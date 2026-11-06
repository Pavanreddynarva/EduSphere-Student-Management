
package com.studentmanagement.service;

import java.util.List;

import com.studentmanagement.model.TeacherIntervention;

public interface TeacherInterventionService {

    boolean recordIntervention(
            int teacherId,
            TeacherIntervention intervention
    );

    // Retrieve all interventions for a student (Admin use)
    List<TeacherIntervention> getStudentInterventions(
            int studentId
    );

    // Retrieve interventions recorded by a teacher
    List<TeacherIntervention> getTeacherInterventions(
            int teacherId
    );

    // Retrieve only a specific teacher's notes for a student
    List<TeacherIntervention> getStudentInterventionsForTeacher(
            int studentId,
            int teacherId
    );

    boolean updateFollowUp(
            int interventionId,
            int teacherId,
            String status,
            String notes
    );
}
