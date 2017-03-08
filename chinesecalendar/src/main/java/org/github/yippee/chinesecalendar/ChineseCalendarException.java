package org.github.yippee.chinesecalendar;

/**
 * Created by sf on 2017/2/16.
 */

/// <summary>
/// 中国日历异常处理
/// </summary>
public class ChineseCalendarException extends Exception {
    public ChineseCalendarException(String msg) {
        super(msg);
    }
}