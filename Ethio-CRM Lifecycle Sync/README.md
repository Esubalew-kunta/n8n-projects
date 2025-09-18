# Event-Driven Sales Lifecycle Automation | n8n

![Complete n8n Workflow Automation](images/all%20workflow.png)

> **Developed by:** Esubalew  
> **Location:** Addis Ababa, Ethiopia 🇪🇹  

---

<aside>

## **Goal**

Automate the complete client lifecycle from signup to purchase using GoHighLevel webhooks, with real-time database synchronization and AI-powered sales journey reporting.

## Solution

- Listens to **GoHighLevel webhook events** for signup, appointment booking, status changes, and payments
- Synchronizes client data in real-time between **GHL and Supabase** for enhanced tracking
- **AI reporting agent** provides intelligent sales journey analysis with conversational interface
- **Complete audit trail** of customer interactions from first contact to purchase
- **Postgres chat memory** enables contextual conversations about client data

## Features

- **Multi-trigger automation**: Responds to 4 different GHL webhook events
- **Real-time data sync**: Instant updates between CRM and custom database
- **AI-powered reporting**: Natural language queries about sales performance
- **Complete customer journey tracking**: Signup → Appointment → Status → Payment
- **Intelligent data cleaning**: Removes null/empty values before database insertion
- **Conversational analytics**: Chat interface for sales journey insights

---

## Steps

### 1. Signup Flow

**Node:** `Webhook Signup`

**Purpose:** Captures new lead signups from GoHighLevel when "signup" tag is applied.

**Configuration:**

- **Method:** POST
- **Path:** `/webhook/signup`
- **Trigger:** GHL "signup" tag applied to contact

**Data Processing:**

- **Code Node:** Cleans incoming data (removes null/empty values)
- **Supabase Insert:** Creates new customer record with signup data

**Fields Captured:**

- full_name, email, first_name
- Business Industry
- signup_date_created

### 2. Appointment Booked Flow

**Node:** `Webhook Appointment Booked`

**Purpose:** Updates customer record when appointment is scheduled in GHL.

**Configuration:**

- **Method:** POST
- **Path:** `/webhook/appointment-booked`
- **Trigger:** GHL appointment booking event

**Data Processing:**

- **Edit Fields Node:** Extracts email and appointment_booked_date
- **Supabase Update:** Updates existing customer record by email

**Fields Updated:**

- appointment_booked_date

### 3. Appointment Status Flow

**Node:** `Webhook Appointment Status`

**Purpose:** Tracks appointment status changes (Confirmed, Showed, No-show, Cancelled, Rescheduled).

**Configuration:**

- **Method:** POST
- **Path:** `/webhook/appointment-status`
- **Trigger:** GHL appointment status change

**Data Processing:**

- **Edit Fields Node:** Extracts email, status, and timestamp
- **Supabase Update:** Updates appointment status fields

**Fields Updated:**

- appointment_status
- appointment_status_date_created

### 4. Payment Flow

**Node:** `Webhook Payment`

**Purpose:** Records successful payments when "invoice_payment_succeeded" tag is applied.

**Configuration:**

- **Method:** POST
- **Path:** `/webhook/payment`
- **Trigger:** GHL payment success event

**Data Processing:**

- **Edit Fields Node:** Processes payment data
- **Supabase Update:** Updates purchase confirmation fields

**Completes Journey:** Signup → Appointment → Purchase tracking

### 5. AI Reporting Agent

**Node:** `AI Agent` (LangChain)

**Purpose:** Provides conversational analytics and sales journey reporting.

**Configuration:**

- **Model:** GPT-4o-mini (OpenAI)
- **Memory:** Postgres Chat Memory for conversation context
- **Tools:** Supabase database access for real-time queries

**System Prompt:**

`You are a reporting assistant for Ethiopian businesses. Generate clear sales journey reports based on company database.

Database fields:
- Signups: full_name, email, business_industry, signup_date_created
- Appointments: appointment_booked_date, appointment_status, appointment_status_date_created  
- Sales: purchase_status, purchase_date

Allow filtering by:
- Individual: "Show me Abebe's journey"
- Industry: "Show me all in Coffee Export"
- Status: "Show me confirmed appointments this week"
- Outcome: "Show me all who purchased after showing up"`

**Capabilities:**

- Individual customer journey tracking
- Industry-based reporting
- Status filtering and analysis
- Purchase conversion tracking
- Timeline visualization

---

## Tools Used

- **n8n:** Workflow automation and webhook handling
- **GoHighLevel:** CRM system firing webhooks for all customer events
- **Supabase:** Real-time database for enhanced customer data storage
- **OpenAI GPT-4o-mini:** AI model for intelligent reporting
- **Postgres:** Chat memory storage for conversational context
- **LangChain:** AI agent framework for tool integration

---

## Impact

- **Complete automation** of customer lifecycle tracking from GHL to custom database
- **Real-time synchronization** ensures data consistency across systems
- **AI-powered analytics** enables natural language sales reporting
- **Enhanced customer insights** beyond standard GHL reporting capabilities
- **Scalable architecture** supports multiple webhook events and data sources
- **Conversational interface** makes data accessible to non-technical users

---

## Learnings

- How to build **event-driven architecture** with multiple webhook triggers
- **Real-time data synchronization** between CRM and custom database systems
- **AI agent integration** with live database access for dynamic reporting
- **Conversational analytics** using LangChain and persistent memory
- **Data cleaning and normalization** for reliable database operations
- **Multi-platform integration** extending CRM capabilities with custom automation

---

## Database Schema

**CUSTOMERS Table:**

- full_name, email, first_name
- business_industry
- signup_date_created
- appointment_booked_date
- appointment_status, appointment_status_date_created
- purchase_status, purchase_date

**Chat Memory (Postgres):**

- session_id, message_history
- Enables contextual conversations about customer data
</aside>
