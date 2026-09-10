/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.controller.AddressController
 *  com.vpnexues.dto.AddressRequest
 *  com.vpnexues.dto.ApiResponse
 *  com.vpnexues.model.Address
 *  com.vpnexues.service.AddressService
 *  jakarta.validation.Valid
 *  org.springframework.http.ResponseEntity
 *  org.springframework.security.core.Authentication
 *  org.springframework.security.core.context.SecurityContextHolder
 *  org.springframework.web.bind.annotation.DeleteMapping
 *  org.springframework.web.bind.annotation.GetMapping
 *  org.springframework.web.bind.annotation.PathVariable
 *  org.springframework.web.bind.annotation.PostMapping
 *  org.springframework.web.bind.annotation.PutMapping
 *  org.springframework.web.bind.annotation.RequestBody
 *  org.springframework.web.bind.annotation.RequestMapping
 *  org.springframework.web.bind.annotation.RestController
 */
package com.vpnexues.controller;

import com.vpnexues.dto.AddressRequest;
import com.vpnexues.dto.ApiResponse;
import com.vpnexues.model.Address;
import com.vpnexues.service.AddressService;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value={"/api/addresses"})
public class AddressController {
    private final AddressService addressService;

    private String getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth.getName();
    }

    @GetMapping
    public ResponseEntity<List<Address>> getAddresses() {
        String userId = this.getCurrentUserId();
        return ResponseEntity.ok((Object)this.addressService.getAddresses(userId));
    }

    @GetMapping(value={"/default"})
    public ResponseEntity<Address> getDefaultAddress() {
        String userId = this.getCurrentUserId();
        Address address = this.addressService.getDefaultAddress(userId);
        if (address == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok((Object)address);
    }

    @PostMapping
    public ResponseEntity<Address> addAddress(@Valid @RequestBody AddressRequest request) {
        String userId = this.getCurrentUserId();
        return ResponseEntity.ok((Object)this.addressService.addAddress(userId, request));
    }

    @PutMapping(value={"/{id}"})
    public ResponseEntity<Address> updateAddress(@PathVariable String id, @Valid @RequestBody AddressRequest request) {
        String userId = this.getCurrentUserId();
        return ResponseEntity.ok((Object)this.addressService.updateAddress(userId, id, request));
    }

    @DeleteMapping(value={"/{id}"})
    public ResponseEntity<ApiResponse> deleteAddress(@PathVariable String id) {
        String userId = this.getCurrentUserId();
        this.addressService.deleteAddress(userId, id);
        return ResponseEntity.ok((Object)ApiResponse.success((String)"Address deleted"));
    }

    @PutMapping(value={"/{id}/default"})
    public ResponseEntity<Address> setDefaultAddress(@PathVariable String id) {
        String userId = this.getCurrentUserId();
        return ResponseEntity.ok((Object)this.addressService.setDefault(userId, id));
    }

    public AddressController(AddressService addressService) {
        this.addressService = addressService;
    }
}

