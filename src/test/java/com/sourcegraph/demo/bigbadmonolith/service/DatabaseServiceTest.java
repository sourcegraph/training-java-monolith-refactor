package com.sourcegraph.demo.bigbadmonolith.service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.AfterAll;
import com.sourcegraph.demo.bigbadmonolith.entity.User;
import static org.junit.jupiter.api.Assertions.*;

class DatabaseServiceTest {
    
    private DatabaseService dbService;
    
    @BeforeEach
    void setUp() {
        dbService = new DatabaseService();
    }
    
    @AfterAll
    static void tearDownAll() {
        DatabaseService.shutdown();
    }
    
    @Test
    void testSaveAndFindUser() {
        String uniqueEmail = "test" + System.currentTimeMillis() + "@example.com";
        User user = new User(uniqueEmail, "Test User");
        User savedUser = dbService.saveUser(user);
        
        assertNotNull(savedUser.getId());
        assertEquals(uniqueEmail, savedUser.getEmail());
        assertEquals("Test User", savedUser.getName());
        
        User foundUser = dbService.findUserById(savedUser.getId());
        assertNotNull(foundUser);
        assertEquals(savedUser.getId(), foundUser.getId());
        assertEquals(uniqueEmail, foundUser.getEmail());
    }
    
    @Test
    void testFindUserByEmail() {
        String uniqueEmail = "email" + System.currentTimeMillis() + "@test.com";
        User user = new User(uniqueEmail, "Email Test");
        dbService.saveUser(user);
        
        User foundUser = dbService.findUserByEmail(uniqueEmail);
        assertNotNull(foundUser);
        assertEquals("Email Test", foundUser.getName());
        
        User notFound = dbService.findUserByEmail("nonexistent@test.com");
        assertNull(notFound);
    }
    
    @Test
    void testFindAllUsers() {
        int initialCount = dbService.findAllUsers().size();
        
        String email1 = "user1" + System.currentTimeMillis() + "@test.com";
        String email2 = "user2" + System.currentTimeMillis() + "@test.com";
        
        dbService.saveUser(new User(email1, "User One"));
        dbService.saveUser(new User(email2, "User Two"));
        
        int finalCount = dbService.findAllUsers().size();
        assertEquals(initialCount + 2, finalCount);
    }
}
