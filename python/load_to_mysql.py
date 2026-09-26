import pandas as pd
import mysql.connector
from getpass import getpass


# ==================================================
# 1. Load cleaned dataset
# ==================================================

df = pd.read_csv("data/superstore_clean.csv")

print(f"Loaded {len(df)} transaction rows")


# ==================================================
# 2. Prepare Customers table
# ==================================================

customers = (
    df[
        [
            "Customer ID",
            "Customer Name",
            "Segment",
            "Country",
            "City",
            "State",
            "Postal Code",
            "Region",
        ]
    ]
    .drop_duplicates(subset=["Customer ID"])
    .copy()
)

customers = customers.rename(
    columns={
        "Customer ID": "customer_id",
        "Customer Name": "customer_name",
        "Segment": "segment",
        "Country": "country",
        "City": "city",
        "State": "state",
        "Postal Code": "postal_code",
        "Region": "region",
    }
)


# ==================================================
# 3. Prepare Products table
# ==================================================

products = (
    df[
        [
            "Product ID",
            "Product Name",
            "Category",
            "Sub-Category",
        ]
    ]
    .drop_duplicates(subset=["Product ID"])
    .copy()
)

products = products.rename(
    columns={
        "Product ID": "product_id",
        "Product Name": "product_name",
        "Category": "category",
        "Sub-Category": "sub_category",
    }
)


# ==================================================
# 4. Prepare Orders table
# ==================================================

orders = (
    df[
        [
            "Order ID",
            "Order Date",
            "Ship Date",
            "Ship Mode",
            "Customer ID",
        ]
    ]
    .drop_duplicates(subset=["Order ID"])
    .copy()
)

orders = orders.rename(
    columns={
        "Order ID": "order_id",
        "Order Date": "order_date",
        "Ship Date": "ship_date",
        "Ship Mode": "ship_mode",
        "Customer ID": "customer_id",
    }
)

orders["order_date"] = pd.to_datetime(orders["order_date"]).dt.date
orders["ship_date"] = pd.to_datetime(orders["ship_date"]).dt.date


# ==================================================
# 5. Prepare Order Items table
# ==================================================

order_items = df[
    [
        "Order ID",
        "Product ID",
        "Sales",
        "Quantity",
        "Discount",
        "Profit",
    ]
].copy()

order_items = order_items.rename(
    columns={
        "Order ID": "order_id",
        "Product ID": "product_id",
        "Sales": "sales",
        "Quantity": "quantity",
        "Discount": "discount",
        "Profit": "profit",
    }
)


# ==================================================
# 6. Show transformed dataset sizes
# ==================================================

print("\n===== ETL DATASET SIZES =====")
print("Customers:", len(customers))
print("Products:", len(products))
print("Orders:", len(orders))
print("Order Items:", len(order_items))


# ==================================================
# 7. Connect to MySQL
# ==================================================

print("\n===== MYSQL CONNECTION =====")

password = getpass("Enter your MySQL root password: ")

connection = mysql.connector.connect(
    host="localhost",
    port=3306,
    user="root",
    password=password,
    database="client_bi",
)

cursor = connection.cursor()

print("Connected to MySQL successfully.")


# ==================================================
# 8. Clear existing data
# ==================================================

cursor.execute("DELETE FROM order_items")
cursor.execute("DELETE FROM orders")
cursor.execute("DELETE FROM products")
cursor.execute("DELETE FROM customers")

connection.commit()

print("Existing database records cleared.")


# ==================================================
# 9. Insert Customers
# ==================================================

customer_query = """
INSERT INTO customers
(customer_id, customer_name, segment, country, city, state, postal_code, region)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
"""

customer_values = [
    tuple(row)
    for row in customers.itertuples(index=False, name=None)
]

cursor.executemany(customer_query, customer_values)

print(f"Inserted {cursor.rowcount} customers")


# ==================================================
# 10. Insert Products
# ==================================================

product_query = """
INSERT INTO products
(product_id, product_name, category, sub_category)
VALUES (%s, %s, %s, %s)
"""

product_values = [
    tuple(row)
    for row in products.itertuples(index=False, name=None)
]

cursor.executemany(product_query, product_values)

print(f"Inserted {cursor.rowcount} products")


# ==================================================
# 11. Insert Orders
# ==================================================

order_query = """
INSERT INTO orders
(order_id, order_date, ship_date, ship_mode, customer_id)
VALUES (%s, %s, %s, %s, %s)
"""

order_values = [
    tuple(row)
    for row in orders.itertuples(index=False, name=None)
]

cursor.executemany(order_query, order_values)

print(f"Inserted {cursor.rowcount} orders")


# ==================================================
# 12. Insert Order Items
# ==================================================

item_query = """
INSERT INTO order_items
(order_id, product_id, sales, quantity, discount, profit)
VALUES (%s, %s, %s, %s, %s, %s)
"""

item_values = [
    tuple(row)
    for row in order_items.itertuples(index=False, name=None)
]

cursor.executemany(item_query, item_values)

print(f"Inserted {cursor.rowcount} order items")


# ==================================================
# 13. Commit transaction
# ==================================================

connection.commit()

print("\n===== ETL COMPLETE =====")

cursor.close()
connection.close()

print("MySQL connection closed.")