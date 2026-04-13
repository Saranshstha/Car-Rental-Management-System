package com.name.model;

import java.sql.Date;

public class Rental {

    private int rentalId;
    private int userId;
    private int carId;
    private Date rentalDate;
    private String carName;
    private String carBrand;
    private double carPrice;

    public Rental() {}

    public int getRentalId()                   { return rentalId; }
    public void setRentalId(int rentalId)      { this.rentalId = rentalId; }
    public int getUserId()                     { return userId; }
    public void setUserId(int userId)          { this.userId = userId; }
    public int getCarId()                      { return carId; }
    public void setCarId(int carId)            { this.carId = carId; }
    public Date getRentalDate()                { return rentalDate; }
    public void setRentalDate(Date d)          { this.rentalDate = d; }
    public String getCarName()                 { return carName; }
    public void setCarName(String carName)     { this.carName = carName; }
    public String getCarBrand()                { return carBrand; }
    public void setCarBrand(String carBrand)   { this.carBrand = carBrand; }
    public double getCarPrice()                { return carPrice; }
    public void setCarPrice(double carPrice)   { this.carPrice = carPrice; }
}