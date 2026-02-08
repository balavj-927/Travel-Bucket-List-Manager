<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Travel Bucket List</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #a8edea, #fed6e3);
            padding: 30px;
            margin: 0;
            transition: background 0.5s ease;
        }

        h2 {
            text-align: center;
            color: #2e3d49;
            font-size: 32px;
            margin-bottom: 30px;
            animation: fadeInUp 0.5s ease;
        }

        .container {
            max-width: 900px;
            margin: auto;
        }

        form {
            background: #ffffff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            margin-bottom: 40px;
            transition: all 0.3s ease;
        }

        form:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
        }

        label {
            display: block;
            margin-top: 16px;
            font-weight: 600;
            color: #333;
        }

        input[type="text"],
        input[type="date"],
        textarea {
            width: 100%;
            padding: 12px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 10px;
            transition: box-shadow 0.3s ease;
        }

        input[type="text"]:focus,
        input[type="date"]:focus,
        textarea:focus {
            box-shadow: 0 0 8px rgba(0, 123, 255, 0.25);
            outline: none;
        }

        input[type="radio"],
        input[type="checkbox"] {
            margin-right: 6px;
        }

        button {
            background: purple;
            color: white;
            padding: 12px 24px;
            margin-top: 20px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: bold;
            transition: background 0.3s ease, transform 0.2s ease;
        }

        button:hover {
            background: #0056b3;
            transform: scale(1.03);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.08);
            overflow: hidden;
            animation: fadeInUp 0.4s ease;
        }

        th, td {
            padding: 16px;
            border-bottom: 1px solid #f2f2f2;
        }

        th {
            background-color: purple;
            color: white;
        }

        tr:hover {
            background-color:palegoldenrod;
            transition: background 0.3s ease;
        }

        img {
            max-width: 120px;
            border-radius: 10px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        img:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Travel Bucket List Manager</h2>

    <form action="travel" method="post">
        <input type="hidden" name="id" id="destinationId">

        <label>Place:</label>
        <input type="text" name="place" id="place" required>

        <label>Country:</label>
        <input type="text" name="country" id="country" required>

        <label>Travel Date:</label>
        <input type="date" name="travel_date" id="travel_date" required>

        <label>Notes:</label>
        <textarea name="notes" id="notes"></textarea>

        <label>Trip Type:</label>
        <input type="radio" name="trip_type" value="Adventure">Adventure
        <input type="radio" name="trip_type" value="Leisure">Leisure
        <input type="radio" name="trip_type" value="Cultural">Cultural

        <label>Activities:</label>
        <input type="checkbox" name="activities" value="Hiking">Hiking
        <input type="checkbox" name="activities" value="Swimming">Swimming
        <input type="checkbox" name="activities" value="Sightseeing">Sightseeing

        <label>Image URL:</label>
        <input type="text" name="image_url" id="image_url">

        <button type="submit">Save Destination</button>
    </form>

    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/travelbucket", "root", "");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM destinations");
    %>
    <table>
        <tr>
            <th>Place</th>
            <th>Country</th>
            <th>Date</th>
            <th>Notes</th>
            <th>Trip Type</th>
            <th>Activities</th>
            <th>Image</th>
            <th>Actions</th>
        </tr>
        <%
            while(rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("place") %></td>
            <td><%= rs.getString("country") %></td>
            <td><%= rs.getDate("travel_date") %></td>
            <td><%= rs.getString("notes") %></td>
            <td><%= rs.getString("trip_type") %></td>
            <td><%= rs.getString("activities") %></td>
            <td>
                <img src="<%= rs.getString("image_url") %>" alt="Destination Image">
            </td>
            <td>
    <div style="display: flex; flex-direction: column; gap: 6px; align-items: center;">
        <form action="TravelServlet1" method="post" style="margin: 0;">
            <input type="hidden" name="delete_id" value="<%= rs.getInt("id") %>">
            <button type="submit" onclick="return confirm('Are you sure you want to delete?')">🗑️</button>
        </form>
        <button onclick="editDestination('<%= rs.getInt("id") %>', '<%= rs.getString("place") %>', '<%= rs.getString("country") %>', '<%= rs.getDate("travel_date") %>', '<%= rs.getString("notes") %>', '<%= rs.getString("trip_type") %>', '<%= rs.getString("activities") %>', '<%= rs.getString("image_url") %>')">✏️</button>
    </div>
</td>

            
        </tr>
        <%
            }
            conn.close();
        } catch(Exception e) {
            out.println("Database error: " + e.getMessage());
        }
    %>
    </table>
</div>

<script>
function editDestination(id, place, country, date, notes, tripType, activities, imageUrl) {
    document.getElementById('destinationId').value = id;
    document.getElementById('place').value = place;
    document.getElementById('country').value = country;
    document.getElementById('travel_date').value = date;
    document.getElementById('notes').value = notes;
    document.getElementById('image_url').value = imageUrl;

    document.querySelectorAll("input[name='trip_type']").forEach(r => {
        r.checked = (r.value === tripType);
    });

    let actArray = activities.split(", ");
    document.querySelectorAll("input[name='activities']").forEach(c => {
        c.checked = actArray.includes(c.value);
    });

    window.scrollTo({ top: 0, behavior: 'smooth' });
}
</script>
</body>
</html>
