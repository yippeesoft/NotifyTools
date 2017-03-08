package org.github.yippee.chinesecalendar;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import static org.github.yippee.chinesecalendar.Consts.ganStr;
import static org.github.yippee.chinesecalendar.Consts.nStr1;
import static org.github.yippee.chinesecalendar.Consts.nStr2;
import static org.github.yippee.chinesecalendar.Consts.zhiStr;

/**
 * Created by sf on 2017/2/16.
 */

public class CalcLunar {
    /// <summary>
    /// 取农历年一年的天数
    /// </summary>
    /// <param name="year"></param>
    /// <returns></returns>
    public static int GetChineseYearDays(int year) {
        int i, f, sumDay, info;

        sumDay = 348; //29天 X 12个月
        i = 0x8000;
        info = Consts.LunarDateArray[year - Consts.MinYear] & 0x0FFFF;

        //计算12个月中有多少天为30天
        for (int m = 0; m < 12; m++) {
            f = info & i;
            if (f != 0) {
                sumDay++;
            }
            i = i >> 1;
        }
        return sumDay + GetChineseLeapMonthDays(year);
    }

    //传回农历 y年闰哪个月 1-12 , 没闰传回 0
    public static int GetChineseLeapMonth(int year) {

        return Consts.LunarDateArray[year - Consts.MinYear] & 0xF;

    }

    //传回农历 y年闰月的天数
    public static int GetChineseLeapMonthDays(int year) {
        if (GetChineseLeapMonth(year) != 0) {
            if ((Consts.LunarDateArray[year - Consts.MinYear] & 0x10000) != 0) {
                return 30;
            } else {
                return 29;
            }
        } else {
            return 0;
        }
    }

    /// <summary>
    /// 检查农历日期是否合理
    /// </summary>
    /// <param name="year"></param>
    /// <param name="month"></param>
    /// <param name="day"></param>
    /// <param name="leapMonth"></param>
    public static void CheckChineseDateLimit(int year, int month, int day, boolean leapMonth) throws ChineseCalendarException {
        if ((year < Consts.MinYear) || (year > Consts.MaxYear)) {
            throw new ChineseCalendarException("非法农历日期");
        }
        if ((month < 1) || (month > 12)) {
            throw new ChineseCalendarException("非法农历日期");
        }
        if ((day < 1) || (day > 30)) //中国的月最多30天
        {
            throw new ChineseCalendarException("非法农历日期");
        }

        int leap = GetChineseLeapMonth(year);// 计算该年应该闰哪个月
        if ((leapMonth == true) && (month != leap)) {
            throw new ChineseCalendarException("非法农历日期");
        }
    }

    /// <summary>
    /// 取干支的月表示字符串，注意农历的闰月不记干支
    /// </summary>
    public String GanZhiMonthString(int _cYear, int _cMonth) {

        //每个月的地支总是固定的,而且总是从寅月开始
        int zhiIndex;
        String zhi;
        if (_cMonth > 10) {
            zhiIndex = _cMonth - 10;
        } else {
            zhiIndex = _cMonth + 2;
        }
        zhi = Consts.zhiStr.toCharArray()[zhiIndex-1]+"";

        //根据当年的干支年的干来计算月干的第一个
        int ganIndex = 1;
        String gan;
        int i = (_cYear - Consts.GanZhiStartYear) % 60; //计算干支
        switch (i % 10) {

            case 0: //甲
                ganIndex = 3;
                break;
            case 1: //乙
                ganIndex = 5;
                break;
            case 2: //丙
                ganIndex = 7;
                break;
            case 3: //丁
                ganIndex = 9;
                break;
            case 4: //戊
                ganIndex = 1;
                break;
            case 5: //己
                ganIndex = 3;
                break;
            case 6: //庚
                ganIndex = 5;
                break;
            case 7: //辛
                ganIndex = 7;
                break;
            case 8: //壬
                ganIndex = 9;
                break;
            case 9: //癸
                ganIndex = 1;
                break;

        }
        gan = ganStr.substring((ganIndex + _cMonth - 2) % 10, (ganIndex + _cMonth - 2) % 10 + 1);

        return gan + zhi + "月";
    }

