package com.studentevents.model;

import java.sql.Date;

public class CampusEvent {
    private int eventId;
    private String title;
    private String category;
    private Date eventDate;
    private int maxCapacity;
    private int currentRegistrations;
    private double registrationFee;
    private String venue;

    public CampusEvent() {}

    public CampusEvent(int eventId, String title, String category, Date eventDate,
                       int maxCapacity, int currentRegistrations, double registrationFee, String venue) {
        this.eventId = eventId;
        this.title = title;
        this.category = category;
        this.eventDate = eventDate;
        this.maxCapacity = maxCapacity;
        this.currentRegistrations = currentRegistrations;
        this.registrationFee = registrationFee;
        this.venue = venue;
    }

    // Getters and Setters
    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public Date getEventDate() { return eventDate; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }

    public int getMaxCapacity() { return maxCapacity; }
    public void setMaxCapacity(int maxCapacity) { this.maxCapacity = maxCapacity; }

    public int getCurrentRegistrations() { return currentRegistrations; }
    public void setCurrentRegistrations(int currentRegistrations) { this.currentRegistrations = currentRegistrations; }

    public double getRegistrationFee() { return registrationFee; }
    public void setRegistrationFee(double registrationFee) { this.registrationFee = registrationFee; }

    public String getVenue() { return venue; }
    public void setVenue(String venue) { this.venue = venue; }

    public boolean isFull() {
        return currentRegistrations >= maxCapacity;
    }

    @Override
    public String toString() {
        return String.format("[%d] %-32s | %-12s | %s | %2d/%2d Seats | Fee: $%,6.2f | %s",
                eventId, title, category, eventDate, currentRegistrations, maxCapacity, registrationFee, venue);
    }
}
