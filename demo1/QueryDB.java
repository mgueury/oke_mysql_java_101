import java.sql.*;
public class QueryDB {
  public static void main(String[] args) {
    try {
      Connection cnx = DriverManager.getConnection(args[0]);
      Statement stmt = cnx.createStatement();
      ResultSet rs = stmt.executeQuery("SELECT id, name FROM t1");
      while (rs.next()) {
        System.out.println(rs.getInt(1) + " " + rs.getString(2));
      }
      cnx.close();
    } catch (SQLException e) {
      e.printStackTrace();
    }
  }
} 

