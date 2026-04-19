import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# ---------- LOAD ----------
file_path = r'D:\Career\Projects\nykaa_dasboard\FSN_ECommerce.xlsx'

df_raw = pd.read_excel(file_path, sheet_name='Data Sheet', header=None)
df_bs  = pd.read_excel(file_path, sheet_name='Balance Sheet', header=None)
df_cf  = pd.read_excel(file_path, sheet_name='Cash Flow', header=None)

years = ['2018','2019','2020','2021','2022','2023','2024','2025']

# ---------- PROFIT & LOSS ----------
pl = pd.DataFrame({
    'Year'                : years,
    'Sales'               : [df_raw.iloc[16, c] for c in range(3, 11)],
    'Raw_Material_Cost'   : [df_raw.iloc[17, c] for c in range(3, 11)],
    'Change_in_Inventory' : [df_raw.iloc[18, c] for c in range(3, 11)],
    'Other_Mfr_Exp'       : [df_raw.iloc[19, c] for c in range(3, 11)],
    'Employee_Cost'       : [df_raw.iloc[21, c] for c in range(3, 11)],
    'Selling_and_Admin'   : [df_raw.iloc[23, c] for c in range(3, 11)],
    'Power_and_Fuel'      : [df_raw.iloc[24, c] for c in range(3, 11)],
    'Other_Expenses'      : [df_raw.iloc[25, c] for c in range(3, 11)],
    'Net_profit'          : [df_raw.iloc[29, c] for c in range(3, 11)],
})

pl.fillna(0, inplace=True)
pl['Year'] = pl['Year'].astype(str)

# ---------- CALCULATIONS ----------
pl['Revenue_Growth_Pct'] = (pl['Sales'].pct_change() * 100).round(2).fillna(0)

pl['COGS'] = pl['Raw_Material_Cost'] + pl['Change_in_Inventory'] + pl['Other_Mfr_Exp']
pl['Gross_Margin_Pct'] = ((pl['Sales'] - pl['COGS']) / pl['Sales'].replace(0,1) * 100).round(2)

pl['Total_OpEx'] = (
    pl['Raw_Material_Cost'] + pl['Change_in_Inventory'] +
    pl['Employee_Cost'] + pl['Selling_and_Admin'] +
    pl['Power_and_Fuel'] + pl['Other_Mfr_Exp'] +
    pl['Other_Expenses']
)

pl['Operating_Profit'] = pl['Sales'] - pl['Total_OpEx']
pl['OPM_Pct'] = (pl['Operating_Profit'] / pl['Sales'].replace(0,1) * 100).round(2)
pl['NPM_Pct'] = (pl['Net_profit'] / pl['Sales'].replace(0,1) * 100).round(2)

# ---------- BALANCE SHEET ----------
def get_row(df, label):
    row = df[df[0].astype(str).str.contains(label, case=False, na=False)]
    if row.empty:
        return [0]*8
    return row.iloc[0, 3:11].values

bs = pd.DataFrame({
    'Year': years,
    'Equity_Share_Capital': get_row(df_bs, 'Equity'),
    'Reserves': get_row(df_bs, 'Reserves'),
    'Borrowings': get_row(df_bs, 'Borrowings'),
})

for col in ['Equity_Share_Capital', 'Reserves', 'Borrowings']:
    bs[col] = pd.to_numeric(bs[col], errors='coerce')

bs.fillna(0, inplace=True)

bs['Total_Equity'] = bs['Equity_Share_Capital'] + bs['Reserves']
bs['Debt_to_Equity'] = (bs['Borrowings'] / bs['Total_Equity'].replace(0,1)).round(2)

# ---------- CASH FLOW ----------
cf = pd.DataFrame({
    'Year': years,
    'Cash_Flow': get_row(df_cf, 'Operating')
})

cf['Cash_Flow'] = pd.to_numeric(cf['Cash_Flow'], errors='coerce')
cf.fillna(0, inplace=True)

# ---------- MERGE ----------
pl = pl.merge(bs[['Year','Debt_to_Equity']], on='Year', how='left')
pl = pl.merge(cf, on='Year', how='left')

# ---------- SAVE ----------
pl.to_csv('data/nykaa_cleaned.csv', index=False)

# ---------- DASHBOARD ----------
plt.style.use('dark_background')

fig, axes = plt.subplots(2, 2, figsize=(16, 10))
axes = axes.flatten()

# Revenue
axes[0].plot(pl['Year'], pl['Sales'], marker='o', color='#ff4d6d', linewidth=2.5)
axes[0].fill_between(pl['Year'], pl['Sales'], alpha=0.2, color='#ff4d6d')
axes[0].set_title('Revenue Trend (₹ Cr)')

# Margin breakdown
latest = pl.iloc[-1]
axes[1].bar(['Gross','OPM','Net'],
            [latest['Gross_Margin_Pct'], latest['OPM_Pct'], latest['NPM_Pct']],
            color=['#00d4aa','#ffd166','#ff4d6d'])
axes[1].set_title('Margin Breakdown')

# Trends
axes[2].plot(pl['Year'], pl['Gross_Margin_Pct'], label='Gross')
axes[2].plot(pl['Year'], pl['OPM_Pct'], label='OPM')
axes[2].plot(pl['Year'], pl['NPM_Pct'], label='Net')
axes[2].legend()
axes[2].set_title('Margin Trends')

# Cash vs Profit
x = np.arange(len(pl))
axes[3].bar(x-0.2, pl['Net_profit'], width=0.4)
axes[3].bar(x+0.2, pl['Cash_Flow'], width=0.4)
axes[3].set_xticks(x)
axes[3].set_xticklabels(pl['Year'])
axes[3].set_title('Cash Flow vs Net Profit')

plt.suptitle('Nykaa Financial Dashboard')
plt.tight_layout()
plt.savefig('data/final_dashboard.png')
plt.show()