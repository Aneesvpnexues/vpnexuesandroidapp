package com.vpnexues;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
public class VpnexuesApplication {
    public static void main(String[] args) {
        SpringApplication.run(VpnexuesApplication.class, args);
    }
}
