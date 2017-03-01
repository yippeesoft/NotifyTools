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

//        AA阳历：公元Wed Mar 01 15:22:38 CST 2017
//        AA属相：狗
//        AA农历：农历二零一七年二月初四
//        AA时辰：戊申
//        节气：
//        前一个节气：雨水[2017-02-18]
//        后一个节气：惊蛰[2017-03-05]
//        节日：国际海豹日
//        干支：丁酉年癸卯月丁巳日
//        星期：星期三
//        星宿：壁水獝
//        星座：双鱼座
    }
}