# JAD-assignment-1  
A JSP-based web application for managing elderly care services, built for the ST0510 Java Applications Development module.

Silver Care allows clients to browse services, make bookings, confirm appointments, and leave feedback, while administrators manage services, categories, clients, and reviews.  
The system follows proper MVC structure (Model–View–Controller), uses a MySQL database, and is deployed using Apache Tomcat.

---

## Features

### Client Features
- Browse services by categories  
- View service details with pricing and images  
- Add service(s) to cart (Pending Booking)  
- Remove individual booking items  
- Confirm booking (Pending → Confirmed)  
- Leave feedback for past services  
- Edit profile / delete account  
- Login and registration  

### Admin Features
- Login authentication  
- Manage service categories (CRUD)  
- Manage services (CRUD)  
- Manage clients  
- View bookings  
- View customer feedback  
- Dashboard with quick statistics  
- Responsive collapsible sidebar  

---

## System Architecture (MVC)

### **Model Layer (Java Beans)**
- `Client`
- `Admin`
- `Service`
- `ServiceCategory`
- `Feedback`
- `Booking` *(Pending / Confirmed)*
- `BookingDetails`

### **Controller Layer (Servlets)**
- `AuthController`
- `CartController`
- `BookingController`
- `FeedbackController`
- CRUD controllers for services & categories

### **DAO Layer**
- `ClientDao`
- `AdminDao`
- `ServiceDao`
- `CategoryDao`
- `FeedbackDao`
- `CartDao` *(booking + booking_details logic)*

### **View Layer**
- JSP pages located under:
  - `/public`
  - `/client`
  - `/admin`
  - `/booking`
  - `/includes` (navbar, footer, header)

---

## Database Schema

### **Tables**
- `admin(admin_id, username, password)`
- `client(client_id, full_name, email, password, phone, address)`
- `service_category(category_id, category_name, description)`
- `service(service_id, category_id, name, description, price, image_path)`
- `booking(booking_id, client_id, status, created_at)`
- `booking_details(detail_id, booking_id, service_id)`
- `feedback(feedback_id, client_id, service_id, rating, comments, created_at)`

### **Booking Workflow**
- Client adds service → `booking_details` item is created  
- If no pending booking exists → system auto-creates `booking(Pending)`  
- On checkout → status updates to `Confirmed`, feedback becomes available  

---

## Frontend / UI
Two complete themes:

### Admin UI  
- Gradient navbar  
- Animated collapsible sidebar  
- Clean metrics dashboard  
- Shadowed cards and tables  

### Client UI  
- Fully separate CSS (`client.css`)  
- Smooth animations  
- Styled forms, cards, and tables  

---

## Technologies Used
- Java 17  
- JSP + JSTL  
- Servlets  
- MySQL 8  
- JDBC  
- Apache Tomcat 10.1  
- HTML5 / Bootstrap  
- CSS3 (custom themes)  

---
