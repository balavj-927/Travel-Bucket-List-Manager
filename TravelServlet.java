/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package travelbucket;


import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author Akshaya V
 */
 public class TravelServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String deleteId = request.getParameter("delete_id");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/travelbucket", "root", "");

            if (deleteId != null) {
                String sql = "DELETE FROM destinations WHERE id=?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, Integer.parseInt(deleteId));
                stmt.executeUpdate();
                stmt.close();
            } else {
                String id = request.getParameter("id");
                String place = request.getParameter("place");
                String country = request.getParameter("country");
                String date = request.getParameter("travel_date");
                String notes = request.getParameter("notes");
                String tripType = request.getParameter("trip_type");
                String[] activitiesArr = request.getParameterValues("activities");
                String imageUrl = request.getParameter("image_url");

                String activities = (activitiesArr != null) ? String.join(", ", activitiesArr) : "";

                if (id != null && !id.isEmpty()) {
                    String sql = "UPDATE destinations SET place=?, country=?, travel_date=?, notes=?, trip_type=?, activities=?, image_url=? WHERE id=?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setString(1, place);
                    stmt.setString(2, country);
                    stmt.setString(3, date);
                    stmt.setString(4, notes);
                    stmt.setString(5, tripType);
                    stmt.setString(6, activities);
                    stmt.setString(7, imageUrl);
                    stmt.setInt(8, Integer.parseInt(id));
                    stmt.executeUpdate();
                    stmt.close();
                } else {
                    String sql = "INSERT INTO destinations (place, country, travel_date, notes, trip_type, activities, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setString(1, place);
                    stmt.setString(2, country);
                    stmt.setString(3, date);
                    stmt.setString(4, notes);
                    stmt.setString(5, tripType);
                    stmt.setString(6, activities);
                    stmt.setString(7, imageUrl);
                    stmt.executeUpdate();
                    stmt.close();
                }
            }

            conn.close();
            response.sendRedirect("index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
    }
