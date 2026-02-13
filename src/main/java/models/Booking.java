package models;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class Booking {
    private int bookingId;
    private int clientId;
    private Timestamp createdAt;
    private String status;

    private Date scheduledDate;
    private Time scheduledTime;
    private double gstRate;
    private String remarks;
    private String clientName;

    // NEW: paymentStatus for JSP and Stripe integration
    private String paymentStatus;

    public Booking() {}

    public Booking(int bookingId, int clientId, Timestamp createdAt, String status) {
        this.bookingId = bookingId;
        this.clientId = clientId;
        this.createdAt = createdAt;
        this.status = status;
    }

    // ===== Getters & Setters =====
    public int getBookingId() { 
        return bookingId; 
    }
    
    public void setBookingId(int bookingId) { 
        this.bookingId = bookingId; 
    }
    
    public int getClientId() { 
        return clientId; 
    }
    
    public void setClientId(int clientId) { 
        this.clientId = clientId; 
    }
    
    public Timestamp getCreatedAt() { 
        return createdAt; 
    }
    
    public void setCreatedAt(Timestamp createdAt) { 
        this.createdAt = createdAt; 
    }
    
    public String getStatus() { 
        return status; 
    }
    
    public void setStatus(String status) { 
        this.status = status; 
    }

    public Date getScheduledDate() {
        return scheduledDate;
    }

    public void setScheduledDate(Date scheduledDate) {
        this.scheduledDate = scheduledDate;
    }

    public Time getScheduledTime() {
        return scheduledTime;
    }

    public void setScheduledTime(Time scheduledTime) {
        this.scheduledTime = scheduledTime;
    }

    public double getGstRate() {
        return gstRate;
    }

    public void setGstRate(double gstRate) {
        this.gstRate = gstRate;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public String getClientName() {
        return clientName;
    }

    public void setClientName(String clientName) {
        this.clientName = clientName;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
}
