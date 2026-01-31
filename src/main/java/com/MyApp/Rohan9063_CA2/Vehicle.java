package com.MyApp.Rohan9063_CA2;
import javax.persistence.*;
import java.util.List;
import java.util.ArrayList;

@Entity
@Table(name = "vehicle")
public class Vehicle {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "vehicle_id")
    private int vehicle_id;

    @Column(name = "vehicle_name", length = 100)
    private String vehicle_name;

    @Column(name = "vehicle_type")
    private String vehicle_type;

    @Column(name = "availability")
    private boolean availability = true;

    @Column(name = "price_per_day")
    private double price_per_day;

    @Column(name = "model_year")
    private int model_year;

    @Column(name = "vehicle_image", length = 255)
    private String vehicle_image;

    @Column(name = "brand", length = 100)
    private String brand;

    @Column(name = "imagePath", length = 255)
    private String imagePath;

    @Column(name = "model", length = 100)
    private String model;

    @Column(name = "year")
    private int year;

    @OneToMany(mappedBy = "vehicle", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Booking> bookings = new ArrayList<>();

    @OneToMany(mappedBy = "vehicle", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Maintenance> maintenanceRecords = new ArrayList<>();

    public Vehicle() {}

    public Vehicle(String vehicle_name, String vehicle_type, boolean availability, 
                   double price_per_day, int model_year, String vehicle_image,
                   String brand, String imagePath, String model, int year) {
        this.vehicle_name = vehicle_name;
        this.vehicle_type = vehicle_type;
        this.availability = availability;
        this.price_per_day = price_per_day;
        this.model_year = model_year;
        this.vehicle_image = vehicle_image;
        this.brand = brand;
        this.imagePath = imagePath;
        this.model = model;
        this.year = year;
    }

    public int getVehicle_id() { return vehicle_id; }
    public void setVehicle_id(int vehicle_id) { this.vehicle_id = vehicle_id; }

    public String getVehicle_name() { return vehicle_name; }
    public void setVehicle_name(String vehicle_name) { this.vehicle_name = vehicle_name; }

    public String getVehicle_type() { return vehicle_type; }
    public void setVehicle_type(String vehicle_type) { this.vehicle_type = vehicle_type; }

    public boolean isAvailability() { return availability; }
    public void setAvailability(boolean availability) { this.availability = availability; }

    public double getPrice_per_day() { return price_per_day; }
    public void setPrice_per_day(double price_per_day) { this.price_per_day = price_per_day; }

    public int getModel_year() { return model_year; }
    public void setModel_year(int model_year) { this.model_year = model_year; }

    public String getVehicle_image() { return vehicle_image; }
    public void setVehicle_image(String vehicle_image) { this.vehicle_image = vehicle_image; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public List<Booking> getBookings() { return bookings; }
    public void setBookings(List<Booking> bookings) { this.bookings = bookings; }

    public List<Maintenance> getMaintenanceRecords() { return maintenanceRecords; }
    public void setMaintenanceRecords(List<Maintenance> maintenanceRecords) { this.maintenanceRecords = maintenanceRecords; }

    // Utility methods for bidirectional relationships
    public void addBooking(Booking booking) {
        bookings.add(booking);
        booking.setVehicle(this);
    }

    public void addMaintenance(Maintenance maintenance) {
        maintenanceRecords.add(maintenance);
        maintenance.setVehicle(this);
    }

    @Override
    public String toString() {
        return "Vehicle{vehicle_id=" + vehicle_id + ", vehicle_name='" + vehicle_name + "', vehicle_type='" + vehicle_type + "'}";
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Vehicle vehicle = (Vehicle) o;
        return vehicle_id == vehicle.vehicle_id;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(vehicle_id);
    }
}
