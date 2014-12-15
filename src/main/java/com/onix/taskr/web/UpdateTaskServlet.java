package com.onix.taskr.web;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.onix.taskr.domain.TaskEntityBuilder;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class UpdateTaskServlet extends HttpServlet {
    TaskEntityBuilder taskEntityBuilder = new TaskEntityBuilder();

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

        String taskrName = req.getParameter("taskrName");
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        try {
            Entity task = datastore.get(KeyFactory.stringToKey(req.getParameter("key")));
            task.setPropertiesFrom(taskEntityBuilder.build(req, user));
            datastore.put(task);
        } catch (Exception e) {

        }

        resp.sendRedirect("/taskr.jsp?taskrName=" + taskrName);
    }
}