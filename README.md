# Project Documentation: Import Data using Transform Maps (Spreadsheet)

**Course / Module:** ServiceNow System Administrator (SkillWallet / Naan Mudhalvan)  
**Project Category:** Micro Project / Group Project  
**Author / Team:** ServiceNow Project Team  

---

## 1. Project Overview & Problem Definition

### 1.1 Project Title
**Import Data using Transform Maps (Spreadsheet)**

### 1.2 Executive Summary
In modern enterprise environments, employee onboarding, organizational restructuring, and departmental transfers often result in bulk human resource data arriving in disparate external spreadsheet formats (Excel/CSV). Manually entering these records into ServiceNow is time-consuming, prone to human transcription errors, and risks data duplication.

This project implements an automated, fault-tolerant data migration pipeline using **ServiceNow Import Sets** and **Transform Maps**. By loading external Excel data into an interim staging table (Import Set table) and configuring a Transform Map with field mapping and unique identifier identification (`Employee ID` coalesce), the platform guarantees data integrity, automatically inserting new employee records while updating existing personnel without duplicating records.

---

## 2. Analysis of the 4 Milestones (Step-by-Step)

### Milestone 1: Requirement Analysis, Data Preparation & Staging Table Creation
* **Step 1.1: Data Schema Definition**
  * Identify external source fields:
    * `Employee ID` (String, e.g., EMP1001)
    * `Name` (String, e.g., Alice Johnson)
    * `Email` (String, e.g., alice.johnson@example.com)
    * `Department` (String, e.g., Information Technology)
    * `Location` (String, e.g., New York)
  * Format spreadsheet as `.xlsx` or `.csv`.
* **Step 1.2: Navigate to ServiceNow Import Sets**
  * Log into the ServiceNow Personal Developer Instance (PDI).
  * In Application Navigator, navigate to: **System Import Sets > Load Data**.
* **Step 1.3: Create Import Set Staging Table**
  * Select **Create table**.
  * Enter Label: `Employee Data Import` (System generates table name: `u_employee_data_import`).
  * Choose **Source of the file**: File.
  * Click **Choose File** and upload the employee spreadsheet.
  * Set **Sheet number** (usually 1) and **Header row** (usually 1).
  * Click **Submit**.
* **Step 1.4: Verify Staging Data**
  * Click the link **Loaded data** or navigate to `u_employee_data_import.list`.
  * Verify that all records and columns from the spreadsheet are ingested with status `pending`.

---

### Milestone 2: Target Table Setup & Transform Map Configuration
* **Step 2.1: Target Table Identification**
  * Target table: ServiceNow User Table (`sys_user`) or Custom Employee Table (`u_employee`).
  * Verify target field names:
    * `employee_number` (Employee ID)
    * `name` (Full Name)
    * `email` (Email address)
    * `department` (Reference to `cmn_department`)
    * `location` (Reference to `cmn_location`)
* **Step 2.2: Create Transform Map Record**
  * Navigate to: **System Import Sets > Create Transform Map**.
  * Specify properties:
    * **Name**: `Employee Data Transform Map`
    * **Source Table**: `u_employee_data_import`
    * **Target Table**: `sys_user` [or `u_employee`]
    * **Active**: Checked
    * **Run business rules**: Checked (ensures audit history and platform triggers execute)
    * Click **Submit** or **Save**.
* **Step 2.3: Field Mapping Strategy**
  * Click **Auto Map Matching Fields** to map identical field names automatically.
  * Click **Mapping Assist** for manual alignment:
    * Source `u_employee_id` $\rightarrow$ Target `employee_number`
    * Source `u_name` $\rightarrow$ Target `name`
    * Source `u_email` $\rightarrow$ Target `email`
    * Source `u_department` $\rightarrow$ Target `department`
    * Source `u_location` $\rightarrow$ Target `location`
  * Click **Save**.

---

### Milestone 3: Coalesce Configuration, Reference Handling & Transformation Execution
* **Step 3.1: Configure Coalesce Field (Unique Key)**
  * Navigate to the **Field Maps** related list on the Transform Map record.
  * Locate the mapping: `u_employee_id` $\rightarrow$ `employee_number`.
  * Set **Coalesce** to `true`.
  * **Coalesce Rule**:
    * If a record in `sys_user` matches the incoming `employee_number`, ServiceNow updates the existing record.
    * If no match is found, ServiceNow creates (inserts) a new record.
* **Step 3.2: Configure Reference Field Handling**
  * `department` and `location` are Reference fields in ServiceNow.
  * In Field Maps for `department`, configure **Choice Action**:
    * `create`: Automatically creates the department in `cmn_department` if it doesn't exist.
    * `ignore`: Ignores the field if the referenced record is not found.
    * `reject`: Rejects the entire row if reference fails.
  * Recommended setting: `create` or ensure matching reference names.
* **Step 3.3: Execute Transformation**
  * In the Transform Map or Import Set record, click the Related Link: **Transform**.
  * Confirm the Transform Map `Employee Data Transform Map` is selected.
  * Click **Transform**.
