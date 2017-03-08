package org.github.yippee.chinesecalendar;

import java.util.Calendar;
import java.util.Date;

/**
 * Created by sf on 2017/2/16.
 */

public class ChineseCalendar {
    //内部变量
    private Date _date;
    private Date _datetime;
    Calendar cld = Calendar.getInstance();
    private int _cYear;
    private int _cMonth;
    private int _cDay;
    private boolean _cIsLeapMonth; //当月是否闰月
    private boolean _cIsLeapYear; //当年是否有闰月


    /// <summary>
    /// 检查公历日期是否符合要求
    /// </summary>
    /// <param name="dt"></param>
    private void CheckDateLimit(Date dt) throws ChineseCalendarException {
        if ((dt.before(Consts.MinDay)) || (dt.after(Consts.MaxDay))) {
            throw new ChineseCalendarException("超出可转换的日期");
        }
    }

    //传回农历 y年m月的总天数
    private int GetChineseMonthDays(int year, int month) throws Exception {
        if (Utils.BitTest32((Consts.LunarDateArray[year - Consts.MinYear] & 0x0000FFFF), (16 - month))) {
            return 30;
        } else {
            return 29;
        }
    }

    // 构造函数
    //ChinaCalendar <公历日期初始化>
    /// <summary>
    /// 用一个标准的公历日期来初使化
    /// </summary>
    /// <param name="dt"></param>
    public ChineseCalendar(Date dt) {
        int i;
        int leap;
        int temp;
        int offset;

        try {
            CheckDateLimit(dt);
        } catch (ChineseCalendarException e) {
            e.printStackTrace();
        }

        _date = dt;
        _datetime = dt;

        //农历日期计算部分
        leap = 0;
        temp = 0;

        offset = Utils.daysBetween(_date, Consts.MinDay);//计算两天的基本差距


        for (i = Consts.MinYear; i <= Consts.MaxYear; i++) {
            temp = CalcLunar.GetChineseYearDays(i);  //求当年农历年天数
            if (offset - temp < 1)
                break;
            else {
                offset = offset - temp;
            }
        }
        _cYear = i;

        leap = CalcLunar.GetChineseLeapMonth(_cYear);//计算该年闰哪个月
        //设定当年是否有闰月
        if (leap > 0) {
            _cIsLeapYear = true;
        } else {
            _cIsLeapYear = false;
        }

        _cIsLeapMonth = false;
        for (i = 1; i <= 12; i++) {
            //闰月
            if ((leap > 0) && (i == leap + 1) && (_cIsLeapMonth == false)) {
                _cIsLeapMonth = true;
                i = i - 1;
                temp = CalcLunar.GetChineseLeapMonthDays(_cYear); //计算闰月天数
            } else {
                _cIsLeapMonth = false;
                try {
                    temp = GetChineseMonthDays(_cYear, i);//计算非闰月天数
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            offset = offset - temp;
            if (offset <= 0) break;
        }

        offset = offset + temp;
        _cMonth = i;
        _cDay = offset;
    }


    /// <summary>
    /// 用农历的日期来初使化
    /// </summary>
    /// <param name="cy">农历年</param>
    /// <param name="cm">农历月</param>
    /// <param name="cd">农历日</param>
    /// <param name="LeapFlag">闰月标志</param>
    public ChineseCalendar(int cy, int cm, int cd, boolean leapMonthFlag) throws Exception {
        int i, leap, Temp, offset;

        CalcLunar.CheckChineseDateLimit(cy, cm, cd, leapMonthFlag);
        _cYear = cy;
        _cMonth = cm;
        _cDay = cd;

        offset = 0;

        for (i = Consts.MinYear; i < cy; i++) {
            Temp = CalcLunar.GetChineseYearDays(i); //求当年农历年天数
            offset = offset + Temp;
        }

        leap = CalcLunar.GetChineseLeapMonth(cy);// 计算该年应该闰哪个月
        if (leap != 0) {
            this._cIsLeapYear = true;
        } else {
            this._cIsLeapYear = false;
        }

        if (cm != leap) {
            _cIsLeapMonth = false;  //当前日期并非闰月
        } else {
            _cIsLeapMonth = leapMonthFlag;  //使用用户输入的是否闰月月份
        }


        if ((_cIsLeapYear == false) || //当年没有闰月
                (cm < leap)) //计算月份小于闰月
        {

            for (i = 1; i < cm; i++) {
                Temp = GetChineseMonthDays(cy, i);//计算非闰月天数
                offset = offset + Temp;
            }

            //检查日期是否大于最大天
            if (cd > GetChineseMonthDays(cy, cm)) {
                throw new ChineseCalendarException("不合法的农历日期");
            }
            offset = offset + cd; //加上当月的天数

        } else   //是闰年，且计算月份大于或等于闰月
        {

            for (i = 1; i < cm; i++) {
                Temp = GetChineseMonthDays(cy, i); //计算非闰月天数
                offset = offset + Temp;
            }

            if (cm > leap) //计算月大于闰月
            {
                Temp = CalcLunar.GetChineseLeapMonthDays(cy);   //计算闰月天数
                offset = offset + Temp;               //加上闰月天数

                if (cd > GetChineseMonthDays(cy, cm)) {
                    throw new ChineseCalendarException("不合法的农历日期");
                }
                offset = offset + cd;
            } else  //计算月等于闰月
            {
                //如果需要计算的是闰月，则应首先加上与闰月对应的普通月的天数
                if (this._cIsLeapMonth == true) //计算月为闰月
                {
                    Temp = GetChineseMonthDays(cy, cm); //计算非闰月天数
                    offset = offset + Temp;
                }

                if (cd > CalcLunar.GetChineseLeapMonthDays(cy)) {
                    throw new ChineseCalendarException("不合法的农历日期");
                }
                offset = offset + cd;
            }

        }
        cld.setTime(Consts.MinDay);
        cld.add(Calendar.DATE, 1);
        _date = cld.getTime();
    }


    /// <summary>
    /// 取当前日期的干支表示法如 甲子年乙丑月丙庚日
    /// </summary>
    public String GanZhiDateString() {

        return cl.GanZhiYearString(_cYear) + cl.GanZhiMonthString(_cYear, _cMonth) + cl.GanZhiDayString(_date);

    }

    CalcLunar cl = new CalcLunar();

    /// <summary>
    /// 公历日期中文表示法 如一九九七年七月一日
    /// </summary>
    public String DateString() {
        return "公元" + this._date.toString();

    }

    public String AnimalString() {
        return cl.AnimalString(_date);
    }

    /// <summary>
    /// 取农历日期表示法：农历一九九七年正月初五
    /// </summary>
    public String ChineseDateString() {
        return cl.ChineseDateString(this._cIsLeapMonth, _cYear, _cMonth, _cDay);
    }

    public String ChineseHour() {
        return cl.GetChineseHour(_datetime, _date);

    }

    public String ChineseTwentyFourDay() {
        return cl.ChineseTwentyFourDay(_date);
    }

    public String ChineseTwentyFourPrevDay() {
        return cl.ChineseTwentyFourPrevDay(_date);
    }

    public String ChineseTwentyFourNextDay() {
        return cl.ChineseTwentyFourNextDay(_date);
    }

    /// <summary>
    /// 按公历日计算的节日
    /// </summary>
    public String DateHoliday()
    {

        String tempStr = "";

            for  (SolarHolidayStruct sh : Consts.sHolidayInfo)
            {
                cld.setTime(_date);
                if ((sh.Month == cld.get(Calendar.MONTH)+1) && (sh.Day == cld.get(Calendar.DAY_OF_MONTH)))
                {
                    tempStr = sh.HolidayName;
                    break;
                }
            }
            return tempStr;

    }

    /// <summary>
    /// 周几的字符
    /// </summary>
    public String WeekDayStr()
    {
        cld.setTime(_date);
            switch (cld.get(Calendar.DAY_OF_WEEK))
            {
                case Calendar.SUNDAY:
                    return "星期日";
                case Calendar.MONDAY:
                    return "星期一";
                case Calendar.TUESDAY:
                    return "星期二";
                case Calendar.WEDNESDAY:
                    return "星期三";
                case Calendar.THURSDAY:
                    return "星期四";
                case Calendar.FRIDAY:
                    return "星期五";
                default:
                    return "星期六";
            }

    }
    public String ChineseConstellation(){
        return cl.ChineseConstellation(_date);
    }
    /// <summary>
    /// 计算指定日期的星座序号
    /// </summary>
    /// <returns></returns>
    public String Constellation()
    {

            int index = 0;
            int y, m, d;
        cld.setTime(_date);
            y = cld.get(Calendar.YEAR);
            m = cld.get(Calendar.MONTH)+1;
            d = cld.get(Calendar.DAY_OF_MONTH);
            y = m * 100 + d;

            if (((y >= 321) && (y <= 419))) { index = 0; }
            else if ((y >= 420) && (y <= 520)) { index = 1; }
            else if ((y >= 521) && (y <= 620)) { index = 2; }
            else if ((y >= 621) && (y <= 722)) { index = 3; }
            else if ((y >= 723) && (y <= 822)) { index = 4; }
            else if ((y >= 823) && (y <= 922)) { index = 5; }
            else if ((y >= 923) && (y <= 1022)) { index = 6; }
            else if ((y >= 1023) && (y <= 1121)) { index = 7; }
            else if ((y >= 1122) && (y <= 1221)) { index = 8; }
            else if ((y >= 1222) || (y <= 119)) { index = 9; }
            else if ((y >= 120) && (y <= 218)) { index = 10; }
            else if ((y >= 219) && (y <= 320)) { index = 11; }
            else { index = 0; }

            return Consts._constellationName[index];

    }
}
