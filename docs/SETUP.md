# Setup and Installation Guide

## Prerequisites

Before setting up the Safety Risk Analysis pipeline, ensure you have the following installed:

- **Python 3.7 or higher**
- **SQLite3** (usually comes pre-installed with Python)
- **pip** (Python package manager)
- **Git** (for cloning the repository)

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/JudeMirac/Saftey-Risk-Analysis.git
cd Saftey-Risk-Analysis
```

### 2. Set Up Python Virtual Environment (Recommended)

Creating a virtual environment helps isolate project dependencies:

```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
# On macOS/Linux:
source venv/bin/activate

# On Windows:
venv\Scripts\activate
```

### 3. Install Python Dependencies

```bash
pip install -r requirements.txt
```

This will install:
- pandas - Data manipulation and analysis
- numpy - Numerical computing
- jupyter - Interactive notebooks
- matplotlib - Data visualization
- seaborn - Statistical data visualization

### 4. Verify Installation

Check that all packages are installed correctly:

```bash
python3 -c "import pandas; import numpy; import sqlite3; print('All packages installed successfully!')"
```

## Initial Setup

### 1. Prepare the Database

The repository includes a pre-populated database (`database/Safety.db`). If you need to rebuild it from scratch:

```bash
# Remove existing database (if any)
rm database/Safety.db

# Run all loader scripts to create raw tables
python database_scripts/load_raw_hours_worked.py
python database_scripts/load_raw_counts.py
python database_scripts/load_raw_severity.py
python database_scripts/load_raw_path_rates.py
python database_scripts/load_raw_root_cause.py
python database_scripts/load_raw_contributing_factors.py
python database_scripts/load_raw_process_path.py
python database_scripts/load_raw_site_details.py
```

### 2. Run the Data Pipeline

Execute the main pipeline to create all staging, integration, context, and feature views:

```bash
python Run_Pipeline.py
```

Expected output:
```
Executed sql/staging/staged_hours_worked.sql
Executed sql/staging/staged_site_details.sql
...
Pipeline run complete.
```

### 3. Verify the Setup

The pipeline script includes automatic verification. You should see:
- List of all database tables
- Sample columns from key integration tables
- Preview of feature tables

## Working with Jupyter Notebooks

### Starting Jupyter

```bash
jupyter notebook
```

This will open a browser window with the Jupyter interface.

### Available Notebooks

1. **Exploratory_Analysis.ipynb** - Start here for an overview of the data
2. **data_health_checks.ipynb** - Validate data quality
3. **Context_EDA.ipynb** - Analyze incident distributions
4. **process_path_EDA.ipynb** - Process path specific analysis
5. **Incident_count_model.ipynb** - Predictive modeling

## Directory Structure After Setup

```
Saftey-Risk-Analysis/
├── Data/                          # Your CSV data files
├── database/
│   └── Safety.db                  # SQLite database (created)
├── database_scripts/              # Loader scripts
├── sql/                           # SQL transformations
├── notebooks/                     # Jupyter notebooks
├── docs/                          # Documentation
├── Run_Pipeline.py                # Main pipeline script
├── requirements.txt               # Python dependencies
└── README.md                      # Project overview
```

## Troubleshooting

### Issue: "ModuleNotFoundError: No module named 'pandas'"

**Solution**: Ensure you've activated your virtual environment and installed dependencies:
```bash
source venv/bin/activate  # or venv\Scripts\activate on Windows
pip install -r requirements.txt
```

### Issue: "OperationalError: unable to open database file"

**Solution**: Ensure the `database/` directory exists and you have write permissions:
```bash
mkdir -p database
chmod 755 database
```

### Issue: "FileNotFoundError: [Errno 2] No such file or directory: 'Data/...'"

**Solution**: Ensure all required CSV files are in the correct subdirectories under `Data/`:
```bash
ls -R Data/
```

### Issue: SQLite version compatibility

**Solution**: Check your SQLite version:
```bash
python3 -c "import sqlite3; print(sqlite3.sqlite_version)"
```

SQLite 3.7.0 or higher is recommended.

## Updating the Pipeline

### Adding New Data

1. Place new CSV files in the appropriate `Data/` subdirectory
2. Run the relevant loader script or create a new one
3. Update the pipeline if new transformations are needed

### Modifying Transformations

1. Edit the relevant SQL file in `sql/staging/`, `sql/integration/`, etc.
2. Re-run the pipeline: `python Run_Pipeline.py`
3. Views will be dropped and recreated with your changes

## Configuration

### Database Location

By default, the database is located at `database/Safety.db`. To change this, update the path in:
- `Run_Pipeline.py`
- Individual loader scripts in `database_scripts/`
- Jupyter notebooks

### Data File Locations

Data file paths are specified in the loader scripts in `database_scripts/`. Update these if your data files are in different locations.

## Performance Considerations

### Large Datasets

For very large datasets:
- Consider creating indexes on frequently queried columns
- Use SQLite ANALYZE command to optimize query planning
- Consider partitioning by time period

### Memory Usage

Jupyter notebooks may consume significant memory when loading large tables. Consider:
- Loading data in chunks using pandas `chunksize` parameter
- Using SQL queries to filter data before loading into pandas
- Closing database connections when not in use

## Next Steps

After successful setup:

1. **Explore the Data**: Open `notebooks/Exploratory_Analysis.ipynb`
2. **Review Architecture**: Read `docs/ARCHITECTURE.md`
3. **Understand Data**: Reference `docs/DATA_DICTIONARY.md`
4. **Run Analysis**: Execute the notebooks in order
5. **Customize**: Modify SQL transformations for your specific needs

## Getting Help

If you encounter issues:

1. Check the troubleshooting section above
2. Review the documentation in `docs/`
3. Examine the SQL files for transformation logic
4. Open an issue on GitHub

## Development Setup

For development and contribution:

```bash
# Install development dependencies (if you create a dev-requirements.txt)
pip install -r dev-requirements.txt

# Run tests (if implemented)
pytest

# Code formatting
black *.py database_scripts/*.py
```

## Deactivating Virtual Environment

When you're done working:

```bash
deactivate
```

This returns you to your global Python environment.
