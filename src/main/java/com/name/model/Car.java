package com.name.model;

public class Car {
    private int     carId;
    private String  name;
    private String  brand;
    private double  price;
    private boolean availability;
    private String  imageUrl;

    public Car() {}

    public int     getCarId()                     { return carId; }
    public void    setCarId(int v)                { this.carId = v; }
    public String  getName()                      { return name; }
    public void    setName(String v)              { this.name = v; }
    public String  getBrand()                     { return brand; }
    public void    setBrand(String v)             { this.brand = v; }
    public double  getPrice()                     { return price; }
    public void    setPrice(double v)             { this.price = v; }
    public boolean isAvailability()               { return availability; }
    public void    setAvailability(boolean v)     { this.availability = v; }
    public String  getImageUrl()                  { return imageUrl; }
    public void    setImageUrl(String v)          { this.imageUrl = v; }
}