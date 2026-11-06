EduSphere – Student Management System
EduSphere is a Java-based web application for managing student information and academic activities through separate Admin, Teacher, and Student portals. It brings student administration, role-based access, and QR-based attendance into one system.
Features
Admin
- Admin login and role-based dashboard access.
- Manage student records and user accounts.
- View academic and attendance-related information, including academic-risk and progress views.
- Access the user-management and administration pages.
Teacher
- Dedicated teacher dashboard.
- Generate QR-based attendance sessions for students.
Student
- Dedicated student dashboard.
- Mark attendance by scanning a session QR code.
- Use manual attendance-token entry when camera scanning is unavailable.
- View attendance history and attendance status.
Authentication and account security
- Email-and-password login for Admin, Teacher, and Student accounts.
- Role-based redirection after login.
- Passwords are stored using BCrypt hashing.
- Authenticated users can change their password using the Change Password page.
Technology Stack
Layer	Technologies
Backend	Java, Jakarta Servlets, JDBC
Frontend	JSP, HTML, CSS, JavaScript
Database	MySQL
Application server	Apache Tomcat 11
Build	Apache Maven
QR scanning	jsQR in the browser with the device camera


Application Flow
Browser
   |
   v
Servlet / Controller
   |
   v
Service Layer
   |
   v
DAO Layer  ---- JDBC ---->  MySQL Database
   |
   v
JSP View
   |
   v
Browser
The servlet handles the request, the service layer applies application logic, and the DAO layer performs database operations through JDBC. JSP pages render the response for the user.
Prerequisites
Install the following before running the project:
- JDK 23 (or a compatible JDK supported by the project configuration)
- Apache Maven
- MySQL Server
- Apache Tomcat 11
- Git
Getting Started
1. Clone the repository
git clone https://github.com/Pavanreddynarva/EduSphere-Student-Management.git
cd EduSphere-Student-Management
2. Create and configure the database
1. Start MySQL Server.
2. Create the database used by your local EduSphere setup.
3. Review the SQL files in the database/ directory and apply the required schema/setup scripts to that database. Apply any upgrade script only after the base schema is present.
3. Configure the database connection
The application reads its database connection settings from:
src/main/resources/db.properties
Create db.properties using the provided example file:
src/main/resources/db.properties.example
Set the values to match your local MySQL installation:
db.url=jdbc:mysql://localhost:3306/YOUR_DATABASE_NAME
db.username=YOUR_MYSQL_USERNAME
db.password=YOUR_MYSQL_PASSWORD
Keep your real db.properties file private. Do not commit database passwords or other credentials to GitHub.
4. Build the application
Run this command from the project root:
mvn clean package
Maven creates the deployable WAR file in the target/ directory.
5. Deploy to Apache Tomcat
1. Stop Tomcat if it is already running.
2. Copy the generated .war file from target/ into Tomcat's webapps/ directory.
3. Start Tomcat.
4. Open the application in a browser using the context path that matches the deployed WAR filename. For example, if the WAR is named student-management.war, use:
http://localhost:8080/student-management/
If you deploy the WAR under a different filename, use that filename (without .war) as the context path.
QR Attendance Notes
- Allow camera permission when prompted by the browser.
- Camera access generally requires a secure context: use localhost during local testing or HTTPS when accessing the application from another device.
- The manual attendance-token option is available as a fallback when camera scanning is unsupported or unavailable.
- The browser needs access to the jsQR library used by the scanner.
Repository Structure

- Never publish real database credentials, API tokens, or other secrets.
- Use unique passwords and change any initial account password after signing in.
- Use HTTPS when accessing camera-based attendance from a device other than the local machine.
Author
Pavan Reddy Narva

GitHub: @Pavanreddynarva
