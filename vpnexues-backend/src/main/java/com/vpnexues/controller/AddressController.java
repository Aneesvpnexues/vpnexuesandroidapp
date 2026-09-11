package com.vpnexues.controller;

import com.vpnexues.dto.ApiResponse;
import com.vpnexues.dto.AddressRequest;
import com.vpnexues.model.Address;
import com.vpnexues.service.AddressService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/addresses")
public class AddressController {

    private final AddressService addressService;

    public AddressController(AddressService addressService) {
        this.addressService = addressService;
    }

    @GetMapping
    public ResponseEntity<List<Address>> getAddresses() {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(addressService.getAddresses(userId));
    }

    @GetMapping("/default")
    public ResponseEntity<Address> getDefaultAddress() {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        Address address = addressService.getDefaultAddress(userId);
        if (address == null) {
            return ResponseEntity.ok(null);
        }
        return ResponseEntity.ok(address);
    }

    @PostMapping
    public ResponseEntity<Address> addAddress(@Valid @RequestBody AddressRequest request) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(addressService.addAddress(userId, request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Address> updateAddress(@PathVariable String id, @Valid @RequestBody AddressRequest request) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(addressService.updateAddress(userId, id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse> deleteAddress(@PathVariable String id) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        addressService.deleteAddress(userId, id);
        return ResponseEntity.ok(ApiResponse.success("Address deleted successfully"));
    }

    @PutMapping("/{id}/default")
    public ResponseEntity<ApiResponse> setDefault(@PathVariable String id) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        addressService.setDefault(userId, id);
        return ResponseEntity.ok(ApiResponse.success("Default address updated"));
    }
}
