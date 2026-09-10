/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.dto.AuthResponse
 *  com.vpnexues.dto.AuthResponse$UserInfo
 */
package com.vpnexues.dto;

import com.vpnexues.dto.AuthResponse;

public class AuthResponse {
    private String token;
    private UserInfo user;

    public String getToken() {
        return this.token;
    }

    public UserInfo getUser() {
        return this.user;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public void setUser(UserInfo user) {
        this.user = user;
    }

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof AuthResponse)) {
            return false;
        }
        AuthResponse other = (AuthResponse)o;
        if (!other.canEqual((Object)this)) {
            return false;
        }
        String this$token = this.getToken();
        String other$token = other.getToken();
        if (this$token == null ? other$token != null : !this$token.equals(other$token)) {
            return false;
        }
        UserInfo this$user = this.getUser();
        UserInfo other$user = other.getUser();
        return !(this$user == null ? other$user != null : !this$user.equals(other$user));
    }

    protected boolean canEqual(Object other) {
        return other instanceof AuthResponse;
    }

    public int hashCode() {
        int PRIME = 59;
        int result = 1;
        String $token = this.getToken();
        result = result * 59 + ($token == null ? 43 : $token.hashCode());
        UserInfo $user = this.getUser();
        result = result * 59 + ($user == null ? 43 : $user.hashCode());
        return result;
    }

    public String toString() {
        return "AuthResponse(token=" + this.getToken() + ", user=" + String.valueOf(this.getUser()) + ")";
    }

    public AuthResponse() {
    }

    public AuthResponse(String token, UserInfo user) {
        this.token = token;
        this.user = user;
    }
}

