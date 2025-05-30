package com.sourcegraph.demo.bigbadmonolith.entity;

import org.joda.time.DateTime;
import org.joda.time.LocalDate;

import java.math.BigDecimal;

public class BillableHour {
    private Long id;
    private Long customerId;
    private Long userId;
    private Long categoryId;
    private BigDecimal hours;
    private String note;
    private LocalDate dateLogged;
    private DateTime createdAt;

    public BillableHour() {}

    public BillableHour(Long customerId, Long userId, Long categoryId, BigDecimal hours, String note, LocalDate dateLogged) {
        this.customerId = customerId;
        this.userId = userId;
        this.categoryId = categoryId;
        this.hours = hours;
        this.note = note;
        this.dateLogged = dateLogged;
        this.createdAt = DateTime.now();
    }

    public BillableHour(Long id, Long customerId, Long userId, Long categoryId, BigDecimal hours, String note, LocalDate dateLogged, DateTime createdAt) {
        this.id = id;
        this.customerId = customerId;
        this.userId = userId;
        this.categoryId = categoryId;
        this.hours = hours;
        this.note = note;
        this.dateLogged = dateLogged;
        this.createdAt = createdAt;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Long customerId) {
        this.customerId = customerId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }

    public BigDecimal getHours() {
        return hours;
    }

    public void setHours(BigDecimal hours) {
        this.hours = hours;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public LocalDate getDateLogged() {
        return dateLogged;
    }

    public void setDateLogged(LocalDate dateLogged) {
        this.dateLogged = dateLogged;
    }

    public DateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(DateTime createdAt) {
        this.createdAt = createdAt;
    }
}
