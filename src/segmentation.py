"""Customer segmentation via RFM clustering."""

import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
import numpy as np

class RFMSegmentation:
    def __init__(self, df):
        """
        Args:
            df: DataFrame with columns [recency, frequency, monetary]
        """
        self.df = df.copy()
        self.scaler = StandardScaler()
        self.kmeans = None
        self.segments = None
    
    def fit(self, n_clusters=4):
        """Fit KMeans clustering on normalized RFM values."""
        # Normalize RFM
        rfm_values = self.df[['recency', 'frequency', 'monetary']].values
        normalized = self.scaler.fit_transform(rfm_values)
        
        # Cluster
        self.kmeans = KMeans(n_clusters=n_clusters, random_state=42)
        clusters = self.kmeans.fit_predict(normalized)
        
        self.df['cluster'] = clusters
        return self
    
    def predict(self, recency, frequency, monetary):
        """Predict segment for new customer."""
        X = np.array([[recency, frequency, monetary]])
        X_normalized = self.scaler.transform(X)
        return self.kmeans.predict(X_normalized)[0]
    
    def segment_summary(self):
        """Get summary statistics per segment."""
        summary = self.df.groupby('cluster').agg({
            'recency': ['mean', 'min', 'max'],
            'frequency': ['mean', 'min', 'max'],
            'monetary': ['mean', 'min', 'max']
        }).round(2)
        return summary

def rfm_scoring(df):
    """RFM scoring using quantile-based approach."""
    df['r_score'] = pd.qcut(df['recency'], 5, labels=[5, 4, 3, 2, 1])
    df['f_score'] = pd.qcut(df['frequency'].rank(method='first'), 5, labels=[1, 2, 3, 4, 5])
    df['m_score'] = pd.qcut(df['monetary'], 5, labels=[1, 2, 3, 4, 5])
    
    df['rfm_segment'] = df['r_score'].astype(str) + df['f_score'].astype(str) + df['m_score'].astype(str)
    return df
