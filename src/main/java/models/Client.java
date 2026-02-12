package models;

public class Client {
    private int clientId;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private String address;
    private String emergencyContactName;
    private String emergencyContactPhone;
    private String medicalInfo;

    public Client() {}

    // Old 6-parameter constructor (for backward compatibility with DAO)
    public Client(int clientId, String fullName, String email, String password, String phone, String address) {
        this.clientId = clientId;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.address = address;
        this.emergencyContactName = null;
        this.emergencyContactPhone = null;
        this.medicalInfo = null;
    }

    // New full 9-parameter constructor
    public Client(int clientId, String fullName, String email, String password, String phone, String address,
                  String emergencyContactName, String emergencyContactPhone, String medicalInfo) {
        this.clientId = clientId;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.address = address;
        this.emergencyContactName = emergencyContactName;
        this.emergencyContactPhone = emergencyContactPhone;
        this.medicalInfo = medicalInfo;
    }

    // --- Getters and Setters ---
    public int getClientId() { return clientId; }
    public void setClientId(int clientId) { this.clientId = clientId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getEmergencyContactName() { return emergencyContactName; }
    public void setEmergencyContactName(String emergencyContactName) { this.emergencyContactName = emergencyContactName; }

    public String getEmergencyContactPhone() { return emergencyContactPhone; }
    public void setEmergencyContactPhone(String emergencyContactPhone) { this.emergencyContactPhone = emergencyContactPhone; }

    public String getMedicalInfo() { return medicalInfo; }
    public void setMedicalInfo(String medicalInfo) { this.medicalInfo = medicalInfo; }
}
