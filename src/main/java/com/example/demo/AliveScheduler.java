package com.example.demo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class AliveScheduler {

    private static final Logger log = LoggerFactory.getLogger(AliveScheduler.class);

    // Runs every 5 seconds
    @Scheduled(fixedRate = 5000)
    public void reportAlive() {
        System.out.println("Project is alive");
        // also log via slf4j
        log.info("Project is alive");
    }
}
