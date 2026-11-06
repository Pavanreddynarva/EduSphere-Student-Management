package com.studentmanagement.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class AcademicRiskSettings {

    private int settingId;
    private BigDecimal attendanceThreshold;
    private BigDecimal performanceThreshold;
    private Integer updatedBy;
    private LocalDateTime updatedAt;

    public AcademicRiskSettings() {
    }

    public int getSettingId() {
        return settingId;
    }

    public void setSettingId(int settingId) {
        this.settingId = settingId;
    }

    public BigDecimal getAttendanceThreshold() {
        return attendanceThreshold;
    }

    public void setAttendanceThreshold(BigDecimal attendanceThreshold) {
        this.attendanceThreshold = attendanceThreshold;
    }

    public BigDecimal getPerformanceThreshold() {
        return performanceThreshold;
    }

    public void setPerformanceThreshold(BigDecimal performanceThreshold) {
        this.performanceThreshold = performanceThreshold;
    }

    public Integer getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(Integer updatedBy) {
        this.updatedBy = updatedBy;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}