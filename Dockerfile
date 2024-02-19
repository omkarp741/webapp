FROM tomcat
COPY ./target/vprofile-v1.war /
CMD ["sleep", "infinity"]
