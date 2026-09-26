import pandas as pd
from pathlib import Path


# --------------------------------------------------
# 1. File paths
# --------------------------------------------------

input_file = Path("data/superstore.csv")
output_file = Path("data/superstore_clean.csv")


# --------------------------------------------------
# 2. Load raw dataset
# --------------------------------------------------

df = pd.read_csv(input_file)

print("\n===== RAW DATA =====")
print(f"Rows: {len(df)}")
print(f"Columns: {len(df.columns)}")


# --------------------------------------------------
# 3. Extract transaction table
# --------------------------------------------------

# The first 9,994 rows contain the transaction data.
transactions = df.iloc[:9994].copy()

print("\n===== TRANSACTION TABLE =====")
print(f"Rows: {len(transactions)}")
print(f"Columns: {len(transactions.columns)}")


# --------------------------------------------------
# 4. Remove exact duplicate transactions
# --------------------------------------------------

duplicates = transactions.duplicated().sum()

print("\n===== DUPLICATE CHECK =====")
print(f"Duplicate transaction rows: {duplicates}")

transactions = transactions.drop_duplicates().copy()

print(f"Rows after removing duplicates: {len(transactions)}")


# --------------------------------------------------
# 5. Convert date columns
# --------------------------------------------------

transactions["Order Date"] = pd.to_datetime(
    transactions["Order Date"],
    errors="coerce"
)

transactions["Ship Date"] = pd.to_datetime(
    transactions["Ship Date"],
    errors="coerce"
)


# --------------------------------------------------
# 6. Convert numeric columns
# --------------------------------------------------

numeric_columns = [
    "Row ID",
    "Postal Code",
    "Sales",
    "Quantity",
    "Discount",
    "Profit"
]

for column in numeric_columns:
    transactions[column] = pd.to_numeric(
        transactions[column],
        errors="coerce"
    )


# --------------------------------------------------
# 7. Validate missing values
# --------------------------------------------------

print("\n===== MISSING VALUES AFTER CLEANING =====")

missing_values = transactions.isnull().sum()

print(missing_values[missing_values > 0])


# --------------------------------------------------
# 8. Validate business rules
# --------------------------------------------------

print("\n===== BUSINESS RULE VALIDATION =====")

print(
    "Invalid dates:",
    transactions["Order Date"].isna().sum()
)

print(
    "Invalid ship dates:",
    transactions["Ship Date"].isna().sum()
)

print(
    "Negative quantity:",
    (transactions["Quantity"] < 0).sum()
)

print(
    "Discount outside 0-1:",
    (
        (transactions["Discount"] < 0)
        | (transactions["Discount"] > 1)
    ).sum()
)


# Ship date should not be earlier than order date
invalid_shipping_dates = (
    transactions["Ship Date"]
    < transactions["Order Date"]
).sum()

print(
    "Ship date before order date:",
    invalid_shipping_dates
)


# --------------------------------------------------
# 9. Export clean dataset
# --------------------------------------------------

transactions.to_csv(output_file, index=False)

print("\n===== CLEANING COMPLETE =====")
print(f"Clean dataset saved to: {output_file}")
print(f"Final rows: {len(transactions)}")
print(f"Final columns: {len(transactions.columns)}")