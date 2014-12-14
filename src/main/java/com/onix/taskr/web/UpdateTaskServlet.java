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

public class UpdateTaskServlet extends HttpServlet {
    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

        String taskrName = req.getParameter("taskrName");
        String description = req.getParameter("description");
        String complete = req.getParameter("complete");
        Date date;
        try {
            date = DateFormatter.parse(req.getParameter("dueDate"));
        } catch (ParseException pe) {
            date = new Date(0); // So I can quickly see date parsing is failing.
        }


        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        try {
            Entity task = datastore.get(KeyFactory.stringToKey(req.getParameter("key")));
            task.setProperty("user", user);
            task.setProperty("dueDate", date);
            task.setProperty("description", description);
            task.setProperty("complete", complete);

            datastore.put(task);
        } catch (Exception e) {
            // Need to add some logging
        }

        resp.sendRedirect("/taskr.jsp?taskrName=" + taskrName);
    }
}