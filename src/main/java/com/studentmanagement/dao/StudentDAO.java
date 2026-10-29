
package com.studentmanagement.dao;

import java.util.List;
import java.util.Optional;

import com.studentmanagement.model.Student;

public interface StudentDAO {

    void addStudent(Student student);

    Optional<Student> getStudentById(int studentId);

    List<Student> getAllStudents();

    boolean updateStudent(Student student);

    boolean deleteStudent(int studentId);

    boolean existsByRollNumber(String rollNumber);

    boolean existsByRollNumberExcludingStudent(
            String rollNumber, int studentId);
}
