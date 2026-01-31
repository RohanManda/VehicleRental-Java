package com.MyApp.Rohan9063_CA2;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import java.util.List;

public class BookingDAO {
    
    public boolean createBooking(Booking booking) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(booking);
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

    public boolean cancelBooking(int bookingId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Booking booking = session.get(Booking.class, bookingId);
            if (booking != null) {
                session.delete(booking);
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

    public List<Booking> listBookings() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT b FROM Booking b LEFT JOIN FETCH b.user LEFT JOIN FETCH b.vehicle ORDER BY b.booking_date DESC";
            return session.createQuery(hql, Booking.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Booking getBookingById(int bookingId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT b FROM Booking b LEFT JOIN FETCH b.user LEFT JOIN FETCH b.vehicle WHERE b.booking_id = :id";
            Query<Booking> query = session.createQuery(hql, Booking.class);
            query.setParameter("id", bookingId);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Booking> getBookingsByUser(int userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT DISTINCT b FROM Booking b LEFT JOIN FETCH b.vehicle WHERE b.user.user_id = :userId ORDER BY b.booking_date DESC";
            Query<Booking> query = session.createQuery(hql, Booking.class);
            query.setParameter("userId", userId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean updateBooking(Booking booking) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.update(booking);
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
}
