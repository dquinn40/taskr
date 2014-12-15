package com.onix.taskr.web;

import com.google.appengine.api.datastore.*;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.onix.taskr.domain.TaskEntityBuilder;
import com.onix.taskr.util.DateFormatter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.util.Date;

public class CreateTaskServlet extends HttpServlet {
    TaskEntityBuilder taskEntityBuilder = new TaskEntityBuilder();
    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

        String taskrName = req.getParameter("taskrName");
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        datastore.put(taskEntityBuilder.build(req, user));

        resp.sendRedirect("/taskr.jsp?taskrName=" + taskrName);
    }
}