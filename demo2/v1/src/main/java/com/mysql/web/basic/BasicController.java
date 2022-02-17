package com.mysql.web.basic.controller;
import org.springframework.web.bind.annotation.*;
import java.sql.*;

@RestController

public class BasicController { 
  private String DB_URL = "jdbc:mysql://10.1.1.237/db1?user=root&password=Welcome1!";                              
  @GetMapping("/query")
  public String query() {
    StringBuilder str = new StringBuilder("");
    try {
      Connection conn = DriverManager.getConnection(DB_URL);
      Statement stmt = conn.createStatement();
      ResultSet rs = stmt.executeQuery("SELECT * FROM t1");
      while (rs.next()) {
        str.append(rs.getInt(1) + ":" + rs.getString(2) + " ");
      }
    } catch(SQLException e) {
      str = new StringBuilder(e.getMessage());
    }
    return str.toString();
  }
}


