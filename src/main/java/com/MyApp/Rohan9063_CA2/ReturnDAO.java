package com.MyApp.Rohan9063_CA2;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class ReturnDAO {
    
    public boolean saveReturn(ReturnVehicle returnObj) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(returnObj);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                try {
                    tx.rollback();
                } catch (Exception rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        }
    }

    public List<ReturnVehicle> listReturns() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT r FROM ReturnVehicle r LEFT JOIN FETCH r.booking b LEFT JOIN FETCH b.user LEFT JOIN FETCH b.vehicle ORDER BY r.actual_return_date DESC";
            return session.createQuery(hql, ReturnVehicle.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public ReturnVehicle getReturnById(int returnId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT r FROM ReturnVehicle r LEFT JOIN FETCH r.booking b LEFT JOIN FETCH b.user LEFT JOIN FETCH b.vehicle WHERE r.return_id = :id";
            return session.createQuery(hql, ReturnVehicle.class)
                          .setParameter("id", returnId)
                          .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Booking getBookingById(int bookingId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT b FROM Booking b LEFT JOIN FETCH b.user LEFT JOIN FETCH b.vehicle WHERE b.booking_id = :id";
            return session.createQuery(hql, Booking.class)
                          .setParameter("id", bookingId)
                          .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean updateReturn(ReturnVehicle returnVehicle) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.update(returnVehicle);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                try {
                    tx.rollback();
                } catch (Exception rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteReturn(int returnId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            ReturnVehicle returnVehicle = session.get(ReturnVehicle.class, returnId);
            if (returnVehicle != null) {
                session.delete(returnVehicle);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                try {
                    tx.rollback();
                } catch (Exception rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        }
    }
}
