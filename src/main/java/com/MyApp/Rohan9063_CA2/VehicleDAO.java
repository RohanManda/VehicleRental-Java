package com.MyApp.Rohan9063_CA2;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import java.util.List;

public class VehicleDAO {
    
    public boolean addVehicle(Vehicle vehicle) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(vehicle);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public List<Vehicle> listVehicles() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Vehicle", Vehicle.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Vehicle> getAllVehiclesWithMaintenance() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT v FROM Vehicle v LEFT JOIN FETCH v.maintenanceRecords ORDER BY v.vehicle_id";
            return session.createQuery(hql, Vehicle.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Vehicle> getAllVehiclesWithBookings() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT v FROM Vehicle v LEFT JOIN FETCH v.bookings ORDER BY v.vehicle_id";
            return session.createQuery(hql, Vehicle.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Vehicle> getAvailableVehicles() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Vehicle> query = session.createQuery("FROM Vehicle WHERE availability = true ORDER BY vehicle_name", Vehicle.class);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Vehicle searchVehicleById(int vehicleId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Vehicle.class, vehicleId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Vehicle getVehicleWithMaintenance(int vehicleId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT v FROM Vehicle v LEFT JOIN FETCH v.maintenanceRecords WHERE v.vehicle_id = :id";
            Query<Vehicle> query = session.createQuery(hql, Vehicle.class);
            query.setParameter("id", vehicleId);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean updateVehicle(Vehicle vehicle) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.update(vehicle);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteVehicle(int vehicleId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Vehicle vehicle = session.get(Vehicle.class, vehicleId);
            if (vehicle != null) {
                session.delete(vehicle);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public List<Vehicle> getVehiclesByType(String vehicleType) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Vehicle> query = session.createQuery("FROM Vehicle WHERE vehicle_type = :type ORDER BY vehicle_name", Vehicle.class);
            query.setParameter("type", vehicleType);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Vehicle> getVehiclesByBrand(String brand) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Vehicle> query = session.createQuery("FROM Vehicle WHERE brand = :brand ORDER BY model", Vehicle.class);
            query.setParameter("brand", brand);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Vehicle> getVehiclesByPriceRange(double minPrice, double maxPrice) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Vehicle> query = session.createQuery("FROM Vehicle WHERE price_per_day BETWEEN :min AND :max AND availability = true ORDER BY price_per_day", Vehicle.class);
            query.setParameter("min", minPrice);
            query.setParameter("max", maxPrice);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public long getTotalVehicleCount() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery("SELECT COUNT(v) FROM Vehicle v", Long.class);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public long getAvailableVehicleCount() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery("SELECT COUNT(v) FROM Vehicle v WHERE v.availability = true", Long.class);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public boolean setVehicleAvailability(int vehicleId, boolean availability) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Vehicle vehicle = session.get(Vehicle.class, vehicleId);
            if (vehicle != null) {
                vehicle.setAvailability(availability);
                session.update(vehicle);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }
}
