/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.model.Product
 *  com.vpnexues.repository.ProductRepository
 *  com.vpnexues.service.SeedDataRunner
 *  org.slf4j.Logger
 *  org.slf4j.LoggerFactory
 *  org.springframework.boot.CommandLineRunner
 *  org.springframework.stereotype.Component
 */
package com.vpnexues.service;

import com.vpnexues.model.Product;
import com.vpnexues.repository.ProductRepository;
import java.util.ArrayList;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class SeedDataRunner
implements CommandLineRunner {
    private static final Logger log = LoggerFactory.getLogger(SeedDataRunner.class);
    private final ProductRepository productRepository;

    public void run(String ... args) {
        if (this.productRepository.count() > 0L) {
            log.info("Database already seeded. Skipping...");
            return;
        }
        log.info("Seeding database with 180 products...");
        ArrayList<Product> products = new ArrayList<Product>();
        products.add(this.createProduct("v1", "Organic Carrots", "Fresh Organic", "vegetables", 230.0, 290.0, "20% OFF", "500g", true));
        products.add(this.createProduct("v2", "Vine Tomatoes", "Fresh Organic", "vegetables", 324.0, 399.0, "18% OFF", "1 kg", true));
        products.add(this.createProduct("v3", "Baby Spinach", "Fresh Organic", "vegetables", 266.0, 320.0, "16% OFF", "200g", true));
        products.add(this.createProduct("v4", "Sweet Corn", "Fresh Organic", "vegetables", 158.0, 208.0, "24% OFF", "1 pc", true));
        products.add(this.createProduct("v5", "Red Onions", "Fresh Organic", "vegetables", 183.0, 232.0, "21% OFF", "1 kg", true));
        products.add(this.createProduct("v6", "Bell Peppers Mix", "Fresh Organic", "vegetables", 374.0, 482.0, "22% OFF", "3 pcs", true));
        products.add(this.createProduct("v7", "Broccoli Head", "Fresh Organic", "vegetables", 291.0, 349.0, "16% OFF", "1 pc", true, true));
        products.add(this.createProduct("v8", "Cucumber", "Fresh Organic", "vegetables", 149.0, 190.0, "21% OFF", "1 pc", true));
        products.add(this.createProduct("v9", "Zucchini", "Fresh Organic", "vegetables", 241.0, 299.0, "19% OFF", "500g", true));
        products.add(this.createProduct("v10", "Cherry Tomatoes", "Fresh Organic", "vegetables", 349.0, 415.0, "15% OFF", "250g", true));
        products.add(this.createProduct("v11", "Kale Bunch", "Fresh Organic", "vegetables", 316.0, 380.0, "16% OFF", "1 bunch", true));
        products.add(this.createProduct("v12", "Purple Cabbage", "Fresh Organic", "vegetables", 266.0, 332.0, "19% OFF", "1 pc", true));
        products.add(this.createProduct("v13", "Cauliflower", "Fresh Organic", "vegetables", 324.0, 399.0, "18% OFF", "1 pc", true));
        products.add(this.createProduct("v14", "White Radish", "Fresh Organic", "vegetables", 208.0, 250.0, "16% OFF", "1 kg", true));
        products.add(this.createProduct("v15", "Sweet Potato", "Fresh Organic", "vegetables", 258.0, 316.0, "18% OFF", "1 kg", true));
        products.add(this.createProduct("v16", "Green Beans", "Fresh Organic", "vegetables", 233.0, 282.0, "17% OFF", "300g", true));
        products.add(this.createProduct("v17", "Leek", "Fresh Organic", "vegetables", 241.0, 290.0, "16% OFF", "2 pcs", true));
        products.add(this.createProduct("v18", "Beetroot", "Fresh Organic", "vegetables", 291.0, 349.0, "16% OFF", "1 kg", true));
        products.add(this.createProduct("v19", "Celery", "Fresh Organic", "vegetables", 200.0, 240.0, "16% OFF", "1 bunch", true));
        products.add(this.createProduct("v20", "Pumpkin", "Fresh Organic", "vegetables", 399.0, 498.0, "19% OFF", "1 kg", true));
        products.add(this.createProduct("v21", "Eggplant", "Fresh Organic", "vegetables", 216.0, 266.0, "18% OFF", "1 pc", true));
        products.add(this.createProduct("v22", "Asparagus", "Fresh Organic", "vegetables", 490.0, 623.0, "21% OFF", "1 bunch", true));
        products.add(this.createProduct("v23", "Pak Choi", "Fresh Organic", "vegetables", 183.0, 220.0, "16% OFF", "1 bunch", true));
        products.add(this.createProduct("v24", "Okra / Ladyfinger", "Fresh Organic", "vegetables", 233.0, 291.0, "19% OFF", "300g", true));
        products.add(this.createProduct("v25", "Spring Onions", "Fresh Organic", "vegetables", 125.0, 150.0, "16% OFF", "1 bunch", true));
        products.add(this.createProduct("v26", "Coriander", "Fresh Organic", "vegetables", 100.0, 120.0, "16% OFF", "1 bunch", true));
        products.add(this.createProduct("v27", "Mint Leaves", "Fresh Organic", "vegetables", 125.0, 150.0, "16% OFF", "1 bunch", true));
        products.add(this.createProduct("v28", "Bitter Gourd", "Fresh Organic", "vegetables", 200.0, 249.0, "19% OFF", "500g", true));
        products.add(this.createProduct("v29", "Long Beans", "Fresh Organic", "vegetables", 183.0, 220.0, "16% OFF", "300g", true));
        products.add(this.createProduct("v30", "French Beans", "Fresh Organic", "vegetables", 266.0, 332.0, "19% OFF", "250g", true));
        products.add(this.createProduct("v31", "Drumstick (Moringa)", "Fresh Organic", "vegetables", 291.0, 350.0, "16% OFF", "1 bunch", true));
        products.add(this.createProduct("v32", "Bottle Gourd", "Fresh Organic", "vegetables", 216.0, 266.0, "18% OFF", "1 pc", true));
        products.add(this.createProduct("v33", "Taro Root", "Fresh Organic", "vegetables", 316.0, 374.0, "15% OFF", "1 kg", true));
        products.add(this.createProduct("v34", "Lotus Root", "Fresh Organic", "vegetables", 349.0, 415.0, "15% OFF", "500g", true));
        products.add(this.createProduct("v35", "Curry Leaves", "Fresh Organic", "vegetables", 100.0, 120.0, "16% OFF", "1 bunch", true));
        products.add(this.createProduct("v36", "Chilli Peppers", "Fresh Organic", "vegetables", 175.0, 216.0, "18% OFF", "100g", true));
        products.add(this.createProduct("v37", "Green Capsicum", "Fresh Organic", "vegetables", 283.0, 349.0, "18% OFF", "3 pcs", true));
        products.add(this.createProduct("v38", "Watercress", "Fresh Organic", "vegetables", 233.0, 280.0, "16% OFF", "1 bunch", true));
        products.add(this.createProduct("v39", "Yam (Purple)", "Fresh Organic", "vegetables", 374.0, 457.0, "18% OFF", "1 kg", true));
        products.add(this.createProduct("v40", "Bitter Melon", "Fresh Organic", "vegetables", 216.0, 266.0, "18% OFF", "500g", true));
        products.add(this.createProduct("v41", "Iceberg Lettuce", "Fresh Organic", "vegetables", 241.0, 290.0, "16% OFF", "1 pc", true));
        products.add(this.createProduct("v42", "Butterhead Lettuce", "Fresh Organic", "vegetables", 266.0, 324.0, "17% OFF", "1 pc", true));
        products.add(this.createProduct("v43", "Turnip", "Fresh Organic", "vegetables", 200.0, 240.0, "16% OFF", "1 kg", true));
        products.add(this.createProduct("v44", "Fennel Bulb", "Fresh Organic", "vegetables", 349.0, 415.0, "15% OFF", "1 pc", true));
        products.add(this.createProduct("v45", "Pointed Gourd", "Fresh Organic", "vegetables", 233.0, 291.0, "19% OFF", "500g", true));
        products.add(this.createProduct("v46", "Cluster Beans", "Fresh Organic", "vegetables", 208.0, 250.0, "16% OFF", "300g", true));
        products.add(this.createProduct("v47", "Ridge Gourd", "Fresh Organic", "vegetables", 216.0, 266.0, "18% OFF", "1 pc", true));
        products.add(this.createProduct("v48", "Colocasia Leaves", "Fresh Organic", "vegetables", 183.0, 220.0, "16% OFF", "1 bunch", true));
        products.add(this.createProduct("v49", "Snake Gourd", "Fresh Organic", "vegetables", 241.0, 299.0, "19% OFF", "1 pc", true));
        products.add(this.createProduct("v50", "Banana Flower", "Fresh Organic", "vegetables", 291.0, 349.0, "16% OFF", "1 pc", true));
        products.add(this.createProduct("f1", "Alphonso Mango", "Fresh Organic", "fruits", 996.0, 1245.0, "19% OFF", "3 pcs", true));
        products.add(this.createProduct("f2", "Fresh Bananas", "Fresh Organic", "fruits", 266.0, 332.0, "19% OFF", "1 bunch", true));
        products.add(this.createProduct("f3", "Dragon Fruit", "Fresh Organic", "fruits", 623.0, 813.0, "23% OFF", "1 pc", true));
        products.add(this.createProduct("f4", "Green Apples", "Fresh Organic", "fruits", 482.0, 598.0, "19% OFF", "1 kg", true));
        products.add(this.createProduct("f5", "Papaya", "Fresh Organic", "fruits", 457.0, 581.0, "21% OFF", "1 kg", true));
        products.add(this.createProduct("f6", "Pomegranate", "Fresh Organic", "fruits", 731.0, 913.0, "19% OFF", "2 pcs", true));
        products.add(this.createProduct("f7", "Fresh Pineapple", "Fresh Organic", "fruits", 565.0, 706.0, "20% OFF", "1 pc", true));
        products.add(this.createProduct("f8", "Watermelon", "Fresh Organic", "fruits", 664.0, 830.0, "20% OFF", "1 pc", true));
        products.add(this.createProduct("f9", "Red Grapes", "Fresh Organic", "fruits", 598.0, 747.0, "20% OFF", "500g", true));
        products.add(this.createProduct("f10", "Strawberries", "Fresh Organic", "fruits", 822.0, 996.0, "17% OFF", "250g", true, true));
        products.add(this.createProduct("f11", "Orange Navel", "Fresh Organic", "fruits", 540.0, 664.0, "18% OFF", "1 kg", true));
        products.add(this.createProduct("f12", "Lemon", "Fresh Organic", "fruits", 233.0, 280.0, "16% OFF", "6 pcs", true));
        products.add(this.createProduct("f13", "Kiwi Fruit", "Fresh Organic", "fruits", 465.0, 581.0, "19% OFF", "4 pcs", true));
        products.add(this.createProduct("f14", "Ripe Avocado", "Fresh Organic", "fruits", 573.0, 706.0, "18% OFF", "2 pcs", true));
        products.add(this.createProduct("f15", "Blueberries", "Fresh Organic", "fruits", 913.0, 1162.0, "21% OFF", "125g", true));
        products.add(this.createProduct("f16", "Passion Fruit", "Fresh Organic", "fruits", 515.0, 664.0, "22% OFF", "4 pcs", true));
        products.add(this.createProduct("f17", "Guava", "Fresh Organic", "fruits", 316.0, 399.0, "20% OFF", "500g", true));
        products.add(this.createProduct("f18", "Sapodilla (Chiku)", "Fresh Organic", "fruits", 374.0, 457.0, "18% OFF", "500g", true));
        products.add(this.createProduct("f19", "Jackfruit", "Fresh Organic", "fruits", 706.0, 850.0, "16% OFF", "500g", true));
        products.add(this.createProduct("f20", "Rambutan", "Fresh Organic", "fruits", 565.0, 664.0, "14% OFF", "500g", true));
        products.add(this.createProduct("f21", "Longan", "Fresh Organic", "fruits", 598.0, 747.0, "20% OFF", "500g", true));
        products.add(this.createProduct("f22", "Star Fruit", "Fresh Organic", "fruits", 349.0, 415.0, "15% OFF", "3 pcs", true));
        products.add(this.createProduct("f23", "Custard Apple", "Fresh Organic", "fruits", 482.0, 581.0, "17% OFF", "1 pc", true));
        products.add(this.createProduct("f24", "Pear", "Fresh Organic", "fruits", 515.0, 664.0, "22% OFF", "1 kg", true));
        products.add(this.createProduct("f25", "Dates Medjool", "Fresh Organic", "fruits", 1038.0, 1328.0, "21% OFF", "250g", true));
        products.add(this.createProduct("f26", "Fig", "Fresh Organic", "fruits", 822.0, 996.0, "17% OFF", "250g", true));
        products.add(this.createProduct("f27", "Plums", "Fresh Organic", "fruits", 623.0, 747.0, "16% OFF", "500g", true));
        products.add(this.createProduct("f28", "Cherries", "Fresh Organic", "fruits", 1162.0, 1494.0, "22% OFF", "250g", true));
        products.add(this.createProduct("f29", "Red Banana", "Fresh Organic", "fruits", 374.0, 482.0, "22% OFF", "1 bunch", true));
        products.add(this.createProduct("f30", "Coconut (Fresh)", "Fresh Organic", "fruits", 291.0, 350.0, "16% OFF", "1 pc", true));
        products.add(this.createProduct("f31", "Soursop", "Fresh Organic", "fruits", 739.0, 913.0, "19% OFF", "1 pc", true));
        products.add(this.createProduct("f32", "Peaches", "Fresh Organic", "fruits", 706.0, 872.0, "19% OFF", "1 kg", true));
        products.add(this.createProduct("f33", "Raspberries", "Fresh Organic", "fruits", 789.0, 996.0, "20% OFF", "125g", true));
        products.add(this.createProduct("f34", "Mandarin Oranges", "Fresh Organic", "fruits", 648.0, 789.0, "17% OFF", "1 kg", true));
        products.add(this.createProduct("f35", "Tamarind", "Fresh Organic", "fruits", 266.0, 320.0, "16% OFF", "250g", true));
        products.add(this.createProduct("f36", "Grape Fruit", "Fresh Organic", "fruits", 490.0, 598.0, "18% OFF", "1 pc", true));
        products.add(this.createProduct("f37", "Cantaloupe Melon", "Fresh Organic", "fruits", 540.0, 664.0, "18% OFF", "1 pc", true));
        products.add(this.createProduct("f38", "Lychee", "Fresh Organic", "fruits", 731.0, 913.0, "19% OFF", "500g", true));
        products.add(this.createProduct("f39", "Apricots", "Fresh Organic", "fruits", 764.0, 913.0, "16% OFF", "500g", true));
        products.add(this.createProduct("f40", "Banana Blossom", "Fresh Organic", "fruits", 324.0, 390.0, "16% OFF", "1 pc", true));
        products.add(this.createProduct("f41", "Pomelo", "Fresh Organic", "fruits", 324.0, 390.0, "16% OFF", "1 pc", true));
        products.add(this.createProduct("f42", "Mangosteen", "Fresh Organic", "fruits", 324.0, 390.0, "16% OFF", "1 pc", true));
        products.add(this.createProduct("f43", "Langsat", "Fresh Organic", "fruits", 324.0, 390.0, "16% OFF", "1 pc", true));
        products.add(this.createProduct("f44", "Salak (Snake Fruit)", "Fresh Organic", "fruits", 324.0, 390.0, "16% OFF", "1 pc", true));
        products.add(this.createProduct("f45", "Java Apple", "Fresh Organic", "fruits", 324.0, 390.0, "16% OFF", "1 pc", true));
        products.add(this.createProduct("f46", "Malay Gooseberry", "Fresh Organic", "fruits", 324.0, 390.0, "16% OFF", "1 pc", true));
        products.add(this.createProduct("f47", "Rose Myrtle", "Fresh Organic", "fruits", 324.0, 390.0, "16% OFF", "1 pc", true));
        products.add(this.createProduct("f48", "Snake Fruit", "Fresh Organic", "fruits", 324.0, 390.0, "16% OFF", "1 pc", true));
        products.add(this.createProduct("f49", "Durian", "Fresh Organic", "fruits", 324.0, 390.0, "16% OFF", "1 pc", true));
        products.add(this.createProduct("f50", "Rose Apple", "Fresh Organic", "fruits", 324.0, 390.0, "16% OFF", "1 pc", true));
        products.add(this.createProduct("f51", "Golden Delicious Apples", "Fresh Organic", "fruits", 324.0, 390.0, "16% OFF", "1 pc", true));
        products.add(this.createProduct("b1", "Cold-Pressed Juice Mix", "Fresh Organic", "beverages", 739.0, 913.0, "19% OFF", "500ml", true));
        products.add(this.createProduct("b2", "Coconut Water", "Fresh Organic", "beverages", 374.0, 482.0, "22% OFF", "500ml", true));
        products.add(this.createProduct("b3", "Turmeric Latte Mix", "Fresh Organic", "beverages", 739.0, 913.0, "19% OFF", "200g", true));
        products.add(this.createProduct("b4", "Herbal Green Tea", "Fresh Organic", "beverages", 598.0, 789.0, "24% OFF", "50 bags", true));
        products.add(this.createProduct("b5", "Sugarcane Juice", "Fresh Organic", "beverages", 316.0, 390.0, "18% OFF", "300ml", true));
        products.add(this.createProduct("b6", "Mango Lassi", "Fresh Organic", "beverages", 457.0, 540.0, "15% OFF", "400ml", true));
        products.add(this.createProduct("b7", "Rose Milk", "Fresh Organic", "beverages", 349.0, 415.0, "15% OFF", "300ml", true));
        products.add(this.createProduct("b8", "Nannari Sarbath", "Fresh Organic", "beverages", 374.0, 457.0, "18% OFF", "400ml", true));
        products.add(this.createProduct("b9", "Aloe Vera Juice", "Fresh Organic", "beverages", 565.0, 706.0, "20% OFF", "500ml", true));
        products.add(this.createProduct("b10", "Tender Coconut Water", "Fresh Organic", "beverages", 291.0, 350.0, "16% OFF", "1 pc", true));
        products.add(this.createProduct("b11", "Amla Juice", "Fresh Organic", "beverages", 490.0, 623.0, "21% OFF", "500ml", true));
        products.add(this.createProduct("b12", "Moringa Tea", "Fresh Organic", "beverages", 623.0, 747.0, "16% OFF", "30 bags", true));
        products.add(this.createProduct("b13", "Tamarind Drink", "Fresh Organic", "beverages", 324.0, 390.0, "16% OFF", "300ml", true));
        products.add(this.createProduct("b14", "Carrot-Ginger Juice", "Fresh Organic", "beverages", 432.0, 540.0, "20% OFF", "300ml", true));
        products.add(this.createProduct("b15", "Hibiscus Iced Tea", "Fresh Organic", "beverages", 515.0, 648.0, "20% OFF", "500ml", true));
        products.add(this.createProduct("b16", "Vetiver Cooler", "Fresh Organic", "beverages", 399.0, 480.0, "16% OFF", "400ml", true));
        products.add(this.createProduct("b17", "Barley Water", "Fresh Organic", "beverages", 349.0, 415.0, "15% OFF", "500ml", true));
        products.add(this.createProduct("b18", "Kokum Sherbet", "Fresh Organic", "beverages", 407.0, 498.0, "18% OFF", "400ml", true));
        products.add(this.createProduct("b19", "Jamun Juice", "Fresh Organic", "beverages", 540.0, 664.0, "18% OFF", "500ml", true));
        products.add(this.createProduct("b20", "Pineapple Vinegar", "Fresh Organic", "beverages", 789.0, 996.0, "20% OFF", "500ml", true));
        products.add(this.createProduct("b21", "Masala Chai", "Fresh Organic", "beverages", 457.0, 540.0, "15% OFF", "200 bags", true));
        products.add(this.createProduct("b22", "Fresh Orange Juice", "Fresh Organic", "beverages", 374.0, 457.0, "18% OFF", "500ml", true));
        products.add(this.createProduct("b23", "Iced Coffee", "Fresh Organic", "beverages", 490.0, 581.0, "15% OFF", "400ml", true));
        products.add(this.createProduct("b24", "Jasmine Green Tea", "Fresh Organic", "beverages", 573.0, 680.0, "15% OFF", "50 bags", true));
        products.add(this.createProduct("b25", "Protein Shake", "Fresh Organic", "beverages", 623.0, 740.0, "15% OFF", "400ml", true));
        products.add(this.createProduct("g1", "Basmati Rice", "Premium Quality", "groceries", 813.0, 1038.0, "21% OFF", "2 kg", false));
        products.add(this.createProduct("g2", "Cold-Pressed Coconut Oil", "Premium Quality", "groceries", 1204.0, 1494.0, "19% OFF", "500ml", false));
        products.add(this.createProduct("g3", "Garlic Bulbs", "Premium Quality", "groceries", 324.0, 415.0, "21% OFF", "250g", false));
        products.add(this.createProduct("g4", "Free Range Eggs", "Premium Quality", "groceries", 540.0, 664.0, "18% OFF", "12 pcs", false));
        products.add(this.createProduct("g5", "Moringa Powder", "Premium Quality", "groceries", 913.0, 1162.0, "21% OFF", "150g", false));
        products.add(this.createProduct("g6", "Chickpeas", "Premium Quality", "groceries", 432.0, 515.0, "16% OFF", "500g", false));
        products.add(this.createProduct("g7", "Red Lentils (Masoor)", "Premium Quality", "groceries", 399.0, 498.0, "19% OFF", "500g", false));
        products.add(this.createProduct("g8", "Yellow Lentils (Toor)", "Premium Quality", "groceries", 457.0, 581.0, "21% OFF", "500g", false));
        products.add(this.createProduct("g9", "Whole Black Pepper", "Premium Quality", "groceries", 565.0, 706.0, "20% OFF", "100g", false));
        products.add(this.createProduct("g10", "Turmeric Powder", "Premium Quality", "groceries", 349.0, 457.0, "23% OFF", "200g", false));
        products.add(this.createProduct("g11", "Cumin Seeds", "Premium Quality", "groceries", 316.0, 390.0, "18% OFF", "100g", false));
        products.add(this.createProduct("g12", "Coriander Seeds", "Premium Quality", "groceries", 291.0, 350.0, "16% OFF", "100g", false));
        products.add(this.createProduct("g13", "Cardamom (Green)", "Premium Quality", "groceries", 739.0, 913.0, "19% OFF", "50g", false));
        products.add(this.createProduct("g14", "Cinnamon Sticks", "Premium Quality", "groceries", 432.0, 540.0, "20% OFF", "50g", false));
        products.add(this.createProduct("g15", "Cloves", "Premium Quality", "groceries", 540.0, 664.0, "18% OFF", "50g", false));
        products.add(this.createProduct("g16", "Sesame Seeds (White)", "Premium Quality", "groceries", 349.0, 415.0, "15% OFF", "250g", false));
        products.add(this.createProduct("g17", "Mustard Seeds", "Premium Quality", "groceries", 233.0, 280.0, "16% OFF", "200g", false));
        products.add(this.createProduct("g18", "Fenugreek Seeds", "Premium Quality", "groceries", 266.0, 320.0, "16% OFF", "200g", false));
        products.add(this.createProduct("g19", "Groundnut Oil", "Premium Quality", "groceries", 1038.0, 1245.0, "16% OFF", "1 L", false));
        products.add(this.createProduct("g20", "Jaggery (Cane)", "Premium Quality", "groceries", 407.0, 498.0, "18% OFF", "500g", false));
        products.add(this.createProduct("g21", "Honey (Raw Wildflower)", "Premium Quality", "groceries", 1237.0, 1494.0, "17% OFF", "500g", false));
        products.add(this.createProduct("g22", "Ghee (Cow Milk)", "Premium Quality", "groceries", 1494.0, 1826.0, "18% OFF", "500g", false));
        products.add(this.createProduct("g23", "Tapioca Flour", "Premium Quality", "groceries", 374.0, 440.0, "15% OFF", "500g", false));
        products.add(this.createProduct("g24", "Ragi Flour (Millet)", "Premium Quality", "groceries", 482.0, 598.0, "19% OFF", "500g", false));
        products.add(this.createProduct("g25", "Quinoa", "Premium Quality", "groceries", 988.0, 1245.0, "20% OFF", "500g", false));
        products.add(this.createProduct("g26", "Oats (Rolled)", "Premium Quality", "groceries", 540.0, 640.0, "15% OFF", "500g", false));
        products.add(this.createProduct("g27", "Almonds", "Premium Quality", "groceries", 1320.0, 1577.0, "16% OFF", "250g", false));
        products.add(this.createProduct("g28", "Cashew Nuts", "Premium Quality", "groceries", 1204.0, 1494.0, "19% OFF", "250g", false));
        products.add(this.createProduct("g29", "Walnut Kernels", "Premium Quality", "groceries", 1403.0, 1660.0, "15% OFF", "250g", false));
        products.add(this.createProduct("g30", "Flaxseeds", "Premium Quality", "groceries", 399.0, 498.0, "19% OFF", "250g", false));
        products.add(this.createProduct("g31", "Chia Seeds", "Premium Quality", "groceries", 656.0, 789.0, "16% OFF", "250g", false));
        products.add(this.createProduct("g32", "Sunflower Seeds", "Premium Quality", "groceries", 374.0, 440.0, "15% OFF", "250g", false));
        products.add(this.createProduct("g33", "Pumpkin Seeds", "Premium Quality", "groceries", 565.0, 706.0, "20% OFF", "250g", false));
        products.add(this.createProduct("g34", "Dry Red Chilli", "Premium Quality", "groceries", 291.0, 374.0, "22% OFF", "100g", false));
        products.add(this.createProduct("g35", "Star Anise", "Premium Quality", "groceries", 407.0, 480.0, "15% OFF", "50g", false));
        products.add(this.createProduct("g36", "Dried Mango Powder", "Premium Quality", "groceries", 432.0, 540.0, "20% OFF", "100g", false));
        products.add(this.createProduct("g37", "Tamarind Paste", "Premium Quality", "groceries", 324.0, 399.0, "18% OFF", "200g", false));
        products.add(this.createProduct("g38", "Coconut Milk", "Premium Quality", "groceries", 349.0, 457.0, "23% OFF", "400ml", false));
        products.add(this.createProduct("g39", "Brown Rice", "Premium Quality", "groceries", 739.0, 913.0, "19% OFF", "2 kg", false));
        products.add(this.createProduct("g40", "Mung Beans (Green)", "Premium Quality", "groceries", 374.0, 482.0, "22% OFF", "500g", false));
        products.add(this.createProduct("g41", "Dried Chilli Flakes", "Premium Quality", "groceries", 266.0, 320.0, "16% OFF", "100g", false));
        products.add(this.createProduct("g42", "Dried Fenugreek Leaves", "Premium Quality", "groceries", 349.0, 432.0, "19% OFF", "100g", false));
        products.add(this.createProduct("g43", "Asafoetida (Hing)", "Premium Quality", "groceries", 457.0, 540.0, "15% OFF", "50g", false));
        products.add(this.createProduct("g44", "Dried Coconut (Kopra)", "Premium Quality", "groceries", 565.0, 706.0, "20% OFF", "500g", false));
        products.add(this.createProduct("g45", "Crunchy Coated Peanuts", "Premium Quality", "groceries", 872.0, 1079.0, "19% OFF", "250g", false));
        products.add(this.createProduct("g46", "Peanut Oil", "Premium Quality", "groceries", 872.0, 1079.0, "19% OFF", "250ml", false));
        products.add(this.createProduct("g47", "Raw Peanuts", "Premium Quality", "groceries", 872.0, 1079.0, "19% OFF", "250g", false));
        products.add(this.createProduct("g48", "Sesame Oil", "Premium Quality", "groceries", 872.0, 1079.0, "19% OFF", "250ml", false));
        products.add(this.createProduct("g49", "Frozen Vegetables", "Premium Quality", "groceries", 872.0, 1079.0, "19% OFF", "250g", false));
        products.add(this.createProduct("g50", "Butter", "Premium Quality", "groceries", 872.0, 1079.0, "19% OFF", "250g", false));
        products.add(this.createProduct("g51", "Farm Fresh Cow Ghee", "Premium Quality", "groceries", 872.0, 1079.0, "19% OFF", "250ml", false));
        products.add(this.createProduct("g52", "Paneer Cheese Cubes", "Premium Quality", "groceries", 872.0, 1079.0, "19% OFF", "1 pack", false));
        products.add(this.createProduct("g53", "Curd", "Premium Quality", "groceries", 872.0, 1079.0, "19% OFF", "250ml", false));
        products.add(this.createProduct("g54", "Cheese", "Premium Quality", "groceries", 872.0, 1079.0, "19% OFF", "250g", false));
        this.productRepository.saveAll(products);
        log.info("Seeded {} products successfully!", (Object)products.size());
    }

    private Product createProduct(String id, String name, String subtitle, String category, double currentPrice, double originalPrice, String discount, String weight, boolean isOrganic) {
        return this.createProduct(id, name, subtitle, category, currentPrice, originalPrice, discount, weight, isOrganic, false);
    }

    private Product createProduct(String id, String name, String subtitle, String category, double currentPrice, double originalPrice, String discount, String weight, boolean isOrganic, boolean isSale) {
        Product p = new Product();
        p.setId(id);
        p.setName(name);
        p.setSubtitle(subtitle);
        p.setCategory(category);
        p.setImageUrl("assets/images/products/" + id + ".jpg");
        p.setCurrentPrice(currentPrice);
        p.setOriginalPrice(originalPrice);
        p.setDiscount(discount);
        p.setWeight(weight);
        p.setOrganic(isOrganic);
        p.setSale(isSale);
        return p;
    }

    public SeedDataRunner(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }
}

