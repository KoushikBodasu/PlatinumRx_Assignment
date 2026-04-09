## 🧠 PlatinumRx

### 🔹 Hotel Management System

- Created relational tables:
  - users
  - bookings
  - booking_commercials
  - items

- Implemented queries to:
  - Find latest booking per user using `ROW_NUMBER()`
  - Calculate total billing using joins and aggregation
  - Filter high-value bills using `HAVING`
  - Identify most and least ordered items using `RANK()`
  - Determine second highest bill per month using window functions

---

### 🔹 Clinic Management System

- Created tables:
  - clinics
  - customer
  - clinic_sales
  - expenses

- Implemented analysis to:
  - Calculate revenue by sales channel
  - Identify top customers
  - Compute monthly profit/loss using `CASE`
  - Find most profitable clinic per city
  - Find second least profitable clinic per state using ranking

---

## 📊 Spreadsheet Analysis

### Sheets Used:
- `ticket`
- `feedbacks`

### 🔹 Data Mapping
- Used `XLOOKUP` to populate `ticket_created_at` from `ticket` sheet into `feedbacks`

### 🔹 Time-Based Analysis
- Created helper columns:
  - **Same_Day** → compared dates using `INT()`
  - **Same_Hour** → compared date and hour using `HOUR()`

### 🔹 Aggregation
- Calculated outlet-wise:
  - Same day ticket count
  - Same hour ticket count
- Used formulas like `COUNTIFS`

---

## 🐍 Python Implementation

### 🔹 Time Converter
- Converted minutes into human-readable format
- Used:
  - Integer division (`//`)
  - Modulo (`%`)

### 🔹 Remove Duplicates
- Removed duplicate characters using loop
- Preserved order without using sets

---

## 🛠 Tools Used

- MySQL / SQL Server
- Microsoft Excel / Google Sheets
- Python 3.x

---

## 🎥 Demonstration

A screen recording is provided explaining:
- SQL queries
- Spreadsheet logic
- Python scripts

---

## 👨‍💻 Author

Koushik

---

## ✅ Key Highlights

- Used advanced SQL concepts (Window Functions)
- Applied real-world data analysis techniques
- Maintained clean and structured project organization
- Focused on readability and clarity in all solutions

  
## 🔗 Links
- GitHub Repository: https://github.com/KoushikBodasu/PlatinumRx_Assignment
- Spreadsheet: https://docs.google.com/spreadsheets/d/1jb4cweQfzDTBL5dBD-7RHs9szkT3kKtIhNaJLZEqVi8/edit?gid=731071454#gid=731071454
  

