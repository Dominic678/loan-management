# Loan Management System (ERPNext)

This project runs **ERPNext**, which already ships a full, production-grade
**Loan Management** module — loan types, loan applications, disbursement,
repayment schedules, interest accrual, and loan closure — inside Docker,
with a custom app that gives the login page a modern, attractive look.

## What's in this repo

```
├── Dockerfile              # Builds ERPNext + the custom login theme
├── entrypoint.sh           # First-boot site creation, then starts ERPNext
├── docker-compose.yml      # Run everything locally
├── render.yaml             # One-click Render Blueprint deployment
├── apps/custom_loan_theme/ # Small Frappe app: gradient login card, custom CSS
└── .gitignore
```

## 1. Run it locally first (recommended)

```bash
docker compose build
docker compose up -d
```

First boot takes a few minutes (creating the site + installing ERPNext +
the theme). Watch progress with:

```bash
docker compose logs -f erpnext
```

Once it's ready, open **http://localhost:8000**, log in as:

- Username: `Administrator`
- Password: whatever you set as `ADMIN_PASSWORD` in a `.env` file (defaults to `admin`)

Loan Management lives under the **Loans** workspace in the ERPNext sidebar —
you can create Loan Types, approve Loan Applications, disburse loans, and
track repayment schedules right away, no extra coding needed.

## 2. Push this to GitHub

```bash
cd loan-management-erpnext
git init
git add .
git commit -m "Loan management system - ERPNext + custom login theme"
git branch -M main
git remote add origin https://github.com/<your-username>/<your-repo>.git
git push -u origin main
```

(Create the empty repo on github.com first, without a README, so the push
above doesn't conflict.)

## 3. Deploy on Render

Render can read `render.yaml` and stand up all three services
(MariaDB, Redis, ERPNext) automatically.

