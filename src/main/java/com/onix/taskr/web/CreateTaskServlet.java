package com.onix.taskr.web;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CreateTaskServlet extends HttpServlet {
    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yy");
        String taskrName = req.getParameter("taskrName");
        Key taskrKey = KeyFactory.createKey("Taskr", taskrName);
        String description = req.getParameter("description");
        String complete = req.getParameter("complete");
        Date date;
        try {
            date = sdf.parse(req.getParameter("dueDate"));
        } catch (ParseException pe) {
            date = new Date(0); // So I can quickly see date parsing is failing.
        }
        Entity task = new Entity("Task", taskrKey);
        task.setProperty("user", user);
        task.setProperty("dueDate", date);
        task.setProperty("description", description);
        task.setProperty("complete", complete);

        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        datastore.put(task);

        resp.sendRedirect("/taskr.jsp?taskrName=" + taskrName);
    }
}