    // 天干地支
    // GanZhiYearString
    /// <summary>
    /// 取农历年的干支表示法如 乙丑年
    /// </summary>
    public String GanZhiYearString(int _cYear) {
        String tempStr;
        int i = (_cYear - Consts.GanZhiStartYear) % 60; //计算干支
        tempStr = Consts.ganStr.substring(i % 10, i % 10 + 1) +
                Consts.zhiStr.substring(i % 12, i % 12 + 1) + "年";
        return tempStr;

    }

    /// <summary>
    /// 取干支日表示法
    /// </summary>
    public String GanZhiDayString(Date _date) {

        int i, offset;
        offset = Utils.daysBetween(_date, Consts.GanZhiStartDay);

        i = offset % 60;
        String tempStr = Consts.ganStr.substring(i % 10, i % 10 + 1) +
                Consts.zhiStr.substring(i % 12, i % 12 + 1) + "日";
        return tempStr;

    }

    /// <summary>
    /// 取属相字符串
    /// </summary>
    public String AnimalString(Date _date) {
        int offset = Utils.yearDateDiff(_date, Consts.AnimalStartYear); //阳历计算
        //int offset = this._cYear - AnimalStartYear;　农历计算
        return Consts.animalStr.substring(offset % 12, offset % 12 + 1);

    }

    /// <summary>
    /// 取农历年字符串如，一九九七年
    /// </summary>
    public String ChineseYearString(int _cYear) {
        String tempStr = "";
        String num = _cYear + "";
        for (int i = 0; i < 4; i++) {
            tempStr += Utils.ConvertNumToChineseNum(num.toCharArray()[i]);
        }
        return tempStr + "年";

    }

    /// <summary>
    /// 农历日中文表示
    /// </summary>
    public String ChineseDayString(int _cDay) {

        switch (_cDay) {
            case 0:
                return "";
            case 10:
                return "初十";
            case 20:
                return "二十";
            case 30:
                return "三十";
            default:
                return nStr2.toCharArray()[(int) (_cDay / 10)] + "" + nStr1.toCharArray()[_cDay % 10];

        }

    }

    /// <summary>
    /// 取农历日期表示法：农历一九九七年正月初五
    /// </summary>
    public String ChineseDateString(boolean _cIsLeapMonth, int _cYear, int _cMonth, int _cDay) {

        if (_cIsLeapMonth == true) {
            return "农历" + ChineseYearString(_cYear) + "闰" + ChineseMonthString(_cMonth) + ChineseDayString(_cDay);
        } else {
            return "农历" + ChineseYearString(_cYear) + ChineseMonthString(_cMonth) + ChineseDayString(_cDay);
        }

    }

    /// <summary>
    /// 农历月份字符串
    /// </summary>
    public String ChineseMonthString(int _cMonth) {

        return Consts._monthString[_cMonth];

    }

    /// <summary>
    /// 获得当前时间的时辰
    /// </summary>
    /// <param name="time"></param>
    /// <returns></returns>
    ///
    public String GetChineseHour(Date dt, Date _date) {

        int _hour, offset, i;
        int _minute = 0;
        int indexGan;
        String ganHour, zhiHour;
        String tmpGan;

        //计算时辰的地支
        _hour = dt.getHours();   //获得当前时间小时
        _minute = dt.getMinutes();  //获得当前时间分钟

        if (_minute != 0) _hour += 1;
        offset = _hour / 2;
        if (offset >= 12) offset = 0;
        //zhiHour = zhiStr[offset].ToString();

        //计算天干
        int ts = Utils.daysBetween(_date, Consts.GanZhiStartDay);
        i = ts % 60;

        indexGan = ((i % 10 + 1) * 2 - 1) % 10 - 1; //ganStr[i % 10] 为日的天干,(n*2-1) %10得出地支对应,n从1开始
        tmpGan = Consts.ganStr.substring(indexGan) + Consts.ganStr.substring(0, indexGan + 2);//凑齐12位
        //ganHour = ganStr[((i % 10 + 1) * 2 - 1) % 10 - 1].ToString();

        return tmpGan.toCharArray()[offset] + "" + Consts.zhiStr.toCharArray()[offset];

    }


