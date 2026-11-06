
package com.studentmanagement.dao;

import java.util.List;

import com.studentmanagement.model.StudentAssessment;

public interface StudentAssessmentDAO {

    boolean saveAssessment(StudentAssessment assessment);

    List<StudentAssessment> getAssessmentsByStudent(int studentId);

    List<StudentAssessment> getAssessmentsByAssignment(int assignmentId);
}
