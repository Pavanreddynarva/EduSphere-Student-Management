
package com.studentmanagement.service;

import java.util.List;

import com.studentmanagement.model.StudentAssessment;

public interface StudentAssessmentService {

    boolean recordAssessment(
            int teacherId,
            StudentAssessment assessment
    );

    List<StudentAssessment> getStudentAssessmentHistory(
            int studentId
    );

    List<StudentAssessment> getAssignmentAssessments(
            int teacherId,
            int assignmentId
    );
}
