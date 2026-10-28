
package com.studentmanagement.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import com.studentmanagement.model.Student;
import com.studentmanagement.service.StudentService;
import com.studentmanagement.service.impl.StudentServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/students")
public class StudentServlet extends HttpServlet {

    private StudentService studentService;

    @Override
    public void init() {
        studentService = new StudentServiceImpl();
    }

    // READ: display students or load one student for editing.
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            try {
                String idValue = request.getParameter("id");

                if (idValue == null || idValue.isBlank()) {
                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "Student ID is required."
                    );
                    return;
                }

                int id = Integer.parseInt(idValue);
                Optional<Student> result =
                        studentService.getStudentById(id);

                if (result.isEmpty()) {
                    response.sendError(
                            HttpServletResponse.SC_NOT_FOUND,
                            "Student not found."
                    );
                    return;
                }

                request.setAttribute("editStudent", result.get());

           } catch (IllegalArgumentException e) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid student ID."
                );
                return;
            }
        }

        List<Student> students = studentService.getAllStudents();
        request.setAttribute("students", students);

        String success = request.getParameter("success");

        if ("added".equals(success)) {
            request.setAttribute(
                    "successMessage", "Student added successfully!"
            );
        } else if ("updated".equals(success)) {
            request.setAttribute(
                    "successMessage", "Student updated successfully!"
            );
        } else if ("deleted".equals(success)) {
            request.setAttribute(
                    "successMessage", "Student deleted successfully!"
            );
        }

        request.getRequestDispatcher("/students.jsp")
                .forward(request, response);
    }

    // CREATE, UPDATE and DELETE.
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        try {
            // DELETE
            if ("delete".equals(action)) {
                int id = Integer.parseInt(
                        required(request, "studentId")
                );

                boolean deleted = studentService.deleteStudent(id);

                if (!deleted) {
                    throw new IllegalArgumentException(
                            "Student not found or already deleted."
                    );
                }

                redirect(response, request, "deleted");
                return;
            }

            // CREATE or UPDATE
            String rollNumber = required(request, "rollNumber");
            String fullName = required(request, "fullName");
            String email = required(request, "email");
            String department = required(request, "department");
            String yearValue = required(request, "yearOfStudy");

            String phone = value(request, "phone");
            String marksValue = value(request, "marks");

            if (!email.matches(
                    "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
                throw new IllegalArgumentException(
                        "Please enter a valid email address."
                );
            }

            if (!phone.isEmpty() &&
                    !phone.matches("^[6-9][0-9]{9}$")) {
                throw new IllegalArgumentException(
                        "Enter a valid 10-digit Indian mobile number."
                );
            }

            int year = Integer.parseInt(yearValue);

            if (year < 1 || year > 4) {
                throw new IllegalArgumentException(
                        "Year of study must be between 1 and 4."
                );
            }

            BigDecimal marks = null;

            if (!marksValue.isEmpty()) {
                marks = new BigDecimal(marksValue);

                if (marks.compareTo(BigDecimal.ZERO) < 0 ||
                        marks.compareTo(new BigDecimal("100")) > 0) {
                    throw new IllegalArgumentException(
                            "Marks must be between 0 and 100."
                    );
                }
            }

            Student student = new Student(
                    rollNumber,
                    fullName,
                    email,
                    phone.isEmpty() ? null : phone,
                    department,
                    year,
                    marks
            );

            if ("update".equals(action)) {
                int id = Integer.parseInt(
                        required(request, "studentId")
                );

                student.setStudentId(id);

                boolean updated = studentService.updateStudent(student);

                if (!updated) {
                    throw new IllegalArgumentException(
                            "Student not found or no update was made."
                    );
                }

                redirect(response, request, "updated");

            } else {
                // Missing or "add" action means CREATE.
                if (action != null &&
                        !action.isBlank() &&
                        !"add".equals(action)) {
                    throw new IllegalArgumentException(
                            "Unknown student operation."
                    );
                }

                studentService.addStudent(student);
                redirect(response, request, "added");
            }

        } catch (NumberFormatException e) {
            showError(
                    request, response,
                    "Year, marks, and student ID must contain valid numbers."
            );

        } catch (IllegalArgumentException e) {
            showError(request, response, e.getMessage());

        } catch (Exception e) {
            log("Student operation failed", e);

            showError(
                    request, response,
                    "The operation failed. Check that roll number and email "
                            + "are unique, then try again."
            );
        }
    }

    private String required(HttpServletRequest request, String name) {
        String result = request.getParameter(name);

        if (result == null || result.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Please fill in all required fields."
            );
        }

        return result.trim();
    }

    private String value(HttpServletRequest request, String name) {
        String result = request.getParameter(name);
        return result == null ? "" : result.trim();
    }

    private void redirect(HttpServletResponse response,
                          HttpServletRequest request,
                          String result)
            throws IOException {
        response.sendRedirect(
                request.getContextPath() + "/students?success=" + result
        );
    }

    private void showError(HttpServletRequest request,
                           HttpServletResponse response,
                           String message)
            throws ServletException, IOException {

        request.setAttribute("formError", message);
        request.setAttribute("showAddForm", true);
        request.setAttribute(
                "students", studentService.getAllStudents()
        );

        request.getRequestDispatcher("/students.jsp")
                .forward(request, response);
    }
}
