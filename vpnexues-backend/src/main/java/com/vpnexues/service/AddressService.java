package com.vpnexues.service;

import com.vpnexues.dto.AddressRequest;
import com.vpnexues.model.Address;
import com.vpnexues.repository.AddressRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
public class AddressService {

    private final AddressRepository addressRepository;

    public AddressService(AddressRepository addressRepository) {
        this.addressRepository = addressRepository;
    }

    public List<Address> getAddresses(String userId) {
        return addressRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId);
    }

    public Address getDefaultAddress(String userId) {
        return addressRepository.findByUserIdAndIsDefaultTrue(userId).orElse(null);
    }

    @Transactional
    public Address addAddress(String userId, AddressRequest request) {
        if (request.isDefault()) {
            unsetAllDefaults(userId);
        }
        Address address = new Address();
        address.setId(UUID.randomUUID().toString());
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
        return addressRepository.save(address);
    }

    @Transactional
    public Address updateAddress(String userId, String addressId, AddressRequest request) {
        Address address = addressRepository.findById(addressId)
                .filter(a -> a.getUserId().equals(userId))
                .orElseThrow(() -> new RuntimeException("Address not found"));
        if (request.isDefault()) {
            unsetAllDefaults(userId);
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
        return addressRepository.save(address);
    }

    @Transactional
    public void deleteAddress(String userId, String addressId) {
        addressRepository.deleteByUserIdAndId(userId, addressId);
    }

    @Transactional
    public void setDefault(String userId, String addressId) {
        unsetAllDefaults(userId);
        Address address = addressRepository.findById(addressId)
                .filter(a -> a.getUserId().equals(userId))
                .orElseThrow(() -> new RuntimeException("Address not found"));
        address.setDefault(true);
        addressRepository.save(address);
    }

    private void unsetAllDefaults(String userId) {
        List<Address> addresses = addressRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId);
        for (Address address : addresses) {
            if (address.isDefault()) {
                address.setDefault(false);
                addressRepository.save(address);
            }
        }
    }
}
