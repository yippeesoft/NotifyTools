package org.github.yippee.chinesecalendar;

/**
 * Created by sf on 2017/2/16.
 */

public class SolarHolidayStruct {
    public int Month;
    public int Day;
    public int Recess; //假期长度
    public String HolidayName;

    public SolarHolidayStruct(int month, int day, int recess, String name) {
        Month = month;
        Day = day;
        Recess = recess;
        HolidayName = name;
    }
}