FROM openjdk:11
COPY . /app
COPY lib /app/lib
WORKDIR /app
RUN javac QueryDB.java
CMD ["java", "-classpath",  "lib/*:.", "QueryDB", "jdbc:mysql://127.0.0.1/db1", "root", "Welcome1!"] 