* **Step 3.4: Review Execution Summary**
  * Check the **Import Set Runs** / **Transform History**:
    * **State**: Completed
    * **Total Records**: e.g., 20
    * **Inserted**: Count of new records created
    * **Updated**: Count of existing records updated
    * **Ignored / Errors**: 0

---

### Milestone 4: Verification, Data Integrity Testing & Validation
* **Step 4.1: Target Table Verification**
  * Navigate to: **User Administration > Users** (`sys_user.list`).
  * Filter records by `Created on Today` or search for the imported `employee_number` values.
  * Verify that `name`, `email`, `department`, and `location` are accurately populated.
* **Step 4.2: Coalesce Validation Test (Idempotency / Update Test)**
  * Modify the spreadsheet: Keep 5 existing `Employee ID`s (with modified department or location) and add 2 brand new `Employee ID`s.
  * Re-run Load Data and Transform.
  * Verify: Exactly 5 records are updated and 2 records are inserted without any duplicate records being generated.
* **Step 4.3: Error Log & Boundary Testing**
  * Test with duplicate IDs in the same sheet, invalid emails, or blank mandatory fields.
  * Inspect **System Import Sets > Import Log** to observe error trapping and remediation.
* **Step 4.4: Final Sign-off**
  * Capture screenshots of:
    1. Loaded Staging Table
    2. Transform Map & Field Maps with Coalesce
    3. Transform Execution Results (Inserted/Updated counts)
    4. Target Table with populated records.

---

## 3. The 6 Phases in Google Drive & Documentation Templates

Based on the Google Drive folder structure (`https://drive.google.com/drive/folders/1tJEdhhbE4r9IXNUVkZIbTURAmwLSUoRA`), here is the exact phase-by-phase breakdown with customized contents for this project:

```
ServiceNow Phasewise Templates/
├── 1. Ideation Phase/
│   ├── Empathy Map Canvas.docx
│   ├── Brainstorming- Idea Generation- Prioritization Template.docx
│   └── Define Problem Statements Template.docx
├── 2. Requirement Analysis/
│   ├── Customer Journey Map - Example.pdf
│   ├── Data Flow Diagrams and User Stories.docx
│   ├── Solution Requirements.docx
│   └── Technology Stack - Template.docx
├── 3. Project Design Phase/
│   ├── Problem - Solution Fit Template/
│   │   └── Problem - Solution Fit Template v1.docx
│   ├── Proposed Solution/
│   │   └── Proposed Solution Template.docx
│   └── Solution Architecture/
│       └── Solution Architecture.docx
├── 4. Project Planning Phase/
│   ├── Project Planning Template.docx
│   └── Planning logic.docx
├── 5. Project Development Phase/
│   ├── Performance Testing/
│   │   └── Performance Testing.docx
│   └── User Acceptance Testing/
│       ├── UAT Report Template.pdf
│       └── User Acceptance Testing FSD.docx
└── 6. Project Documentation/
    ├── FSD Documentation Format.docx
    └── Final Report Template.pdf
```

---

### Phase 1: Ideation Phase
* **Folder Name:** `1. Ideation Phase`
* **Folder ID:** `1O4M0bQmb6q5vcyXIUHbRIyjZhViVk9SB`
* **Documents & Project Content:**
  1. **Empathy Map Canvas:**
     * *User Persona:* HR Operations Specialist / ServiceNow Administrator.
     * *Says:* "Entering hundreds of employees manually every week is exhausting and leads to typos."
     * *Thinks:* "How can I ensure we don't accidentally create duplicate user accounts?"
     * *Does:* Exports spreadsheet from HRIS, cleans columns, imports into ServiceNow staging.
     * *Feels:* Frustrated with manual data entry; relieved when automated with coalesce matching.
     * *Pains:* Typos, duplicated employee records, broken reference fields (departments/locations).
     * *Gains:* 95% reduction in onboarding latency, 100% data integrity, automated update vs insert.
  2. **Brainstorming & Idea Prioritization Template:**
     * *Idea 1:* Manual record creation via Form view (Rejected: High effort, error-prone).
     * *Idea 2:* REST API integration with HRIS (Future scope: Requires middleware and integration licensing).
     * *Idea 3:* Import Sets with Transform Maps & Coalesce (Selected: Built-in, low code, isolated staging area, robust rollback/error handling).
  3. **Define Problem Statements Template:**
     * *Problem Statement:* "Manual entry of bulk employee spreadsheet data into ServiceNow results in record duplication, missing reference links, and administrative overhead. An automated data import solution using Import Sets and Transform Maps with Coalesce logic is required to ensure seamless, accurate, and scalable data synchronization."

---

