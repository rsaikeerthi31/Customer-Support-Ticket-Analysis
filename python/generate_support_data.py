import pandas as pd
import random
from datetime import datetime, timedelta

issue_types = ["Login Issue", "Payment Issue", "Delivery Delay", "App Crash", "Refund Request"]
priorities = ["Low", "Medium", "High"]
statuses = ["Open", "In Progress", "Closed"]
departments = {
    "Login Issue": "Technical",
    "App Crash": "Technical",
    "Payment Issue": "Billing",
    "Refund Request": "Billing",
    "Delivery Delay": "Logistics"
}

data = []

start_date = datetime(2024, 1, 1)

for i in range(1, 301):  # 300 records
    issue = random.choice(issue_types)
    created = start_date + timedelta(days=random.randint(0, 90))
    
    if random.choice([True, False]):
        resolved = created + timedelta(days=random.randint(1, 7))
        status = "Closed"
    else:
        resolved = None
        status = random.choice(["Open", "In Progress"])
    
    data.append([
        i,
        random.randint(1000, 2000),
        issue,
        random.choice(priorities),
        status,
        created.date(),
        resolved.date() if resolved else "",
        departments[issue],
        random.randint(1, 5)
    ])

df = pd.DataFrame(data, columns=[
    "ticket_id",
    "customer_id",
    "issue_type",
    "priority",
    "status",
    "created_date",
    "resolved_date",
    "department",
    "satisfaction_rating"
])

df.to_csv("../data/support_tickets.csv", index=False)

print("✅ 300 support tickets generated successfully")
