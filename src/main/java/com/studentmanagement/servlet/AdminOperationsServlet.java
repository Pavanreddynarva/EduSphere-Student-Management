package com.studentmanagement.servlet;

import com.studentmanagement.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.time.LocalDate;
import java.util.*;

/** Admin-only dashboard, reports and operations. URL authorization is enforced by AuthorizationFilter. */
@WebServlet({"/admin/dashboard", "/admin/reports", "/admin/operations"})
public class AdminOperationsServlet extends HttpServlet {
    private static final Set<String> REPORTS = Set.of("students", "teachers", "assessments", "attendance", "fees", "timetable", "monthly");
    private static final String STUDENTS = "SELECT s.student_id,s.roll_number,s.full_name,s.department,s.year_of_study,s.section,"+
        "(SELECT ROUND(100*SUM(a.marks_obtained)/NULLIF(SUM(a.max_marks),0),1) FROM student_assessments a WHERE a.student_id=s.student_id AND a.assessment_date<=CURRENT_DATE()) average_marks,"+
        "(SELECT ROUND(100*SUM(CASE WHEN ar.status='PRESENT' THEN 1 ELSE 0 END)/NULLIF(COUNT(*),0),1) FROM attendance_sessions ses JOIN teacher_assignments ta ON ta.assignment_id=ses.assignment_id LEFT JOIN attendance_records ar ON ar.session_id=ses.session_id AND ar.student_id=s.student_id WHERE ta.department=s.department AND ta.year_of_study=s.year_of_study AND ta.section=s.section AND ses.session_date<=CURRENT_DATE()) attendance_rate " +
        "FROM students s";
    private static final String TEACHERS = "SELECT u.user_id,u.full_name,u.email,COUNT(t.assignment_id) class_count,GROUP_CONCAT(CONCAT(t.subject_name,' (',t.department,' ',t.year_of_study,'-',t.section,')') SEPARATOR ', ') subjects FROM users u LEFT JOIN teacher_assignments t ON t.teacher_id=u.user_id WHERE u.role='TEACHER' GROUP BY u.user_id,u.full_name,u.email ORDER BY u.full_name";
    private static final String ASSIGNMENTS = "SELECT t.assignment_id,t.teacher_id,u.full_name teacher_name,t.department,t.year_of_study,t.section,t.subject_name FROM teacher_assignments t LEFT JOIN users u ON u.user_id=t.teacher_id ORDER BY t.department,t.year_of_study,t.section,t.subject_name";
    private static final String ASSESSMENTS = "SELECT s.student_id,s.roll_number,s.full_name,t.subject_name,a.assessment_name,a.assessment_date,a.marks_obtained,a.max_marks,ROUND(100*a.marks_obtained/NULLIF(a.max_marks,0),1) percentage FROM student_assessments a JOIN students s ON s.student_id=a.student_id JOIN teacher_assignments t ON t.assignment_id=a.assignment_id WHERE a.assessment_date<=CURRENT_DATE() ORDER BY a.assessment_date DESC";
    private static final String ATTENDANCE = "SELECT s.student_id,s.roll_number,s.full_name,t.subject_name,ses.session_date,COALESCE(ar.status,'ABSENT') attendance_status FROM attendance_sessions ses JOIN teacher_assignments t ON t.assignment_id=ses.assignment_id JOIN students s ON s.department=t.department AND s.year_of_study=t.year_of_study AND s.section=t.section LEFT JOIN attendance_records ar ON ar.session_id=ses.session_id AND ar.student_id=s.student_id WHERE ses.session_date<=CURRENT_DATE() ORDER BY ses.session_date DESC,s.full_name";
    private static final String FEES = "SELECT s.student_id,s.roll_number,s.full_name,f.academic_year,f.total_amount,f.paid_amount,(f.total_amount-f.paid_amount) pending_amount,f.updated_at FROM student_fee_accounts f JOIN students s ON s.student_id=f.student_id ORDER BY s.full_name,f.academic_year DESC";
    private static final String TIMETABLE = "SELECT tt.timetable_id,tt.day_of_week,tt.start_time,tt.end_time,tt.room_number,t.subject_name,t.department,t.year_of_study,t.section,u.full_name teacher_name FROM class_timetable tt JOIN teacher_assignments t ON t.assignment_id=tt.assignment_id LEFT JOIN users u ON u.user_id=t.teacher_id ORDER BY FIELD(tt.day_of_week,'MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY','SUNDAY'),tt.start_time";
    private static final String MONTHLY = "SELECT DATE_FORMAT(a.assessment_date,'%Y-%m') month,ROUND(100*SUM(a.marks_obtained)/NULLIF(SUM(a.max_marks),0),1) average_marks,COUNT(*) assessments FROM student_assessments a WHERE a.assessment_date<=CURRENT_DATE() GROUP BY DATE_FORMAT(a.assessment_date,'%Y-%m') ORDER BY month";
    private static final String SUBJECTS = "SELECT t.subject_name,ROUND(100*SUM(a.marks_obtained)/NULLIF(SUM(a.max_marks),0),1) average_marks,COUNT(*) assessments FROM student_assessments a JOIN teacher_assignments t ON t.assignment_id=a.assignment_id WHERE a.assessment_date<=CURRENT_DATE() GROUP BY t.subject_name ORDER BY average_marks DESC";

