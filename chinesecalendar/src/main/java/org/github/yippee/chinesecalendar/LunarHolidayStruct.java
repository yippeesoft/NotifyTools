package org.github.yippee.chinesecalendar;

/**
 * Created by sf on 2017/2/16.
 */

public class LunarHolidayStruct {
    public int Month;
    public int Day;
    public int Recess;
    public String HolidayName;

    public LunarHolidayStruct(int month, int day, int recess, String name) {
        Month = month;
        Day = day;
        Recess = recess;
        HolidayName = name;
    }
}