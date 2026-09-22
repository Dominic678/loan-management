# Custom ERPNext image: base Frappe/ERPNext image + our custom loan theme app
FROM frappe/erpnext:v15.28.1

USER frappe
WORKDIR /home/frappe/frappe-bench

# Copy the custom branding/loan theme app into the bench apps directory
COPY --chown=frappe:frappe apps/custom_loan_theme ./apps/custom_loan_theme

# Register the custom app on a separate line in sites/apps.txt,
# install it as an editable Python package, and build its assets.
RUN sed -i '$a custom_loan_theme' sites/apps.txt && \
    pip install --no-cache-dir -e ./apps/custom_loan_theme && \
    bench build --app custom_loan_theme

# Copy the custom entrypoint
COPY --chown=frappe:frappe entrypoint.sh /home/frappe/entrypoint.sh

USER root

# Make the entrypoint executable
RUN chmod +x /home/frappe/entrypoint.sh

USER frappe

EXPOSE 8000 9000

ENTRYPOINT ["/home/frappe/entrypoint.sh"]