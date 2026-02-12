package models;

public class Caregiver {

    private int caregiverId;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private String specialization;

    public Caregiver() {}

    public Caregiver(int caregiverId, String fullName, String email,
                     String password, String phone, String specialization) {
        this.caregiverId = caregiverId;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.specialization = specialization;
    }

    public int getCaregiverId() {
        return caregiverId;
    }

    public void setCaregiverId(int caregiverId) {
        this.caregiverId = caregiverId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }
}