    /// <summary>
    /// 定气法计算二十四节气,二十四节气是按地球公转来计算的，并非是阴历计算的
    /// </summary>
    /// <remarks>
    /// 节气的定法有两种。古代历法采用的称为"恒气"，即按时间把一年等分为24份，
    /// 每一节气平均得15天有余，所以又称"平气"。现代农历采用的称为"定气"，即
    /// 按地球在轨道上的位置为标准，一周360°，两节气之间相隔15°。由于冬至时地
    /// 球位于近日点附近，运动速度较快，因而太阳在黄道上移动15°的时间不到15天。
    /// 夏至前后的情况正好相反，太阳在黄道上移动较慢，一个节气达16天之多。采用
    /// 定气时可以保证春、秋两分必然在昼夜平分的那两天。
    /// </remarks>
    public String ChineseTwentyFourDay(Date _date) {

        Date baseDateAndTime = new Date(0, 0, 6, 2, 5, 0); //#1/6/1900 2:05:00 AM#
        Calendar basecalendar = Calendar.getInstance();
        basecalendar.setTime(baseDateAndTime);
        Date newDate;
        double num;
        int y;
        String tempStr = "";
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(_date);

        y = _date.getYear() + 1900;

        for (int i = 1; i <= 24; i++) {
            num = 525948.76 * (y - 1900) + Consts.sTermInfo[i - 1];
            basecalendar.setTime(baseDateAndTime);
            basecalendar.add(Calendar.MINUTE, (int) (num));//按分钟计算
            if (basecalendar.get(Calendar.DAY_OF_YEAR) == calendar.get(Calendar.DAY_OF_YEAR)) {
                tempStr = Consts.SolarTerm[i - 1];
                break;
            }
        }
        return tempStr;
    }


    //当前日期前一个最近节气
    public String ChineseTwentyFourPrevDay(Date _date) {

        Date baseDateAndTime = new Date(0, 0, 6, 2, 5, 0); //#1/6/1900 2:05:00 AM#
        Calendar basecalendar = Calendar.getInstance();
        basecalendar.setTime(baseDateAndTime);
        Date newDate;
        double num;
        int y;
        String tempStr = "";

        y = _date.getYear() + 1900;
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(_date);
        for (int i = 24; i >= 1; i--) {
            num = 525948.76 * (y - 1900) + Consts.sTermInfo[i - 1];


            basecalendar.setTime(baseDateAndTime);
            basecalendar.add(Calendar.MINUTE, (int) (num));//按分钟计算
//            System.out.println(y + "  " + sdf.format(basecalendar.getTime()));
            if (basecalendar.get(Calendar.DAY_OF_YEAR) < calendar.get(Calendar.DAY_OF_YEAR)) {

                tempStr = String.format("%s[%s]", Consts.SolarTerm[i - 1], sdf.format(basecalendar.getTime()));
                break;
            }
        }

        return tempStr;


    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    //当前日期后一个最近节气
    public String ChineseTwentyFourNextDay(Date _date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(_date);
        Date baseDateAndTime = new Date(0, 0, 6, 2, 5, 0); //#1/6/1900 2:05:00 AM#
        Calendar basecalendar = Calendar.getInstance();
        basecalendar.setTime(baseDateAndTime);
        Date newDate;
        double num;
        int y;
        String tempStr = "";

        y = _date.getYear() + 1900;

        for (int i = 1; i <= 24; i++) {
            num = 525948.76 * (y - 1900) + Consts.sTermInfo[i - 1];

            basecalendar.setTime(baseDateAndTime);
            basecalendar.add(Calendar.MINUTE, (int) (num));//按分钟计算
            if (basecalendar.get(Calendar.DAY_OF_YEAR) > calendar.get(Calendar.DAY_OF_YEAR)) {

                tempStr = String.format("%s[%s]", Consts.SolarTerm[i - 1], sdf.format(basecalendar.getTime()));
                break;

            }
        }
        return tempStr;
    }

    /// <summary>
    /// 取当前日期的干支表示法如 甲子年乙丑月丙庚日
    /// </summary>
    public String GanZhiDateString(int _cYear,int _cMonth,Date _cDate)
    {

            return GanZhiYearString(_cYear) + GanZhiMonthString (_cYear,_cMonth)+ GanZhiDayString(_cDate);

    }

    /// <summary>
    /// 28星宿计算
    /// </summary>
    public String ChineseConstellation(Date _date)
    {

            int offset = 0;
            int modStarDay = 0;

        offset =Utils.daysBetween( _date ,Consts. ChineseConstellationReferDay);

            modStarDay = offset % 28;
            return (modStarDay >= 0 ?  Consts._chineseConstellationName[modStarDay] : Consts._chineseConstellationName[27 + modStarDay]);

    }
}

