
package com.studentmanagement.service.impl;

import java.util.List;
import java.util.Optional;

import com.studentmanagement.dao.StudentDAO;
import com.studentmanagement.dao.impl.StudentDAOImpl;
import com.studentmanagement.model.Student;
import com.studentmanagement.service.StudentService;

public class StudentServiceImpl implements StudentService {

    private final StudentDAO studentDAO;

    public StudentServiceImpl() {
        this.studentDAO = new StudentDAOImpl();
    }

    
@Override
public void addStudent(Student student) {

    if (student == null) {
        throw new IllegalArgumentException(
                "Student cannot be null");
    }

    if (student.getRollNumber() == null
            || student.getRollNumber().isBlank()) {
        throw new IllegalArgumentException(
                "Roll number is required");
    }

    if (student.getFullName() == null
            || student.getFullName().isBlank()) {
        throw new IllegalArgumentException(
                "Student name is required");
    }

    if (student.getEmail() == null
            || student.getEmail().isBlank()) {
        throw new IllegalArgumentException(
                "Email is required");
    }

    if (student.getDepartment() == null
            || student.getDepartment().isBlank()) {
        throw new IllegalArgumentException(
                "Department is required");
    }

    if (student.getYearOfStudy() < 1
            || student.getYearOfStudy() > 4) {
        throw new IllegalArgumentException(
                "Year of study must be between 1 and 4");
    }

    if (student.getMarks() != null
            && (student.getMarks().signum() < 0
            || student.getMarks().compareTo(
                    new java.math.BigDecimal("100")) > 0)) {
        throw new IllegalArgumentException(
                "Marks must be between 0 and 100");
    }

    studentDAO.addStudent(student);
}


    
@Override
public Optional<Student> getStudentById(int studentId) {

    if (studentId <= 0) {
        throw new IllegalArgumentException(
                "Student ID must be greater than zero");
    }

    return studentDAO.getStudentById(studentId);
}

    @Override
    public List<Student> getAllStudents() {
        return studentDAO.getAllStudents();
    }

   
@Override
public boolean updateStudent(Student student) {

    if (student == null) {
        throw new IllegalArgumentException(
                "Student cannot be null");
    }

    if (student.getStudentId() <= 0) {
        throw new IllegalArgumentException(
                "Valid student ID is required");
    }

    if (student.getRollNumber() == null
            || student.getRollNumber().isBlank()) {
        throw new IllegalArgumentException(
                "Roll number is required");
    }

    if (student.getFullName() == null
            || student.getFullName().isBlank()) {
        throw new IllegalArgumentException(
                "Student name is required");
    }

    if (student.getEmail() == null
            || student.getEmail().isBlank()) {
        throw new IllegalArgumentException(
                "Email is required");
    }

    if (student.getDepartment() == null
            || student.getDepartment().isBlank()) {
        throw new IllegalArgumentException(
                "Department is required");
    }

    if (student.getYearOfStudy() < 1
            || student.getYearOfStudy() > 4) {
        throw new IllegalArgumentException(
                "Year of study must be between 1 and 4");
    }

    if (student.getMarks() != null
            && (student.getMarks().signum() < 0
            || student.getMarks().compareTo(
                    new java.math.BigDecimal("100")) > 0)) {
        throw new IllegalArgumentException(
                "Marks must be between 0 and 100");
    }

    return studentDAO.updateStudent(student);
}


    
@Override
public boolean deleteStudent(int studentId) {

    if (studentId <= 0) {
        throw new IllegalArgumentException(
                "Student ID must be greater than zero");
    }

    return studentDAO.deleteStudent(studentId);
}

}
