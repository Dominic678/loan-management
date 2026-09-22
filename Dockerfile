FROM frappe/erpnext:v15.28.1

USER frappe
WORKDIR /home/frappe/frappe-bench

# Copy custom loan theme app
COPY --chown=frappe:frappe apps/custom_loan_theme ./apps/custom_loan_theme

# Ensure custom_loan_theme is added as a separate entry in apps.txt
RUN python -c "from pathlib import Path; p=Path('sites/apps.txt'); s=p.read_text(); s=s.rstrip('\n') + '\ncustom_loan_theme\n'; p.write_text(s)"

# Install custom app
RUN pip install --no-cache-dir -e ./apps/custom_loan_theme

# Build custom app assets
RUN bench build --app custom_loan_theme

# Copy entrypoint
COPY --chown=frappe:frappe entrypoint.sh /home/frappe/entrypoint.sh

USER root
RUN chmod +x /home/frappe/entrypoint.sh

USER frappe

EXPOSE 8000 9000

ENTRYPOINT ["/home/frappe/entrypoint.sh"]