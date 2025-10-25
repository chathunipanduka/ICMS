package ICMSpackage;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    // Hash the password before saving to DB
    public static String hashPassword(String plainTextPassword) {
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt());
    }

    // Verify password during login
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}