    @Override protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        if(!admin(req,resp)) return;
        String report=Optional.ofNullable(req.getParameter("report")).orElse("students");
        if(!REPORTS.contains(report)) report="students";
        try(Connection c=DBConnection.getConnection()) {
            if("csv".equals(req.getParameter("format"))) {
                List<Map<String,Object>> rows=query(c,sql(report),req);
                resp.setContentType("text/csv;charset=UTF-8");
                resp.setHeader("Content-Disposition","attachment; filename=edusphere-"+report+".csv");
                PrintWriter w=resp.getWriter();w.write('\ufeff');
                if(!rows.isEmpty()) { List<String> keys=new ArrayList<>(rows.get(0).keySet());w.println(String.join(",",keys));for(Map<String,Object> row:rows){List<String> cells=new ArrayList<>();for(String k:keys) cells.add(csv(row.get(k)));w.println(String.join(",",cells));} }
                return;
            }
            req.setAttribute("students",query(c,STUDENTS+" ORDER BY s.full_name",req));
            req.setAttribute("teachers",query(c,TEACHERS,req));
            req.setAttribute("assignments",query(c,ASSIGNMENTS,req));
            req.setAttribute("assessments",query(c,ASSESSMENTS,req));
            req.setAttribute("attendance",query(c,ATTENDANCE,req));
            req.setAttribute("subjects",query(c,SUBJECTS,req));
            req.setAttribute("monthly",query(c,MONTHLY,req));
            req.setAttribute("fees",query(c,FEES,req));
            req.setAttribute("timetable",query(c,TIMETABLE,req));
            req.setAttribute("report",report);
            req.setAttribute("totalStudents",scalar(c,"SELECT COUNT(*) FROM students"));
            req.setAttribute("totalTeachers",scalar(c,"SELECT COUNT(*) FROM users WHERE role='TEACHER'"));
            req.setAttribute("averageMarks",scalar(c,"SELECT ROUND(100*SUM(marks_obtained)/NULLIF(SUM(max_marks),0),1) FROM student_assessments WHERE assessment_date<=CURRENT_DATE()"));
            req.setAttribute("attendanceRate",scalar(c,"SELECT ROUND(100*SUM(CASE WHEN ar.status='PRESENT' THEN 1 ELSE 0 END)/NULLIF(COUNT(*),0),1) FROM attendance_sessions ses JOIN teacher_assignments t ON t.assignment_id=ses.assignment_id JOIN students s ON s.department=t.department AND s.year_of_study=t.year_of_study AND s.section=t.section LEFT JOIN attendance_records ar ON ar.session_id=ses.session_id AND ar.student_id=s.student_id WHERE ses.session_date<=CURRENT_DATE()"));
            req.setAttribute("highRiskCount",scalar(c,"SELECT COUNT(*) FROM ("+STUDENTS+") x WHERE x.average_marks<60 OR x.attendance_rate<75"));
            req.getRequestDispatcher("/WEB-INF/views/admin/operations.jsp").forward(req,resp);
        } catch(SQLException e){throw new ServletException("Unable to load admin dashboard. Run the Day 10/11 SQL migration first.",e);}
    }
    private String sql(String report){return switch(report){case "teachers"->TEACHERS;case "assessments"->ASSESSMENTS;case "attendance"->ATTENDANCE;case "fees"->FEES;case "timetable"->TIMETABLE;case "monthly"->MONTHLY;default->STUDENTS+" ORDER BY s.full_name";};}
    private List<Map<String,Object>> query(Connection c,String sql,HttpServletRequest req)throws SQLException {
        String filter=req.getParameter("q"),dept=req.getParameter("department"),year=req.getParameter("year"),section=req.getParameter("section"),student=req.getParameter("studentId");
        // Filter results in Java to keep all report queries parameter-free and avoid concatenating user SQL.
        List<Map<String,Object>> rows=new ArrayList<>();
        try(PreparedStatement p=c.prepareStatement(sql);ResultSet r=p.executeQuery()){
            ResultSetMetaData m=r.getMetaData();while(r.next()){
                Map<String,Object> row=new LinkedHashMap<>();for(int i=1;i<=m.getColumnCount();i++)row.put(m.getColumnLabel(i),r.getObject(i));
                if(student!=null&&!student.isBlank()&&row.containsKey("student_id")&&!student.equals(String.valueOf(row.get("student_id"))))continue;
                if(dept!=null&&!dept.isBlank()&&row.containsKey("department")&&!dept.equalsIgnoreCase(String.valueOf(row.get("department"))))continue;
                if(year!=null&&!year.isBlank()&&row.containsKey("year_of_study")&&!year.equals(String.valueOf(row.get("year_of_study"))))continue;
                if(section!=null&&!section.isBlank()&&row.containsKey("section")&&!section.equalsIgnoreCase(String.valueOf(row.get("section"))))continue;
                if(filter!=null&&!filter.isBlank()&&row.values().stream().noneMatch(v->v!=null&&String.valueOf(v).toLowerCase(Locale.ROOT).contains(filter.toLowerCase(Locale.ROOT))))continue;
                rows.add(row);
            }
        }return rows;
    }
    private Object scalar(Connection c,String sql)throws SQLException{try(Statement s=c.createStatement();ResultSet r=s.executeQuery(sql)){return r.next()?r.getObject(1):null;}}
    private String csv(Object value){String s=value==null?"":String.valueOf(value);if(s.startsWith("=")||s.startsWith("+")||s.startsWith("-")||s.startsWith("@")||s.startsWith("\t")||s.startsWith("\r"))s="'"+s;return "\""+s.replace("\"","\"\"")+"\"";}
    private boolean admin(HttpServletRequest req,HttpServletResponse resp)throws IOException {HttpSession s=req.getSession(false);if(s==null||!"ADMIN".equalsIgnoreCase(String.valueOf(s.getAttribute("role")))){resp.sendError(403);return false;}return true;}
    private String required(HttpServletRequest req,String key){String x=req.getParameter(key);if(x==null||x.isBlank())throw new IllegalArgumentException("Missing "+key);return x.trim();}
    private int positive(HttpServletRequest req,String key){int n=Integer.parseInt(required(req,key));if(n<=0)throw new IllegalArgumentException("Invalid "+key);return n;}
    @Override protected void doPost(HttpServletRequest req,HttpServletResponse resp)throws IOException {
        if(!admin(req,resp))return;req.setCharacterEncoding("UTF-8");
        try(Connection c=DBConnection.getConnection()){
            String action=required(req,"action");
            switch(action){
                case "assign" -> {
                    int teacher=positive(req,"teacherId"),year=positive(req,"year");if(year>8)throw new IllegalArgumentException("Invalid year");
                    try(PreparedStatement check=c.prepareStatement("SELECT COUNT(*) FROM users WHERE user_id=? AND role='TEACHER'")){check.setInt(1,teacher);try(ResultSet rs=check.executeQuery()){rs.next();if(rs.getInt(1)==0)throw new IllegalArgumentException("Teacher not found");}}
                    try(PreparedStatement p=c.prepareStatement("INSERT INTO teacher_assignments(teacher_id,department,year_of_study,section,subject_name) VALUES(?,?,?,?,?)")){p.setInt(1,teacher);p.setString(2,required(req,"department"));p.setInt(3,year);p.setString(4,required(req,"section"));p.setString(5,required(req,"subject"));p.executeUpdate();}
                }
                case "timetable" -> {
                    int assignment=positive(req,"assignmentId");String day=required(req,"day");if(!Set.of("MONDAY","TUESDAY","WEDNESDAY","THURSDAY","FRIDAY","SATURDAY","SUNDAY").contains(day))throw new IllegalArgumentException("Invalid day");
                    java.sql.Time start=java.sql.Time.valueOf(required(req,"start")+":00"),end=java.sql.Time.valueOf(required(req,"end")+":00");if(!start.before(end))throw new IllegalArgumentException("End must follow start");
                    String room=required(req,"room");
                    try(PreparedStatement p=c.prepareStatement("INSERT INTO class_timetable(assignment_id,day_of_week,start_time,end_time,room_number) VALUES(?,?,?,?,?)")){p.setInt(1,assignment);p.setString(2,day);p.setTime(3,start);p.setTime(4,end);p.setString(5,room);p.executeUpdate();}
                }
                case "fee" -> {
                    int student=positive(req,"studentId");String year=required(req,"academicYear");if(!year.matches("\\d{4}-\\d{4}"))throw new IllegalArgumentException("Use YYYY-YYYY academic year");
                    BigDecimal total=new BigDecimal(required(req,"total")),paid=new BigDecimal(required(req,"paid"));if(total.signum()<0||paid.signum()<0||paid.compareTo(total)>0)throw new IllegalArgumentException("Paid must be between zero and total");
                    try(PreparedStatement p=c.prepareStatement("INSERT INTO student_fee_accounts(student_id,academic_year,total_amount,paid_amount) VALUES(?,?,?,?) ON DUPLICATE KEY UPDATE total_amount=VALUES(total_amount),paid_amount=VALUES(paid_amount)")){p.setInt(1,student);p.setString(2,year);p.setBigDecimal(3,total);p.setBigDecimal(4,paid);p.executeUpdate();}
                }
                default -> throw new IllegalArgumentException("Unknown operation");
            }
            resp.sendRedirect(req.getContextPath()+"/admin/dashboard?message=saved");
        }catch(SQLException|IllegalArgumentException e){resp.sendError(400,"Operation not saved: "+e.getMessage());}
    }
}
