import streamlit as st
import pandas as pd
from sqlalchemy import create_engine
import plotly.express as px

# -----------------------------
# PAGE CONFIG
# -----------------------------
st.set_page_config(layout="wide")

# -----------------------------
# STYLE FUNCTION (PUT HERE ✅)
# -----------------------------
def style_chart(fig):
    fig.update_layout(
        height=600,  
        title_font=dict(size=30),
        font=dict(size=20),

        xaxis=dict(
            title_font=dict(size=22),
            tickfont=dict(size=18)
        ),

        yaxis=dict(
            title_font=dict(size=22),
            tickfont=dict(size=18)
        )
    )
    return fig

# -----------------------------
# DB CONNECTION
# -----------------------------
engine = create_engine("mysql+pymysql://root:root@localhost:3308/banking_db")

st.title("🏦 Banking Transactions & Fraud Detection Dashboard")

# -----------------------------
# LOAD DATA
# -----------------------------
@st.cache_data
def load_data():
    transactions = pd.read_sql("SELECT * FROM transactions", engine)
    risk = pd.read_sql("SELECT * FROM risk_events", engine)
    risky_accounts = pd.read_sql("SELECT * FROM v_risky_accounts", engine)
    return transactions, risk, risky_accounts

transactions, risk, risky_accounts = load_data()

# -----------------------------
# KPIs
# -----------------------------
col1, col2, col3 = st.columns(3)

col1.metric("Total Transactions", len(transactions))
col2.metric("Fraud Alerts", len(risk))
col3.metric("Unique Accounts", transactions['account_id'].nunique())

# -----------------------------
# TRANSACTION TREND
# -----------------------------
transactions['txn_ts'] = pd.to_datetime(transactions['txn_ts'])

daily = transactions.groupby(transactions['txn_ts'].dt.date)['amount'].sum().reset_index()

fig1 = px.line(daily, x='txn_ts', y='amount', title="Daily Transaction Volume")
fig1 = style_chart(fig1)
st.plotly_chart(fig1, use_container_width=True)

# -----------------------------
# CHANNEL ANALYSIS
# -----------------------------
channel_df = transactions.groupby('channel')['amount'].sum().reset_index()

fig2 = px.bar(channel_df, x='channel', y='amount', title="Transaction by Channel")
fig2 = style_chart(fig2)
st.plotly_chart(fig2, use_container_width=True)


# -----------------------------
# HIGH VALUE TRANSACTIONS
# -----------------------------
high_value = transactions[transactions['amount'] > 50000]

fig3 = px.histogram(high_value, x='amount', nbins=20, title="High Value Transactions")
fig3 = style_chart(fig3)
st.plotly_chart(fig3, use_container_width=True)


# -----------------------------
# RISKY ACCOUNTS
# -----------------------------
st.subheader("Top Risky Accounts")
st.dataframe(risky_accounts.head(10))

# -----------------------------
# FRAUD ALERT DISTRIBUTION
# -----------------------------
if not risk.empty:
    fig4 = px.pie(risk, names='rule_code', title="Fraud Rule Distribution")
    fig4 = style_chart(fig4)
    st.plotly_chart(fig4, use_container_width=True)
   
