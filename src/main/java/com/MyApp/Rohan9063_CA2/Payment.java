package com.MyApp.Rohan9063_CA2;
import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "payment")
public class Payment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "payment_id")
    private int payment_id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "booking_id", nullable = false)
    private Booking booking;

    @Column(name = "amount", nullable = false)
    private double amount;

    @Column(name = "payment_date", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date payment_date;

    @Column(name = "payment_method", nullable = false)
    private String payment_method; 

    @Column(name = "status")
    private String status = "Paid"; 

    public Payment() {}

    public Payment(Booking booking, double amount, Date payment_date, String payment_method) {
        this.booking = booking;
        this.amount = amount;
        this.payment_date = payment_date;
        this.payment_method = payment_method;
    }
    public int getPayment_id() { return payment_id; }
    public void setPayment_id(int payment_id) { this.payment_id = payment_id; }

    public Booking getBooking() { return booking; }
    public void setBooking(Booking booking) { this.booking = booking; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public Date getPayment_date() { return payment_date; }
    public void setPayment_date(Date payment_date) { this.payment_date = payment_date; }

    public String getPayment_method() { return payment_method; }
    public void setPayment_method(String payment_method) { this.payment_method = payment_method; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // Utility methods
    public String getBookingReference() {
        return booking != null ? "BOOK-" + booking.getBooking_id() : null;
    }

    public String getUserName() {
        return (booking != null && booking.getUser() != null) ? 
                booking.getUser().getName() : "Unknown";
    }

    public String getVehicleName() {
        return (booking != null && booking.getVehicle() != null) ? 
                booking.getVehicle().getVehicle_name() : "Unknown";
    }

    @Override
    public String toString() {
        return "Payment{payment_id=" + payment_id + ", booking_id=" + (booking != null ? booking.getBooking_id() : "N/A") + 
               ", amount=" + amount + ", payment_method='" + payment_method + "'}";
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Payment payment = (Payment) o;
        return payment_id == payment.payment_id;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(payment_id);
    }
}
