package models;

public class BookingDetail {
    private int detailId;
    private int bookingId;
    private int serviceId;

    private int quantity;
    private double unitPrice;

    private String serviceName;

    public BookingDetail() {}

    public int getDetailId() { 
    	return detailId; 
    }
   
	public void setDetailId(int detailId) {
		this.detailId = detailId; 
	}
	
	public int getBookingId() { 
		return bookingId; 
	}
	
	public void setBookingId(int bookingId) { 
		this.bookingId = bookingId; 
	}
	
	public int getServiceId() { 
		return serviceId; 
	}
	
	public void setServiceId(int serviceId) { 
		this.serviceId = serviceId; 
	}
	
	public int getQuantity() { 
		return quantity; 
	}
	
	public void setQuantity(int quantity) { 
		this.quantity = quantity; 
	}
	
	public double getUnitPrice() { 
		return unitPrice; 
	}
	
	public void setUnitPrice(double unitPrice) { 
		this.unitPrice = unitPrice; 
	}
	
	public String getServiceName() {
		return serviceName;
	}
	
	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}
}
