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
<%@ page import="com.onix.taskr.util.DateFormatter" %>
<%@ page import="java.util.Date" %>

<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
    <head>
        <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
        <link rel="stylesheet" href="/bootstrap/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="/bootstrap/css/bootstrap-responsive.min.css"/>
        <link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">

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
        to include your name with tasks.</p>
    <%
        }
    %>

    <%
        SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        Key taskrKey = KeyFactory.createKey("Taskr", taskrName);
        // Run an ancestor query to ensure we see the most up-to-date
        // view of the Greetings belonging to the selected Guestbook.
        Query query = new Query("Task", taskrKey).addSort("dueDate", Query.SortDirection.DESCENDING);
        List<Entity> tasks = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
        if (tasks.isEmpty()) {
    %>
    <p>Taskr '${fn:escapeXml(taskrName)}' has no tasks.</p>
    <%
    } else {
    %>
    <p>Tasks in Taskr '${fn:escapeXml(taskrName)}'.</p>
    <table class="table table-striped">
        <tr><th>Description</th><th>Due</th><th>Completed</th><th></th></tr>
    <%
        for (Entity task : tasks) {
            pageContext.setAttribute("task_description",
                    task.getProperty("description"));
            pageContext.setAttribute("task_due_date",
                    DateFormatter.format((Date)task.getProperty("dueDate")));
            pageContext.setAttribute("task_is_complete",
                    task.getProperty("complete"));
            pageContext.setAttribute("task_id",
                    task.getProperty("id"));
            if (task.getProperty("user") == null) {

            } else {
                pageContext.setAttribute("task_user",
                task.getProperty("user"));
            }
    %>
        <tr>
            <form class="form-inline" action="/task" method="put">
                <td><input type="text" placeholder="Description" class="input-large" name="description" value="${fn:escapeXml(task_description)}"/></td>
                <td><input type="text" placeholder="Due Date" class="input-small" name="dueDate" value="${fn:escapeXml(task_due_date)}"></td>
                <td><input type="checkbox" name="complete" value="${fn:escapeXml(task_is_complete)}"></td>
                <td><button class="btn" type="submit">Update</button></td>
                <input type="hidden" name="id" value="${fn:escapeXml(task_id)}"/>
            </form>
        </tr>
    <%
            }
        }
    %>
    </table>

    <form class="form-inline" action="/create" method="post">
        <input type="text" placeholder="Description" class="input-large" name="description"/>
        <input type="text" placeholder="Due Date" class="input-small" name="dueDate" id="datepicker">
        <label class="checkbox">Complete:</label>
        <input type="checkbox" name="complete">

        <button class="btn" type="submit">Post Task</button>
        <input type="hidden" name="taskrName" value="${fn:escapeXml(taskrName)}"/>
    </form>

    <form class="form-inline" action="/taskr.jsp" method="get">
        <input type="text" name="taskrName" value="${fn:escapeXml(taskrName)}"/>
        <button class="btn" type="submit">Switch Taskr</button>
    </form>

    <script src="//code.jquery.com/jquery-1.10.2.js"></script>
    <script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
    <script>
        $(function() {
            $( "#datepicker" ).datepicker();
        });
    </script>
    <script src="/bootstrap/js/bootstrap.min.js"></script>

</body>
</html>