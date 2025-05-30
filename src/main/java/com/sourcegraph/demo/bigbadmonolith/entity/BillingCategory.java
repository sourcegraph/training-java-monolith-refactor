package com.sourcegraph.demo.bigbadmonolith.entity;

import java.math.BigDecimal;

public class BillingCategory {
    private Long id;
    private String name;
    private String description;
    private BigDecimal hourlyRate;

    public BillingCategory() {}

    public BillingCategory(String name, String description, BigDecimal hourlyRate) {
        this.name = name;
        this.description = description;
        this.hourlyRate = hourlyRate;
    }

    public BillingCategory(Long id, String name, String description, BigDecimal hourlyRate) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.hourlyRate = hourlyRate;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getHourlyRate() {
        return hourlyRate;
    }

    public void setHourlyRate(BigDecimal hourlyRate) {
        this.hourlyRate = hourlyRate;
    }
}
