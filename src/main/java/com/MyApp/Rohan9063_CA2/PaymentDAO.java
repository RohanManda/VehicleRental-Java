package com.MyApp.Rohan9063_CA2;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class PaymentDAO {
    
    public boolean savePayment(Payment payment) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(payment);
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

    // *** FIXED: Use JOIN FETCH to load related entities ***
    public List<Payment> listPayments() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT p FROM Payment p " +
                        "LEFT JOIN FETCH p.booking b " +
                        "LEFT JOIN FETCH b.user " +
                        "LEFT JOIN FETCH b.vehicle " +
                        "ORDER BY p.payment_date DESC";
            return session.createQuery(hql, Payment.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Payment getPaymentById(int paymentId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT p FROM Payment p " +
                        "LEFT JOIN FETCH p.booking b " +
                        "LEFT JOIN FETCH b.user " +
                        "LEFT JOIN FETCH b.vehicle " +
                        "WHERE p.payment_id = :id";
            return session.createQuery(hql, Payment.class)
                          .setParameter("id", paymentId)
                          .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Payment> getPaymentsByUser(int userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT p FROM Payment p " +
                        "LEFT JOIN FETCH p.booking b " +
                        "LEFT JOIN FETCH b.vehicle " +
                        "WHERE b.user.user_id = :userId " +
                        "ORDER BY p.payment_date DESC";
            return session.createQuery(hql, Payment.class)
                          .setParameter("userId", userId)
                          .list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean updatePayment(Payment payment) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.update(payment);
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

    public boolean deletePayment(int paymentId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Payment payment = session.get(Payment.class, paymentId);
            if (payment != null) {
                session.delete(payment);
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
	