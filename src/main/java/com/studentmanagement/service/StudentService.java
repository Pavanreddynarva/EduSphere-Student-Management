
package com.studentmanagement.service;

import java.util.List;
import java.util.Optional;

import com.studentmanagement.model.Student;

public interface StudentService {

    void addStudent(Student student);

    Optional<Student> getStudentById(int studentId);

    List<Student> getAllStudents();

    boolean updateStudent(Student student);

    boolean deleteStudent(int studentId);
}
