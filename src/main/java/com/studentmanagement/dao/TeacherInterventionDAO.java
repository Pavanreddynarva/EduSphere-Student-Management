
package com.studentmanagement.dao;

import java.util.List;

import com.studentmanagement.model.TeacherIntervention;

public interface TeacherInterventionDAO {

    boolean saveIntervention(TeacherIntervention intervention);

    List<TeacherIntervention> getInterventionsByStudent(
            int studentId);

    List<TeacherIntervention> getInterventionsByTeacher(
            int teacherId);

    // Retrieve only this teacher's interventions for a student
    List<TeacherIntervention> getInterventionsByStudentAndTeacher(
            int studentId,
            int teacherId);

    boolean updateFollowUpStatus(
            int interventionId,
            int teacherId,
            String status,
            String notes);
}
