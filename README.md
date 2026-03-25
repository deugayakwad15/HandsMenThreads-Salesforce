# 🧵 HandsMen Threads — Salesforce CRM Project

> A complete, production-ready Salesforce CRM system built for **HandsMen Threads**, a dynamic fashion organization. This project automates key business workflows including order confirmations, customer loyalty management, inventory alerts, and bulk order processing.
[![Live Demo](https://img.shields.io/badge/Live-Dashboard-gold?style=for-the-badge&logo=github)](https://deugayakwad15.github.io/HandsMenThreads-Salesforce/HandsMenDev/frontend/)
[![GitHub](https://img.shields.io/badge/GitHub-Repository-blue?style=for-the-badge&logo=github)](https://github.com/deugayakwad15/HandsMenThreads-Salesforce)
[![Salesforce](https://img.shields.io/badge/Salesforce-CRM-00A1E0?style=for-the-badge&logo=salesforce)](https://developer.salesforce.com)
---
## 📌 Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Data Model](#data-model)
- [Automation & Apex](#automation--apex)
- [Project Structure](#project-structure)
- [Setup & Deployment](#setup--deployment)
- [Running Tests](#running-tests)
- [Technologies Used](#technologies-used)
- [Skills Demonstrated](#skills-demonstrated)

---

## 📖 Project Overview

HandsMen Threads needed a robust Salesforce solution to manage their growing fashion business. This CRM system handles everything from customer data and order management to automated communications and real-time inventory tracking.

The project was built entirely on the **Salesforce Platform** using industry-standard tools including Apex, Flows, Lightning App Builder, and the Salesforce CLI.

| Detail | Info |
|---|---|
| Platform | Salesforce (Developer Edition) |
| API Version | 59.0 |
| Language | Apex (Java-like) |
| Tools | VS Code, Salesforce CLI, GitHub |
| Type | CRM + Process Automation |

---

## ✨ Features

### 1. 📧 Automated Order Confirmation Emails
- **Trigger:** When an order status is changed to `Confirmed`
- **Action:** Customer automatically receives a confirmation email
- **Built with:** Record-Triggered Flow (no code needed)
- **Benefit:** Improves customer experience and reduces manual work

### 2. ⭐ Dynamic Loyalty Program
- **Trigger:** After an order is marked as `Delivered`
- **Action:** Customer loyalty tier is recalculated based on total spend
- **Tiers:**
  - 🥉 Bronze → Total spend < ₹1,000
  - 🥈 Silver → Total spend ₹1,000 – ₹4,999
  - 🥇 Gold → Total spend ₹5,000 – ₹9,999
  - 💎 Platinum → Total spend ₹10,000+
- **Built with:** Apex Trigger (`LoyaltyStatusTrigger`)

### 3. ⚠️ Proactive Stock Alerts
- **Trigger:** When product stock drops below 5 units
- **Action:** Automatic email alert sent to the warehouse team
- **Smart logic:** Only fires when stock CROSSES the threshold (not on every update)
- **Built with:** Apex Trigger (`StockAlertTrigger`)

### 4. 🕛 Scheduled Bulk Order Processing
- **Trigger:** Every day at midnight (00:00)
- **Action:** All confirmed orders are processed, marked as Shipped, and inventory is updated
- **Built with:** Scheduled Apex (`BulkOrderScheduler`)
- **Schedule:** `0 0 0 * * ?` (Cron expression)

---

## 🗃️ Data Model

The system uses 4 custom objects:

```
Customer__c
│
├── Name (Text)
├── Email__c (Email) ← required, unique
├── Phone__c (Phone)
├── Loyalty_Status__c (Picklist: Bronze/Silver/Gold/Platinum)
└── Total_Purchases__c (Currency)

Order__c
│
├── Customer__c (Lookup → Customer__c)
├── Status__c (Picklist: Draft/Confirmed/Shipped/Delivered/Cancelled)
├── Order_Date__c (Date)
├── Total_Amount__c (Currency)
└── Notes__c (Long Text)

Product__c
│
├── SKU__c (Text, unique, external ID)
├── Price__c (Currency)
├── Stock__c (Number)
└── Category__c (Picklist: Shirts/Trousers/Blazers/Shoes/Accessories)

Order_Line_Item__c
│
├── Order__c (Master-Detail → Order__c)
├── Product__c (Lookup → Product__c)
├── Quantity__c (Number)
├── Unit_Price__c (Currency)
└── Line_Total__c (Formula: Quantity × Unit Price)
```

### Relationships Diagram
```
Customer__c  ──(1:Many)──  Order__c  ──(1:Many)──  Order_Line_Item__c
                                                           │
                                                    (Many:1)
                                                           │
                                                     Product__c
```

---

## ⚡ Automation & Apex

### Apex Triggers

| Trigger | Object | Event | Purpose |
|---|---|---|---|
| `LoyaltyStatusTrigger` | Order__c | After Insert/Update | Updates customer loyalty tier |
| `StockAlertTrigger` | Product__c | After Update | Sends warehouse email when stock < 5 |

### Apex Classes

| Class | Type | Purpose |
|---|---|---|
| `BulkOrderScheduler` | Schedulable | Processes bulk orders daily at midnight |
| `LoyaltyStatusTriggerTest` | Test Class | Tests all loyalty tier scenarios |
| `StockAlertTriggerTest` | Test Class | Tests stock alert threshold logic |
| `BulkOrderSchedulerTest` | Test Class | Tests scheduler and bulk processing |

### Flow

| Flow Name | Type | Trigger | Action |
|---|---|---|---|
| `Send_Order_Confirmation` | Record-Triggered | Order Status = Confirmed | Sends email to customer |

### Validation Rules

| Object | Rule | Formula | Purpose |
|---|---|---|---|
| Product__c | Stock_Cannot_Be_Negative | `Stock__c < 0` | Prevents negative stock |
| Product__c | Price_Must_Be_Positive | `Price__c <= 0` | Ensures valid pricing |
| Order__c | Total_Amount_Positive | `Total_Amount__c < 0` | Prevents negative totals |
| Order__c | Order_Date_Cannot_Be_Future | `Order_Date__c > TODAY()` | Prevents future-dated orders |

---

## 📁 Project Structure

```
HandsMenThreads-Salesforce/
│
├── force-app/
│   └── main/
│       └── default/
│           ├── classes/
│           │   ├── BulkOrderScheduler.cls
│           │   ├── BulkOrderScheduler.cls-meta.xml
│           │   ├── BulkOrderSchedulerTest.cls
│           │   ├── BulkOrderSchedulerTest.cls-meta.xml
│           │   ├── LoyaltyStatusTriggerTest.cls
│           │   ├── LoyaltyStatusTriggerTest.cls-meta.xml
│           │   ├── StockAlertTriggerTest.cls
│           │   └── StockAlertTriggerTest.cls-meta.xml
│           │
│           ├── triggers/
│           │   ├── LoyaltyStatusTrigger.trigger
│           │   ├── LoyaltyStatusTrigger.trigger-meta.xml
│           │   ├── StockAlertTrigger.trigger
│           │   └── StockAlertTrigger.trigger-meta.xml
│           │
│           ├── objects/
│           │   ├── Customer__c/
│           │   ├── Order__c/
│           │   ├── Product__c/
│           │   └── Order_Line_Item__c/
│           │
│           └── flows/
│               └── Send_Order_Confirmation.flow-meta.xml
│
├── manifest/
│   └── package.xml
│
├── sfdx-project.json
└── README.md
```

---

## 🚀 Setup & Deployment

### Prerequisites
Make sure you have these installed:

- [VS Code](https://code.visualstudio.com/)
- [Salesforce CLI](https://developer.salesforce.com/tools/sfdxcli)
- [Java JDK 21](https://adoptium.net/)
- [Git](https://git-scm.com/)
- Salesforce Extension Pack (VS Code marketplace)
- A free [Salesforce Developer Org](https://developer.salesforce.com/signup)

---

### Step 1 — Clone the Repository

```bash
git clone https://github.com/deugayakwad15/HandsMenThreads-Salesforce.git
cd HandsMenThreads-Salesforce
```

### Step 2 — Authorize Your Salesforce Org

```bash
sf org login web --alias HandsMenDev
```

### Step 3 — Deploy to Org

```bash
sf project deploy start --source-dir force-app
```

### Step 4 — Schedule the Bulk Order Job

Open **Developer Console** in your Salesforce org → **Debug** → **Open Execute Anonymous Window** → paste and run:

```apex
System.schedule(
    'HandsMen Bulk Order Midnight Job',
    '0 0 0 * * ?',
    new BulkOrderScheduler()
);
```

### Step 5 — Activate the Flow

- Go to **Setup** → **Flows**
- Find `Send_Order_Confirmation`
- Click **Activate** ✅

---

## 🧪 Running Tests

Run all test classes with coverage report:

```bash
sf apex run test --test-level RunLocalTests --result-format human --code-coverage --synchronous
```

### Expected Results

```
TEST NAME                                      OUTCOME
──────────────────────────────────────────────────────
BulkOrderSchedulerTest.testScheduleJob          Pass ✅
BulkOrderSchedulerTest.testBulkProcessing       Pass ✅
BulkOrderSchedulerTest.testEmptyRun             Pass ✅
LoyaltyStatusTriggerTest.testBronzeTier         Pass ✅
LoyaltyStatusTriggerTest.testGoldTier           Pass ✅
LoyaltyStatusTriggerTest.testPlatinumTier       Pass ✅
StockAlertTriggerTest.testAlertFired            Pass ✅
StockAlertTriggerTest.testNoAlertIfAlreadyLow   Pass ✅
StockAlertTriggerTest.testNoAlertAboveThreshold Pass ✅

CODE COVERAGE
──────────────────────────
BulkOrderScheduler      90%+ ✅
LoyaltyStatusTrigger    85%+ ✅
StockAlertTrigger       88%+ ✅
```

> ✅ Salesforce requires minimum **75% code coverage** to deploy — this project exceeds that requirement.

---

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| **Salesforce Apex** | Server-side business logic |
| **Apex Triggers** | Event-driven automation |
| **Scheduled Apex** | Asynchronous background jobs |
| **Record-Triggered Flow** | No-code email automation |
| **SOQL** | Salesforce Object Query Language |
| **Salesforce CLI** | Deploy and retrieve metadata |
| **VS Code** | Development environment |
| **Git & GitHub** | Version control |

---

## 🎯 Skills Demonstrated

- ✅ **Data Modelling** — Custom objects, fields, relationships, formula fields
- ✅ **Data Quality** — Validation rules, required fields, unique constraints
- ✅ **Apex Programming** — Triggers, classes, SOQL, DML operations
- ✅ **Asynchronous Apex** — Schedulable interface, batch processing
- ✅ **Flow Designer** — Record-triggered flows, email actions
- ✅ **Test-Driven Development** — Test classes with 75%+ coverage
- ✅ **Salesforce Lightning** — Lightning App Builder, custom objects UI
- ✅ **Version Control** — Git, GitHub, SFDX project structure

## 🌐 Live Demo

👉 **[Click here to view the live CRM Dashboard](https://deugayakwad15.github.io/HandsMenThreads-Salesforce/HandsMenDev/frontend/)**

> Open the link above to see the fully working frontend dashboard
> built for HandsMen Threads CRM — no login required!

---

## 📸 Dashboard Preview

### Main Dashboard
![Dashboard](https://deugayakwad15.github.io/HandsMenThreads-Salesforce/HandsMenDev/frontend/preview.png)

### Key Screens

| Screen | Description |
|---|---|
| 📊 Dashboard | Revenue stats, recent orders, loyalty tiers, live activity feed |
| 📦 Orders | Full order table with status badges and New Order modal |
| 👤 Customers | Customer profiles with Bronze/Silver/Gold/Platinum badges |
| 📦 Inventory | Stock levels with Critical/In Stock indicators |
| ⚡ Automation | Live status of all 4 Salesforce automations |
| 🕛 Scheduler | Scheduled Apex job monitoring |

---

## 🔗 Quick Links

| Resource | Link |
|---|---|
| 🌐 Live Dashboard | [View Here](https://deugayakwad15.github.io/HandsMenThreads-Salesforce/HandsMenDev/frontend/) |
| 💻 GitHub Repo | [View Code](https://github.com/deugayakwad15/HandsMenThreads-Salesforce) |
| 📄 Solution Design Doc | Available in repository root |

---

## 👩‍💻 Developer

**Divyani Ugayakwad**
- GitHub: [@deugayakwad15](https://github.com/deugayakwad15)

---

## 📄 License

This project is built for educational purposes as part of a Salesforce development learning path.

---

> *Built with ❤️ using Salesforce Platform*
