import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class ClearSlots {
    public static void main(String[] args) {
        try {
            String dbPassword = System.getenv("SPRING_DATASOURCE_PASSWORD") != null ? System.getenv("SPRING_DATASOURCE_PASSWORD") : "";
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/queue_db", "root", dbPassword);
            Statement stmt = conn.createStatement();
            stmt.executeUpdate("TRUNCATE TABLE tokens");
            stmt.executeUpdate("TRUNCATE TABLE slot");
            stmt.executeUpdate("TRUNCATE TABLE token_sequences");
            System.out.println("CLEARED SUCCESSFULLY");
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
