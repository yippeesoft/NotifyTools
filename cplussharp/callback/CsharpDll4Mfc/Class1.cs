using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace CsharpDll4Mfc
{
    [ComVisible(true)]
    [Guid("9A26F178-28D6-43AC-9C1A-2CD9F9D01246")]
    [InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface ICalculator
    {
        [DispId(1)]
        int Add(int Number1, int Number2);

        [DispId(2)]
        int testCallBack(int kk, long callback);
 
    }

    [Guid("7FE32A1D-F239-45ad-8188-89738C6EDB6F")]
    [InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface IEvent
    {
        [DispId(20)]
        void DrawEvent(int count);
    }


    [TypeLibType(4160)]
    //[ComVisible(true), ComSourceInterfaces(typeof(ICalculator))]
    [ClassInterface(ClassInterfaceType.None),  
    ComDefaultInterface(typeof(ICalculator)),  
    ComSourceInterfaces(typeof(IEvent)),  
    ComVisible(true)]  
    [Guid("B1612D7D-3DB0-4CC3-8C3C-3504CBC77BAD")]
    [ProgId("CsharpDll4Mfc.Class1")]
    public class Class1 : ICalculator
    {
        public int Add(int Number1, int Number2)
        {
            OnDraw(Number1+ Number2);
            return Number1 * Number2;
        }

        public int testCallBack(int kk, long callback)
        {
            ProgressCallback p = (ProgressCallback)Marshal.GetDelegateForFunctionPointer(new IntPtr(callback), typeof(ProgressCallback));
            int dd = kk + 1000;
            return p(dd);
        }

        [UnmanagedFunctionPointerAttribute(CallingConvention.StdCall, CharSet = CharSet.Ansi)]
        public delegate int ProgressCallback(int kk);


        public void Initialize()
        {
            //nothing todo
        }
        public void Dispose()
        {
            //nothing todo
        }


        public delegate void DrawDelegate(int count);
        //注意事件的名称必须和IEvent定义的名字一致，而且必须public  
        public event DrawDelegate DrawEvent;
        public void OnDraw(int count)
        {
            try
            {
                if (DrawEvent == null)
                {
                    Console.WriteLine("Event is NULL!");
                }
                else
                {
                    DrawEvent(count);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }
    }
}
