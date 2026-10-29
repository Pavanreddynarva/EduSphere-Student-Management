
package com.studentmanagement.service.impl;

import java.math.BigDecimal;
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

        validateStudent(student);

        String rollNumber = student.getRollNumber().trim();
        student.setRollNumber(rollNumber);

        if (studentDAO.existsByRollNumber(rollNumber)) {
            throw new IllegalArgumentException(
                "A student with this roll number already exists");
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

        validateStudent(student);

        if (student.getStudentId() <= 0) {
            throw new IllegalArgumentException(
                "Valid student ID is required");
        }

        String rollNumber = student.getRollNumber().trim();
        student.setRollNumber(rollNumber);

        if (studentDAO.existsByRollNumberExcludingStudent(
                rollNumber, student.getStudentId())) {
            throw new IllegalArgumentException(
                "Another student already uses this roll number");
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

    private void validateStudent(Student student) {

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

        BigDecimal marks = student.getMarks();

        if (marks != null
                && (marks.signum() < 0
                || marks.compareTo(new BigDecimal("100")) > 0)) {
            throw new IllegalArgumentException(
                "Marks must be between 0 and 100");
        }
    }
}
