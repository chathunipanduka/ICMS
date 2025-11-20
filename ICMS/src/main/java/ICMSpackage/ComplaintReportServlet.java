package ICMSpackage;

import java.io.*;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.*;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

@WebServlet("/ComplaintReportServlet")
public class ComplaintReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String exportType = request.getParameter("exportType");
        String username = (String) request.getSession().getAttribute("username");
        
        System.out.println("Export type: " + exportType);
        
        if (username == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        
        // Get filter parameters
        String fStatus = request.getParameter("status");
        String fLocation = request.getParameter("location");
        String fFromDate = request.getParameter("fromDate");
        String fToDate = request.getParameter("toDate");
        String fSearch = request.getParameter("search");
        
        // Get department name
        String deptName = getDepartmentName(username);
        
        try {
            if ("excel".equals(exportType)) {
                exportToExcelCompatible(response, deptName, fStatus, fLocation, fFromDate, fToDate, fSearch);
            } else if ("pdf".equals(exportType)) {
                exportToPDF(response, deptName, fStatus, fLocation, fFromDate, fToDate, fSearch);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Export failed: " + e.getMessage());
        }
    }
    
    private String getDepartmentName(String username) {
        String deptName = "";
        try (Connection con = IcmsConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT dept_name FROM dept_admin_tb WHERE deptAdmUname = ?");
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) deptName = rs.getString("dept_name");
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return deptName;
    }
    
    private void exportToExcelCompatible(HttpServletResponse response, String deptName, String status, 
                                       String location, String fromDate, String toDate, String search) 
            throws Exception {
        
        Workbook workbook = null;
        ServletOutputStream out = null;
        
        try {
            System.out.println("Creating Excel workbook...");
            
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=complaints_report.xlsx");
            
            // Create workbook
            workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("Complaints Report");
            
            // Create header with minimal styling to avoid compatibility issues
            Row headerRow = sheet.createRow(0);
            String[] headers = {"ID", "Description", "Status", "User", "Location", "Department", "Date/Time", "Updated"};
            
            // Simple header style - using fully qualified names to avoid conflicts
            CellStyle headerStyle = workbook.createCellStyle();
            org.apache.poi.ss.usermodel.Font headerFont = workbook.createFont(); // Use full qualified name
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }
            
            // Get data
            List<ComplaintData> complaints = getComplaintsData(deptName, status, location, fromDate, toDate, search);
            System.out.println("Exporting " + complaints.size() + " records");
            
            // Add data rows safely
            int rowNum = 1;
            for (ComplaintData complaint : complaints) {
                Row row = sheet.createRow(rowNum++);
                
                // Use safe cell creation
                createCell(row, 0, String.valueOf(complaint.getId()));
                createCell(row, 1, complaint.getDescription());
                createCell(row, 2, complaint.getStatus());
                createCell(row, 3, complaint.getUsername());
                createCell(row, 4, complaint.getLocation());
                createCell(row, 5, complaint.getDeptName());
                createCell(row, 6, safeToString(complaint.getDateTime()));
                createCell(row, 7, complaint.getUpdatedTime() != null ? complaint.getUpdatedTime().toString() : "-");
            }
            
            // Auto-size columns
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }
            
            // Write to response
            out = response.getOutputStream();
            workbook.write(out);
            System.out.println("Excel export completed successfully!");
            
        } catch (Exception e) {
            System.err.println("Excel export error: " + e.getMessage());
            throw e;
        } finally {
            if (workbook != null) {
                try { workbook.close(); } catch (Exception e) { e.printStackTrace(); }
            }
            if (out != null) {
                try { out.flush(); } catch (Exception e) { e.printStackTrace(); }
            }
        }
    }
    
    private void createCell(Row row, int column, String value) {
        Cell cell = row.createCell(column);
        if (value != null) {
            cell.setCellValue(value);
        } else {
            cell.setCellValue("");
        }
    }
    
    private String safeToString(Timestamp timestamp) {
        return timestamp != null ? timestamp.toString() : "";
    }
    
    private void exportToPDF(HttpServletResponse response, String deptName, String status,
                            String location, String fromDate, String toDate, String search) 
            throws Exception {
        
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=complaints_report.pdf");
        
        Document document = new Document(PageSize.A4.rotate());
        ServletOutputStream outputStream = response.getOutputStream();
        PdfWriter.getInstance(document, outputStream);
        
        document.open();
        
        // Add title - using fully qualified names for PDF Font
        com.itextpdf.text.Font titleFont = new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 18, com.itextpdf.text.Font.BOLD);
        Paragraph title = new Paragraph("Complaints Report", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);
        
        // Get data
        List<ComplaintData> complaints = getComplaintsData(deptName, status, location, fromDate, toDate, search);
        
        // Create table
        PdfPTable table = new PdfPTable(8);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);
        table.setSpacingAfter(10f);
        
        // Table headers
        String[] pdfHeaders = {"ID", "Description", "Status", "User", "Location", "Department", "Date/Time", "Updated"};
        com.itextpdf.text.Font headerFont = new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 10, com.itextpdf.text.Font.BOLD);
        
        for (String header : pdfHeaders) {
            PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
            cell.setBackgroundColor(com.itextpdf.text.BaseColor.LIGHT_GRAY);
            cell.setPadding(5);
            table.addCell(cell);
        }
        
        // Table data
        com.itextpdf.text.Font dataFont = new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 8);
        for (ComplaintData complaint : complaints) {
            table.addCell(new Phrase(String.valueOf(complaint.getId()), dataFont));
            table.addCell(new Phrase(complaint.getDescription(), dataFont));
            table.addCell(new Phrase(complaint.getStatus(), dataFont));
            table.addCell(new Phrase(complaint.getUsername(), dataFont));
            table.addCell(new Phrase(complaint.getLocation(), dataFont));
            table.addCell(new Phrase(complaint.getDeptName(), dataFont));
            table.addCell(new Phrase(safeToString(complaint.getDateTime()), dataFont));
            table.addCell(new Phrase(
                complaint.getUpdatedTime() != null ? complaint.getUpdatedTime().toString() : "-", 
                dataFont
            ));
        }
        
        document.add(table);
        document.close();
        outputStream.flush();
    }
    
    private List<ComplaintData> getComplaintsData(String deptName, String status, String location,
                                                 String fromDate, String toDate, String search) 
            throws SQLException {
        
        List<ComplaintData> complaints = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = IcmsConnection.getConnection();
            
            StringBuilder sql = new StringBuilder(
                "SELECT c.id_complaint_tb, c.description, c.status, c.location, c.date_time, c.updated, " +
                "d.deptName, l.uName AS username " +
                "FROM complaint_tb c " +
                "LEFT JOIN dept_tb d ON c.dept_id = d.id_dept_tb " +
                "LEFT JOIN user_tb l ON c.user_id = l.id_login_tb " +
                "WHERE d.deptName = ? "
            );
            
            List<Object> bindParams = new ArrayList<>();
            bindParams.add(deptName);
            
            // Apply filters
            if (status != null && !status.trim().isEmpty()) {
                sql.append(" AND c.status = ? ");
                bindParams.add(status.trim());
            }
            if (location != null && !location.trim().isEmpty()) {
                sql.append(" AND c.location LIKE ? ");
                bindParams.add("%" + location.trim() + "%");
            }
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                sql.append(" AND DATE(c.date_time) >= ? ");
                bindParams.add(java.sql.Date.valueOf(fromDate.trim()));
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                sql.append(" AND DATE(c.date_time) <= ? ");
                bindParams.add(java.sql.Date.valueOf(toDate.trim()));
            }
            if (search != null && !search.trim().isEmpty()) {
                sql.append(" AND (c.id_complaint_tb LIKE ? OR c.description LIKE ? OR l.uName LIKE ? OR c.location LIKE ? ) ");
                String s = "%" + search.trim() + "%";
                bindParams.add(s);
                bindParams.add(s);
                bindParams.add(s);
                bindParams.add(s);
            }
            
            sql.append(" ORDER BY c.date_time DESC");
            
            ps = conn.prepareStatement(sql.toString());
            
            for (int i = 0; i < bindParams.size(); i++) {
                Object o = bindParams.get(i);
                if (o instanceof java.sql.Date) {
                    ps.setDate(i + 1, (java.sql.Date) o);
                } else {
                    ps.setObject(i + 1, o);
                }
            }
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                ComplaintData data = new ComplaintData();
                data.setId(rs.getInt("id_complaint_tb"));
                data.setDescription(rs.getString("description"));
                data.setStatus(rs.getString("status"));
                data.setLocation(rs.getString("location"));
                data.setUsername(rs.getString("username"));
                data.setDeptName(rs.getString("deptName"));
                data.setDateTime(rs.getTimestamp("date_time"));
                data.setUpdatedTime(rs.getTimestamp("updated"));
                complaints.add(data);
            }
            
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
        
        return complaints;
    }
    
    // Complete ComplaintData class
    private static class ComplaintData {
        private int id;
        private String description;
        private String status;
        private String username;
        private String location;
        private String deptName;
        private Timestamp dateTime;
        private Timestamp updatedTime;
        
        // Getters and setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        
        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }
        
        public String getLocation() { return location; }
        public void setLocation(String location) { this.location = location; }
        
        public String getDeptName() { return deptName; }
        public void setDeptName(String deptName) { this.deptName = deptName; }
        
        public Timestamp getDateTime() { return dateTime; }
        public void setDateTime(Timestamp dateTime) { this.dateTime = dateTime; }
        
        public Timestamp getUpdatedTime() { return updatedTime; }
        public void setUpdatedTime(Timestamp updatedTime) { this.updatedTime = updatedTime; }
    }
}