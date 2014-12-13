package com.onix.taskr.util;

import org.junit.Test;

import java.text.ParseException;
import java.util.Date;

import static org.junit.Assert.assertEquals;

/**
 * Created by dquinn40 on 12/13/14.
 */
public class DateFormatterTest {
    @Test
    public void formatDate() {
        long timeSinceEpoch = 1418360400000L;
        Date date = new Date(timeSinceEpoch);

        assertEquals("12/12/2014", DateFormatter.format(date));
    }

    @Test
    public void parseDate() throws ParseException {
        long timeSinceEpoch = 1418360400000L;
        assertEquals(timeSinceEpoch, DateFormatter.parse("12/12/2014").getTime());
    }
}
