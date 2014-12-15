package com.onix.taskr.domain;

import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.onix.taskr.util.DateFormatter;

import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.util.Date;

/**
 * Created by dquinn40 on 12/14/14.
 */
public class TaskEntityBuilder {

    public Entity build(HttpServletRequest req, User user) {
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
        task.setProperty("userId", user != null ? user.getUserId() : "unknown");
        task.setProperty("user", user);
        task.setProperty("dueDate", date);
        task.setProperty("description", description);
        task.setProperty("complete", complete);

        return task;
    }
}
