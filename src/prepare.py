"""
Data Preparation Stage
Loads raw dataset and performs initial cleaning
"""
import argparse
import pandas as pd
import yaml
import os

def load_params():
    with open("params.yaml") as f:
        return yaml.safe_load(f)

def prepare_data(dataset_path, out_dir, random_seed):
    """Load and prepare the house price dataset"""
    print(f"📥 Loading dataset from {dataset_path}...")
    
    # Load data
    df = pd.read_csv(dataset_path)
    
    print(f"   Original shape: {df.shape}")
    print(f"   Columns: {list(df.columns)}")
    
    # Select relevant columns
    columns_to_keep = ['city', 'property_type', 'price', 'baths', 'bedrooms', 
                      'purpose', 'latitude', 'longitude', 'Area Type', 'Area Size']
    
    df = df[columns_to_keep]
    
    # Handle missing values
    initial_rows = len(df)
    df = df.dropna(subset=['price', 'bedrooms', 'baths', 'Area Size'])
    print(f"   Removed {initial_rows - len(df)} rows with missing values")
    
    # Remove rows with invalid prices (0 or negative)
    df = df[df['price'] > 0]
    
    # Remove outliers (price) - keep 1st to 99th percentile
    Q1 = df['price'].quantile(0.01)
    Q3 = df['price'].quantile(0.99)
    df = df[(df['price'] >= Q1) & (df['price'] <= Q3)]
    print(f"   Removed outliers, final shape: {df.shape}")
    
    print(f"   Price range: {df['price'].min():,.0f} - {df['price'].max():,.0f} PKR")
    
    # Save prepared data
    os.makedirs(out_dir, exist_ok=True)
    output_path = os.path.join(out_dir, "prepared_data.csv")
    df.to_csv(output_path, index=False)
    
    print(f"✅ Prepared data saved to {output_path}")
    return df

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--out_dir", type=str, default="data")
    args = parser.parse_args()
    
    params = load_params()
    prepare_params = params['prepare']
    
    prepare_data(
        dataset_path=prepare_params['dataset_path'],
        out_dir=args.out_dir,
        random_seed=prepare_params['random_seed']
    )
    
    print("✅ Data preparation complete!")
