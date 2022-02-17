package com.mysql.web.basic.controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import com.mysql.web.basic.config.DbProperties;
import java.sql.*;

@RestController

public class BasicController { 
  private String dbUrl = null;
  @Autowired
  public BasicController(DbProperties properties) {
    String baseUrl = properties.getUrl();
    String username = System.getenv("DB_USERNAME");
    String password = System.getenv("DB_PASSWORD");
    this.dbUrl = baseUrl + "?user=" + username + "&password=" + password;
  }

  @GetMapping("/query")
  public String query() {
    StringBuilder str = new StringBuilder("");
    try {
      Connection conn = DriverManager.getConnection(this.dbUrl);
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


