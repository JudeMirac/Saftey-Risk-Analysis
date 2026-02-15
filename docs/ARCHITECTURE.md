# Data Pipeline Architecture

## Overview

The Safety Risk Analysis pipeline is designed with a layered architecture that ensures data quality, reproducibility, and analytical flexibility.

## Pipeline Stages

### 1. Data Ingestion (Raw Layer)

**Purpose**: Load raw CSV data into SQLite database

**Scripts**:
- `load_raw_counts.py` - Safety event counts
- `load_raw_hours_worked.py` - Exposure hours by site
- `load_raw_severity.py` - Incident severity classifications
- `load_raw_path_rates.py` - Process path rate information
- `load_raw_root_cause.py` - Root cause data
- `load_raw_contributing_factors.py` - Contributing factors
- `load_raw_process_path.py` - Process path definitions
- `load_raw_site_details.py` - Site metadata

**Inputs**: CSV files from `Data/` directory
**Outputs**: Raw tables in SQLite database

### 2. Staging Layer

**Purpose**: Standardize and clean raw data

**Transformations**:
- Text normalization (lowercase, trim whitespace)
- Type casting (integers, dates, floats)
- Column renaming for consistency
- Null handling and validation

**SQL Files**:
- `staged_hours_worked.sql`
- `staged_site_details.sql`
- `staged_event_counts.sql`
- `staged_process_path.sql`
- `staged_severity_level.sql`
- `staged_contributing_factors.sql`
- `staged_path_rate.sql`
- `staged_root_cause.sql`

**Outputs**: Staged views (prefix: `stg_`)

### 3. Integration Layer

**Purpose**: Combine data across multiple dimensions

**Integration Hierarchy**:

#### Level 01: Site and Period
- `int_site_period.sql` - Links sites with time periods

#### Level 02: Time Mapping
- `week_mapping.sql` - Maps periods to weeks
- `int_site_week_hours.sql` - Combines site, week, and exposure hours

#### Level 03: Process Path Integration
- `int_site_process_path.sql` - Links sites with process paths
- `int_site_week_hours_process_path.sql` - Comprehensive dataset

**Outputs**: Integrated views (prefix: `int_`)

### 4. Context Layer

**Purpose**: Generate statistical distributions and insights

**Analysis Types**:
- `dist_root_cause.sql` - Distribution by root cause
- `dist_process_path.sql` - Distribution by process path
- `dist_contributing_factors.sql` - Distribution by contributing factors
- `dist_by_severity_level.sql` - Distribution by severity

**Outputs**: Context views (prefix: `dist_`)

### 5. Features Layer

**Purpose**: Calculate risk metrics for modeling

**Feature Sets**:
- `feat_site_week_hours_risk.sql` - Overall risk features
- `feat_site_week_hours_path_risk.sql` - Process-specific risk features

**Outputs**: Feature views (prefix: `feat_`)

## Data Flow Diagram

```
┌─────────────────────────────────────────────────────────┐
│                      CSV Data Files                      │
│  (safety_events, hours_worked, dimensions, exposure)    │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│              Raw Tables (SQLite Database)                │
│         (raw_event_counts, raw_hours_worked, etc.)      │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                    Staging Layer                         │
│     (stg_hours_worked, stg_event_counts, etc.)          │
│         • Text normalization                             │
│         • Type casting                                   │
│         • Data validation                                │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                  Integration Layer                       │
│  (int_site_period, int_site_week_hours, etc.)           │
│         • Join multiple sources                          │
│         • Time period mapping                            │
│         • Create unified datasets                        │
└─────────────┬──────────────────────┬────────────────────┘
              │                      │
              ▼                      ▼
┌──────────────────────┐  ┌──────────────────────────────┐
│   Context Layer      │  │      Features Layer          │
│   (dist_* views)     │  │      (feat_* views)          │
│   • Distributions    │  │   • Risk calculations        │
│   • Statistical      │  │   • Modeling features        │
│     summaries        │  │   • Rate normalization       │
└──────────────────────┘  └──────────────────────────────┘
              │                      │
              └──────────┬───────────┘
                         ▼
              ┌─────────────────────────┐
              │   Analysis & Modeling   │
              │   (Jupyter Notebooks)   │
              └─────────────────────────┘
```

## Key Design Principles

### 1. Reproducibility
- All transformations defined as SQL views
- Views can be dropped and recreated
- Pipeline is idempotent

### 2. Modularity
- Each layer has clear responsibilities
- SQL files organized by layer
- Easy to modify individual components

### 3. Traceability
- Clear naming conventions (prefixes)
- Layered approach shows data lineage
- Easy to debug and validate

### 4. Efficiency
- Views computed on-demand
- SQLite provides good performance for analytical queries
- Indexed appropriately for common queries

## Running the Pipeline

The `Run_Pipeline.py` script executes all layers in order:

```python
# Staging
run_sql_file('database/Safety.db', "sql/staging/staged_hours_worked.sql")
# ... more staging files

# Integration
run_sql_file('database/Safety.db', "sql/integration/01/int_site_period.sql")
# ... more integration files

# Context
run_sql_file('database/Safety.db', "sql/context/dist_root_cause.sql")
# ... more context files

# Features
run_sql_file('database/Safety.db', "sql/features/feat_site_week_hours_risk.sql")
# ... more feature files
```

## Database Schema

The database uses a combination of tables (raw data) and views (transformations):

**Tables** (Raw Layer):
- `raw_event_counts`
- `raw_hours_worked`
- `raw_severity`
- `raw_path_rates`
- `raw_root_cause`
- `raw_contributing_factors`
- `raw_process_path`
- `raw_site_details`

**Views** (Processed Layers):
- Staging: `stg_*`
- Integration: `int_*`
- Context: `dist_*`
- Features: `feat_*`

## Extension Points

The pipeline can be extended by:

1. **Adding new data sources**: Create new loader scripts and staging SQL
2. **New features**: Add SQL files to the features layer
3. **Alternative integrations**: Create new integration views
4. **Additional analysis**: Add context layer queries for new dimensions
