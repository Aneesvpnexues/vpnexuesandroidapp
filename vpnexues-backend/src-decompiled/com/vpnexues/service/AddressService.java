/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.dto.AddressRequest
 *  com.vpnexues.model.Address
 *  com.vpnexues.repository.AddressRepository
 *  com.vpnexues.service.AddressService
 *  org.springframework.stereotype.Service
 */
package com.vpnexues.service;

import com.vpnexues.dto.AddressRequest;
import com.vpnexues.model.Address;
import com.vpnexues.repository.AddressRepository;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class AddressService {
    private final AddressRepository addressRepository;

    public List<Address> getAddresses(String userId) {
        return this.addressRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId);
    }

    public Address getDefaultAddress(String userId) {
        return this.addressRepository.findByUserIdAndIsDefaultTrue(userId).orElse(null);
    }

    public Address addAddress(String userId, AddressRequest request) {
        if (request.isDefault() || this.addressRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId).isEmpty()) {
            this.unsetAllDefaults(userId);
        }
        Address address = new Address();
        address.setUserId(userId);
        address.setLabel(request.getLabel());
        address.setFullName(request.getFullName());
        address.setPhone(request.getPhone());
        address.setAddressLine1(request.getAddressLine1());
        address.setAddressLine2(request.getAddressLine2());
        address.setCity(request.getCity());
        address.setState(request.getState());
        address.setPincode(request.getPincode());
        address.setCountry(request.getCountry());
        address.setLatitude(request.getLatitude());
        address.setLongitude(request.getLongitude());
        address.setDefault(request.isDefault());
        List existing = this.addressRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId);
        if (existing.isEmpty()) {
            address.setDefault(true);
        }
        return (Address)this.addressRepository.save((Object)address);
    }

    public Address updateAddress(String userId, String addressId, AddressRequest request) {
        Address address = (Address)this.addressRepository.findById((Object)addressId).orElseThrow(() -> new RuntimeException("Address not found"));
        if (!address.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized to update this address");
        }
        if (request.isDefault()) {
            this.unsetAllDefaults(userId);
        }
        address.setLabel(request.getLabel());
        address.setFullName(request.getFullName());
        address.setPhone(request.getPhone());
        address.setAddressLine1(request.getAddressLine1());
        address.setAddressLine2(request.getAddressLine2());
        address.setCity(request.getCity());
        address.setState(request.getState());
        address.setPincode(request.getPincode());
        address.setCountry(request.getCountry());
        address.setLatitude(request.getLatitude());
        address.setLongitude(request.getLongitude());
        address.setDefault(request.isDefault());
        return (Address)this.addressRepository.save((Object)address);
    }

    public void deleteAddress(String userId, String addressId) {
        List remaining;
        Address address = (Address)this.addressRepository.findById((Object)addressId).orElseThrow(() -> new RuntimeException("Address not found"));
        if (!address.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized to delete this address");
        }
        boolean wasDefault = address.isDefault();
        this.addressRepository.deleteById((Object)addressId);
        if (wasDefault && !(remaining = this.addressRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId)).isEmpty()) {
            Address newDefault = (Address)remaining.get(0);
            newDefault.setDefault(true);
            this.addressRepository.save((Object)newDefault);
        }
    }

    public Address setDefault(String userId, String addressId) {
        Address address = (Address)this.addressRepository.findById((Object)addressId).orElseThrow(() -> new RuntimeException("Address not found"));
        if (!address.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized");
        }
        this.unsetAllDefaults(userId);
        address.setDefault(true);
        return (Address)this.addressRepository.save((Object)address);
    }

    private void unsetAllDefaults(String userId) {
        List addresses = this.addressRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId);
        for (Address addr : addresses) {
            if (!addr.isDefault()) continue;
            addr.setDefault(false);
            this.addressRepository.save((Object)addr);
        }
    }

    public AddressService(AddressRepository addressRepository) {
        this.addressRepository = addressRepository;
    }
}

