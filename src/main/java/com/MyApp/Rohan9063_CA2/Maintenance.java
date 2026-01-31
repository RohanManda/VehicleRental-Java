package com.MyApp.Rohan9063_CA2;
import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "maintenance")
public class Maintenance {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "maintenance_id")
    private int maintenance_id;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vehicle_id", nullable = false)
    private Vehicle vehicle;

    @Column(name = "description")
    private String description;

    @Column(name = "maintenance_date")
    @Temporal(TemporalType.DATE)
    private Date maintenance_date;

    @Column(name = "cost")
    private double cost;

    public Maintenance() {}

    public Maintenance(Vehicle vehicle, String description, Date maintenance_date, double cost) {
        this.vehicle = vehicle;
        this.description = description;
        this.maintenance_date = maintenance_date;
        this.cost = cost;
    }
    public int getMaintenance_id() { return maintenance_id; }
    public void setMaintenance_id(int maintenance_id) { this.maintenance_id = maintenance_id; }

    public Vehicle getVehicle() { return vehicle; }
    public void setVehicle(Vehicle vehicle) { this.vehicle = vehicle; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getMaintenance_date() { return maintenance_date; }
    public void setMaintenance_date(Date maintenance_date) { this.maintenance_date = maintenance_date; }

    public double getCost() { return cost; }
    public void setCost(double cost) { this.cost = cost; }

    public String getMaintenanceType() {
        if (description != null && description.length() > 50) {
            return description.substring(0, 50) + "...";
        }
        return description;
    }

    public boolean isExpensiveMaintenance(double threshold) {
        return cost > threshold;
    }

    public String getVehicleInfo() {
        if (vehicle != null) {
            return vehicle.getBrand() + " " + vehicle.getModel() + " (" + vehicle.getYear() + ")";
        }
        return "Unknown Vehicle";
    }

    public boolean isRecentMaintenance() {
        if (maintenance_date != null) {
            Date now = new Date();
            long timeDiff = now.getTime() - maintenance_date.getTime();
            long daysDiff = timeDiff / (1000 * 60 * 60 * 24);
            return daysDiff <= 30;
        }
        return false;
    }

    @Override
    public String toString() {
        return "Maintenance{maintenance_id=" + maintenance_id + ", vehicle=" + (vehicle != null ? vehicle.getVehicle_id() : null) + 
               ", description='" + description + "', maintenance_date=" + maintenance_date + ", cost=" + cost + "}";
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Maintenance that = (Maintenance) o;
        return maintenance_id == that.maintenance_id;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(maintenance_id);
    }
}
