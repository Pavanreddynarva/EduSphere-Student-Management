
package com.studentmanagement;

import java.math.BigDecimal;

import com.studentmanagement.dao.StudentDAO;
import com.studentmanagement.dao.impl.StudentDAOImpl;
import com.studentmanagement.model.Student;

public class StudentDAOTest {

    public static void main(String[] args) {

        


StudentDAO studentDAO = new StudentDAOImpl();

Student student = new Student(
        "TEST999",
        "Test Student",
        "test999@example.com",
        "9999999999",
        "CSE",
        2,
        new BigDecimal("75.00")
);

studentDAO.addStudent(student);

int id = student.getStudentId();
System.out.println("Test student added with ID: " + id);

boolean deleted = studentDAO.deleteStudent(id);

if (deleted) {
    System.out.println("Student deleted successfully!");
} else {
    System.out.println("Student was not deleted.");
}

    }
}

