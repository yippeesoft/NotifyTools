using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace callback
{

    //http://www.cnblogs.com/Again/p/5337467.html
    //http://www.cnblogs.com/Again/p/5354138.html

    //http://blog.csdn.net/tuan891205/article/details/12427997

    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();

        }

        //声明

        public delegate int CsharpDllCall(int a);
        //声明回调的函数

        public int FunA(int a)
        {
           
            return a+200;
        }

        [DllImport("../../debug/MfcDll4Csharp.dll", CharSet = CharSet.Unicode,
           CallingConvention = CallingConvention.StdCall)]
        public static extern int ExportedFunction(int a,int b, CsharpDllCall fa);
        private void Form1_Load(object sender, EventArgs e)
        {
            Console.Out.WriteLine(ExportedFunction(111,222,FunA));
        }
    }
}
