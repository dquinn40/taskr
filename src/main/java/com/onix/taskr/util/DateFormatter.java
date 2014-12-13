package com.onix.taskr.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by dquinn40 on 12/13/14.
 */
public class DateFormatter {
    private static final String FORMAT = "MM/dd/yyyy";
    private static SimpleDateFormat sdf = new SimpleDateFormat(FORMAT);

    public static String format(Date date) {
        return sdf.format(date);
    }

    public static Date parse(String date) throws ParseException {
        return sdf.parse(date);
    }
}
