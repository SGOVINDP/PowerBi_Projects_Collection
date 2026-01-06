
# Online Courses Analysis – Power BI Report

A Power BI project that analyzes online course offerings (e.g., Coursera Specializations) using the `Online_Courses.csv` dataset.  
This report provides insights into categories, ratings, durations, skills, instructors, languages, and pricing signals to support product and marketing decisions.

---

## 1) Overview

- **Objective:** Build an interactive dashboard to explore the online courses landscape and identify trends across categories, skills, and engagement metrics.
- **Key Questions:**
  - Which categories and sub-categories have the highest average ratings and the most viewers?
  - What are the most common skills/topics across high-ranking courses?
  - How do duration and program types relate to popularity or ratings?
  - Which instructors or schools frequently appear in top-ranked courses?

**Tech Stack**
- Power BI Desktop (latest)
- Data Source: `Online_Courses.csv` (flat file)
- Optional: Power Query (M), DAX measures, and custom visuals

---

## 2) Dataset Description

- **File:** `Online_Courses.csv`
- **Sample Columns (trim to what you used):**
  - `Title`, `Course Title`, `Course Short Intro`
  - `URL`, `Course URL`
  - `Category`, `Sub-Category`, `Site`, `Program Type`, `Course Type`
  - `Language`, `Subtitle Languages`
  - `Skills`, `Topics related to CRM` (optional), `ExpertTracks` (optional)
  - `Instructors`, `School`
  - `Rating`, `Number of viewers`, `Number of Reviews`, `Number of ratings`
  - `Duration`, `Weekly study`, `Price` (if present)
  - Other fields like `Rank`, `Level`, `Prequisites`, `What you learn`, `FAQs`
- **Grain:** One row per course/specialization/program listing.
- **Known quirks:**
  - Inconsistent separators in `Skills` (comma-separated text)
  - `Rating` may include text suffix (e.g., `4.9stars`) → needs cleaning
  - Numeric fields like `Number of viewers`, `Number of Reviews`, `Duration` may be strings → convert to numeric
  - `Subtitles` fields sometimes prefixed (e.g., `Subtitles: English`) → parse language list

---

## 3) Data Preparation (Power Query)
- **Column Cleanup**
  - Trim and clean `Rating` to numeric (remove `"stars"`).
  - Convert `Number of viewers`, `Number of Reviews`, `Number of ratings` to Number types.
  - Standardize `Duration` (e.g., extract numeric months from text like `"Approximately 5 months to complete"`).
- **Feature Engineering**
  - Create `Primary Language` from `Subtitle Languages`.
  - Split `Skills` into multiple rows (or use a delimited list for visuals).
- **Deduplication & Quality**
  - Remove exact duplicates by (`Title`, `URL`).
  - Handle missing `Category`/`Sub-Category` via “Unknown” buckets.
---

## 4) Data Model & DAX

- **Tables:**
  - `Courses` (from `Online_Courses.csv`)
- **Key Measures (DAX):**
  - `Avg Rating` = AVERAGE(`Courses[Rating]`)
  - `Total Viewers` = SUM(`Courses[Number of viewers]`)
  - `Total Reviews` = SUM(`Courses[Number of Reviews]`)
  - `Avg Duration (Months)` = AVERAGE(`Courses[DurationMonths]`)
  - `Course Count` = COUNTROWS(`Courses`)
- **Calculated Columns:**
  - `DurationMonths` (numeric from `Duration` text)
  - `IsTopRated` (boolean flag, e.g., Rating ≥ 4.7)

---
