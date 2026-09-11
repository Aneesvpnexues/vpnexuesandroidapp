package com.vpnexues.repository;

import com.vpnexues.model.Address;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

public interface AddressRepository extends JpaRepository<Address, String> {
    List<Address> findByUserIdOrderByIsDefaultDescCreatedAtDesc(String userId);

    Optional<Address> findByUserIdAndIsDefaultTrue(String userId);

    @Modifying
    @Transactional
    @Query("DELETE FROM Address a WHERE a.userId = :userId AND a.id = :id")
    void deleteByUserIdAndId(@Param("userId") String userId, @Param("id") String id);
}
