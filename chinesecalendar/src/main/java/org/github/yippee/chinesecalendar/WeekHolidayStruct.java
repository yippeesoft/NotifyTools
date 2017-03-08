package org.github.yippee.chinesecalendar;

/**
 * Created by sf on 2017/2/16.
 */

public class WeekHolidayStruct {
    public int Month;
    public int WeekAtMonth;
    public int WeekDay;
    public String HolidayName;

    public WeekHolidayStruct(int month, int weekAtMonth, int weekDay, String name) {
        Month = month;
        WeekAtMonth = weekAtMonth;
        WeekDay = weekDay;
        HolidayName = name;
    }
}