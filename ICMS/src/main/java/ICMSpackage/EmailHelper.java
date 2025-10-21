package ICMSpackage;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailHelper {

    public static void sendEmail(String toEmail, String subject, String body) {
        final String fromEmail = "bps.icms@gmail.com"; // your Gmail
        final String password = "dmej lwxp gpht xrye"; // 16-char App Password

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, "ICMS Notifications"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(body, "text/html; charset=utf-8");
            message.setReplyTo(new Address[]{new InternetAddress("support@icms.lk")});

            Transport.send(message);
            System.out.println("✅ Email sent successfully to " + toEmail);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
