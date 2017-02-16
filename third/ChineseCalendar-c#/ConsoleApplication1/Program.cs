using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using yangliToyinli;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            DateTime dt = DateTime.Now;
            ChineseCalendar cc = new ChineseCalendar(dt);
            Console.WriteLine("阳历：" + cc.DateString);
            Console.WriteLine("属相：" + cc.AnimalString);
            Console.WriteLine("农历：" + cc.ChineseDateString);
            Console.WriteLine("时辰：" + cc.ChineseHour);
            Console.WriteLine("节气：" + cc.ChineseTwentyFourDay);
            Console.WriteLine("节日：" + cc.DateHoliday);
            Console.WriteLine("前一个节气：" + cc.ChineseTwentyFourPrevDay);
            Console.WriteLine("后一个节气：" + cc.ChineseTwentyFourNextDay);
            Console.WriteLine("干支：" + cc.GanZhiDateString);
            Console.WriteLine("星期：" + cc.WeekDayStr);
            Console.WriteLine("星宿：" + cc.ChineseConstellation);
            Console.WriteLine("星座：" + cc.Constellation);
        }
    }
}
