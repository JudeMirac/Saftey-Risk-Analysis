# Safety Risk Analysis Pipeline

A comprehensive data analytics pipeline for analyzing workplace safety incidents, exposure hours, and risk factors across multiple sites and organizational units.

## Important Note on Data

**The data used in this project is synthetic and generated for demonstration purposes only.** Due to data leakage policies within the company, actual operational data cannot be shared publicly. However, the analytical pipeline and analysis methods implemented here closely mimic the yearly safety report created for a specific site of operation, maintaining the same structure, metrics, and analytical approaches used in production.

## Project Overview

This project implements an end-to-end data pipeline that:
- Ingests safety incident data from multiple CSV sources
- Stages and transforms data using SQL views
- Integrates data across time periods, sites, and process paths
- Analyzes incident distributions by root cause, severity, and contributing factors
- Generates risk metrics and features for analysis

## Architecture

The pipeline follows a layered architecture:

```
Raw Data (CSV) → SQLite Database → Staging → Integration → Context/Features → Analysis
```

### Data Layers:

1. **Raw Layer**: CSV files loaded into SQLite tables
2. **Staging Layer**: Standardized views with cleaned and normalized data
3. **Integration Layer**: Unified datasets combining site, time, and exposure data
4. **Context Layer**: Statistical distributions of incidents by various dimensions
5. **Features Layer**: Calculated risk metrics for analysis

## Project Structure

```
├── Data/                          # Raw CSV data files
│   ├── safety_events/            # Safety incident records
│   ├── hours_worked/             # Exposure hours by site
│   ├── dimensions/               # Site details and metadata
│   └── exposure/                 # Event count data
├── database/                      # SQLite database
│   └── Safety.db                 # Main database file
├── database_scripts/              # Python scripts to load raw data
│   ├── load_raw_counts.py
│   ├── load_raw_hours_worked.py
│   ├── load_raw_severity.py
│   └── ...
├── sql/                          # SQL transformation scripts
│   ├── staging/                  # Data staging views
│   ├── integration/              # Data integration views
│   ├── context/                  # Statistical analysis queries
│   └── features/                 # Feature engineering queries
├── notebooks/                     # Jupyter notebooks for analysis
│   ├── Exploratory_Analysis.ipynb
│   ├── Context_EDA.ipynb
│   ├── process_path_EDA.ipynb
│   └── data_health_checks.ipynb
└── Run_Pipeline.py               # Main pipeline execution script
```

## Getting Started

### Prerequisites

- Python 3.7+
- SQLite3
- Pandas
- Jupyter Notebook (for analysis notebooks)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/JudeMirac/Saftey-Risk-Analysis.git
cd Saftey-Risk-Analysis
```

2. Install required packages:
```bash
pip install -r requirements.txt
```

3. Ensure your data files are in the `Data/` directory structure

### Usage

#### Running the Full Pipeline

Execute the main pipeline script to process all data layers:

```bash
python Run_Pipeline.py
```

This will:
1. Execute all staging transformations
2. Create integrated datasets
3. Generate context and distribution tables
4. Build feature tables for analysis

#### Loading Raw Data

To reload raw data into the database, run the individual loader scripts:

```bash
python database_scripts/load_raw_hours_worked.py
python database_scripts/load_raw_counts.py
python database_scripts/load_raw_severity.py
# ... run other loaders as needed
```

#### Exploring Analysis

Open the Jupyter notebooks to explore the data and analysis:

```bash
jupyter notebook
```

Key notebooks:
- `Exploratory_Analysis.ipynb` - Overall data exploration
- `Context_EDA.ipynb` - Incident distribution analysis
- `process_path_EDA.ipynb` - Process path specific analysis
- `data_health_checks.ipynb` - Data quality validation

## Key Features

### Risk Metrics
- **Incident Rate**: Incidents per exposure hours
- **Severity Distribution**: Classification by severity levels
- **Process Path Analysis**: Risk patterns by operational processes
- **Root Cause Analysis**: Identification of primary incident drivers
- **Contributing Factors**: Secondary factors influencing incidents

### Data Quality
- Standardized text fields (lowercase, trimmed)
- Type casting for numeric and date fields
- Validation checks for data completeness
- Reproducible transformations using SQL views

## Analysis Capabilities

The pipeline supports various analytical use cases:
- Trend analysis of safety incidents over time
- Identification of high-risk process paths
- Root cause and contributing factor analysis
- Resource allocation based on exposure hours and risk

##  Technology Stack

- **Database**: SQLite3
- **Data Processing**: Python, Pandas
- **SQL**: For data transformation and feature engineering
- **Analysis**: Jupyter Notebooks
- **Visualization**: (Add your visualization libraries here)

## Data Pipeline Details

### Staging Layer
Standardizes raw data by:
- Normalizing text fields (lowercase, trim)
- Casting data types appropriately
- Creating consistent column naming
- Removing duplicates and handling nulls

### Integration Layer
Combines data across dimensions:
- Site + Time Period: `int_site_period`
- Site + Week + Hours: `int_site_week_hours`
- Site + Process Path: `int_site_process_path`
- Comprehensive: `int_site_week_hours_process_path`

### Context Layer
Provides statistical distributions:
- Distribution by root cause
- Distribution by process path
- Distribution by contributing factors
- Distribution by severity level

### Features Layer
Generates metrics for analysis:
- Site-level risk metrics
- Process path-specific risk metrics
- Time-windowed calculations
- Normalized incident rates

  
## License

This project is licensed under the MIT License - see the LICENSE file for details.

##  Author

**Jude Mirac**

##  Acknowledgments

- Data sourced from workplace safety management systems
- Built with Python and SQLite for portability and efficiency
