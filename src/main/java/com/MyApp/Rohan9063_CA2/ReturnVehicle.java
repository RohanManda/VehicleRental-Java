package com.MyApp.Rohan9063_CA2;
import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "return_vehicle")
public class ReturnVehicle {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "return_id")
    private int return_id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "booking_id", nullable = false)
    private Booking booking;

    @Column(name = "return_date", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date return_date;

    @Column(name = "actual_return_date", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date actual_return_date;

    @Column(name = "extra_charge")
    private double extra_charge = 0.0;

    @Column(name = "remarks")
    private String remarks;

    // Constructors
    public ReturnVehicle() {}

    public ReturnVehicle(Booking booking, Date return_date, double extra_charge) {
        this.booking = booking;
        this.return_date = return_date;
        this.actual_return_date = return_date; // Set actual_return_date same as return_date by default
        this.extra_charge = extra_charge;
    }

    public ReturnVehicle(Booking booking, Date return_date, Date actual_return_date, double extra_charge, String remarks) {
        this.booking = booking;
        this.return_date = return_date;
        this.actual_return_date = actual_return_date;
        this.extra_charge = extra_charge;
        this.remarks = remarks;
    }

    // All getters and setters
    public int getReturn_id() { return return_id; }
    public void setReturn_id(int return_id) { this.return_id = return_id; }

    public Booking getBooking() { return booking; }
    public void setBooking(Booking booking) { this.booking = booking; }

    public Date getReturn_date() { return return_date; }
    public void setReturn_date(Date return_date) { this.return_date = return_date; }

    // *** ADDED: Getter and setter for actual_return_date ***
    public Date getActual_return_date() { return actual_return_date; }
    public void setActual_return_date(Date actual_return_date) { this.actual_return_date = actual_return_date; }

    public double getExtra_charge() { return extra_charge; }
    public void setExtra_charge(double extra_charge) { this.extra_charge = extra_charge; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    // Utility methods
    public boolean isLateReturn() {
        if (booking != null && actual_return_date != null && booking.getReturn_date() != null) {
            return actual_return_date.after(booking.getReturn_date());
        }
        return false;
    }

    public long getLateDays() {
        if (isLateReturn()) {
            long timeDiff = actual_return_date.getTime() - booking.getReturn_date().getTime();
            return timeDiff / (1000 * 60 * 60 * 24);
        }
        return 0;
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
        return "ReturnVehicle{return_id=" + return_id + ", booking_id=" + (booking != null ? booking.getBooking_id() : "N/A") + 
               ", actual_return_date=" + actual_return_date + ", extra_charge=" + extra_charge + "}";
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ReturnVehicle that = (ReturnVehicle) o;
        return return_id == that.return_id;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(return_id);
    }
}
