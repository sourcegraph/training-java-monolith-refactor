package com.sourcegraph.demo.bigbadmonolith;

import com.sourcegraph.demo.bigbadmonolith.dao.LibertyConnectionManager;
import com.sourcegraph.demo.bigbadmonolith.service.DataInitializationService;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class StartupListener implements ServletContextListener {
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            // Initialize database schema for Liberty if needed
            if (LibertyConnectionManager.isLibertyDataSourceAvailable()) {
                System.out.println("Running on WebSphere Liberty - using managed DataSource");
                LibertyConnectionManager.initializeDatabaseSchema();
            } else {
                System.out.println("Running in embedded mode - using embedded Derby");
            }
            
            // Initialize sample data
            DataInitializationService dataService = new DataInitializationService();
            dataService.initializeSampleData();
            System.out.println("Sample data initialized successfully");
        } catch (Exception e) {
            System.err.println("Failed to initialize application: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            // Only shutdown embedded Derby, Liberty manages its own DataSource
            if (!LibertyConnectionManager.isLibertyDataSourceAvailable()) {
                com.sourcegraph.demo.bigbadmonolith.dao.ConnectionManager.shutdown();
                System.out.println("Embedded Derby database shutdown successfully");
            } else {
                System.out.println("Liberty DataSource will be managed by server");
            }
        } catch (Exception e) {
            System.err.println("Failed to shutdown database: " + e.getMessage());
        }
    }
}
