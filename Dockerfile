# Custom ERPNext image: base Frappe/ERPNext image + our login-theme app pre-baked in.
FROM frappe/erpnext:v15.28.1

USER frappe
WORKDIR /home/frappe/frappe-bench

# Copy our custom branding app's source into the bench's apps folder
COPY --chown=frappe:frappe apps/custom_loan_theme ./apps/custom_loan_theme

# Register the app with the bench, install it as an editable package,
# and pre-build its CSS/JS assets so the container starts instantly.
RUN echo "custom_loan_theme" >> sites/apps.txt && \
    pip install --no-cache-dir -e ./apps/custom_loan_theme && \
    bench build --app custom_loan_theme

COPY --chown=frappe:frappe entrypoint.sh /home/frappe/entrypoint.sh
USER root
RUN chmod +x /home/frappe/entrypoint.sh
USER frappe

EXPOSE 8000 9000

ENTRYPOINT ["/home/frappe/entrypoint.sh"]
