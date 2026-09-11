package com.vpnexues.service;

import com.vpnexues.model.Product;
import com.vpnexues.repository.ProductRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class SeedDataRunner implements CommandLineRunner {

    private final ProductRepository productRepository;

    public SeedDataRunner(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @Override
    public void run(String... args) {
        if (productRepository.count() == 0) {
            seedProducts();
        }
    }

    private void seedProducts() {
        String[][] fruits = {
                {"Apple", "Fresh red apple", "Fruits", "https://images.unsplash.com/photo-1568702846914-96b305d2uj18?w=300", "3.99", "4.99", "20%", "1 kg", "true", "true"},
                {"Banana", "Ripe yellow bananas", "Fruits", "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=300", "1.99", "2.49", "20%", "1 dozen", "false", "true"},
                {"Orange", "Sweet navel oranges", "Fruits", "https://images.unsplash.com/photo-1547514701-42782101795e?w=300", "2.99", "3.49", "14%", "1 kg", "false", "false"},
                {"Mango", "Alphonso mangoes", "Fruits", "https://images.unsplash.com/photo-1553279768-865429fa0078?w=300", "5.99", "7.99", "25%", "1 kg", "false", "false"},
                {"Grapes", "Green seedless grapes", "Fruits", "https://images.unsplash.com/photo-1537640538966-79f369143f8f?w=300", "4.49", "5.49", "18%", "500 g", "false", "false"},
                {"Strawberry", "Fresh strawberries", "Fruits", "https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=300", "4.99", "6.49", "23%", "250 g", "true", "false"},
                {"Pineapple", "Golden sweet pineapple", "Fruits", "https://images.unsplash.com/photo-1550258987-190a2d41a8ba?w=300", "3.49", "4.49", "22%", "1 piece", "false", "false"},
                {"Watermelon", "Refreshing watermelon", "Fruits", "https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=300", "5.99", "7.99", "25%", "5 kg", "false", "false"},
                {"Papaya", "Ripe papaya", "Fruits", "https://images.unsplash.com/photo-1615484477778-ca3b77940c25?w=300", "2.49", "3.49", "29%", "1 piece", "false", "false"},
                {"Pomegranate", "Fresh pomegranate", "Fruits", "https://images.unsplash.com/photo-1615485500704-8e990f9900f7?w=300", "3.99", "4.99", "20%", "500 g", "false", "false"},
                {"Kiwi", "Green kiwi fruit", "Fruits", "https://images.unsplash.com/photo-1585059895524-72359e06138a?w=300", "4.49", "5.99", "25%", "1 kg", "false", "false"},
                {"Blueberry", "Organic blueberries", "Fruits", "https://images.unsplash.com/photo-1498557850523-fd3d118655f7?w=300", "6.99", "8.99", "22%", "250 g", "true", "true"},
                {"Peach", "Juicy peaches", "Fruits", "https://images.unsplash.com/photo-1622921491193-341d3de3a41f?w=300", "3.49", "4.49", "22%", "1 kg", "false", "false"},
                {"Plum", "Red plums", "Fruits", "https://images.unsplash.com/photo-1519996529931-28324d5a630e?w=300", "3.99", "4.99", "20%", "500 g", "false", "false"},
                {"Cherry", "Sweet cherries", "Fruits", "https://images.unsplash.com/photo-1528821128474-27f963b062bf?w=300", "7.99", "9.99", "20%", "250 g", "false", "false"},
        };

        String[][] vegetables = {
                {"Tomato", "Fresh red tomatoes", "Vegetables", "https://images.unsplash.com/photo-1546470427-0d4db154ceb8?w=300", "1.99", "2.49", "20%", "1 kg", "false", "false"},
                {"Potato", "Organic potatoes", "Vegetables", "https://images.unsplash.com/photo-1518977676601-b53f82ber59?w=300", "1.49", "1.99", "25%", "2 kg", "true", "true"},
                {"Onion", "Fresh onions", "Vegetables", "https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=300", "0.99", "1.49", "33%", "1 kg", "false", "false"},
                {"Carrot", "Organic carrots", "Vegetables", "https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=300", "1.79", "2.29", "22%", "1 kg", "true", "false"},
                {"Cucumber", "Fresh cucumber", "Vegetables", "https://images.unsplash.com/photo-1449300079323-02e209d9d3a6?w=300", "1.29", "1.79", "28%", "500 g", "false", "false"},
                {"Spinach", "Baby spinach leaves", "Vegetables", "https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=300", "2.49", "3.49", "29%", "250 g", "true", "false"},
                {"Broccoli", "Fresh broccoli", "Vegetables", "https://images.unsplash.com/photo-1459411552884-841db9b3cc2a?w=300", "2.29", "2.99", "23%", "500 g", "false", "false"},
                {"Bell Pepper", "Red bell pepper", "Vegetables", "https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=300", "1.99", "2.49", "20%", "3 pieces", "false", "false"},
                {"Cauliflower", "Fresh cauliflower", "Vegetables", "https://images.unsplash.com/photo-1568702846914-96b305d2uj18?w=300", "1.79", "2.29", "22%", "1 piece", "false", "false"},
                {"Mushroom", "Button mushrooms", "Vegetables", "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=300", "3.49", "4.49", "22%", "250 g", "false", "false"},
                {"Cabbage", "Fresh cabbage", "Vegetables", "https://images.unsplash.com/photo-1594282486756-7e4b10146d80?w=300", "1.29", "1.79", "28%", "1 piece", "false", "false"},
                {"Lettuce", "Iceberg lettuce", "Vegetables", "https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=300", "1.49", "1.99", "25%", "1 piece", "false", "false"},
                {"Beetroot", "Fresh beetroot", "Vegetables", "https://images.unsplash.com/photo-1574316071802-0d684efa7bf5?w=300", "1.69", "2.19", "23%", "1 kg", "false", "false"},
                {"Green Beans", "Fresh green beans", "Vegetables", "https://images.unsplash.com/photo-1563746098251-d35aef196e83?w=300", "2.49", "3.29", "24%", "500 g", "false", "false"},
                {"Peas", "Green peas", "Vegetables", "https://images.unsplash.com/photo-1587735243615-c03f25aaff15?w=300", "2.29", "2.99", "23%", "500 g", "false", "false"},
        };

        String[][] dairy = {
                {"Milk", "Whole milk", "Dairy", "https://images.unsplash.com/photo-1550583724-b2692b85b150?w=300", "1.29", "1.59", "19%", "1 L", "false", "false"},
                {"Eggs", "Farm fresh eggs", "Dairy", "https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=300", "2.99", "3.49", "14%", "12 pieces", "false", "true"},
                {"Cheese", "Mozzarella cheese", "Dairy", "https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=300", "4.49", "5.49", "18%", "250 g", "false", "false"},
                {"Yogurt", "Greek yogurt", "Dairy", "https://images.unsplash.com/photo-1488477181946-6428a0291777?w=300", "2.49", "3.29", "24%", "500 g", "false", "false"},
                {"Butter", "Unsalted butter", "Dairy", "https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300", "3.49", "4.29", "19%", "250 g", "false", "false"},
                {"Cream", "Fresh cream", "Dairy", "https://images.unsplash.com/photo-1563636619-e9143da7973b?w=300", "2.99", "3.79", "21%", "200 ml", "false", "false"},
                {"Paneer", "Fresh paneer", "Dairy", "https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=300", "3.99", "4.99", "20%", "250 g", "false", "false"},
                {"Ghee", "Pure cow ghee", "Dairy", "https://images.unsplash.com/photo-1631209121750-a9f656d27549?w=300", "8.99", "11.99", "25%", "500 ml", "false", "false"},
                {"Buttermilk", "Fresh buttermilk", "Dairy", "https://images.unsplash.com/photo-1527661591475-527312dd65f5?w=300", "1.49", "1.99", "25%", "500 ml", "false", "false"},
                {"Cheese Slice", "Processed cheese slices", "Dairy", "https://images.unsplash.com/photo-1618176707075-57f400f5ca39?w=300", "3.49", "4.49", "22%", "200 g", "false", "false"},
        };

        String[][] bakery = {
                {"Bread", "Whole wheat bread", "Bakery", "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300", "1.99", "2.49", "20%", "400 g", "false", "false"},
                {"Croissant", "Butter croissant", "Bakery", "https://images.unsplash.com/photo-1555507036-ab1f4038024a?w=300", "2.49", "3.29", "24%", "100 g", "false", "false"},
                {"Muffin", "Blueberry muffin", "Bakery", "https://images.unsplash.com/photo-1607920591413-4ec007e70023?w=300", "1.99", "2.79", "29%", "1 piece", "false", "false"},
                {"Bagel", "Plain bagel", "Bakery", "https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300", "1.49", "1.99", "25%", "4 pieces", "false", "false"},
                {"Cake", "Chocolate cake", "Bakery", "https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=300", "12.99", "16.99", "24%", "1 kg", "false", "false"},
                {"Cookie", "Chocolate chip cookies", "Bakery", "https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=300", "3.49", "4.49", "22%", "250 g", "false", "false"},
                {"Pasta", "Fresh pasta", "Bakery", "https://images.unsplash.com/photo-1551462147-ff29053bfc14?w=300", "3.99", "4.99", "20%", "500 g", "false", "false"},
                {"Tortilla", "Flour tortilla", "Bakery", "https://images.unsplash.com/photo-1619881590738-a111d176d936?w=300", "2.49", "3.29", "24%", "8 pieces", "false", "false"},
                {"Naan", "Fresh naan bread", "Bakery", "https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=300", "1.99", "2.79", "29%", "4 pieces", "false", "false"},
                {"Sourdough", "Sourdough loaf", "Bakery", "https://images.unsplash.com/photo-1585478259715-876acc5be8eb?w=300", "4.49", "5.49", "18%", "500 g", "false", "false"},
        };

        String[][] beverages = {
                {"Orange Juice", "Fresh orange juice", "Beverages", "https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=300", "3.99", "4.99", "20%", "1 L", "false", "false"},
                {"Green Tea", "Organic green tea", "Beverages", "https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=300", "4.49", "5.99", "25%", "25 bags", "true", "false"},
                {"Coffee", "Premium coffee beans", "Beverages", "https://images.unsplash.com/photo-1559056199-644a0c9ee0c4?w=300", "9.99", "12.99", "23%", "250 g", "false", "false"},
                {"Water", "Mineral water", "Beverages", "https://images.unsplash.com/photo-1523362628745-0c100fc988a8?w=300", "0.99", "1.29", "23%", "1 L", "false", "false"},
                {"Cola", "Classic cola", "Beverages", "https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=300", "1.49", "1.99", "25%", "2 L", "false", "false"},
                {"Lemonade", "Fresh lemonade", "Beverages", "https://images.unsplash.com/photo-1621263764928-df1444c5e859?w=300", "2.49", "3.29", "24%", "1 L", "false", "false"},
                {"Almond Milk", "Organic almond milk", "Beverages", "https://images.unsplash.com/photo-1550583724-b2692b85b150?w=300", "3.49", "4.49", "22%", "1 L", "true", "false"},
                {"Apple Juice", "Fresh apple juice", "Beverages", "https://images.unsplash.com/photo-1560008581-09826d1de69e?w=300", "3.29", "4.19", "21%", "1 L", "false", "false"},
                {"Coconut Water", "Natural coconut water", "Beverages", "https://images.unsplash.com/photo-1536657464919-8926136f0be3?w=300", "2.99", "3.99", "25%", "500 ml", "false", "false"},
                {"Mango Drink", "Mango fruit drink", "Beverages", "https://images.unsplash.com/photo-1546173159-315724a31696?w=300", "2.49", "3.29", "24%", "1 L", "false", "false"},
        };

        String[][] snacks = {
                {"Chips", "Potato chips", "Snacks", "https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=300", "1.99", "2.49", "20%", "150 g", "false", "false"},
                {"Trail Mix", "Healthy trail mix", "Snacks", "https://images.unsplash.com/photo-1599599810769-bcde5a160d32?w=300", "4.99", "6.49", "23%", "250 g", "true", "true"},
                {"Granola", "Organic granola", "Snacks", "https://images.unsplash.com/photo-1517093728432-a0440f8d45af?w=300", "5.49", "6.99", "21%", "500 g", "true", "false"},
                {"Peanut Butter", "Creamy peanut butter", "Snacks", "https://images.unsplash.com/photo-1612187209234-a4b3b5e7a0c3?w=300", "4.49", "5.99", "25%", "350 g", "false", "false"},
                {"Hummus", "Classic hummus", "Snacks", "https://images.unsplash.com/photo-1577805947697-89e18249d767?w=300", "3.49", "4.49", "22%", "250 g", "false", "false"},
                {"Salsa", "Fresh salsa dip", "Snacks", "https://images.unsplash.com/photo-1599909533601-91c8ff9b8292?w=300", "2.99", "3.79", "21%", "300 g", "false", "false"},
                {"Popcorn", "Microwave popcorn", "Snacks", "https://images.unsplash.com/photo-1585238342024-78d387f41774?w=300", "2.49", "3.29", "24%", "3 bags", "false", "false"},
                {"Crackers", "Whole grain crackers", "Snacks", "https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=300", "2.99", "3.79", "21%", "200 g", "false", "false"},
                {"Energy Bar", "Protein energy bar", "Snacks", "https://images.unsplash.com/photo-1622485831930-25b75e002e8e?w=300", "1.99", "2.79", "29%", "50 g", "true", "false"},
                {"Dried Fruit", "Mixed dried fruit", "Snacks", "https://images.unsplash.com/photo-1612257999756-1237e22e3ba1?w=300", "5.99", "7.49", "20%", "250 g", "false", "false"},
        };

        String[][] meat = {
                {"Chicken Breast", "Boneless chicken breast", "Meat & Fish", "https://images.unsplash.com/photo-1604503468506-a8da13d82571?w=300", "7.99", "9.99", "20%", "1 kg", "false", "false"},
                {"Salmon", "Fresh salmon fillet", "Meat & Fish", "https://images.unsplash.com/photo-1574781330855-d0db8cc6a79c?w=300", "12.99", "16.99", "24%", "500 g", "false", "false"},
                {"Mutton", "Fresh mutton", "Meat & Fish", "https://images.unsplash.com/photo-1603048297172-c92544798d5a?w=300", "14.99", "18.99", "21%", "1 kg", "false", "false"},
                {"Prawns", "Fresh prawns", "Meat & Fish", "https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=300", "11.99", "14.99", "20%", "500 g", "false", "false"},
                {"Tuna", "Tuna steak", "Meat & Fish", "https://images.unsplash.com/photo-1599084993091-1cb5c0721cc6?w=300", "9.99", "12.99", "23%", "500 g", "false", "false"},
                {"Minced Meat", "Lean minced meat", "Meat & Fish", "https://images.unsplash.com/photo-1588168333986-5078d3ae3976?w=300", "6.99", "8.99", "22%", "500 g", "false", "false"},
                {"Sausages", "Chicken sausages", "Meat & Fish", "https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba?w=300", "4.99", "6.49", "23%", "300 g", "false", "false"},
                {"Fish Fillet", "White fish fillet", "Meat & Fish", "https://images.unsplash.com/photo-1510130113358-d3c1e1b24f77?w=300", "8.99", "11.99", "25%", "500 g", "false", "false"},
                {"Shrimp", "Tiger prawns", "Meat & Fish", "https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=300", "13.99", "17.99", "22%", "500 g", "false", "false"},
                {"Chicken Wings", "Chicken wings", "Meat & Fish", "https://images.unsplash.com/photo-1527477396000-e27163b4d3e9?w=300", "5.99", "7.49", "20%", "1 kg", "false", "false"},
        };

        String[][] pantry = {
                {"Rice", "Basmati rice", "Pantry", "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300", "4.99", "6.49", "23%", "2 kg", "false", "false"},
                {"Pasta", "Italian pasta", "Pantry", "https://images.unsplash.com/photo-1551462147-ff29053bfc14?w=300", "1.99", "2.49", "20%", "500 g", "false", "false"},
                {"Olive Oil", "Extra virgin olive oil", "Pantry", "https://images.unsplash.com/photo-1474979266404-7eaacdc50f5a?w=300", "8.99", "11.99", "25%", "500 ml", "false", "false"},
                {"Honey", "Pure organic honey", "Pantry", "https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=300", "7.49", "9.49", "21%", "500 g", "true", "true"},
                {"Flour", "All-purpose flour", "Pantry", "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=300", "2.49", "3.29", "24%", "2 kg", "false", "false"},
                {"Sugar", "Organic cane sugar", "Pantry", "https://images.unsplash.com/photo-1581349485608-9469421980da?w=300", "2.99", "3.79", "21%", "1 kg", "true", "false"},
                {"Salt", "Sea salt", "Pantry", "https://images.unsplash.com/photo-1518110925495-5fe2c841c3f7?w=300", "1.49", "1.99", "25%", "500 g", "false", "false"},
                {"Soy Sauce", "Premium soy sauce", "Pantry", "https://images.unsplash.com/photo-1585159842525-04b67a0cd043?w=300", "3.49", "4.49", "22%", "250 ml", "false", "false"},
                {"Vinegar", "Apple cider vinegar", "Pantry", "https://images.unsplash.com/photo-1571613316887-6f8d5cbf7ef7?w=300", "3.99", "4.99", "20%", "500 ml", "false", "false"},
                {"Spices", "Mixed spice blend", "Pantry", "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=300", "4.49", "5.99", "25%", "100 g", "false", "false"},
        };

        String[][][] categories = {fruits, vegetables, dairy, bakery, beverages, snacks, meat, pantry};

        for (String[][] category : categories) {
            for (String[] product : category) {
                Product p = new Product();
                p.setId(UUID.randomUUID().toString());
                p.setName(product[0]);
                p.setSubtitle(product[1]);
                p.setCategory(product[2]);
                p.setImageUrl(product[3]);
                p.setCurrentPrice(Double.parseDouble(product[4]));
                p.setOriginalPrice(Double.parseDouble(product[5]));
                p.setDiscount(product[6]);
                p.setWeight(product[7]);
                p.setOrganic(Boolean.parseBoolean(product[8]));
                p.setSale(Boolean.parseBoolean(product[9]));
                productRepository.save(p);
            }
        }
    }
}
