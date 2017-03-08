package org.github.yippee.chinesecalendar;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * Created by sf on 2017/2/16.
 */

public class Utils {
    /// <summary>
    /// 测试某位是否为真
    /// </summary>
    /// <param name="num"></param>
    /// <param name="bitpostion"></param>
    /// <returns></returns>
    public static boolean BitTest32(int num, int bitpostion) throws Exception {

        if ((bitpostion > 31) || (bitpostion < 0))
            throw new Exception("Error Param: bitpostion[0-31]:" + bitpostion );

        int bit = 1 << bitpostion;

        if ((num & bit) == 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    /**
     * 通过时间秒毫秒数判断两个时间的间隔
     *
     * @param date1
     * @param date2
     * @return
     */
    private static int differentDaysByMillisecond(Date date2,Date date1) {
        int days = (int) ((date2.getTime() - date1.getTime()) / (1000 * 3600 * 24));
        return days;
    }
    public static final int daysBetween( Date late,Date early) {

        java.util.Calendar calst = java.util.Calendar.getInstance();
        java.util.Calendar caled = java.util.Calendar.getInstance();
        calst.setTime(early);
        caled.setTime(late);
        //设置时间为0时
        calst.set(java.util.Calendar.HOUR_OF_DAY, 0);
        calst.set(java.util.Calendar.MINUTE, 0);
        calst.set(java.util.Calendar.SECOND, 0);
        caled.set(java.util.Calendar.HOUR_OF_DAY, 0);
        caled.set(java.util.Calendar.MINUTE, 0);
        caled.set(java.util.Calendar.SECOND, 0);
//        System.out.println("1  "+caled.getTime().getTime()/1000+"  "+calst.getTime().getTime()/1000);
//        System.out.println("2  "+(caled.getTime().getTime()/1000-calst.getTime().getTime()/1000)/ 3600 / 24);
        //得到两个日期相差的天数
        int days =(int) ((  (caled.getTime().getTime() / 1000) -(calst.getTime().getTime() / 1000)) / 3600 / 24);
//        System.out.println("3  "+late.toString()+"  "+early.toString());
        return days;
    }
    //计算两个日期相差年数
    public static int yearDateDiff(Date date2,Date date1) {
        Calendar calBegin = Calendar.getInstance(); //获取日历实例
        Calendar calEnd = Calendar.getInstance();
        calBegin.setTime(date1); //字符串按照指定格式转化为日期
        calEnd.setTime(date2);
        return calEnd.get(Calendar.YEAR) - calBegin.get(Calendar.YEAR);
    }
    //字符串按照指定格式转化为日期
    public static Date stringTodate(String dateStr, String formatStr) {
        // 如果时间为空则默认当前时间
        Date date = null;
        SimpleDateFormat format = new SimpleDateFormat(formatStr);
        if (dateStr != null && !dateStr.equals("")) {
            String time = "";
            try {
                Date dateTwo = format.parse(dateStr);
                time = format.format(dateTwo);
                date = format.parse(time);
            } catch (ParseException e) {
                e.printStackTrace();
            }

        } else {
            String timeTwo = format.format(new Date());
            try {
                date = format.parse(timeTwo);
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        return date;
    }
    /// <summary>
    /// 将0-9转成汉字形式
    /// </summary>
    /// <param name="n"></param>
    /// <returns></returns>
    public static String ConvertNumToChineseNum(char nn)
    {
        int i=Integer.parseInt(nn+"");
        if ((i<0) || (i>9)) return "";
        return Consts.HZNum[i]+"";

    }
}
