package models;

public class Service {
    private int serviceId;
    private String serviceName;
    private String serviceDesc;
    private double price;
    private int categoryId;
    private String imagePath;
    private int bookingId;
    private int detailId;

    public Service() {}

    public Service(int serviceId, String serviceName, String serviceDesc, double price, int categoryId, String imagePath) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.serviceDesc = serviceDesc;
        this.price = price;
        this.categoryId = categoryId;
        this.imagePath = imagePath;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getServiceDesc() {
        return serviceDesc;
    }

    public void setServiceDesc(String serviceDesc) {
        this.serviceDesc = serviceDesc;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
    
    public int getBookingId() { 
    	return bookingId; 
    }
    
    public void setBookingId(int bookingId) { 
    	this.bookingId = bookingId; 
    }
    
    public int getDetailId() {
    	return detailId;
    }

	public void setDetailId(int detailId) {
		this.detailId = detailId;
	}
}
