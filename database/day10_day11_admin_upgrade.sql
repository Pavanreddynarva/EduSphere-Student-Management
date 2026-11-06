-- Run once against the same database configured in src/main/resources/db.properties.
-- Existing tables and data are preserved.
CREATE TABLE IF NOT EXISTS student_fee_accounts (
  fee_account_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  academic_year VARCHAR(9) NOT NULL,
  total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  paid_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_student_fee_year (student_id,academic_year),
  CONSTRAINT fk_fee_student FOREIGN KEY (student_id) REFERENCES students(student_id),
  CONSTRAINT chk_fee_nonnegative CHECK (total_amount >= 0 AND paid_amount >= 0 AND paid_amount <= total_amount)
);
CREATE TABLE IF NOT EXISTS class_timetable (
  timetable_id INT AUTO_INCREMENT PRIMARY KEY,
  assignment_id INT NOT NULL,
  day_of_week VARCHAR(10) NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  room_number VARCHAR(40) NOT NULL,
  CONSTRAINT fk_timetable_assignment FOREIGN KEY (assignment_id) REFERENCES teacher_assignments(assignment_id),
  CONSTRAINT chk_timetable_time CHECK (start_time < end_time)
);
