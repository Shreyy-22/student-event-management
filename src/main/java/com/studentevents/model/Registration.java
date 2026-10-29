package com.studentevents.model;

import java.sql.Timestamp;

public class Registration {
    private int registrationId;
    private int studentId;
    private int eventId;
    private String studentName;
    private String eventTitle;
    private Timestamp registrationDate;
    private String status; // CONFIRMED, WAITLISTED, CANCELLED
    private double feePaid;
    private String ticketCode;

    public Registration() {}

    public Registration(int registrationId, int studentId, int eventId, String studentName,
                        String eventTitle, Timestamp registrationDate, String status, double feePaid, String ticketCode) {
        this.registrationId = registrationId;
        this.studentId = studentId;
        this.eventId = eventId;
        this.studentName = studentName;
        this.eventTitle = eventTitle;
        this.registrationDate = registrationDate;
        this.status = status;
        this.feePaid = feePaid;
        this.ticketCode = ticketCode;
    }

    // Getters and Setters
    public int getRegistrationId() { return registrationId; }
    public void setRegistrationId(int registrationId) { this.registrationId = registrationId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getEventTitle() { return eventTitle; }
    public void setEventTitle(String eventTitle) { this.eventTitle = eventTitle; }

    public Timestamp getRegistrationDate() { return registrationDate; }
    public void setRegistrationDate(Timestamp registrationDate) { this.registrationDate = registrationDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public double getFeePaid() { return feePaid; }
    public void setFeePaid(double feePaid) { this.feePaid = feePaid; }

    public String getTicketCode() { return ticketCode; }
    public void setTicketCode(String ticketCode) { this.ticketCode = ticketCode; }

    @Override
    public String toString() {
        return String.format("[%d] %-20s -> %-28s | Status: %-10s | Ticket: %-18s | Paid: $%,.2f",
                registrationId, studentName != null ? studentName : "Student #" + studentId,
                eventTitle != null ? eventTitle : "Event #" + eventId, status, ticketCode, feePaid);
    }
}
