package com.MyApp.Rohan9063_CA2;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class MaintenanceDAO {
    
    public boolean addMaintenance(Maintenance maintenance) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(maintenance);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public List<Maintenance> listMaintenance() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT m FROM Maintenance m LEFT JOIN FETCH m.vehicle ORDER BY m.maintenance_date DESC";
            return session.createQuery(hql, Maintenance.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Maintenance getMaintenanceById(int maintenanceId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Maintenance.class, maintenanceId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean updateMaintenance(Maintenance maintenance) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.update(maintenance);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteMaintenance(int maintenanceId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Maintenance maintenance = session.get(Maintenance.class, maintenanceId);
            if (maintenance != null) {
                session.delete(maintenance);
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
