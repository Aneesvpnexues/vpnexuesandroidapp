package com.vpnexues.repository;

import com.vpnexues.model.PaymentMethod;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

public interface PaymentMethodRepository extends JpaRepository<PaymentMethod, String> {
    List<PaymentMethod> findByUserIdOrderByIsDefaultDescCreatedAtDesc(String userId);

    Optional<PaymentMethod> findByUserIdAndIsDefaultTrue(String userId);

    @Modifying
    @Transactional
    @Query("DELETE FROM PaymentMethod p WHERE p.userId = :userId AND p.id = :id")
    void deleteByUserIdAndId(@Param("userId") String userId, @Param("id") String id);
}
