package com.vpnexues.repository;

import com.vpnexues.model.Otp;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;
import java.time.Instant;
import java.util.Optional;

public interface OtpRepository extends JpaRepository<Otp, String> {
    Optional<Otp> findByEmailAndOtpAndVerifiedFalseAndExpiresAtAfter(String email, String otp, Instant now);

    @Modifying
    @Transactional
    @Query("DELETE FROM Otp o WHERE o.email = :email")
    void deleteByEmail(@Param("email") String email);
}
