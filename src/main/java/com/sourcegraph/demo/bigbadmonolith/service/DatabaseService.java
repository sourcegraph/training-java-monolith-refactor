package com.sourcegraph.demo.bigbadmonolith.service;

import com.sourcegraph.demo.bigbadmonolith.dao.ConnectionManager;
import com.sourcegraph.demo.bigbadmonolith.dao.UserDAO;
import com.sourcegraph.demo.bigbadmonolith.entity.User;
import java.util.List;

public class DatabaseService {
    private final UserDAO userDAO = new UserDAO();
    
    public static void shutdown() {
        ConnectionManager.shutdown();
    }
    
    public User saveUser(User user) {
        return userDAO.save(user);
    }
    
    public User findUserById(Long id) {
        return userDAO.findById(id);
    }
    
    public List<User> findAllUsers() {
        return userDAO.findAll();
    }
    
    public User findUserByEmail(String email) {
        return userDAO.findByEmail(email);
    }
    
    public boolean deleteUser(Long id) {
        return userDAO.delete(id);
    }
    
    public User updateUser(User user) {
        return userDAO.update(user);
    }
}
