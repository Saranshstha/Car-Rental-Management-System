package com.name.model;

import java.sql.Date;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class Rental {
    private int       rentalId;
    private int       userId;
    private int       carId;
    private Date      rentalDate;
    private String    carName;
    private String    carBrand;
    private double    carPrice;
    private String    carImageUrl;   // ← populated by JOIN on cars.image_url
    private int       days;
    private double    totalCost;
    private String    renterName;
    private String    renterEmail;
    private String    renterPhone;
    private String    renterLocation;
    private Timestamp pickupDatetime;
    private Timestamp returnDatetime;
    private int       isConfirmed;

    public Rental() {}

    // ── getters / setters ──────────────────────────────────────────
    public int       getRentalId()                  { return rentalId; }
    public void      setRentalId(int v)             { this.rentalId = v; }
    public int       getUserId()                    { return userId; }
    public void      setUserId(int v)               { this.userId = v; }
    public int       getCarId()                     { return carId; }
    public void      setCarId(int v)                { this.carId = v; }
    public Date      getRentalDate()                { return rentalDate; }
    public void      setRentalDate(Date v)          { this.rentalDate = v; }
    public String    getCarName()                   { return carName; }
    public void      setCarName(String v)           { this.carName = v; }
    public String    getCarBrand()                  { return carBrand; }
    public void      setCarBrand(String v)          { this.carBrand = v; }
    public double    getCarPrice()                  { return carPrice; }
    public void      setCarPrice(double v)          { this.carPrice = v; }
    public String    getCarImageUrl()               { return carImageUrl; }
    public void      setCarImageUrl(String v)       { this.carImageUrl = v; }
    public int       getDays()                      { return days > 0 ? days : 1; }
    public void      setDays(int v)                 { this.days = v; }
    public double    getTotalCost()                 { return totalCost; }
    public void      setTotalCost(double v)         { this.totalCost = v; }
    public String    getRenterName()                { return renterName != null ? renterName : ""; }
    public void      setRenterName(String v)        { this.renterName = v; }
    public String    getRenterEmail()               { return renterEmail != null ? renterEmail : ""; }
    public void      setRenterEmail(String v)       { this.renterEmail = v; }
    public String    getRenterPhone()               { return renterPhone != null ? renterPhone : ""; }
    public void      setRenterPhone(String v)       { this.renterPhone = v; }
    public String    getRenterLocation()            { return renterLocation != null ? renterLocation : ""; }
    public void      setRenterLocation(String v)    { this.renterLocation = v; }
    public Timestamp getPickupDatetime()            { return pickupDatetime; }
    public void      setPickupDatetime(Timestamp v) { this.pickupDatetime = v; }
    public Timestamp getReturnDatetime()            { return returnDatetime; }
    public void      setReturnDatetime(Timestamp v) { this.returnDatetime = v; }
    public int       getIsConfirmed()               { return isConfirmed; }
    public void      setIsConfirmed(int v)          { this.isConfirmed = v; }

    // ── derived helpers used by JSP EL ─────────────────────────────

    /** "EXPIRED", "CONFIRMED", or "ACTIVE" */
    public String getStatusLabel() {
        if (returnDatetime != null && returnDatetime.before(new java.util.Date())) return "EXPIRED";
        return isConfirmed == 1 ? "CONFIRMED" : "ACTIVE";
    }

    /** Only ACTIVE (not confirmed, not expired) can be cancelled */
    public boolean isCanCancel() {
        return isConfirmed == 0
               && (returnDatetime == null || returnDatetime.after(new java.util.Date()));
    }

    /** Formatted "yyyy-MM-dd HH:mm" for display */
    public String getFormattedPickup() {
        if (pickupDatetime == null) return "";
        return new SimpleDateFormat("yyyy-MM-dd HH:mm").format(pickupDatetime);
    }

    public String getFormattedReturn() {
        if (returnDatetime == null) return "";
        return new SimpleDateFormat("yyyy-MM-dd HH:mm").format(returnDatetime);
    }

    /** ISO string for JS countdown  e.g. "2026-04-18T10:00:00" */
    public String getReturnIso() {
        if (returnDatetime == null) return "";
        return new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").format(returnDatetime);
    }
}