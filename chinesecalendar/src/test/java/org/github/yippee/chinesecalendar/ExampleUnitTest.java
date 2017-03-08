package org.github.yippee.chinesecalendar;

import org.junit.Test;

import java.util.Date;

import static org.junit.Assert.*;

/**
 * Example local unit test, which will execute on the development machine (host).
 *
 * @see <a href="http://d.android.com/tools/testing">Testing documentation</a>
 */
public class ExampleUnitTest {
    @Test
    public void addition_isCorrect() throws Exception {
        assertEquals(4, 2 + 2);

        Date dt = new Date();
        ChineseCalendar cc = new ChineseCalendar(dt);
        System.out.println("AA阳历：" + cc.DateString());
        System.out.println("AA属相：" + cc.AnimalString());
        System.out.println("AA农历：" + cc.ChineseDateString());
        System.out.println("AA时辰：" + cc.ChineseHour());
        System.out.println("节气：" + cc.ChineseTwentyFourDay());
        System.out.println("前一个节气：" + cc.ChineseTwentyFourPrevDay());
        System.out.println("后一个节气：" + cc.ChineseTwentyFourNextDay());
        System.out.println("节日：" + cc.DateHoliday());

        System.out.println("干支：" + cc.GanZhiDateString());
        System.out.println("星期：" + cc.WeekDayStr());
        System.out.println("星宿：" + cc.ChineseConstellation());
        System.out.println("星座：" + cc.Constellation());
    }
}