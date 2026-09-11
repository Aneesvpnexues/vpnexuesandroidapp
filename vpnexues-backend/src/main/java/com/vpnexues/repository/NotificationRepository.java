package com.vpnexues.repository;

import com.vpnexues.model.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

public interface NotificationRepository extends JpaRepository<Notification, String> {
    List<Notification> findByUserIdOrderByCreatedAtDesc(String userId);

    long countByUserIdAndIsReadFalse(String userId);

    List<Notification> findByUserIdAndIsReadFalse(String userId);

    @Modifying
    @Transactional
    @Query("DELETE FROM Notification n WHERE n.userId = :userId AND n.id = :id")
    void deleteByUserIdAndId(@Param("userId") String userId, @Param("id") String id);
}
