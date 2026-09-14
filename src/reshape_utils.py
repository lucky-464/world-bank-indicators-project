# reshape utility functions
import pandas as pd


def reshape_wdi(df, id_vars):
    """
    Reshape a wide WDI DataFrame to long format.
    One row per (Country, Indicator, Year).
    """
    year_cols = [col for col in df.columns if str(col).isdigit()]

    long_df = pd.melt(
        df,
        id_vars=id_vars,
        value_vars=year_cols,
        var_name='Years',
        value_name='Value',
    )

    return long_df