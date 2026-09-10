/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.model.Otp
 *  org.springframework.data.annotation.Id
 *  org.springframework.data.mongodb.core.index.CompoundIndex
 *  org.springframework.data.mongodb.core.mapping.Document
 */
package com.vpnexues.model;

import java.time.Instant;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection="otps")
@CompoundIndex(name="email_expires", def="{'email': 1, 'expiresAt': 1}")
public class Otp {
    @Id
    private String id;
    private String email;
    private String otp;
    private Instant expiresAt;
    private boolean verified = false;

    public String getId() {
        return this.id;
    }

    public String getEmail() {
        return this.email;
    }

    public String getOtp() {
        return this.otp;
    }

    public Instant getExpiresAt() {
        return this.expiresAt;
    }

    public boolean isVerified() {
        return this.verified;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public void setExpiresAt(Instant expiresAt) {
        this.expiresAt = expiresAt;
    }

    public void setVerified(boolean verified) {
        this.verified = verified;
    }

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof Otp)) {
            return false;
        }
        Otp other = (Otp)o;
        if (!other.canEqual((Object)this)) {
            return false;
        }
        if (this.isVerified() != other.isVerified()) {
            return false;
        }
        String this$id = this.getId();
        String other$id = other.getId();
        if (this$id == null ? other$id != null : !this$id.equals(other$id)) {
            return false;
        }
        String this$email = this.getEmail();
        String other$email = other.getEmail();
        if (this$email == null ? other$email != null : !this$email.equals(other$email)) {
            return false;
        }
        String this$otp = this.getOtp();
        String other$otp = other.getOtp();
        if (this$otp == null ? other$otp != null : !this$otp.equals(other$otp)) {
            return false;
        }
        Instant this$expiresAt = this.getExpiresAt();
        Instant other$expiresAt = other.getExpiresAt();
        return !(this$expiresAt == null ? other$expiresAt != null : !((Object)this$expiresAt).equals(other$expiresAt));
    }

    protected boolean canEqual(Object other) {
        return other instanceof Otp;
    }

    public int hashCode() {
        int PRIME = 59;
        int result = 1;
        result = result * 59 + (this.isVerified() ? 79 : 97);
        String $id = this.getId();
        result = result * 59 + ($id == null ? 43 : $id.hashCode());
        String $email = this.getEmail();
        result = result * 59 + ($email == null ? 43 : $email.hashCode());
        String $otp = this.getOtp();
        result = result * 59 + ($otp == null ? 43 : $otp.hashCode());
        Instant $expiresAt = this.getExpiresAt();
        result = result * 59 + ($expiresAt == null ? 43 : ((Object)$expiresAt).hashCode());
        return result;
    }

    public String toString() {
        return "Otp(id=" + this.getId() + ", email=" + this.getEmail() + ", otp=" + this.getOtp() + ", expiresAt=" + String.valueOf(this.getExpiresAt()) + ", verified=" + this.isVerified() + ")";
    }

    public Otp() {
    }

    public Otp(String id, String email, String otp, Instant expiresAt, boolean verified) {
        this.id = id;
        this.email = email;
        this.otp = otp;
        this.expiresAt = expiresAt;
        this.verified = verified;
    }
}

