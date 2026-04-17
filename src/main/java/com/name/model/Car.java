package com.name.model;

public class Car {

    private int     carId;
    private String  name;
    private String  brand;
    private double  price;
    private boolean availability;
    private String  imageUrl;   // relative path, e.g. /uploads/cars/12345_civic.jpg

    public Car() {}

    public int     getCarId()                      { return carId; }
    public void    setCarId(int carId)             { this.carId = carId; }
    public String  getName()                       { return name; }
    public void    setName(String name)            { this.name = name; }
    public String  getBrand()                      { return brand; }
    public void    setBrand(String brand)          { this.brand = brand; }
    public double  getPrice()                      { return price; }
    public void    setPrice(double price)          { this.price = price; }
    public boolean isAvailability()                { return availability; }
    public void    setAvailability(boolean avail)  { this.availability = avail; }
    public String  getImageUrl()                   { return imageUrl; }
    public void    setImageUrl(String imageUrl)    { this.imageUrl = imageUrl; }
}