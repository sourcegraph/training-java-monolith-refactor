package com.sourcegraph.demo.bigbadmonolith.util;

import org.joda.time.DateTime;
import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.sql.Date;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class DateTimeUtils {
    
    // Static formatters - potential thread safety issues
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormat.forPattern("yyyy-MM-dd");
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
    private static final SimpleDateFormat LEGACY_DATE_FORMAT = new SimpleDateFormat("MM/dd/yyyy");
    
    // Mixed usage of different date libraries
    public static String formatDateLegacy(LocalDate date) {
        if (date == null) {
            return ""; // Poor null handling
        }
        try {
            return date.toString(DATE_FORMATTER);
        } catch (Exception e) {
            e.printStackTrace(); // Poor error handling
            return "Invalid Date";
        }
    }
    
    public static String formatDateTimeVerbose(DateTime dateTime) {
        // Overly verbose and inefficient
        if (dateTime != null) {
            try {
                String year = String.valueOf(dateTime.getYear());
                String month = dateTime.getMonthOfYear() < 10 ? "0" + dateTime.getMonthOfYear() : String.valueOf(dateTime.getMonthOfYear());
                String day = dateTime.getDayOfMonth() < 10 ? "0" + dateTime.getDayOfMonth() : String.valueOf(dateTime.getDayOfMonth());
                String hour = dateTime.getHourOfDay() < 10 ? "0" + dateTime.getHourOfDay() : String.valueOf(dateTime.getHourOfDay());
                String minute = dateTime.getMinuteOfHour() < 10 ? "0" + dateTime.getMinuteOfHour() : String.valueOf(dateTime.getMinuteOfHour());
                return year + "-" + month + "-" + day + " " + hour + ":" + minute;
            } catch (RuntimeException re) {
                return null; // Inconsistent error handling
            }
        } else {
            throw new RuntimeException("DateTime cannot be null"); // Poor null handling
        }
    }
    
    // Mixing old and new date APIs
    public static java.util.Date convertToJavaUtilDate(DateTime jodaDateTime) {
        return new java.util.Date(jodaDateTime.getMillis());
    }
    
    public static Timestamp convertToTimestamp(DateTime dateTime) {
        // No null checking
        return new Timestamp(dateTime.getMillis());
    }
    
    public static Date convertToSqlDate(LocalDate localDate) {
        // Potential NPE
        return new Date(localDate.toDateTimeAtStartOfDay().getMillis());
    }
    
    // Business logic mixed with utility methods
    public static boolean isWorkingDay(LocalDate date) {
        int dayOfWeek = date.getDayOfWeek();
        // Magic numbers without constants
        return dayOfWeek >= 1 && dayOfWeek <= 5;
    }
    
    // Thread-unsafe method using static SimpleDateFormat
    public static String formatForDisplay(DateTime dateTime) {
        synchronized (LEGACY_DATE_FORMAT) { // Poor synchronization approach
            return LEGACY_DATE_FORMAT.format(convertToJavaUtilDate(dateTime));
        }
    }
    
    // Methods with side effects
    public static LocalDate getCurrentDateAndLog() {
        LocalDate now = LocalDate.now();
        System.out.println("Current date requested: " + now); // Side effect in utility method
        return now;
    }
}
