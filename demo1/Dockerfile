FROM openjdk:11
COPY . /app
COPY lib /app/lib
WORKDIR /app
RUN javac QueryDB.java
CMD ["java", "-classpath",  "lib/*:.", "QueryDB", "jdbc:mysql://10.1.1.237/db1?user=root&password=Welcome1!"] 

