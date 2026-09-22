# Custom ERPNext image
FROM frappe/erpnext:v15.28.1

USER frappe
WORKDIR /home/frappe/frappe-bench

# Copy custom loan theme app
COPY --chown=frappe:frappe apps/custom_loan_theme ./apps/custom_loan_theme

# Add custom app to apps.txt
RUN echo "custom_loan_theme" >> sites/apps.txt

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