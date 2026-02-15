# Data Dictionary

## Raw Data Sources

### Safety Events Data

#### `safety_events_by_process_weekly_qiuicksight_2025-12-22.csv`
Weekly safety event records by process path.

#### `safety_events_by_contributing_factors_2025-12-22.csv`
Safety events categorized by contributing factors.

#### `safety_events_by_root_cause_2025-12-22.csv`
Safety events categorized by root cause analysis.

#### `safety_events_by_severity_2025-12-22.csv`
Safety events categorized by severity level.

### Hours Worked / Exposure Data

#### `hours_worked_daily_quicksight_2025-12-16.csv`
Daily exposure hours by site and organizational unit.

**Key Fields**:
- `site` - Site identifier
- `region` - Geographic region
- `country` - Country location
- `state` - State/province
- `site_type` - Type of facility
- `org` - Organization unit
- `suborg` - Sub-organization unit
- `year` - Year
- `period` - Time period
- `hours_worked` - Total exposure hours
- `created_date` - Record creation timestamp
- `updated_date` - Last update timestamp

#### `path_rates_quicksuite_01-05-2026.csv`
Process path rate information for calculating risk metrics.

### Dimension Data

#### `site_details_static_quicksight_2025-12-16.csv`
Static site metadata and classifications.

### Event Counts

#### `safety_event_counts_2025-12-16.csv`
Aggregated safety event counts by various dimensions.

## Database Tables and Views

### Raw Tables (Loaded from CSV)

#### `raw_event_counts`
Direct load from safety event counts CSV.

#### `raw_hours_worked`
Direct load from hours worked CSV.

#### `raw_severity`
Severity level classifications.

#### `raw_path_rates`
Process path rate data.

#### `raw_root_cause`
Root cause categories and definitions.

#### `raw_contributing_factors`
Contributing factor categories.

#### `raw_process_path`
Process path definitions and mappings.

#### `raw_site_details`
Site metadata and attributes.

### Staging Views

#### `stg_hours_worked`
Standardized exposure hours data with:
- Normalized text fields (lowercase, trimmed)
- Type-casted numeric fields
- Validated date fields
- Consistent column naming

#### `stg_site_details`
Standardized site metadata.

#### `stg_event_counts`
Standardized event count data.

#### `stg_process_path`
Standardized process path definitions.

#### `stg_severity_level`
Standardized severity classifications.

#### `stg_contributing_factors`
Standardized contributing factor categories.

#### `stg_path_rate`
Standardized process path rates.

#### `stg_root_cause`
Standardized root cause categories.

### Integration Views

#### `int_site_period`
Combines site information with time periods.

**Key Fields**:
- `site` - Site identifier
- `period` - Time period
- `year` - Year
- Site attributes (region, country, org, etc.)

#### `int_site_week_hours`
Integrates site, week, and exposure hours.

**Key Fields**:
- `site` - Site identifier
- `week` - Week number
- `year` - Year
- `hours_worked` - Total exposure hours
- Site attributes

#### `int_site_process_path`
Links sites with process paths.

#### `int_site_week_hours_process_path` (or `int_site_period_week_hours_path`)
Comprehensive dataset combining:
- Site information
- Time dimensions (year, period, week)
- Exposure hours
- Process path
- Event counts

This is the primary analytical dataset used for modeling.

### Context Views

#### `dist_root_cause`
Distribution of incidents by root cause.

**Output**:
- Root cause category
- Count of incidents
- Percentage of total

#### `dist_process_path`
Distribution of incidents by process path.

**Output**:
- Process path
- Count of incidents
- Percentage of total

#### `dist_contributing_factors`
Distribution of incidents by contributing factors.

**Output**:
- Contributing factor
- Count of incidents
- Percentage of total

#### `dist_by_severity_level`
Distribution of incidents by severity level.

**Output**:
- Severity level
- Count of incidents
- Percentage of total

### Feature Views

#### `feat_site_week_hours_risk`
Risk metrics for overall site performance.

**Calculated Features**:
- Incident rate (incidents per exposure hour)
- Risk score
- Normalized rates
- Time-based features

#### `feat_site_week_hours_path_risk`
Risk metrics specific to process paths.

**Calculated Features**:
- Process-specific incident rates
- Path-adjusted risk scores
- Comparative metrics
- Process safety performance indicators

## Key Metrics and Calculations

### Incident Rate
```
Incident Rate = (Number of Incidents / Total Hours Worked) × Normalizing Factor
```

Typically normalized to incidents per 200,000 hours (approximately 100 full-time workers per year).

### Risk Score
Composite metric considering:
- Incident frequency
- Severity distribution
- Process path risk factors
- Historical trends

### Severity Levels
Classification of incidents by potential or actual harm:
- Critical
- High
- Medium
- Low
- Near Miss

## Data Quality Notes

### Standardization
All text fields are:
- Converted to lowercase
- Trimmed of leading/trailing whitespace
- Consistently formatted

### Data Types
- Dates: ISO 8601 format (YYYY-MM-DD)
- Numeric: Appropriate precision for calculations
- Text: UTF-8 encoding

### Null Handling
- Missing values handled appropriately per field
- Optional fields clearly documented
- Required fields validated during staging

## Usage in Analysis

### For Exploratory Analysis
Use integration layer views (`int_*`) for:
- Trends over time
- Site comparisons
- Regional analysis

### For Modeling
Use feature layer views (`feat_*`) for:
- Predictive modeling
- Risk forecasting
- Anomaly detection

### For Reporting
Use context layer views (`dist_*`) for:
- Summary statistics
- Distribution analysis
- Root cause reporting
