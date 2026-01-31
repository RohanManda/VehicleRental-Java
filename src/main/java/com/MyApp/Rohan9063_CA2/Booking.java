package com.MyApp.Rohan9063_CA2;
import javax.persistence.*;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;

@Entity
@Table(name = "booking")
public class Booking {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "booking_id")
    private int booking_id;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vehicle_id", nullable = false)
    private Vehicle vehicle;
    @Column(name = "booking_date", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date booking_date;
    @Column(name = "return_date", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date return_date;
    @Column(name = "total_amount", nullable = false)
    private double total_amount;
    @Column(name = "status")
    private String status = "Booked";
    @OneToMany(mappedBy = "booking", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Payment> payments = new ArrayList<>();
    @OneToMany(mappedBy = "booking", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<ReturnVehicle> returns = new ArrayList<>();

    public Booking() {}

    public Booking(User user, Vehicle vehicle, Date booking_date, Date return_date) {
        this.user = user;
        this.vehicle = vehicle;
        this.booking_date = booking_date;
        this.return_date = return_date;
    }

    public Booking(User user, Vehicle vehicle, Date booking_date, Date return_date, double total_amount) {
        this.user = user;
        this.vehicle = vehicle;
        this.booking_date = booking_date;
        this.return_date = return_date;
        this.total_amount = total_amount;
    }

    public int getBooking_id() { return booking_id; }
    public void setBooking_id(int booking_id) { this.booking_id = booking_id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Vehicle getVehicle() { return vehicle; }
    public void setVehicle(Vehicle vehicle) { this.vehicle = vehicle; }

    public Date getBooking_date() { return booking_date; }
    public void setBooking_date(Date booking_date) { this.booking_date = booking_date; }

    public Date getReturn_date() { return return_date; }
    public void setReturn_date(Date return_date) { this.return_date = return_date; }

    public double getTotal_amount() { return total_amount; }
    public void setTotal_amount(double total_amount) { this.total_amount = total_amount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public List<Payment> getPayments() { return payments; }
    public void setPayments(List<Payment> payments) { this.payments = payments; }

    public List<ReturnVehicle> getReturns() { return returns; }
    public void setReturns(List<ReturnVehicle> returns) { this.returns = returns; }

    public long getRentalDurationDays() {
        if (booking_date != null && return_date != null) {
            long timeDiff = return_date.getTime() - booking_date.getTime();
            return Math.max(1, timeDiff / (1000 * 60 * 60 * 24));
        }
        return 1;
    }

    public double calculateTotalAmount() {
        if (vehicle != null && booking_date != null && return_date != null) {
            return getRentalDurationDays() * vehicle.getPrice_per_day();
        }
        return total_amount;
    }

    public void addPayment(Payment payment) {
        payments.add(payment);
        payment.setBooking(this);
    }

    public void addReturn(ReturnVehicle returnVehicle) {
        returns.add(returnVehicle);
        returnVehicle.setBooking(this);
    }

    public int getUser_id() { return user != null ? user.getUser_id() : 0; }
    public int getVehicle_id() { return vehicle != null ? vehicle.getVehicle_id() : 0; }

    @Override
    public String toString() {
        return "Booking{booking_id=" + booking_id + ", user=" + (user != null ? user.getName() : "N/A") + 
               ", vehicle=" + (vehicle != null ? vehicle.getVehicle_name() : "N/A") + ", total_amount=" + total_amount + "}";
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Booking booking = (Booking) o;
        return booking_id == booking.booking_id;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(booking_id);
    }
}
