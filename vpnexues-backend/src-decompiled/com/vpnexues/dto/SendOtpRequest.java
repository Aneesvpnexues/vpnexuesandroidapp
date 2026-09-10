/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.dto.SendOtpRequest
 *  jakarta.validation.constraints.Email
 *  jakarta.validation.constraints.NotBlank
 */
package com.vpnexues.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public class SendOtpRequest {
    @NotBlank(message="Email is required")
    @Email(message="Invalid email format")
    private @NotBlank(message="Email is required") @Email(message="Invalid email format") String email;

    public String getEmail() {
        return this.email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof SendOtpRequest)) {
            return false;
        }
        SendOtpRequest other = (SendOtpRequest)o;
        if (!other.canEqual((Object)this)) {
            return false;
        }
        String this$email = this.getEmail();
        String other$email = other.getEmail();
        return !(this$email == null ? other$email != null : !this$email.equals(other$email));
    }

    protected boolean canEqual(Object other) {
        return other instanceof SendOtpRequest;
    }

    public int hashCode() {
        int PRIME = 59;
        int result = 1;
        String $email = this.getEmail();
        result = result * 59 + ($email == null ? 43 : $email.hashCode());
        return result;
    }

    public String toString() {
        return "SendOtpRequest(email=" + this.getEmail() + ")";
    }
}

