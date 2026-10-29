package com.studentevents.model;

public class Student {
    private int studentId;
    private String fullName;
    private String email;
    private String major;
    private int yearOfStudy;
    private String phone;

    public Student() {}

    public Student(int studentId, String fullName, String email, String major, int yearOfStudy, String phone) {
        this.studentId = studentId;
        this.fullName = fullName;
        this.email = email;
        this.major = major;
        this.yearOfStudy = yearOfStudy;
        this.phone = phone;
    }

    // Getters and Setters
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getMajor() { return major; }
    public void setMajor(String major) { this.major = major; }

    public int getYearOfStudy() { return yearOfStudy; }
    public void setYearOfStudy(int yearOfStudy) { this.yearOfStudy = yearOfStudy; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    @Override
    public String toString() {
        return String.format("[ID:%d] %-20s | %-24s | %-20s | Yr %d | %s",
                studentId, fullName, email, major, yearOfStudy, phone);
    }
}
