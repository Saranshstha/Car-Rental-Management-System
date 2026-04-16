package com.name.model;

import java.sql.Date;

public class Rental {

    private int    rentalId;
    private int    userId;
    private int    carId;
    private Date   rentalDate;
    private String carName;
    private String carBrand;
    private double carPrice;
    private int    days;
    private double totalCost;
    private String renterName;
    private String renterEmail;
    private String renterPhone;

    public Rental() {}

    public int    getRentalId()               { return rentalId; }
    public void   setRentalId(int v)          { this.rentalId = v; }
    public int    getUserId()                 { return userId; }
    public void   setUserId(int v)            { this.userId = v; }
    public int    getCarId()                  { return carId; }
    public void   setCarId(int v)             { this.carId = v; }
    public Date   getRentalDate()             { return rentalDate; }
    public void   setRentalDate(Date v)       { this.rentalDate = v; }
    public String getCarName()                { return carName; }
    public void   setCarName(String v)        { this.carName = v; }
    public String getCarBrand()               { return carBrand; }
    public void   setCarBrand(String v)       { this.carBrand = v; }
    public double getCarPrice()               { return carPrice; }
    public void   setCarPrice(double v)       { this.carPrice = v; }
    public int    getDays()                   { return days; }
    public void   setDays(int v)              { this.days = v; }
    public double getTotalCost()              { return totalCost; }
    public void   setTotalCost(double v)      { this.totalCost = v; }
    public String getRenterName()             { return renterName; }
    public void   setRenterName(String v)     { this.renterName = v; }
    public String getRenterEmail()            { return renterEmail; }
    public void   setRenterEmail(String v)    { this.renterEmail = v; }
    public String getRenterPhone()            { return renterPhone; }
    public void   setRenterPhone(String v)    { this.renterPhone = v; }
}
