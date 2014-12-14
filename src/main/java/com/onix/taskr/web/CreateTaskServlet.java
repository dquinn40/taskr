package com.onix.taskr.web;

import com.google.appengine.api.datastore.*;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.onix.taskr.util.DateFormatter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.util.Date;

public class CreateTaskServlet extends HttpServlet {
    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

        String taskrName = req.getParameter("taskrName");
        Key taskrKey = KeyFactory.createKey("Taskr", taskrName);
        String description = req.getParameter("description");
        String complete = req.getParameter("complete");
        Date date;
        try {
            date = DateFormatter.parse(req.getParameter("dueDate"));
        } catch (ParseException pe) {
            date = new Date(0); // So I can quickly see date parsing is failing.
        }
        Entity task = new Entity("Task", taskrKey);
        task.setProperty("userId", user.getUserId());
        task.setProperty("user", user);
        task.setProperty("dueDate", date);
        task.setProperty("description", description);
        task.setProperty("complete", complete);

        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        datastore.put(task);

        resp.sendRedirect("/taskr.jsp?taskrName=" + taskrName);
    }
}