### Phase 2: Requirement Analysis
* **Folder Name:** `2. Requirement Analysis`
* **Folder ID:** `1k7TMYFBBKUJclnJduHfwtqm1SIka_DgK`
* **Documents & Project Content:**
  1. **Customer Journey Map:**
     * Stages: *Awareness $\rightarrow$ Data Preparation $\rightarrow$ Staging Ingestion $\rightarrow$ Transform Execution $\rightarrow$ Quality Audit*.
     * Touchpoints: Excel file, ServiceNow Import Sets module, Transform Map editor, Target User table.
  2. **Data Flow Diagrams and User Stories:**
     * *DFD Level 0:* External Spreadsheet $\rightarrow$ [ServiceNow Import Subsystem] $\rightarrow$ Employee Records (`sys_user`).
     * *DFD Level 1:* Spreadsheet $\rightarrow$ Staging Table (`u_employee_data_import`) $\rightarrow$ Field Mapping & Coalesce Engine $\rightarrow$ Target Table (`sys_user`).
     * *User Story 1:* As an HR admin, I want to upload an Excel file so that employee data enters ServiceNow in bulk.
     * *User Story 2:* As a System Administrator, I want to use `Employee ID` as a coalesce key so that existing records are updated rather than duplicated.
  3. **Solution Requirements:**
     * *Functional:* Support `.xlsx` format, auto/manual field mapping, coalesce logic, reference field resolution for Department and Location.
     * *Non-Functional:* Ingestion speed $< 5$ seconds per 100 records, data confidentiality, audit logging of transformations.
  4. **Technology Stack Template:**
     * *Platform:* ServiceNow Platform (Vancouver / Washington DC / Xanadu).
     * *Modules:* System Import Sets, Transform Maps, User Administration (`sys_user`).
     * *Data Sources:* Microsoft Excel (.xlsx), CSV (.csv).
     * *Scripting Engine:* GlideRecord, JavaScript (ES5/ES6).

---

### Phase 3: Project Design Phase
* **Folder Name:** `3. Project Design Phase`
* **Folder ID:** `1H3jUcs_874mugTP1Zy9CGlPmgnGfoljZ`
* **Subfolders & Documents:**
  1. **Subfolder:** `Problem - Solution Fit Template`
     * Document: `Problem - Solution Fit Template v1.docx`
     * Content: Validates how ServiceNow Transform Maps resolve the business pain points (Staging table prevents corrupting production tables; Coalesce prevents duplicates; Mapping Assist aligns unstandardized column names).
  2. **Subfolder:** `Proposed Solution`
     * Document: `Proposed Solution Template.docx`
     * Content: Comprehensive design of the 3-tier architecture: Ingestion Tier (File Upload) $\rightarrow$ Intermediate Staging Tier (`u_employee_data_import`) $\rightarrow$ Transformation & Target Tier (`sys_user`).
  3. **Subfolder:** `Solution Architecture`
     * Document: `Solution Architecture.docx`
     * Content: Architectural diagrams, Entity-Relationship (ER) model between staging table columns and `sys_user`, `cmn_department`, and `cmn_location`.

---

### Phase 4: Project Planning Phase
* **Folder Name:** `4. Project Planning Phase`
* **Folder ID:** `1W1tpFnC4PkhJGppGaRetd5aehPgCj5jM`
* **Documents & Project Content:**
  1. **Project Planning Template:**
     * Milestone Gantt Chart, Work Breakdown Structure (WBS), Sprint duration (1–2 weeks), Team role allocation (Project Lead, ServiceNow Developer, Quality Assurance Tester).
  2. **Planning Logic:**
     * Sequential execution pipeline: Data cleansing $\rightarrow$ Staging Table setup $\rightarrow$ Transform Map definition $\rightarrow$ Testing on sub-production $\rightarrow$ Production verification $\rightarrow$ Rollback & exception management.

---

### Phase 5: Project Development Phase
* **Folder Name:** `5. Project Development Phase`
* **Folder ID:** `16tGmlLqOmGTuHNn-xatrqxtViVRo9TaS`
* **Subfolders & Documents:**
  1. **Subfolder:** `Performance Testing`
     * Document: `Performance Testing.docx`
     * Content: Load metrics testing for batch sizes (50, 200, 1000 records). Metrics tracked: Import Set Load Time, Transformation Elapsed Time, Memory Footprint, CPU overhead.
  2. **Subfolder:** `User Acceptance Testing`
     * Documents: `UAT Report Template.pdf` & `User Acceptance Testing FSD.docx`
     * Test Cases:
       * **TC-01:** Insert New Employee Record (Result: PASS)
       * **TC-02:** Update Existing Employee Record via Coalesce ID (Result: PASS)
       * **TC-03:** Reference Resolution for Department & Location (Result: PASS)
       * **TC-04:** Missing Mandatory Fields handling (Result: PASS)
       * **TC-05:** Duplicate Rows in Same Batch (Result: PASS)

---

### Phase 6: Project Documentation
* **Folder Name:** `6. Project Documentation`
* **Folder ID:** `1ib18sBYSgMSZZSrvBJAaGMBRcA_XemaX`
* **Documents & Project Content:**
  1. **Functional Specification Document (FSD):**
     * Document: `FSD Documentation Format.docx`
     * Content: Comprehensive specification of field dictionaries, transformation logic, coalesce rules, exception handling workflows, and user interface layouts.
  2. **Final Project Report:**
     * Document: `Final Report Template.pdf`
     * Content: Complete micro-project report including Title Page, Certificate, Acknowledgement, Abstract, Table of Contents, Milestone Implementations, Verification Screenshots, Conclusion, and References.
