package models;

import java.time.LocalDateTime;

public class ServiceStatus {

    private int statusId;
    private int bookingId;
    private String status; // Scheduled, In Progress, Completed, Cancelled
    private LocalDateTime checkInTime;
    private LocalDateTime checkOutTime;
    private String caregiverNotes;
    private LocalDateTime updatedAt;

    // Default constructor
    public ServiceStatus() {}

    // Full constructor
    public ServiceStatus(int statusId, int bookingId, String status,
                         LocalDateTime checkInTime, LocalDateTime checkOutTime,
                         String caregiverNotes, LocalDateTime updatedAt) {
        this.statusId = statusId;
        this.bookingId = bookingId;
        this.status = status;
        this.checkInTime = checkInTime;
        this.checkOutTime = checkOutTime;
        this.caregiverNotes = caregiverNotes;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public int getStatusId() {
        return statusId;
    }

    public void setStatusId(int statusId) {
        this.statusId = statusId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCheckInTime() {
        return checkInTime;
    }

    public void setCheckInTime(LocalDateTime checkInTime) {
        this.checkInTime = checkInTime;
    }

    public LocalDateTime getCheckOutTime() {
        return checkOutTime;
    }

    public void setCheckOutTime(LocalDateTime checkOutTime) {
        this.checkOutTime = checkOutTime;
    }

    public String getCaregiverNotes() {
        return caregiverNotes;
    }

    public void setCaregiverNotes(String caregiverNotes) {
        this.caregiverNotes = caregiverNotes;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "ServiceStatus{" +
                "statusId=" + statusId +
                ", bookingId=" + bookingId +
                ", status='" + status + '\'' +
                ", checkInTime=" + checkInTime +
                ", checkOutTime=" + checkOutTime +
                ", caregiverNotes='" + caregiverNotes + '\'' +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
