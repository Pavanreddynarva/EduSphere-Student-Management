
package com.studentmanagement;

import com.studentmanagement.service.StudentService;
import com.studentmanagement.service.impl.StudentServiceImpl;

public class StudentServiceTest {

    public static void main(String[] args) {

        StudentService studentService = new StudentServiceImpl();

        try {
            studentService.getStudentById(0);
            System.out.println("Test failed: Invalid ID was accepted.");
        } catch (IllegalArgumentException e) {
            System.out.println("Test passed: Invalid ID rejected.");
        }
    }
}
