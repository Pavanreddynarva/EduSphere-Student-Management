package com.studentmanagement.dao;

import java.util.List;
import com.studentmanagement.model.Student;
import com.studentmanagement.model.SubjectImprovement;

public interface ImprovementPlanDAO {
    List<SubjectImprovement> getSubjectAttendance(Student student);
}
