# Use official Apache image
FROM httpd:2.4

# Copy website files
COPY public/ /usr/local/apache2/htdocs/

# Create virtual host config
RUN echo '\
<VirtualHost *:8080>\n\
    DocumentRoot "/usr/local/apache2/htdocs/site1"\n\
    ServerName site1.railway.app\n\
</VirtualHost>\n\
<VirtualHost *:8080>\n\
    DocumentRoot "/usr/local/apache2/htdocs/site2"\n\
    ServerName site2.railway.app\n\
</VirtualHost>\n\
' > /usr/local/apache2/conf/extra/httpd-vhosts.conf

# Include virtual hosts in Apache config
RUN echo 'Include conf/extra/httpd-vhosts.conf' >> /usr/local/apache2/conf/httpd.conf

# Use dynamic Railway port
ENV PORT 8080
RUN sed -i "s/Listen 80/Listen ${PORT}/" /usr/local/apache2/conf/httpd.conf
RUN sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${PORT}>/" /usr/local/apache2/conf/extra/httpd-vhosts.conf

# Expose port
EXPOSE ${PORT}

# Start Apache in foreground
CMD ["httpd-foreground"]
