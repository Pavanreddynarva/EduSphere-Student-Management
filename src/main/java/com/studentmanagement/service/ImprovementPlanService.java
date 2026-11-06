package com.studentmanagement.service;

import com.studentmanagement.dao.ImprovementPlanDAO;
import com.studentmanagement.dao.StudentAssessmentDAO;
import com.studentmanagement.dao.impl.ImprovementPlanDAOImpl;
import com.studentmanagement.dao.impl.StudentAssessmentDAOImpl;
import com.studentmanagement.model.Student;
import com.studentmanagement.model.StudentAssessment;
import com.studentmanagement.model.SubjectImprovement;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class ImprovementPlanService {
    private final ImprovementPlanDAO planDAO = new ImprovementPlanDAOImpl();
    private final StudentAssessmentDAO assessmentDAO = new StudentAssessmentDAOImpl();

    public List<SubjectImprovement> buildSubjectAnalysis(Student student) {
        List<SubjectImprovement> subjects = planDAO.getSubjectAttendance(student);
        Map<Integer, List<StudentAssessment>> byAssignment = assessmentDAO
            .getAssessmentsByStudent(student.getStudentId()).stream()
            .filter(a -> a.getAssessmentDate() != null && !a.getAssessmentDate().isAfter(LocalDate.now()))
            .collect(Collectors.groupingBy(StudentAssessment::getAssignmentId));

        for (SubjectImprovement subject : subjects) {
            List<StudentAssessment> rows = byAssignment.getOrDefault(subject.getAssignmentId(), new ArrayList<>());
            rows.sort(Comparator.comparing(StudentAssessment::getAssessmentDate));
            BigDecimal obtained = rows.stream().map(StudentAssessment::getMarksObtained)
                .filter(v -> v != null).reduce(BigDecimal.ZERO, BigDecimal::add);
            BigDecimal maximum = rows.stream().map(StudentAssessment::getMaxMarks)
                .filter(v -> v != null).reduce(BigDecimal.ZERO, BigDecimal::add);
            subject.setAssessmentCount(rows.size());
            subject.setMarksObtained(obtained);
            subject.setMaxMarks(maximum);
            if (maximum.compareTo(BigDecimal.ZERO) > 0) {
                subject.setAveragePercentage(obtained.multiply(BigDecimal.valueOf(100))
                    .divide(maximum, 2, RoundingMode.HALF_UP));
            }
            rows.forEach(a -> subject.getAssessmentNames().add(a.getAssessmentName()));
            subject.setTrend(calculateTrend(rows));
            subject.setPriority(calculatePriority(subject));
        }
        subjects.sort(Comparator.comparingInt(s -> priorityRank(s.getPriority())));
        return subjects;
    }

    private String calculateTrend(List<StudentAssessment> rows) {
        if (rows.size() < 4) return "INSUFFICIENT_DATA";
        int split = rows.size() / 2;
        BigDecimal earlier = average(rows.subList(0, split));
        BigDecimal recent = average(rows.subList(split, rows.size()));
        BigDecimal difference = recent.subtract(earlier);
        if (difference.compareTo(BigDecimal.valueOf(5)) >= 0) return "IMPROVING";
        if (difference.compareTo(BigDecimal.valueOf(-5)) <= 0) return "DECLINING";
        return "CONSISTENT";
    }

    private BigDecimal average(List<StudentAssessment> rows) {
        BigDecimal marks = BigDecimal.ZERO, max = BigDecimal.ZERO;
        for (StudentAssessment a : rows) {
            if (a.getMarksObtained() != null && a.getMaxMarks() != null) {
                marks = marks.add(a.getMarksObtained());
                max = max.add(a.getMaxMarks());
            }
        }
        return max.signum() == 0 ? BigDecimal.ZERO : marks.multiply(BigDecimal.valueOf(100)).divide(max, 2, RoundingMode.HALF_UP);
    }

    private String calculatePriority(SubjectImprovement s) {
        boolean lowMarks = s.getAveragePercentage() != null && s.getAveragePercentage().compareTo(BigDecimal.valueOf(60)) < 0;
        boolean lowAttendance = s.getAttendancePercentage() >= 0 && s.getAttendancePercentage() < 75;
        if (lowMarks || "DECLINING".equals(s.getTrend())) return "HIGH";
        if (lowAttendance || (s.getAveragePercentage() != null && s.getAveragePercentage().compareTo(BigDecimal.valueOf(75)) < 0)) return "MEDIUM";
        if (s.getAssessmentCount() == 0 && s.getTotalSessions() == 0) return "NEEDS_MORE_DATA";
        return "MAINTAIN";
    }

    private int priorityRank(String p) {
        return switch (p) { case "HIGH" -> 0; case "MEDIUM" -> 1; case "NEEDS_MORE_DATA" -> 2; default -> 3; };
    }

    public List<String> buildSevenDayPlan(List<SubjectImprovement> subjects) {
        List<SubjectImprovement> ranked = subjects.stream()
            .filter(s -> s.getAssessmentCount() > 0 || s.getTotalSessions() > 0)
            .sorted(Comparator.comparingInt(s -> priorityRank(s.getPriority())))
            .toList();
        List<String> plan = new ArrayList<>();
        String[] actions = {
            "Review class notes and identify 3 concepts that need more practice.",
            "Solve 8–10 practice questions and check every incorrect answer.",
            "Revise the most recent completed assessment and redo missed questions.",
            "Study one difficult concept, then explain it aloud without notes.",
            "Complete a short timed practice set and review mistakes.",
            "Revise key definitions, examples, and previously difficult problems.",
            "Take a self-test, review the result, and set next week's target."
        };
        for (int i = 0; i < 7; i++) {
            if (ranked.isEmpty()) plan.add("Day " + (i + 1) + ": Review your current class notes for 60–90 minutes and record topics that need support. Assessment and attendance data are not yet sufficient for subject-specific targeting.");
            else {
                SubjectImprovement subject = ranked.get(i % ranked.size());
                String topic = subject.getAssessmentNames().isEmpty() ? "current class topics" : "topics covered in " + subject.getAssessmentNames().get(0);
                plan.add("Day " + (i + 1) + " — " + subject.getSubjectName() + ": " + actions[i] + " Focus: " + topic + " (about 60–90 minutes).");
            }
        }
        return plan;
    }
}
