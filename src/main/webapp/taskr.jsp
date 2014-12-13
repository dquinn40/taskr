<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>

<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
    <head>
        <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
        <link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">
        <script src="//code.jquery.com/jquery-1.10.2.js"></script>
        <script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>

        <script>
            $(function() {
                $( "#datepicker" ).datepicker();
            });
        </script>
    </head>

    <%
        String taskrName = request.getParameter("taskrName");
        if (taskrName == null) {
            taskrName = "default";
        }
        pageContext.setAttribute("taskrName", taskrName);
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        if (user != null) {
            pageContext.setAttribute("user", user);
    %>

    <p>Hello, ${fn:escapeXml(user.nickname)}! (You can
        <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
    <%
        } else {
    %>
    <p>Hello!
        <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
        to include your name with greetings you post.</p>
    <%
        }
    %>

    <%
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        Key taskrKey = KeyFactory.createKey("Taskr", taskrName);
        // Run an ancestor query to ensure we see the most up-to-date
        // view of the Greetings belonging to the selected Guestbook.
        Query query = new Query("Task", taskrKey).addSort("dueDate", Query.SortDirection.DESCENDING);
        List<Entity> tasks = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
        if (tasks.isEmpty()) {
    %>
    <p>Taskr '${fn:escapeXml(taskrName)}' has no messages.</p>
    <%
    } else {
    %>
    <p>Tasks in Taskr '${fn:escapeXml(taskrName)}'.</p>
    <%
        for (Entity task : tasks) {
            pageContext.setAttribute("task_description",
                    task.getProperty("description"));
            pageContext.setAttribute("task_due_date",
                    task.getProperty("dueDate"));
            pageContext.setAttribute("task_is_complete",
                    task.getProperty("complete"));
            if (task.getProperty("user") == null) {
    %>
                <p>An anonymous person wrote:</p>
    <%
            } else {
                pageContext.setAttribute("task_user",
                task.getProperty("user"));
    %>
    <p><b>${fn:escapeXml(task_user.nickname)}</b> wrote:</p>
    <%
            }
    %>
    <blockquote>${fn:escapeXml(task_description)}</blockquote>
    <blockquote>${fn:escapeXml(task_due_date)}</blockquote>
    <blockquote>${fn:escapeXml(task_is_complete)}</blockquote>
    <%
            }
        }
    %>

    <form action="/create" method="post">
        <div><label>Description: </label><input type="text" name="description"/></div>
        <label>Due: </label><input type="text" name="dueDate" id="datepicker">
        <label>Status: </label><input type="radio" name="complete" value="yes" checked>yes
        <br>
        <input type="radio" name="complete" value="no">no
        <div><input type="submit" value="Post Task"/></div>
        <input type="hidden" name="taskrName" value="${fn:escapeXml(taskrName)}"/>
    </form>


    <form action="/taskr.jsp" method="get">
        <div><input type="text" name="taskrName" value="${fn:escapeXml(taskrName)}"/></div>
        <div><input type="submit" value="Switch Taskr"/></div>
    </form>

</body>
</html>