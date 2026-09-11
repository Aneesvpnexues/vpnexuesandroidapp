package com.vpnexues.model;

import jakarta.persistence.*;
import java.time.Instant;

@Entity
@Table(name = "otps")
public class Otp {

    @Id
    private String id;

    @Column(unique = true)
    private String email;

    private String otp;

    @Column(name = "expires_at")
    private Instant expiresAt;

    private boolean verified = false;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getOtp() {
        return otp;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public Instant getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Instant expiresAt) {
        this.expiresAt = expiresAt;
    }

    public boolean isVerified() {
        return verified;
    }

    public void setVerified(boolean verified) {
        this.verified = verified;
    }
}
